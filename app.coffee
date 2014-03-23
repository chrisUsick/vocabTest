
###
Module dependencies
###
express = require("express")
routes = require("./routes/routes.js")
http = require("http")
path = require("path")
fs = require('fs')
pg = require('pg')
passport = require('passport')
GoogleStrategy = require('passport-google').Strategy 
WebSocketServer = require("ws").Server 

parseCookie = express.cookieParser()
MemStore = express.session.MemoryStore

store = new MemStore()

# add various websocket handlers
SelectCategory = require("./lib/SelectCategory.js").SelectCategory
IndexWs = require("./lib/IndexWs.js").IndexWs
TestWs = require("./lib/TestWs.js").TestWs

# the websocket handler class
WsHandler = require("./lib/WsHandler.js").WsHandler

runQuery = require("./lib/pg-helper.js").runQuery
app = express()

# all environments
app.set "port", process.env.PORT or 3000
app.set "views", path.join(__dirname, "views")
app.set "view engine", "jade"
app.use express.favicon()
app.use express.logger("dev")
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use express.static(path.join(__dirname, "public"))
app.use express.cookieParser('guess again')
app.use express.session(
	store: store
	key: 'sid'
	secret: 'guess again')

app.use passport.initialize()
app.use app.router
app.use passport.session()

# development only
app.use express.errorHandler()  if "development" is app.get("env")

# auth code
passport.use new GoogleStrategy({ 
    returnURL: 'http://192.168.56.1:3000/auth/google/return',
    realm: 'http://192.168.56.1:3000/'
    },
    (identifier, profile, done) ->
    	console.log profile, identifier, 'from GoogleStrategy'
    	done(null, {email: profile.emails[0].value, name: profile.displayName})
  )

passport.serializeUser = (user, done) ->
	done null, user

passport.deserializeUser = (user, done) ->
	done null, user

app.get "/", routes.index
app.get "/test", routes.test
app.get "/login", routes.login

# auth routes
app.get "/auth/google", passport.authenticate('google')
app.get "/auth/google/return", 
	passport.authenticate('google', 
		successRedirect: '/'
		failureRedirect: '/login'
	)

server = http.createServer(app).listen app.get("port"), '192.168.56.1', ->
  console.log "Express server listening on port " + app.get("port")

# only do this for development
constring = "postgres://postgres@localhost:5432/postgres"
textQueries = fs.readFileSync 'queries.sql', 'utf8'

runQuery new pg.Client(constring), textQueries, null, (r) ->
	console.log 'prepared queries loaded'


wss = new WebSocketServer({server: server})
wss.on "connection", (ws) ->
	
	wsHandler = new WsHandler()
	wsHandler.addConversations [
		new SelectCategory(ws, pg.Client, constring)
		new IndexWs(ws, pg.Client, constring)
		new TestWs(ws, pg.Client, constring)
	]
	# console.log store.sessions
	# console.log(ws.upgradeReq.headers.cookie, 'from ws')
	# parseCookie ws.upgradeReq.headers.cookie, null, (err, res) ->
	# 	console.log res, 'worked??'



	ws.on 'message', (data, flags) -> 
		msg = JSON.parse data
		getSessionData ws, (ses) ->

			# adds session data to be sent to websocket conversations
			if msg.data then msg.data.ses = ses else msg.data = {ses: ses}
			wsHandler.onmessage(msg)
		
getSessionData = (ws, cb) ->
	parseCookie(ws.upgradeReq, null, (err) ->
		if err then console.log 'error'
		sID = ws.upgradeReq.cookies['sid'].substring(2,26)
		store.get sID, (err, ses) ->
			# console.log ses.passport, 'cookies!'
			cb ses 
		)
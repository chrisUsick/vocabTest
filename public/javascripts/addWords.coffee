# functions
# console.log $(window)

addWords = () ->
	form = '#addWords'

	data = {
		word: $(form + ' input#word').val()
		def: $(form + ' input#def').val()
		subject: $(form + ' select#subject').val()
		category: $(form + ' select#category').val()
		unit: $(form + ' #unit').val()
	}
	console.log 'sending word: ', data
	ws.send JSON.stringify({request: 'addWord', data: data})

addSubject = (s) -> 
	# console.log $('#addwords #subject')
	$('#addWords #subject').append("<option>#{s.name}</option>")

addCategory = (c) ->
	$('#category').append("<option>#{c.name}</option>")

pageLoad = () -> 
	ws.send JSON.stringify({request: 'subjectList'})
	ws.send JSON.stringify({request: 'categoryList'})
	ws.send JSON.stringify({request: 'wordList'})
	console.log document.cookie, 'cookies'

makeWordList = (wd) ->
	view = '
		<div data-bind="id=id">
		<input contenteditable="true" data-bind="word"/> - 
		<input contenteditable="true" data-bind="def"/> - 
		<span data-bind="subject"/> - 
		<span data-bind="unit"/> - 
		<span data-bind="category"/> -
		<span id="delete">delete</span>

		</div>
	'
	style = '
	'
	mvc = $$(wd, {format:view, style:style}, {
		'change *': (e) ->
			updateWord(this.model.get())
			# console.log this.model.get()
		'click #delete': (e) ->
			delWord(this.model.get("id"))
			this.destroy()
		})
	obj = $$(wd, mvc)
	$$.document.append(mvc, '#wordList') 
	# $$.document.append($$({word:'foo', def:'bar',subject:'french'}, mvc), '#wordList')

updateWord = (word) ->
	ws.send JSON.stringify({request: 'updateWord', data:word})

getUnits = (sub) ->
	ws.send (JSON.stringify {request:'unitList', data:sub})

addUnit = (u) ->
	$('#addWords #unit').append("<option>#{u.name}</option>")

delWord = (id) ->
	console.log "deleting word with id: #{id}"
	ws.send JSON.stringify(
		request: 'delWord'
		data: {id: id}
	)

# event handlers

#form submit
$('#addWords').submit (e) -> 
	e.preventDefault()
	addWords()
	$("#def").val('')
	$("#word").val('')
	$("#word").focus()

#subject selected
$('#subject').change (e) -> 
	sub = $('#subject')
	getUnits sub.val(); console.log sub.val()

host = window.document.location.host.replace(/:.*/, '')
ws = new WebSocket('ws://' + host + ':3000')

ws.onmessage = (data) -> 
	console.log "message received"
	msg = JSON.parse(data.data)
	# subjectList
	if msg.response == 'subjectList'
		console.log msg.data, 'subjectList'
		addSubject(s) for s in msg.data

	# categoryList
	if msg.response == 'categoryList'
		addCategory c for c in msg.data

	# unitList
	if msg.response == 'unitList'
		addUnit u for u in msg.data

	# wordList
	if msg.response == 'wordList'
		console.log 'getting word list', msg.data
		makeWordList wd for wd in msg.data



ws.onopen =  -> 
	console.log 'socket open'
	pageLoad()


# IMPORTANT 
# when browser refreshes the `ws.onopen` method isn't re-run. 
# to do this put the contents of `ws.onopen` in the conditional
$(window).load (e) ->
	console.log 'loaded'
	if ws.isopen
		pageLoad()
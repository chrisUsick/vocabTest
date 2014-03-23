# functions
pageLoad = () -> 
	ws.send JSON.stringify({request:'subjectList'})
	ws.send JSON.stringify({request: 'categoryList'})

###
OBJECT wd {
	STRING question
	STRING answer
}
###
addTestWord = (wd) ->

	console.log 'word to add: ', wd
	view = '
		<p>question: <span data-bind="question"/>
		answer: <input id="input" type=text>
		<span id="correct"/>
		<button>show answer</button>
		<span id="answer" data-bind="answer"/>
		</p>
	'
	style = '& span#correct {display: none;} & span#answer {display:none}'
	mvc = $$(wd, {format:view, style:style}, {
		'create': (e) -> 
			# console.log @view.$("#input").focus()
			# BUG problem with jQuery selector and focus() method.  Doesn't work
			$("#testWords p input").focus()
		'change input': (e) -> 
			if this.view.$('#input').val() == this.model.get('answer')
				this.view.$('#correct').show().text('correct')
			else this.view.$('#correct').show().text('incorrect')
			$("#testType").submit()
		'click button': (e) ->
			this.view.$('#answer').show()
		})
	$$.document.prepend(mvc, '#testWords')

addSubject = (s) -> 
	# console.log $('#testType #subject')
	$('#testType #subject').append("<option>#{s.name}</option>")

addCategory = (c) ->
	$('#category').append("<option>#{c.name}</option>")

getUnits = (sub) ->
	ws.send (JSON.stringify {request:'unitList', data:sub})

addUnit = (u) ->
	$('#unit').append("<option>#{u.name}</option>")

#event handlers
$('#testType').submit (e) ->
	e.preventDefault()
	form = '#testType'
	w_or_d = if $(form + ' input:radio:checked')[0].id == 'word' then true else false
	d = {
		subject: $(form + ' #subject').val()
		unit: $(form + ' select#unit').val()
		category: $(form + ' #category').val()
		w_or_d: w_or_d
	}
	console.log d
	ws.send JSON.stringify({request:'testWord', data:d})

$('#subject').change (e) ->
	getUnits $('#subject').val()

# websockets
host = window.document.location.host.replace(/:.*/, '')
ws = new WebSocket('ws://' + host + ':3000')

ws.onmessage = (data) -> 
	msg = JSON.parse(data.data)
	console.log 'message received:' + msg.response
	# subjectList
	if msg.response == 'subjectList'
		# console.log msg.data
		addSubject(s) for s in msg.data

	# categoryList
	if msg.response == 'categoryList'
		addCategory c for c in msg.data

	# unitList
	if msg.response == 'unitList'
		addUnit u for u in msg.data

	# testWord
	if msg.response == 'testWord'
		console.log msg.data
		# server returns an array with length = 1, so just take the first element
		addTestWord {question:msg.data[0].q, answer:msg.data[0].a}		
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
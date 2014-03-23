host = window.document.location.host.replace(/:.*/, '')
ws = new WebSocket('ws://' + host + ':3000')

ws.onmessage = (data) -> 
	console.log "message received"
	msg = JSON.parse(data.data)
	# subjectList
	if msg.response == 'subjectList'
		console.log msg.data
	if msg.response == 'returnEvens'
		console.log msg.data[0]

ws.onopen = ->
	# console.log 'websocket open'
	# console.log "oppen"
	ws.send JSON.stringify({request:'subjectList', data:''})
	ws.send JSON.stringify({request:'returnEvens', data:[1,2,3,4,5,6]})
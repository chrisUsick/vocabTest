class WsHandler
	constructor: () ->

	convos: [] # Array<WSC-extensions>
	addConversations: (cons) ->
		@convos = @convos.concat cons

	onmessage: (msg) ->
		convo = con for con in @convos when con[msg.request]
		if convo
			convo.onmessage msg
		else console.log "no response for #{msg.request} request"
		
exports.WsHandler = WsHandler
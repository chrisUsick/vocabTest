class WSC
	constructor: (@ws) ->

	onmessage: (msg) ->
		data = msg.data or {}
		@[msg.request] data, (r) =>
			res = JSON.stringify(
				response: msg.request
				data: r
			)
			@ws.send res

exports.WSC = WSC
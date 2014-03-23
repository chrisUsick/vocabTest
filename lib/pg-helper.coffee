exports.runQuery = (client, q, args, cb) ->
	client.on('drain', client.end.bind(client))
	client.connect()
	client.query q, args, (err, result) =>
		if (err)
			console.log 'couldnt run query', err 
			return
		cb result.rows
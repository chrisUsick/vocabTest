WSC = require('./WSC.js').WSC
runQuery = require("./pg-helper.js").runQuery

class IndexWs extends WSC
	constructor: (ws, @Client, @constring) ->
		super ws

	addWord: (data, cb) ->
		runQuery new @Client(@constring), "select * from add_word($1, $2, $3, $4, $5)", [data.word, data.def, data.subject, data.unit, data.category], cb

	delWord: (data, cb) ->
		console.log "delete word with id #{data.id}"
		runQuery new @Client(@constring), "select * from del_word($1)", [data.id], cb

	wordList: (data, cb) ->
		console.log data.ses, 'from IndexWs.wordList()'
		runQuery new @Client(@constring), "select * from word_view", null, cb

exports.IndexWs = IndexWs
WSC = require('./WSC.js').WSC
runQuery = require("./pg-helper.js").runQuery

class TestWs extends WSC
	constructor: (ws, @Client, @constring) ->
		super ws
	testWord: (data, cb) ->
		runQuery new @Client(@constring), "select * from test_word($1::varchar, $2::varchar, $3::varchar, $4::boolean)", [data.subject, data.unit, data.category, data.w_or_d], cb

exports.TestWs = TestWs
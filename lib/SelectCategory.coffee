WSC = require('./WSC.js').WSC
runQuery = require("./pg-helper.js").runQuery

class SelectCategory extends WSC
	constructor: (ws, @Client, @constring) ->
		super ws

	subjectList: (data, cb) ->
		runQuery new @Client(@constring), "select name from subjects", null, cb

	unitList: (data, cb) ->
		runQuery new @Client(@constring), "select * from unit_list('#{data}')", null, cb

	categoryList: (data, cb) ->
		runQuery new @Client(@constring), "select * from categories;", null, cb
		

exports.SelectCategory = SelectCategory 

#
# * GET home page.
# 
exports.index = (req, res) ->
	user = req.session.passport.user

	console.log user if user
	console.log req.session, 'in routes'
	res.render "index",
    title: "Express"
    user: user

  return

exports.test = (req, res) ->
	user = req.session.passport.user
	res.render "test",
		user: user

exports.login = (req,res) ->
	res.render "login"
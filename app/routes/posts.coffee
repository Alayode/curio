exports.read = (req, res, next) ->

exports.create = (req, res, next) ->
  post = new Post(req.body).set_user(req.session.user.id)
  utils.save_and_send(req, res, next, post)


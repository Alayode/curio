app.param ':config', (req, res, next, id) ->
  SiteConfig.find id, (err, config) ->
    return next(err) if err?.status = 500
    req.resource = config
    next()

app.param ':source', (req, res, next, source) ->
  model = global[fleck.capitalize(source)]
  new model(req.body).validate (err, source) ->
    return next(err) if err?.status = 400
    req.source = source
    next()

app.param ':user', (req, res, next, id) ->
  User.find id, (err, user) ->
    return next(err) if err?.status = 404
    req.resource = user
    req.resource.set_self() if req.resource.id() is req.session?.user?.id
    next()

app.param ':post', (req, res, next, id) ->
  Post.find id, (err, post) ->
    return next(err) if err?.status = 404
    req.resource = post
    next()

app.param ':page', (req, res, next, id) ->
  Page.find id, (err, page) ->
    return next(err) if err?.status = 404
    req.resource = page
    next()

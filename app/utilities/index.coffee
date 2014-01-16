fs = require('fs')
require('./underscore_mixins')

exports.randomString = (length=32) ->
  str = ''
  str += Math.random().toString(36).substr(2) while str.length < length
  str.substr(0, length)

exports.walk_dir = (dir) ->
  results = []
  for file in fs.readdirSync(dir)
    file = "#{dir}/#{file}"
    stat = fs.statSync(file)
    switch true
      when stat?.isDirectory() then results = results.concat(utils.walk_dir(file))
      else results.push(file)
  return results

exports.is_json_request = (req) ->
  req.is('json') or _(req.accepted).any((a) -> a.subtype is 'json')

exports.save_and_send = (req, res, next, model) ->
  model.save (err, model) ->
    return next(err) if err?.status = 400
    return res.json(model.toJSON()) unless model.populate?
    model.populate (err, model) ->
      return next(err) if err?.status = 500
      res.json model.toJSON()

exports.cursorJSON = (cursor, fn) ->
  stream  = cursor.stream()
  type    = stream._cursor.collection.collectionName
  model   = global[fleck.inflect(type, 'singularize', 'capitalize')]
  data    = []
  stream.on 'data', (item) ->
    stream.pause()
    new model(item).populate (err, item) ->
      data.push item.toJSON() ; stream.resume()
  stream.on 'close', -> fn(null, data)

exports.streamJSON = (req, res, next, cursor) ->
  utils.cursorJSON cursor, (err, data) ->
    return next(err) if err?.status = 500
    res.json(data)

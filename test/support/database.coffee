exports.connect = (done) ->
  do connect = ->
    return done() if app.mongo.db?.state is 'connected'
    setTimeout connect, 5

empty_db = (fn) ->
  app.mongo.db.collections (err, collections) ->
    async.forEach collections, ((c, fn) ->
      return fn() if /^system/.test(c.collectionName)
      c.remove({}, {safe: true}, fn)
    ), fn

exports.clear = (done) ->
  async.parallel
    redis: (fn) -> app.redis.flushdb(fn)
    mongo: (fn) -> empty_db(fn)
  , done

exports.seed = (done) ->
  app.mongo.seed done

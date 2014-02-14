module.exports = (app) ->
  mongo = app.mongo

  class global.Post extends Model
    @collection: mongo.posts

    @sorted: (page, limit) ->
      @paginated(page, limit).sort('_id', 'desc')

    whitelist: ['title', 'context']

    _user:    -> @model._user
    title:    -> @model.title
    context:  -> @model.context

    validate: (fn) ->
      return fn(new BadRequest('Missing Title')) unless @title()?.length
      return fn(new BadRequest('Missing Context')) unless @context()?.length
      User.collection.find({_id: @_user()}).count (err, count) =>
        return fn(err or new BadRequest('Invalid User')) unless count
        fn(null, this)

    amend: (values) ->
      super(values)
      @set({slug: _(values.title).toSlug()})

    toJSON: ->
      id:         @id()
      title:      @title()
      slug:       @slug()
      created_at: @created_at()
      context:    @context()
      author:     @user?.toJSON()

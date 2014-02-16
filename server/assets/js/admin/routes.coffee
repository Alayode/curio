AppRouter::routes =
  'admin':              'dashboard'
  'admin/settings':     'settings'
  'admin/users(/:id)':  'users'
  'admin/posts(/:id)':  'posts'

App.router = new AppRouter

App.router.on 'route:dashboard', ->
  new App.views.Dashboard().render()

App.router.on 'route:settings', ->
  new App.views.Settings().render()

App.router.on 'route:users', (id) ->
  new App.views.Users().render()

App.router.on 'route:posts', (id) ->
  new App.views.Posts().render()

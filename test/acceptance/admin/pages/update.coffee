describe 'Admin Pages update', ->

  before (done) ->
    @browser.as_admin().visit('/admin/pages', done)

  before ->
    @main     = @browser.query('main[role=main]')
    @overlay  = @browser.query('#page_overlay')
    @form     = @browser.query('form', @overlay)
    @title    = @browser.query('[name=title]', @form)
    @context  = @browser.query('[name=context]', @form)

  beforeEach (done) ->
    @browser.clickLink('.model-list li:first-of-type a', done)

  it 'should update a page title', (done) ->
    @browser.fill('title', 'A New Title').pressButton('Update').then(=>
      expect(@browser.query('#page_overlay')).to.be.null
      page_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', page_item)).to.equal 'A New Title'
      expect(@browser.text('.path', page_item)).to.equal 'path-2'
      return null
    ).then(done, done)

  it 'should update a page path', (done) ->
    @browser.fill('path', 'new-path').pressButton('Update').then(=>
      expect(@browser.query('#page_overlay')).to.be.null
      page_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', page_item)).to.equal 'A New Title'
      expect(@browser.text('.path', page_item)).to.equal 'new-path'
      return null
    ).then(done, done)

  it 'should update a page context', (done) ->
    @browser.fill('context', 'New page content').pressButton('Update').then(=>
      expect(@browser.query('#page_overlay')).to.be.null
      page_item = @browser.query('.model-list li:first-of-type', @main)
      expect(@browser.text('.title', page_item)).to.equal 'A New Title'
      expect(@browser.text('.path', page_item)).to.equal 'new-path'
      return null
    ).then(done, done)

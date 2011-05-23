app = Sammy '#main', ->
  this.use "Template"

  # List index
  this.get '#/', (context) ->
    $('#main').empty()
    $('#main').append("<ul id='lists'></ul>")
    this.load("/lists").then (lists) ->
      for list in lists
        this.render('templates/lists.template', { list: list }).appendTo('#lists')

  # Items index
  this.get '#/lists/:id', ->
    this.load("/lists/#{this.params.id}").then (items) ->
      $('#main').empty().append("<a href='#/'>Back</a>")
      $('#main').append("<ul id='items'></ul>")
      for item in items
        this.render('templates/item.template', { item: item }).appendTo('#items')

$ ->
  app.run('#/')

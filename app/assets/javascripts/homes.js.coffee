app = Sammy '#main', ->

  # List index
  this.get '#/', (context) ->
    $('#main').empty()
    this.load("/lists").then (lists) ->
      $('#main').append("<ul id='lists'></ul>")
      for list in lists
        $('#lists').append("<li><a href='#/lists/#{list}'>#{list}</a></li>")

  # Items index
  this.get '#/lists/:id', ->
    this.load("/lists/#{this.params.id}").then (items) ->
      $('#main').empty().append("<a href='#/'>Back</a>")
      $('#main').append("<ul id='items'></ul>")
      for item in items
        if item.prio
          $('#items').append("<li class='prio_#{item.prio.toLowerCase()}'>#{item.text}</li>")
        else
          $('#items').append("<li>#{item.text}</li>")

$ ->
  app.run('#/')

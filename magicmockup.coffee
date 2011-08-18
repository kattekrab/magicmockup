$ = @jQuery

@magicmockup = do ->
  inkNS = 'http://www.inkscape.org/namespaces/inkscape'
  $doc = $(@document)
  views = {}

  _dispatch = (context, command, id) ->
    act =
      next: ->
        # Hide the current visible view
        $(context).parents('g:visible').last().hide()
        # Show the specified view
        $(views[id]).show?()

    act[command]?()


  init = ->
    # Propogate views
    $('g').each ->
      label = @getAttributeNS(inkNS, 'label')
      views[label] = @ if label

    $doc
      .delegate 'g', 'click', (e) ->
        actions = $(e.currentTarget).children('desc').text()

        return unless actions

        for action in actions.split(/([\s\n]+)/)
          [command, id] = action.split(/\=/)

          _dispatch(@, command, id)

      .delegate 'g', 'hover', (e) ->
        $this = $(this)

        return if $this.data('hoverable')

        actions = $(e.currentTarget).children('desc').text()

        return unless actions

        $this.css(cursor: 'pointer').data('hoverable', true)



  {init} # Public exports


# Dummy function to handle the inline JS
@nextScreen = (e) ->
  #e.preventDefault()

@init = ->
  magicmockup.init()

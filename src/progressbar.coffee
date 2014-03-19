((document, window) ->
  "use strict"

  progressBar = (el, options) ->

    updateBar = (el, percentage) ->
      el.style.width = percentage + '%'

    updateText = (el, text) ->
      el.innerText = text

    updateTime = (el, time) ->
      updateText(el, time+' s')

      if time > 0
        setTimeout( ->
          time--
          updateTime el, time
        , 1000)

    updateProgress = (el, options)->
      now = new Date()
      timeDiff = now.getTime() - options.start.getTime()
      perc = Math.floor((timeDiff/options.waitMs)*100)

      if perc <= 100
        updateBar options.pBar, perc
        updateText( options.pText, perc+' %') if options.asPerc
        setTimeout( ->
          updateProgress(el, options)
        , options.timeoutVal)

    getEl = (el) ->
      # Wrapper
      wrapperEl = el.replace("#","")

      # Try selecting ID first
      if document.getElementById(wrapperEl)
        wrapper = document.getElementById(wrapperEl)

      # If element with an ID doesn't exist, use querySelector
      else if document.querySelector(wrapperEl)
        wrapper = document.querySelector(wrapperEl)

      # If element doesn't exists, stop here.
      else
        # throw new Error("The element you are trying to select doesn't exist")
        wrapper = null

      return wrapper

    progress = undefined
    opts = undefined

    ProgressBar = (el, options) ->

      i = undefined

      # Defaults
      @options =
        start : new Date()
        pBar : '.progress__bar'
        pText : '.progress__text'
        asPerc : false
        waitSeconds : 160

      for i of options
        @options[i] = options[i]

      opts = @options
      progress = getEl el
      opts.pBar = getEl(opts.pBar)
      opts.pText = getEl(opts.pText)
      opts.waitMs = opts.waitSeconds * 1000
      opts.timeoutVal = Math.floor(opts.waitMs/100)

      @_init this
      return

    ProgressBar:: =
      _init : ->

        updateTime(opts.pText, opts.waitSeconds) if opts.pText and not opts.asPerc
        updateProgress(progress, opts)
        return



    new ProgressBar(el,options)

  window.progressBar = progressBar
  return
) document, window

opts = {
  start : new Date()
}

progressBar('.progress', opts)
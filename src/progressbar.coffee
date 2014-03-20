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

    updateStatus = (perc, options)
      p = if (perc <= 100) then perc else 100
      unless isPaused
        updateBar options.pBar, p
        updateText( options.pText, p+' %') if options.asPercent

    updateProgress = (el, options)->
      now = new Date()
      timeDiff = now.getTime() - options.start.getTime()
      perc = Math.floor((timeDiff/options.waitMs)*100)

      if perc <= 100 and not isPaused

        updateStatus(perc, options)

        setTimeout( ->
          updateProgress(el, options)
        , options.timeoutVal)
      else
        updateStatus(perc, options)

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
    isPaused = undefined
    pauseStart = undefined

    ProgressBar = (el, options) ->

      i = undefined

      # Defaults
      @options =
        start : new Date()
        pBar : '.progress__bar'
        pText : '.progress__text'
        asPercent : false
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
      toggle : ->
        if isPaused
          @run()
        else
          @pause()

      run : ->
        isPaused = false

        # opts.start = new Date(@_getNewWait(opts.waitSeconds, pauseStart))
        # console.log @_getPauseSeconds(pauseStart)
        # @updateWait(@_getPauseSeconds(pauseStart))
        @updateWait(30)

        updateProgress(progress, opts)
        return

      pause : ->
        @_setPause()
        isPaused = true
        return

      # Sets new wait time (in seconds)
      updateWait : (t) ->
        opts.waitSeconds = t
        opts.waitMs = t * 1000
        opts.timeoutVal = Math.floor(opts.waitMs/100)
        return


      _init : ->

        updateTime(opts.pText, opts.waitSeconds) if opts.pText and not opts.asPercent
        updateProgress(progress, opts)
        return

      _setPause : ->
        pauseStart = new Date()

      _getPauseSeconds : (pause) ->
        now = new Date()
        return Math.round((now.getTime() - pause.getTime())/1000)


    new ProgressBar(el,options)

  window.progressBar = progressBar
  return
) document, window

opts = {
  start : new Date()
  waitSeconds : 60
  asPercent : true
}

tmp = progressBar('.progress', opts)
((document, window) ->
  "use strict"

  progressBar = (el, options) ->

    updateBar = (el, percentage) ->
      el.style.width = percentage + '%'
      el.setAttribute('data-value', percentage)
      return

    updateText = (el, text) ->
      # TODO : neds to be more browser agnostic
      el.innerText = text

    updateTime = (el, time) ->
      # TODO: Update the time when recalculation happens

      updateText(el, time+' s')

      if time > 0
        setTimeout( ->
          time--
          updateTime el, time
        , 1000)

    updateStatus = (perc, options) ->
      p = if (perc <= 100) then perc else 100
      unless isPaused
        updateBar options.pBar, p
        updateText( options.pText, p+' %') if options.asPercent

    updateProgress = (el, options)->
      now = new Date()
      timeDiff = now.getTime() - options.start.getTime()
      # Should we separate the percentage calculation?
      p = Math.floor((timeDiff/options.waitMs)*100)
      perc = if (p >= 0) then p else 100
      curPerc = options.pBar.getAttribute('data-value')

      # If new perc is smalle than current perc
      perc = if (perc < curPerc) then curPerc else perc

      updateStatus(perc, options)

      if perc < 100 and not isPaused

        setTimeout( ->
          updateProgress(el, options)
        , options.timeoutVal)

    recalculateProgress = (time, opts) ->

      # get the curent percentage
      curP = opts.pBar.getAttribute('data-value')

      # get the remaining percentage
      remaining = 100-curP

      # get the time passed
      passedTime = Math.floor(opts.waitSeconds*curP/100)

      # get the new remainig time
      newRemainingTime = if (time-passedTime < 0) then 0 else time-passedTime

      # recalculate the new wait time and speed based on the current percenage position
      newWaitTime = Math.floor(newRemainingTime/(remaining/100))

      # Calculate new start offset
      startOffset = (newWaitTime-newRemainingTime)*1000
      now = new Date()

      # Set the new start time
      opts.start = new Date( now.getTime() - startOffset)
      opts.waitSeconds = newWaitTime
      opts.waitMs = opts.waitSeconds * 1000
      opts.timeoutVal = Math.floor(opts.waitMs/100)

      return

    addTime = (v1, v2) ->
      parseFloat(v1) + parseFloat(v2)

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
        pText : null
        asPercent : false
        waitSeconds : 160

      for i of options
        @options[i] = options[i]

      opts = @options
      progress = getEl el
      opts.pBar = getEl(opts.pBar)
      opts.pText = if (opts.pText) then getEl(opts.pText) else opts.pText
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

        @updateWait('+' + @_getPauseSeconds(pauseStart))

        updateProgress(progress, opts)
        return

      # Pause the progress bar
      pause : ->
        @_setPause()
        isPaused = true
        return

      # Sets new wait time (in seconds)
      updateWait : (t) ->
        t = if (t.match(/\+|\-/)) then addTime(opts.waitSeconds, t) else t

        # opts.waitSeconds = t
        # opts.waitMs = t * 1000
        # opts.timeoutVal = Math.floor(opts.waitMs/100)
        @_recalculate(t)
        return

      # Set progress bar to 100
      done : ->
        @updateWait('0')

      _init : ->

        updateTime(opts.pText, opts.waitSeconds) if opts.pText and not opts.asPercent
        updateProgress(progress, opts)
        return

      _setPause : ->
        pauseStart = new Date()

      _getPauseSeconds : (pause) ->
        now = new Date()
        return Math.round((now.getTime() - pause.getTime())/1000)

      _recalculate : (time)->
        recalculateProgress(time,opts)

    new ProgressBar(el,options)

  window.progressBar = progressBar
  return
) document, window
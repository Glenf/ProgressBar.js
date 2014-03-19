((document, window) ->
  "use strict"

  progressBar = (el, options) ->

    updateBar = (el, percentage) ->
      el.style.width = percentage + '%'

    updateText = (el, text) ->
      el.innerText = text

    updateTime = (el, time) ->
      updateText(time+' s')

      if time > 0
        setTimeout( ->
          time--
          updateTime(time)
        , 1000)

    updateProgress = ->
      now = new Date()
      timeDiff = now.getTime() - start.getTime()
      perc = Math.floor((timeDiff/wait)*100)

      if perc <= 100
        updateBar perc
        updateText(perc+' %') if asPerc
        setTimeout( ->
          updateProgress()
        , timeoutVal)

    progress = undefined
    opts = undefined

    ProgressBar = (el, options ) ->

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

      # Wrapper
      @wrapperEl = el.replace("#","")

      # Try selecting ID first
      if document.getElementById(@wrapperEl)
        @wrapper = document.getElementById(@wrapperEl)

      # If element with an ID doesn't exist, use querySelector
      else if document.querySelector(@wrapperEl)
        @wrapper = document.querySelector(@wrapperEl)

      # If element doesn't exists, stop here.
      else
        throw new Error("The element you are trying to select doesn't exist")

      opts = @options
      progress = @wrapper

      return

    ProgressBar:: =



    new ProgressBar(el,options)

  window.progressBar = progressBar
  return
) document, window

opts = {
  start : new Date()
}

progressBar('.progress', opts)
var opts, tmp;

(function(document, window) {
  "use strict";
  var progressBar;
  progressBar = function(el, options) {
    var ProgressBar, getEl, isPaused, opts, pauseStart, progress, updateBar, updateProgress, updateText, updateTime;
    updateBar = function(el, percentage) {
      return el.style.width = percentage + '%';
    };
    updateText = function(el, text) {
      return el.innerText = text;
    };
    updateTime = function(el, time) {
      updateText(el, time + ' s');
      if (time > 0) {
        return setTimeout(function() {
          time--;
          return updateTime(el, time);
        }, 1000);
      }
    };
    updateProgress = function(el, options) {
      var now, perc, timeDiff;
      now = new Date();
      timeDiff = now.getTime() - options.start.getTime();
      perc = Math.floor((timeDiff / options.waitMs) * 100);
      if (perc <= 100 && !isPaused) {
        updateBar(options.pBar, perc);
        if (options.asPercent) {
          updateText(options.pText, perc + ' %');
        }
        return setTimeout(function() {
          return updateProgress(el, options);
        }, options.timeoutVal);
      }
    };
    getEl = function(el) {
      var wrapper, wrapperEl;
      wrapperEl = el.replace("#", "");
      if (document.getElementById(wrapperEl)) {
        wrapper = document.getElementById(wrapperEl);
      } else if (document.querySelector(wrapperEl)) {
        wrapper = document.querySelector(wrapperEl);
      } else {
        wrapper = null;
      }
      return wrapper;
    };
    progress = void 0;
    opts = void 0;
    isPaused = void 0;
    pauseStart = void 0;
    ProgressBar = function(el, options) {
      var i;
      i = void 0;
      this.options = {
        start: new Date(),
        pBar: '.progress__bar',
        pText: '.progress__text',
        asPercent: false,
        waitSeconds: 160
      };
      for (i in options) {
        this.options[i] = options[i];
      }
      opts = this.options;
      progress = getEl(el);
      opts.pBar = getEl(opts.pBar);
      opts.pText = getEl(opts.pText);
      opts.waitMs = opts.waitSeconds * 1000;
      opts.timeoutVal = Math.floor(opts.waitMs / 100);
      this._init(this);
    };
    ProgressBar.prototype = {
      toggle: function() {
        if (isPaused) {
          return this.run();
        } else {
          return this.pause();
        }
      },
      run: function() {
        isPaused = false;
        this.updateWait(30);
        console.log(opts);
        updateProgress(progress, opts);
      },
      pause: function() {
        this._setPause();
        isPaused = true;
      },
      updateWait: function(t) {
        opts.waitSeconds = t;
        opts.waitMs = t * 1000;
        return opts.timeoutVal = Math.floor(opts.waitMs / 100);
      },
      _init: function() {
        if (opts.pText && !opts.asPercent) {
          updateTime(opts.pText, opts.waitSeconds);
        }
        updateProgress(progress, opts);
      },
      _setPause: function() {
        return pauseStart = new Date();
      },
      _getPauseSeconds: function(pause) {
        var now;
        now = new Date();
        return Math.round((now.getTime() - pause.getTime()) / 1000);
      }
    };
    return new ProgressBar(el, options);
  };
  window.progressBar = progressBar;
})(document, window);

opts = {
  start: new Date(),
  waitSeconds: 60,
  asPercent: true
};

tmp = progressBar('.progress', opts);

var opts, tmp;

(function(document, window) {
  "use strict";
  var progressBar;
  progressBar = function(el, options) {
    var ProgressBar, addTime, calculateRemaining, getEl, isPaused, opts, pauseStart, progress, updateBar, updateProgress, updateStatus, updateText, updateTime;
    updateBar = function(el, percentage) {
      el.style.width = percentage + '%';
      el.dataset.value = percentage;
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
    updateStatus = function(perc, options) {
      var p;
      p = perc <= 100 ? perc : 100;
      if (!isPaused) {
        updateBar(options.pBar, p);
        if (options.asPercent) {
          return updateText(options.pText, p + ' %');
        }
      }
    };
    updateProgress = function(el, options) {
      var now, perc, timeDiff;
      now = new Date();
      timeDiff = now.getTime() - options.start.getTime();
      perc = Math.floor((timeDiff / options.waitMs) * 100);
      if (perc < options.pBar.dataset.value) {
        calculateRemaining(options);
      }
      if (perc <= 100 && !isPaused) {
        updateStatus(perc, options);
        return setTimeout(function() {
          return updateProgress(el, options);
        }, options.timeoutVal);
      } else {
        return updateStatus(perc, options);
      }
    };
    calculateRemaining = function(options) {
      var remaining;
      remaining = 100 - options.pBar.dataset.value;
    };
    addTime = function(v1, v2) {
      return parseFloat(v1) + parseFloat(v2);
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
        this.updateWait('+' + this._getPauseSeconds(pauseStart));
        updateProgress(progress, opts);
      },
      pause: function() {
        this._setPause();
        isPaused = true;
      },
      updateWait: function(t) {
        t = t.match(/\+|\-/) ? addTime(opts.waitSeconds, t) : t;
        opts.waitSeconds = t;
        opts.waitMs = t * 1000;
        opts.timeoutVal = Math.floor(opts.waitMs / 100);
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
  waitSeconds: 100,
  asPercent: true
};

tmp = progressBar('.progress', opts);

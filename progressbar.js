var opts;

(function(document, window) {
  "use strict";
  var progressBar;
  progressBar = function(el, options) {
    var ProgressBar, getEl, opts, progress, updateBar, updateProgress, updateText, updateTime;
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
      if (perc <= 100) {
        updateBar(options.pBar, perc);
        if (options.asPerc) {
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
    ProgressBar = function(el, options) {
      var i;
      i = void 0;
      this.options = {
        start: new Date(),
        pBar: '.progress__bar',
        pText: '.progress__text',
        asPerc: false,
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
      _init: function() {
        if (opts.pText && !opts.asPerc) {
          updateTime(opts.pText, opts.waitSeconds);
        }
        updateProgress(progress, opts);
      }
    };
    return new ProgressBar(el, options);
  };
  window.progressBar = progressBar;
})(document, window);

opts = {
  start: new Date()
};

progressBar('.progress', opts);

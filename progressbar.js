(function() {
  var opts;

  (function(document, window) {
    "use strict";
    var progressBar;
    progressBar = function(el, options) {
      var ProgressBar, opts, progress, updateBar, updateProgress, updateText, updateTime;
      updateBar = function(el, percentage) {
        return el.style.width = percentage + '%';
      };
      updateText = function(el, text) {
        return el.innerText = text;
      };
      updateTime = function(el, time) {
        updateText(time + ' s');
        if (time > 0) {
          return setTimeout(function() {
            time--;
            return updateTime(time);
          }, 1000);
        }
      };
      updateProgress = function() {
        var now, perc, timeDiff;
        now = new Date();
        timeDiff = now.getTime() - start.getTime();
        perc = Math.floor((timeDiff / wait) * 100);
        if (perc <= 100) {
          updateBar(perc);
          if (asPerc) {
            updateText(perc + ' %');
          }
          return setTimeout(function() {
            return updateProgress();
          }, timeoutVal);
        }
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
        this.wrapperEl = el.replace("#", "");
        if (document.getElementById(this.wrapperEl)) {
          this.wrapper = document.getElementById(this.wrapperEl);
        } else if (document.querySelector(this.wrapperEl)) {
          this.wrapper = document.querySelector(this.wrapperEl);
        } else {
          throw new Error("The element you are trying to select doesn't exist");
        }
        opts = this.options;
        progress = this.wrapper;
      };
      return ProgressBar.prototype = new ProgressBar(el, options);
    };
    window.progressBar = progressBar;
  })(document, window);

  opts = {
    start: new Date()
  };

  progressBar('.progress', opts);

}).call(this);

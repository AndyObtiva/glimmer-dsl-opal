/**
 * jquery.sash.js
 *
 * jQuery Sash Plugin implements so-called sash element: layout with two panels,
 * divided with thin draggable bar. Sash can be vertical or horizontal,
 * accurately works with margins, paddings, borders. Nested sash elements are supported.
 * Written by Andrey Hihlovskiy (akhikhl AT gmail DOT com).
 * Licensed under the MIT (http://opensource.org/licenses/MIT).
 * Date: 30.05.2013
 *
 * @author Andrey Hihlovskiy
 * @version 1.0.0
 * @requires jQuery v1.7 or later
 * @requires jQuery UI v1.7 or later
 * @requires jQuery resize plugin v1.1 or later
 *
 * https://github.com/akhikhl/jquery.sash
 *
 **/
jQuery(function($) {

  function Context(sash, options) {
  
    options = options || sash.get(0)._sashOptions;
    var orientation = options.orientation || "horizontal";
    var ratio = typeof options.ratio == "undefined" ? 0.5 : options.ratio;

    function getDecoration(elem) {
      if(orientation == "horizontal")
        return elem.outerWidth ? elem.outerWidth(true) - elem.width() : 0;
      else
        return elem.outerHeight ? elem.outerHeight(true) - elem.height() : 0;
    }

    function getOuterWidth(elem) {
      if(orientation == "horizontal")
        return elem.outerWidth ? elem.outerWidth(true) : elem.width();
      else
        return elem.outerHeight ? elem.outerHeight(true) : elem.height();
    }

    function getWidth(elem) {
      return orientation == "horizontal" ? elem.width() : elem.height();
    }
    this.getWidth = getWidth;
  
    function setBegin(elem, value) {
      var style = {};
      style[orientation == "horizontal" ? "left" : "top"] = typeof value == "number" ? (String(value) + "px") : "";
      elem.css(style);
    }
  
    function setEnd(elem, value) {
      var style = {};
      style[orientation == "horizontal" ? "right" : "bottom"] = typeof value == "number" ? (String(value) + "px") : "";
      elem.css(style);
    }
  
    function setWidth(elem, value) {
      var style = {};
      style[orientation == "horizontal" ? "width" : "height"] = typeof value == "number" ? (String(value) + "px") : "";
      elem.css(style);
    }
  
    function getInnerWidth(elem) {
      if(orientation == "horizontal")
        return elem.innerWidth ? elem.innerWidth() : elem.width();
      else
        return elem.innerHeight ? elem.innerHeight() : elem.height();
    }

    if(!options.content1) {
      $.error("Sash requires property options.content1");
      return;
    }
    if(!options.content2) {
      $.error("Sash requires property options.content2");
      return;
    }
    
    var cw = getInnerWidth(sash);
    var content1 = sash.children(options.content1);
    var deco1 = getDecoration(content1);
    var visible1 = content1.is(":visible");
    var content2 = sash.children(options.content2);
    var deco2 = getDecoration(content2);
    var visible2 = content2.is(":visible");
    var splitter = sash.children(".sashSplitter");
    var isw = options.splitterWidth || 5; // inner splitter width
    var osw; // outer splitter width
    var sa; // shared area - this is an area, not occupied by decoration or splitter
    if(splitter.length != 0) {
      osw = isw + getDecoration(splitter);
      sa = cw - deco1 - deco2 - osw;
    }
    
    function updateStyleClasses() {
      if(orientation == "horizontal") {
        splitter.addClass("sashSplitterh").removeClass("sashSplitterv");
        content1.addClass("sashContent1h").removeClass("sashContent1v");
        content2.addClass("sashContent2h").removeClass("sashContent2v");
      } else {
        splitter.addClass("sashSplitterv").removeClass("sashSplitterh");
        content1.addClass("sashContent1v").removeClass("sashContent1h");
        content2.addClass("sashContent2v").removeClass("sashContent2h");
      }
    }

    function setWidth1(iw1, ratio) {
      var ow1 = iw1 + deco1;
      options.visible1 = visible1;
      options.visible2 = visible2;
      if(visible1) {
        if(visible2) { // both are visible
          ratio = ratio || (ow1 / cw);
          var ow2 = cw - ow1 - osw;
          var iw2 = ow2 - deco2;
          if(options.minRatio && ratio < parseFloat(options.minRatio)) {
            ratio = Math.max(ratio, parseFloat(options.minRatio));
            ow1 = ratio * cw;
            iw1 = ow1 - deco1;
            ow2 = cw - ow1 - osw;
            iw2 = ow2 - deco2;
          }
          if(options.maxRatio && ratio > parseFloat(options.maxRatio)) {
            ratio = Math.min(ratio, parseFloat(options.maxRatio));
            ow1 = ratio * cw;
            iw1 = ow1 - deco1;
            ow2 = cw - ow1 - osw;
            iw2 = ow2 - deco2;
          }
          var minWidth1 = options.minWidth1 && parseFloat(options.minWidth1);
          if(minWidth1 && iw1 < minWidth1) {
            iw1 = Math.max(iw1, minWidth1);
            ow1 = iw1 + deco1;
            ratio = ow1 / cw;
            ow2 = cw - ow1 - osw;
            iw2 = ow2 - deco2;
          }
          var maxWidth1 = options.maxWidth1 && parseFloat(options.maxWidth1);
          if(maxWidth1 && iw1 > maxWidth1) {
            iw1 = Math.min(iw1, maxWidth1);
            ow1 = iw1 + deco1;
            ratio = ow1 / cw;
            ow2 = cw - ow1 - osw;
            iw2 = ow2 - deco2;
          }
          var minWidth2 = options.minWidth2 && parseFloat(options.minWidth2);
          if(minWidth2 && iw2 < minWidth2) {
            iw2 = Math.max(iw2, minWidth2);
            ow2 = iw2 + deco2;
            ow1 = cw - ow2 - osw;
            iw1 = ow1 - deco1;
            ratio = ow1 / cw;
          }
          var maxWidth2 = options.maxWidth2 && parseFloat(options.maxWidth2);
          if(maxWidth2 && iw2 > maxWidth2) {
            iw2 = Math.min(iw2, maxWidth2);
            ow2 = iw2 + deco2;
            ow1 = cw - ow2 - osw;
            iw1 = ow1 - deco1;
            ratio = ow1 / cw;
          }
          options.ratio = ratio;
          options.width1 = iw1;
          options.width2 = iw2;
          splitter.show();
          if(options.mirror) {
            setBegin(content1, 0);
            setWidth(content1, null);
            setEnd(content1, ow2 + osw);
            setBegin(splitter, null);
            setWidth(splitter, isw);
            setEnd(splitter, ow2);
            setBegin(content2, null);
            setWidth(content2, iw2);
            setEnd(content2, 0);
          }
          else {
            setBegin(content1, 0);
            setWidth(content1, iw1);
            setEnd(content1, null);
            setBegin(splitter, ow1);
            setWidth(splitter, isw);
            setEnd(splitter, null);
            setBegin(content2, ow1 + osw);
            setWidth(content2, null);
            setEnd(content2, 0);
          }
        }
        else { // only 1 is visible
          options.width1 = cw - deco1;
          options.width2 = 0;
          options.ratio = 1;
          setBegin(content1, 0);
          setWidth(content1, null);
          setEnd(content1, 0);
          splitter.hide();
        }
      }
      else if(visible2) { // only 2 is visible
        options.width1 = 0;
        options.width2 = cw - deco2;
        options.ratio = 0;
        setBegin(content2, 0);
        setWidth(content2, null);
        setEnd(content2, 0);
        splitter.hide();
      }
      else { // none visible
        options.width1 = 0;
        options.width2 = 0;
        options.ratio = 0.5;
        splitter.hide();
      }
      if(options.splitterColor)
        splitter.css({ "background-color": options.splitterColor });
      sash.trigger("sashMoved", [ getInfo() ]);
    }
    this.setWidth1 = setWidth1;
  
    function setWidth2(iw2) {
      var iw1 =
        typeof iw2 == "undefined" ?
          (options.mirror ? sa - options._saved_iw : options._saved_iw) :
          sa - iw2;
      setWidth1(iw1);
    }
    this.setWidth2 = setWidth2;
    
    this.getContent1 = function() { return content1; };
    this.getContent2 = function() { return content2; };
    this.getDeco1 = function() { return deco1; };
    this.getDeco2 = function() { return deco2; };
    
    function getInfo() {
      return { orientation: orientation, ratio: options.ratio, width1: options.width1, width2: options.width2,
            visible1: options.visible1, visible2: options.visible2 };
    }
    this.getInfo = getInfo;
    
    this.getOrientation = function() { return orientation; };
    
    this.content1 = function() {
      return content1;
    };
    
    this.content2 = function() {
      return content2;
    };
    
    this.init = function() {
      sash.each(function() {
        this._sashOptions = options;
      });
      splitter = $("<div/>").addClass("sashSplitter").appendTo(sash);
      if(sash.attr("id"))
        splitter.attr("id", sash.attr("id") + "_splitter");
      updateStyleClasses();
      splitter.draggable({
        stop: function(event, ui) {
          var ctx = new Context(sash);
          var ow1 = ctx.getOrientation() == "horizontal" ? ui.position.left : ui.position.top;
          var iw1 = ow1 - ctx.getDeco1();
          ctx.setWidth1(iw1);
          sash.trigger("sashDragged", [ ctx.getInfo() ]);
        }
      });
      splitter.css("position", "");
      osw = isw + getDecoration(splitter);
      sa = cw - deco1 - deco2 - osw;
      sash.resize(function() {
        var ctx = new Context(sash);
        ctx.setWidth1(ctx.getWidth(ctx.getContent1()));
      });
      if(options.ratio)
        this.ratio(options.ratio);
      else if(options.width1)
        this.width1(options.width1);
      else if(options.width2)
        this.width2(options.width2);
      else
        this.ratio(0.5);
    };
    
    this.orientation = function(newValue) {
      if(typeof newValue == "undefined")
        return orientation;
      if(newValue == "toggle")
        newValue = orientation == "horizontal" ? "vertical" : "horizontal";
      if(orientation != newValue) {
        var iw1 = getWidth(content1); // attention: call order is important here
        orientation = options.orientation = newValue;
        var clearPos = { left: "", top: "", right: "", bottom: "", width: "", height: "" };
        content1.css(clearPos);
        content2.css(clearPos);
        splitter.css(clearPos);
        updateStyleClasses();
        setWidth1(iw1);
      }
      return sash;
    };
    
    this.ratio = function(newValue) {
      if(typeof newValue == "undefined")
        return ratio;
      newValue = parseFloat(newValue);
      setWidth1(cw * newValue - deco1, newValue);
      return sash;
    };
    
    this.visible1 = function(newValue) {
      if(typeof newValue == "undefined")
        return visible1;
      var iw1;
      var saved_iw1 = options.mirror ? sa - options._saved_iw : options._saved_iw;
      if(typeof newValue == "object") {
        iw1 = (typeof newValue.width1 != "undefined" && parseInt(newValue.width1)) || saved_iw1;
        newValue = typeof newValue.value == "undefined" ? true : newValue.value; // attention: boolean
      }
      else
        iw1 = saved_iw1;
      iw1 = iw1 || getWidth(content1);
      if(newValue == "toggle")
        newValue = !visible1;
      if(visible1 != newValue) {
        if(newValue) {
          content1.show();
          if(visible2)
            delete options._saved_iw;
        }
        else {
          if(visible2)
            options._saved_iw = options.mirror ? getWidth(content2) : getWidth(content1);
          content1.hide();
        }
        visible1 = content1.is(":visible");
        setWidth1(iw1);
      }
      return sash;
    };
    
    this.visible2 = function(newValue) {
      if(typeof newValue == "undefined")
        return visible2;
      var iw2;
      var saved_iw2 = options.mirror ? options._saved_iw : sa - options._saved_iw;
      if(typeof newValue == "object") {
        iw2 = typeof newValue.width2 != "undefined" && parseInt(newValue.width2) || saved_iw2;
        newValue = typeof newValue.value == "undefined" ? true : newValue.value; // attention: boolean
      }
      else
        iw2 = saved_iw2;
      iw2 = iw2 || getWidth(content2);
      if(newValue == "toggle")
        newValue = !visible2;
      if(visible2 != newValue) {
        if(newValue) {
          content2.show();
          if(visible1)
            delete options._saved_iw;
        }
        else {
          if(visible1)
            options._saved_iw = options.mirror ? getWidth(content2) : getWidth(content1);
          content2.hide();
        }
        visible2 = content2.is(":visible");
        setWidth2(iw2);
      }
      return sash;
    };
    
    this.width1 = function(newValue) {
      if(typeof newValue == "undefined")
        return options.width1;
      newValue = parseInt(newValue);
      setWidth1(newValue);
      return sash;
    };
    
    this.width2 = function(newValue) {
      if(typeof newValue == "undefined")
        return options.width2;
      newValue = parseInt(newValue);
      setWidth2(newValue);
      return sash;
    };
  } // Context
  
  var methods = {
    content1 : function(newValue) {
      return new Context(this).content1(newValue);
    },
    content2 : function(newValue) {
      return new Context(this).content2(newValue);
    },
    init: function(options) {
      return new Context(this, options).init();
    },
    initialized: function() {
      return typeof this.get(0)._sashOptions != "undefined";
    },
    options : function(newValue) {
      return this.get(0)._sashOptions;
    },
    orientation : function(newValue) {
      return new Context(this).orientation(newValue);
    },
    ratio: function(newValue) {
      return new Context(this).ratio(newValue);
    },
    visible1 : function(newValue) {
      return new Context(this).visible1(newValue);
    },
    visible2 : function(newValue) {
      return new Context(this).visible2(newValue);
    },
    width1 : function(newValue) {
      return new Context(this).width1(newValue);
    },
    width2: function(newValue) {
      return new Context(this).width2(newValue);
    }
  };

  $.fn.sash = function(method) {
    if (methods[method])
      return methods[ method ].apply(this, Array.prototype.slice.call(arguments, 1));
      
    if (typeof method == "object" || !method)
      return methods.init.apply(this, arguments);
    
    $.error("Method " +  method + " does not exist on jQuery.sash");
  };
});

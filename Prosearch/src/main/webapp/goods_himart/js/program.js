var toggle   = "[data-button='dropdown'], [data-dropdown='true']";
var Dropdown = function (element) {
    $(element).on("click.p-dropdown", this.toggle);
};

Dropdown.prototype.toggle = function (e) {
    var $parent  = $(this).parent(),
        options = $(this).data(),
        isActive = $parent.hasClass("open");
    dropdownClear();

    if (options.position && !$parent.hasClass(options.position)){
        $parent.addClass(options.position);
    }
    if (options.arrow && !$parent.hasClass("arrow")){
        $parent.addClass("arrow");
    }
    if (options.width){
        var width_target = options.width_target;
        if(!options.width_target){
            width_target = "p-dropdown__list";
        }
        $parent.find("." + width_target).css("width", options.width);
    }
    if (!isActive) {
        if (e.isDefaultPrevented()) { return; }
        $parent.toggleClass("open");
    }
    return false;
};

/**
 * clear
 */
function dropdownClear() {
    $(toggle).each(function () {
        var $parent       = $(this).parent(),
            relatedTarget = { relatedTarget: $(this) };
        if (!$parent.hasClass("open")) { return; }
        $parent.removeClass("open").trigger("hidden.dropdown", relatedTarget);
    });
}

$(document)
.on("click.p-dropdown", dropdownClear)
.on("click.p-dropdown", toggle, Dropdown.prototype.toggle);



function setDate(date,str) {
    var id ="";
    if (str == null || str == undefined || str=="undefined"){
        id="lWidget";
    }else{
        id ="l" + str;
    }
    if(date){
        objCal.value = date;
    }
    $(objCal).removeClass(activeClass).focus();
    closeCal();
}

function getAbsTop(obj) {
    return (obj.offsetParent == null)? 0 : obj.offsetTop+getAbsTop(obj.offsetParent);
}

function getAbsLeft(obj) {
    return (obj.offsetParent == null)? 0 : obj.offsetLeft+getAbsLeft(obj.offsetParent);
}

function findPos(obj) {
    var curLeft = curTop = 0;

    if (obj.offsetParent) {
        do {
            curLeft += obj.offsetLeft;
            curTop += obj.offsetTop;
        } while (obj = obj.offsetParent);
    }

    return {"left": curLeft, "top": curTop};
}

function addWidget(){
    var hasWidget = $("body").find("#lWidget").length;
    if(hasWidget === 0){
        var calIframeStr = "<div id=\"lWidget\" style=\"position:absolute;z-index:1000;\">";
        calIframeStr += "<iframe id=\"wWidget\" name=\"wWidget\" src=\"about:blank\" title=\"달력\"></iframe>";
        calIframeStr += "</div>";
        $("body").append(calIframeStr);
    }else{
        return
    }
}

function closeCal() {
    var elem = document.getElementById("lWidget");
    elem.parentNode.removeChild(elem);
}
function removeActiveClass(obj) {
    $("input[type='text']").not(obj).removeClass(activeClass);
}

var objCal;
var activeClass ="obj-active";
function getCalendar(objName, syear, smonth, str) {

    if( !objName){
        alert("getCalendar(document.bbsNttForm.start_date)와 같이 입력 필드 정보를 추가 하세요.");
        return;
    }
    addWidget();
    var id , name;
    if (str == null || str == undefined || str=="undefined"){
        str = "Widget";
    }
    id ="l" + str;
    name = "w" + str;
    var win = document.getElementsByName(name)[0];

    objCal = objName;

    with(document.getElementById(id)) {
        removeActiveClass(objName);
        if( $(objName).hasClass(activeClass) ) {
            return;
        } else {
            var left = getAbsLeft(objName);
            var top = getAbsTop(objName) + 30;
            win.width = "244";
            win.height = "320";
            win.style.width= "244px";
            win.style.height= "320px";
            $(document).ready(function() {
                if ( 460 > document.body.clientWidth) {
                    var term = (document.body.clientWidth - win.width )/2;
                    left =  term;
                }
            });
            style.left = left + "px";
            style.top = top + "px";

            if (syear == null || syear == undefined || syear == "undefined"){
                syear = "";
            }
            if (smonth == null || smonth == undefined || smonth == "undefined"){
                smonth = "";
            }
            self.eval(name).location.replace("/common/calendar.html?syear=" + syear + "&smonth=" + smonth);
        }
        $(objName).addClass(activeClass);
    }
}


/**
 *  브라우저 버전 체크 및 ie8 class 추가
 *
function GetIEVersion() {
    var sAgent = window.navigator.userAgent;
    var Idx = sAgent.indexOf("MSIE");
    if (Idx > 0)
        return parseInt(sAgent.substring(Idx+ 5, sAgent.indexOf(".", Idx)));

    else if (!!navigator.userAgent.match(/Trident\/7\./))
        return 11;
    else
        return 99; //It is not IE
}
if (GetIEVersion() === 9) {
    $("body").addClass("ie9");
}
if (GetIEVersion() <= 8) {
    $("body").addClass("ie8");
    var lowIE = true;
}
 */


//className .svg 추가시  svg inline 화
$(function(){
    var replaceSvg = function(img, svg){
        var $img = img;
        var options = $img.data();
        var $svg = svg;

        var imgID = $img.attr('id');
        var imgClass = $img.attr('class');
        var imgAlt = $img.attr('alt');

        if(typeof imgID !== 'undefined') {
            $svg = $svg.attr('id', imgID);
        }

        if(typeof imgClass !== 'undefined') {
            $svg = $svg.attr('class', imgClass+' replaced-svg');
        }

        $svg = $svg.removeAttr('xmlns:a');

        $svg.attr("focusable", "false");

        if(!$svg.attr('viewBox') && $svg.attr('height') && $svg.attr('width')) {
            $svg.attr('viewBox', '0 0 ' + $svg.attr('height') + ' ' + $svg.attr('width'))
        }

        if($img.attr('height') || $img.attr('width')){
            if($img.attr('width')){
                $svg.attr('width', $img.attr('width'));
            } else{
                $svg.removeAttr('width');
            }
            //height
            if($img.attr('height')){
                $svg.attr('height', $img.attr('height'));
            } else{
                $svg.removeAttr('height');
            }
        }
        if(imgAlt){
            $svg.prepend('<title>' + imgAlt + '</title>');
        }

        if(options.svgColor){
            $svg.find('path').attr('fill', options.svgColor);
        }
        return $svg;

    };

    jQuery('img.svg').each(function(){
        var $img = jQuery(this);
        var imgURL = $img.attr('src');

        jQuery.get(imgURL, function(data) {
            var $svg = jQuery(data).find('svg');
            if(!$svg) return;

            resultSvg = replaceSvg($img, $svg);
            $img.replaceWith(resultSvg);
        }, 'xml');

    });

    jQuery('img.svgview').each(function(){
        var $img = jQuery(this);
        var imgURL = $img.attr('src');
        var svgImsi = imgURL.split("#");
        var svgId = "#" + svgImsi[1];

        jQuery.get(imgURL, function(data) {
            var $svg = jQuery(data).find('svg');
            var $view = jQuery(data).find('view'+ svgId);
            if(!$view) return;

            var $svgTarget = jQuery(data).find('view'+ svgId).next("svg");
            resultSvg = replaceSvg($img, $svgTarget);
            $img.replaceWith(resultSvg);
        }, 'xml');

    });

});

$(function(){
    var showToggle = function(element, options) {
        $element            = $(element);
        this.element        = element;
        this.options        = options;
        $element.on('click mouseenter',  $.proxy(this.show, this));
        $element.on('click.close mouseleave',  $.proxy(this.hide, this));
    };
    showToggle.prototype.show = function(){
        $target = $(this.options.target);
        $target.show();
    };
    showToggle.prototype.hide = function(){
        $target = $(this.options.target);
        $target.hide();
    };
    function showTogglePlugin(option){
        var $this = $(this);
        var data  = $this.data('button');
        var options = typeof option === 'object' && option;
        $this.data('map', (data = new showToggle(this, options)));
        if (typeof option === 'string') data[option]()
    }
    $.fn.showToggle             =  showTogglePlugin;

    $(window).on("load",function(){
        $("[data-button=\"showToggle\"]").each(function () {
            var $this = $(this);
            var option = $this.data();
            showTogglePlugin.call($this, option);
        });
    });
});

/**
 * jquery.mask.js
 * @version: v1.14.15
*/

(function (factory, jQuery, Zepto) {
    if (typeof define === 'function' && define.amd) {
        define(['jquery'], factory);
    } else if (typeof exports === 'object') {
        module.exports = factory(require('jquery'));
    } else {
        factory(jQuery || Zepto);
    }

}(function ($) {
    'use strict';
    var Mask = function (el, mask, options) {
        var p = {
            invalid: [],
            getCaret: function () {
                try {
                    var sel,
                        pos = 0,
                        ctrl = el.get(0),
                        dSel = document.selection,
                        cSelStart = ctrl.selectionStart;

                    if (dSel && navigator.appVersion.indexOf('MSIE 10') === -1) {
                        sel = dSel.createRange();
                        sel.moveStart('character', -p.val().length);
                        pos = sel.text.length;
                    }
                    else if (cSelStart || cSelStart === '0') {
                        pos = cSelStart;
                    }

                    return pos;
                } catch (e) {}
            },
            setCaret: function(pos) {
                try {
                    if (el.is(':focus')) {
                        var range, ctrl = el.get(0);

                        if (ctrl.setSelectionRange) {
                            ctrl.setSelectionRange(pos, pos);
                        } else { // IE
                            range = ctrl.createTextRange();
                            range.collapse(true);
                            range.moveEnd('character', pos);
                            range.moveStart('character', pos);
                            range.select();
                        }
                    }
                } catch (e) {}
            },
            events: function() {
                el
                .on('keydown.mask', function(e) {
                    el.data('mask-keycode', e.keyCode || e.which);
                    el.data('mask-previus-value', el.val());
                    el.data('mask-previus-caret-pos', p.getCaret());
                    p.maskDigitPosMapOld = p.maskDigitPosMap;
                })
                .on($.jMaskGlobals.useInput ? 'input.mask' : 'keyup.mask', p.behaviour)
                .on('paste.mask drop.mask', function() {
                    setTimeout(function() {
                        el.keydown().keyup();
                    }, 100);
                })
                .on('change.mask', function(){
                    el.data('changed', true);
                })
                .on('blur.mask', function(){
                    if (oldValue !== p.val() && !el.data('changed')) {
                        el.trigger('change');
                    }
                    el.data('changed', false);
                })
                .on('blur.mask', function() {
                    oldValue = p.val();
                })
                .on('focus.mask', function (e) {
                    if (options.selectOnFocus === true) {
                        $(e.target).select();
                    }
                })
                .on('focusout.mask', function() {
                    if (options.clearIfNotMatch && !regexMask.test(p.val())) {
                       p.val('');
                   }
                });
            },
            getRegexMask: function() {
                var maskChunks = [], translation, pattern, optional, recursive, oRecursive, r;
                for (var i = 0; i < mask.length; i++) {
                    translation = jMask.translation[mask.charAt(i)];
                    if (translation) {
                        pattern = translation.pattern.toString().replace(/.{1}$|^.{1}/g, '');
                        optional = translation.optional;
                        recursive = translation.recursive;

                        if (recursive) {
                            maskChunks.push(mask.charAt(i));
                            oRecursive = {digit: mask.charAt(i), pattern: pattern};
                        } else {
                            maskChunks.push(!optional && !recursive ? pattern : (pattern + '?'));
                        }
                    } else {
                        maskChunks.push(mask.charAt(i).replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&'));
                    }
                }
                r = maskChunks.join('');
                if (oRecursive) {
                    r = r.replace(new RegExp('(' + oRecursive.digit + '(.*' + oRecursive.digit + ')?)'), '($1)?')
                         .replace(new RegExp(oRecursive.digit, 'g'), oRecursive.pattern);
                }
                return new RegExp(r);
            },
            destroyEvents: function() {
                el.off(['input', 'keydown', 'keyup', 'paste', 'drop', 'blur', 'focusout', ''].join('.mask '));
            },
            val: function(v) {
                var isInput = el.is('input'),
                    method = isInput ? 'val' : 'text',
                    r;
                if (arguments.length > 0) {
                    if (el[method]() !== v) {
                        el[method](v);
                    }
                    r = el;
                } else {
                    r = el[method]();
                }

                return r;
            },
            calculateCaretPosition: function() {
                var oldVal = el.data('mask-previus-value') || '',
                    newVal = p.getMasked(),
                    caretPosNew = p.getCaret();
                if (oldVal !== newVal) {
                    var caretPosOld = el.data('mask-previus-caret-pos') || 0,
                        newValL = newVal.length,
                        oldValL = oldVal.length,
                        maskDigitsBeforeCaret = 0,
                        maskDigitsAfterCaret = 0,
                        maskDigitsBeforeCaretAll = 0,
                        maskDigitsBeforeCaretAllOld = 0,
                        i = 0;

                    for (i = caretPosNew; i < newValL; i++) {
                        if (!p.maskDigitPosMap[i]) {
                            break;
                        }
                        maskDigitsAfterCaret++;
                    }

                    for (i = caretPosNew - 1; i >= 0; i--) {
                        if (!p.maskDigitPosMap[i]) {
                            break;
                        }
                        maskDigitsBeforeCaret++;
                    }

                    for (i = caretPosNew - 1; i >= 0; i--) {
                        if (p.maskDigitPosMap[i]) {
                            maskDigitsBeforeCaretAll++;
                        }
                    }

                    for (i = caretPosOld - 1; i >= 0; i--) {
                        if (p.maskDigitPosMapOld[i]) {
                            maskDigitsBeforeCaretAllOld++;
                        }
                    }

                    if (caretPosNew > oldValL) {
                      caretPosNew = newValL * 10;
                    } else if (caretPosOld >= caretPosNew && caretPosOld !== oldValL) {
                        if (!p.maskDigitPosMapOld[caretPosNew])  {
                          var caretPos = caretPosNew;
                          caretPosNew -= maskDigitsBeforeCaretAllOld - maskDigitsBeforeCaretAll;
                          caretPosNew -= maskDigitsBeforeCaret;
                          if (p.maskDigitPosMap[caretPosNew])  {
                            caretPosNew = caretPos;
                          }
                        }
                    }
                    else if (caretPosNew > caretPosOld) {
                        caretPosNew += maskDigitsBeforeCaretAll - maskDigitsBeforeCaretAllOld;
                        caretPosNew += maskDigitsAfterCaret;
                    }
                }
                return caretPosNew;
            },
            behaviour: function(e) {
                e = e || window.event;
                p.invalid = [];
                var keyCode = el.data('mask-keycode');
                if ($.inArray(keyCode, jMask.byPassKeys) === -1) {
                    var newVal = p.getMasked(),
                        caretPos = p.getCaret();


                    setTimeout(function() {
                      p.setCaret(p.calculateCaretPosition());
                    }, $.jMaskGlobals.keyStrokeCompensation);

                    p.val(newVal);
                    p.setCaret(caretPos);
                    return p.callbacks(e);
                }
            },
            getMasked: function(skipMaskChars, val) {
                var buf = [],
                    value = val === undefined ? p.val() : val + '',
                    m = 0, maskLen = mask.length,
                    v = 0, valLen = value.length,
                    offset = 1, addMethod = 'push',
                    resetPos = -1,
                    maskDigitCount = 0,
                    maskDigitPosArr = [],
                    lastMaskChar,
                    check;

                if (options.reverse) {
                    addMethod = 'unshift';
                    offset = -1;
                    lastMaskChar = 0;
                    m = maskLen - 1;
                    v = valLen - 1;
                    check = function () {
                        return m > -1 && v > -1;
                    };
                } else {
                    lastMaskChar = maskLen - 1;
                    check = function () {
                        return m < maskLen && v < valLen;
                    };
                }

                var lastUntranslatedMaskChar;
                while (check()) {
                    var maskDigit = mask.charAt(m),
                        valDigit = value.charAt(v),
                        translation = jMask.translation[maskDigit];
                    if (translation) {
                        if (valDigit.match(translation.pattern)) {
                            buf[addMethod](valDigit);
                             if (translation.recursive) {
                                if (resetPos === -1) {
                                    resetPos = m;
                                } else if (m === lastMaskChar && m !== resetPos) {
                                    m = resetPos - offset;
                                }

                                if (lastMaskChar === resetPos) {
                                    m -= offset;
                                }
                            }
                            m += offset;
                        } else if (valDigit === lastUntranslatedMaskChar) {

                            maskDigitCount--;
                            lastUntranslatedMaskChar = undefined;
                        } else if (translation.optional) {
                            m += offset;
                            v -= offset;
                        } else if (translation.fallback) {
                            buf[addMethod](translation.fallback);
                            m += offset;
                            v -= offset;
                        } else {
                          p.invalid.push({p: v, v: valDigit, e: translation.pattern});
                        }
                        v += offset;
                    } else {
                        if (!skipMaskChars) {
                            buf[addMethod](maskDigit);
                        }

                        if (valDigit === maskDigit) {
                            maskDigitPosArr.push(v);
                            v += offset;
                        } else {
                            lastUntranslatedMaskChar = maskDigit;
                            maskDigitPosArr.push(v + maskDigitCount);
                            maskDigitCount++;
                        }
                        m += offset;
                    }
                }

                var lastMaskCharDigit = mask.charAt(lastMaskChar);
                if (maskLen === valLen + 1 && !jMask.translation[lastMaskCharDigit]) {
                    buf.push(lastMaskCharDigit);
                }

                var newVal = buf.join('');
                p.mapMaskdigitPositions(newVal, maskDigitPosArr, valLen);
                return newVal;
            },
            mapMaskdigitPositions: function(newVal, maskDigitPosArr, valLen) {
              var maskDiff = options.reverse ? newVal.length - valLen : 0;
              p.maskDigitPosMap = {};
              for (var i = 0; i < maskDigitPosArr.length; i++) {
                p.maskDigitPosMap[maskDigitPosArr[i] + maskDiff] = 1;
              }
            },
            callbacks: function (e) {
                var val = p.val(),
                    changed = val !== oldValue,
                    defaultArgs = [val, e, el, options],
                    callback = function(name, criteria, args) {
                        if (typeof options[name] === 'function' && criteria) {
                            options[name].apply(this, args);
                        }
                    };

                callback('onChange', changed === true, defaultArgs);
                callback('onKeyPress', changed === true, defaultArgs);
                callback('onComplete', val.length === mask.length, defaultArgs);
                callback('onInvalid', p.invalid.length > 0, [val, e, el, p.invalid, options]);
            }
        };

        el = $(el);
        var jMask = this, oldValue = p.val(), regexMask;
        mask = typeof mask === 'function' ? mask(p.val(), undefined, el,  options) : mask;
        jMask.mask = mask;
        jMask.options = options;
        jMask.remove = function() {
            var caret = p.getCaret();
            if (jMask.options.placeholder) {
                el.removeAttr('placeholder');
            }
            if (el.data('mask-maxlength')) {
                el.removeAttr('maxlength');
            }
            p.destroyEvents();
            p.val(jMask.getCleanVal());
            p.setCaret(caret);
            return el;
        };

        jMask.getCleanVal = function() {
           return p.getMasked(true);
        };

        jMask.getMaskedVal = function(val) {
           return p.getMasked(false, val);
        };

       jMask.init = function(onlyMask) {
            onlyMask = onlyMask || false;
            options = options || {};
            jMask.clearIfNotMatch  = $.jMaskGlobals.clearIfNotMatch;
            jMask.byPassKeys       = $.jMaskGlobals.byPassKeys;
            jMask.translation      = $.extend({}, $.jMaskGlobals.translation, options.translation);
            jMask = $.extend(true, {}, jMask, options);
            regexMask = p.getRegexMask();

            if (onlyMask) {
                p.events();
                p.val(p.getMasked());
            } else {
                if (options.placeholder) {
                    el.attr('placeholder' , options.placeholder);
                }
                if (el.data('mask')) {
                  el.attr('autocomplete', 'off');
                }
                for (var i = 0, maxlength = true; i < mask.length; i++) {
                    var translation = jMask.translation[mask.charAt(i)];
                    if (translation && translation.recursive) {
                        maxlength = false;
                        break;
                    }
                }
                if (maxlength) {
                    el.attr('maxlength', mask.length).data('mask-maxlength', true);
                }
                p.destroyEvents();
                p.events();

                var caret = p.getCaret();
                p.val(p.getMasked());
                p.setCaret(caret);
            }
        };
        jMask.init(!el.is('input'));
    };

    $.maskWatchers = {};
    var HTMLAttributes = function () {
        var input = $(this),
            options = {},
            prefix = 'data-mask-',
            mask = input.attr('data-mask');
        if (input.attr(prefix + 'reverse')) {
            options.reverse = true;
        }

        if (input.attr(prefix + 'clearifnotmatch')) {
            options.clearIfNotMatch = true;
        }

        if (input.attr(prefix + 'selectonfocus') === 'true') {
           options.selectOnFocus = true;
        }

        if (notSameMaskObject(input, mask, options)) {
            return input.data('mask', new Mask(this, mask, options));
        }
    },
    notSameMaskObject = function(field, mask, options) {
        options = options || {};
        var maskObject = $(field).data('mask'),
            stringify = JSON.stringify,
            value = $(field).val() || $(field).text();
        try {
            if (typeof mask === 'function') {
                mask = mask(value);
            }
            return typeof maskObject !== 'object' || stringify(maskObject.options) !== stringify(options) || maskObject.mask !== mask;
        } catch (e) {}
    },
    eventSupported = function(eventName) {
        var el = document.createElement('div'), isSupported;

        eventName = 'on' + eventName;
        isSupported = (eventName in el);

        if ( !isSupported ) {
            el.setAttribute(eventName, 'return;');
            isSupported = typeof el[eventName] === 'function';
        }
        el = null;

        return isSupported;
    };

    $.fn.mask = function(mask, options) {
        options = options || {};
        var selector = this.selector,
            globals = $.jMaskGlobals,
            interval = globals.watchInterval,
            watchInputs = options.watchInputs || globals.watchInputs,
            maskFunction = function() {
                if (notSameMaskObject(this, mask, options)) {
                    return $(this).data('mask', new Mask(this, mask, options));
                }
            };

        $(this).each(maskFunction);

        if (selector && selector !== '' && watchInputs) {
            clearInterval($.maskWatchers[selector]);
            $.maskWatchers[selector] = setInterval(function(){
                $(document).find(selector).each(maskFunction);
            }, interval);
        }
        return this;
    };

    $.fn.masked = function(val) {
        return this.data('mask').getMaskedVal(val);
    };

    $.fn.unmask = function() {
        clearInterval($.maskWatchers[this.selector]);
        delete $.maskWatchers[this.selector];
        return this.each(function() {
            var dataMask = $(this).data('mask');
            if (dataMask) {
                dataMask.remove().removeData('mask');
            }
        });
    };

    $.fn.cleanVal = function() {
        return this.data('mask').getCleanVal();
    };

    $.applyDataMask = function(selector) {
        selector = selector || $.jMaskGlobals.maskElements;
        var $selector = (selector instanceof $) ? selector : $(selector);
        $selector.filter($.jMaskGlobals.dataMaskAttr).each(HTMLAttributes);
    };

    var globals = {
        maskElements: 'input,td,span,div,time,em',
        dataMaskAttr: '*[data-mask]',
        dataMask: true,
        watchInterval: 300,
        watchInputs: true,
        keyStrokeCompensation: 10,

        useInput: !/Chrome\/[2-4][0-9]|SamsungBrowser/.test(window.navigator.userAgent) && eventSupported('input'),
        watchDataMask: false,
        byPassKeys: [9, 16, 17, 18, 36, 37, 38, 39, 40, 91],
        translation: {
            '0': {pattern: /\d/},
            '9': {pattern: /\d/, optional: true},
            '#': {pattern: /\d/, recursive: true},
            'A': {pattern: /[a-zA-Z0-9]/},
            'S': {pattern: /[a-zA-Z]/}
        }
    };

    $.jMaskGlobals = $.jMaskGlobals || {};
    globals = $.jMaskGlobals = $.extend(true, {}, globals, $.jMaskGlobals);

    if (globals.dataMask) {
        $.applyDataMask();
    }

    setInterval(function() {
        if ($.jMaskGlobals.watchDataMask) {
            $.applyDataMask();
        }
    }, globals.watchInterval);
}, window.jQuery, window.Zepto));

/*! modernizr 3.6.0 (Custom Build) | MIT *!*/
!function(e,t,n){function o(e,t){return typeof e===t}function a(){var e,t,n,a,r,s,i;for(var l in C)if(C.hasOwnProperty(l)){if(e=[],t=C[l],t.name&&(e.push(t.name.toLowerCase()),t.options&&t.options.aliases&&t.options.aliases.length))for(n=0;n<t.options.aliases.length;n++)e.push(t.options.aliases[n].toLowerCase());for(a=o(t.fn,"function")?t.fn():t.fn,r=0;r<e.length;r++)s=e[r],i=s.split("."),1===i.length?Modernizr[i[0]]=a:(!Modernizr[i[0]]||Modernizr[i[0]]instanceof Boolean||(Modernizr[i[0]]=new Boolean(Modernizr[i[0]])),Modernizr[i[0]][i[1]]=a),w.push((a?"":"no-")+i.join("-"))}}function r(e){var t=b.className,n=Modernizr._config.classPrefix||"";if(x&&(t=t.baseVal),Modernizr._config.enableJSClass){var o=new RegExp("(^|\\s)"+n+"no-js(\\s|$)");t=t.replace(o,"$1"+n+"js$2")}Modernizr._config.enableClasses&&(t+=" "+n+e.join(" "+n),x?b.className.baseVal=t:b.className=t)}function s(){return"function"!=typeof t.createElement?t.createElement(arguments[0]):x?t.createElementNS.call(t,"http://www.w3.org/2000/svg",arguments[0]):t.createElement.apply(t,arguments)}function i(e,t){return!!~(""+e).indexOf(t)}function l(e){return e.replace(/([a-z])-([a-z])/g,function(e,t,n){return t+n.toUpperCase()}).replace(/^-/,"")}function c(e,t){return function(){return e.apply(t,arguments)}}function u(e,t,n){var a;for(var r in e)if(e[r]in t)return n===!1?e[r]:(a=t[e[r]],o(a,"function")?c(a,n||t):a);return!1}function d(e){return e.replace(/([A-Z])/g,function(e,t){return"-"+t.toLowerCase()}).replace(/^ms-/,"-ms-")}function p(t,n,o){var a;if("getComputedStyle"in e){a=getComputedStyle.call(e,t,n);var r=e.console;if(null!==a)o&&(a=a.getPropertyValue(o));else if(r){var s=r.error?"error":"log";r[s].call(r,"getComputedStyle returning null, its possible modernizr test results are inaccurate")}}else a=!n&&t.currentStyle&&t.currentStyle[o];return a}function f(){var e=t.body;return e||(e=s(x?"svg":"body"),e.fake=!0),e}function y(e,n,o,a){var r,i,l,c,u="modernizr",d=s("div"),p=f();if(parseInt(o,10))for(;o--;)l=s("div"),l.id=a?a[o]:u+(o+1),d.appendChild(l);return r=s("style"),r.type="text/css",r.id="s"+u,(p.fake?p:d).appendChild(r),p.appendChild(d),r.styleSheet?r.styleSheet.cssText=e:r.appendChild(t.createTextNode(e)),d.id=u,p.fake&&(p.style.background="",p.style.overflow="hidden",c=b.style.overflow,b.style.overflow="hidden",b.appendChild(p)),i=n(d,e),p.fake?(p.parentNode.removeChild(p),b.style.overflow=c,b.offsetHeight):d.parentNode.removeChild(d),!!i}function m(t,o){var a=t.length;if("CSS"in e&&"supports"in e.CSS){for(;a--;)if(e.CSS.supports(d(t[a]),o))return!0;return!1}if("CSSSupportsRule"in e){for(var r=[];a--;)r.push("("+d(t[a])+":"+o+")");return r=r.join(" or "),y("@supports ("+r+") { #modernizr { position: absolute; } }",function(e){return"absolute"==p(e,null,"position")})}return n}function v(e,t,a,r){function c(){d&&(delete z.style,delete z.modElem)}if(r=o(r,"undefined")?!1:r,!o(a,"undefined")){var u=m(e,a);if(!o(u,"undefined"))return u}for(var d,p,f,y,v,g=["modernizr","tspan","samp"];!z.style&&g.length;)d=!0,z.modElem=s(g.shift()),z.style=z.modElem.style;for(f=e.length,p=0;f>p;p++)if(y=e[p],v=z.style[y],i(y,"-")&&(y=l(y)),z.style[y]!==n){if(r||o(a,"undefined"))return c(),"pfx"==t?y:!0;try{z.style[y]=a}catch(h){}if(z.style[y]!=v)return c(),"pfx"==t?y:!0}return c(),!1}function g(e,t,n,a,r){var s=e.charAt(0).toUpperCase()+e.slice(1),i=(e+" "+$.join(s+" ")+s).split(" ");return o(t,"string")||o(t,"undefined")?v(i,t,a,r):(i=(e+" "+k.join(s+" ")+s).split(" "),u(i,t,n))}function h(e,t,o){return g(e,n,n,t,o)}var w=[],C=[],T={_version:"3.6.0",_config:{classPrefix:"",enableClasses:!0,enableJSClass:!0,usePrefixes:!0},_q:[],on:function(e,t){var n=this;setTimeout(function(){t(n[e])},0)},addTest:function(e,t,n){C.push({name:e,fn:t,options:n})},addAsyncTest:function(e){C.push({name:null,fn:e})}},Modernizr=function(){};Modernizr.prototype=T,Modernizr=new Modernizr,Modernizr.addTest("svg",!!t.createElementNS&&!!t.createElementNS("http://www.w3.org/2000/svg","svg").createSVGRect);var b=t.documentElement,x="svg"===b.nodeName.toLowerCase();Modernizr.addTest("audio",function(){var e=s("audio"),t=!1;try{t=!!e.canPlayType,t&&(t=new Boolean(t),t.ogg=e.canPlayType('audio/ogg; codecs="vorbis"').replace(/^no$/,""),t.mp3=e.canPlayType('audio/mpeg; codecs="mp3"').replace(/^no$/,""),t.opus=e.canPlayType('audio/ogg; codecs="opus"')||e.canPlayType('audio/webm; codecs="opus"').replace(/^no$/,""),t.wav=e.canPlayType('audio/wav; codecs="1"').replace(/^no$/,""),t.m4a=(e.canPlayType("audio/x-m4a;")||e.canPlayType("audio/aac;")).replace(/^no$/,""))}catch(n){}return t}),Modernizr.addTest("canvas",function(){var e=s("canvas");return!(!e.getContext||!e.getContext("2d"))}),Modernizr.addTest("video",function(){var e=s("video"),t=!1;try{t=!!e.canPlayType,t&&(t=new Boolean(t),t.ogg=e.canPlayType('video/ogg; codecs="theora"').replace(/^no$/,""),t.h264=e.canPlayType('video/mp4; codecs="avc1.42E01E"').replace(/^no$/,""),t.webm=e.canPlayType('video/webm; codecs="vp8, vorbis"').replace(/^no$/,""),t.vp9=e.canPlayType('video/webm; codecs="vp9"').replace(/^no$/,""),t.hls=e.canPlayType('application/x-mpegURL; codecs="avc1.42E01E"').replace(/^no$/,""))}catch(n){}return t});var P=s("input"),S="search tel url email datetime date month week time datetime-local number range color".split(" "),_={};Modernizr.inputtypes=function(e){for(var o,a,r,s=e.length,i="1)",l=0;s>l;l++)P.setAttribute("type",o=e[l]),r="text"!==P.type&&"style"in P,r&&(P.value=i,P.style.cssText="position:absolute;visibility:hidden;",/^range$/.test(o)&&P.style.WebkitAppearance!==n?(b.appendChild(P),a=t.defaultView,r=a.getComputedStyle&&"textfield"!==a.getComputedStyle(P,null).WebkitAppearance&&0!==P.offsetHeight,b.removeChild(P)):/^(search|tel)$/.test(o)||(r=/^(url|email)$/.test(o)?P.checkValidity&&P.checkValidity()===!1:P.value!=i)),_[e[l]]=!!r;return _}(S);var E="Moz O ms Webkit",$=T._config.usePrefixes?E.split(" "):[];T._cssomPrefixes=$;var k=T._config.usePrefixes?E.toLowerCase().split(" "):[];T._domPrefixes=k;var N={elem:s("modernizr")};Modernizr._q.push(function(){delete N.elem});var z={style:N.elem.style};Modernizr._q.unshift(function(){delete z.style}),T.testAllProps=g,T.testAllProps=h,Modernizr.addTest("cssgridlegacy",h("grid-columns","10px",!0)),Modernizr.addTest("cssgrid",h("grid-template-rows","none",!0)),Modernizr.addTest("flexbox",h("flexBasis","1px",!0)),a(),r(w),delete T.addTest,delete T.addAsyncTest;for(var A=0;A<Modernizr._q.length;A++)Modernizr._q[A]();e.Modernizr=Modernizr}(window,document);
/*!
 * Datepicker for Bootstrap v1.8.0 (https://github.com/uxsolutions/bootstrap-datepicker)
 */

(function(factory){
	if (typeof define === 'function' && define.amd) {
		define(['jquery'], factory);
	} else if (typeof exports === 'object') {
		factory(require('jquery'));
	} else {
		factory(jQuery);
	}
}(function($, undefined){
	function UTCDate(){
		return new Date(Date.UTC.apply(Date, arguments));
	}
	function UTCToday(){
		var today = new Date();
		return UTCDate(today.getFullYear(), today.getMonth(), today.getDate());
	}
	function isUTCEquals(date1, date2) {
		return (
			date1.getUTCFullYear() === date2.getUTCFullYear() &&
			date1.getUTCMonth() === date2.getUTCMonth() &&
			date1.getUTCDate() === date2.getUTCDate()
		);
	}
	function alias(method, deprecationMsg){
		return function(){
			if (deprecationMsg !== undefined) {
				$.fn.datepicker.deprecated(deprecationMsg);
			}

			return this[method].apply(this, arguments);
		};
	}
	function isValidDate(d) {
		return d && !isNaN(d.getTime());
	}

	var DateArray = (function(){
		var extras = {
			get: function(i){
				return this.slice(i)[0];
			},
			contains: function(d){
				var val = d && d.valueOf();
				for (var i=0, l=this.length; i < l; i++)
					if (0 <= this[i].valueOf() - val && this[i].valueOf() - val < 1000*60*60*24)
						return i;
				return -1;
			},
			remove: function(i){
				this.splice(i,1);
			},
			replace: function(new_array){
				if (!new_array)
					return;
				if (!$.isArray(new_array))
					new_array = [new_array];
				this.clear();
				this.push.apply(this, new_array);
			},
			clear: function(){
				this.length = 0;
			},
			copy: function(){
				var a = new DateArray();
				a.replace(this);
				return a;
			}
		};

		return function(){
			var a = [];
			a.push.apply(a, arguments);
			$.extend(a, extras);
			return a;
		};
	})();

	var Datepicker = function(element, options){
		$.data(element, 'datepicker', this);
		this._process_options(options);
		this.dates = new DateArray();
		this.viewDate = this.o.defaultViewDate;
		this.focusDate = null;
		this.element = $(element);
		this.button = $(element).find("button");
		this.isInput = this.element.is('input');
		this.inputField = this.isInput ? this.element : this.element.closest(".p-date").find('input');
		this.component = this.element.hasClass('p-date__icon') ? this.element : false;
		if(this.button.length){
			this.component = this.button.hasClass('p-date__icon') ? this.button : false;
		}
		if (this.component && this.component.length === 0)
			this.component = false;
		this.isInline = !this.component && this.element.is('div');

		this.picker = $(DPGlobal.template);

		if (this._check_template(this.o.templates.leftArrow)) {
			this.picker.find('.prev').html(this.o.templates.leftArrow);
		}

		if (this._check_template(this.o.templates.rightArrow)) {
			this.picker.find('.next').html(this.o.templates.rightArrow);
		}

		this._buildEvents();
		this._attachEvents();

		if (this.isInline){
			this.picker.addClass('p-datepicker-inline').appendTo(this.element);
		}
		else {
			this.picker.addClass('p-datepicker__dropdown dropdown-menu');
		}

		if (this.o.rtl){
			this.picker.addClass('p-datepicker-rtl');
		}

		this._process_options({
			startDate: this._o.startDate,
			endDate: this._o.endDate,
			daysOfWeekDisabled: this.o.daysOfWeekDisabled,
			daysOfWeekHighlighted: this.o.daysOfWeekHighlighted,
			datesDisabled: this.o.datesDisabled
		});

		this._allow_update = false;
		this.setViewMode(this.o.startView);
		this._allow_update = true;

		this.fillDow();
		this.fillMonths();

		this.update();

		if (this.isInline){
			this.show();
		}
	};

	Datepicker.prototype = {
		constructor: Datepicker,

		_resolveViewName: function(view){
			$.each(DPGlobal.viewModes, function(i, viewMode){
				if (view === i || $.inArray(view, viewMode.names) !== -1){
					view = i;
					return false;
				}
			});
			return view;
		},

		_resolveDaysOfWeek: function(daysOfWeek){
			if (!$.isArray(daysOfWeek))
				daysOfWeek = daysOfWeek.split(/[,\s]*/);
			return $.map(daysOfWeek, Number);
		},

		_check_template: function(tmp){
			try {
				if (tmp === undefined || tmp === "") {
					return false;
				}
				if ((tmp.match(/[<>]/g) || []).length <= 0) {
					return true;
				}
				var jDom = $(tmp);
				return jDom.length > 0;
			}
			catch (ex) {
				return false;
			}
		},

		_process_options: function(opts){
			this._o = $.extend({}, this._o, opts);
			var o = this.o = $.extend({}, this._o);
			var lang = o.language;
			if (!dates[lang]){
				lang = lang.split('-')[0];
				if (!dates[lang])
					lang = defaults.language;
			}
			o.language = lang;
			o.startView = this._resolveViewName(o.startView);
			o.minViewMode = this._resolveViewName(o.minViewMode);
			o.maxViewMode = this._resolveViewName(o.maxViewMode);
			o.startView = Math.max(this.o.minViewMode, Math.min(this.o.maxViewMode, o.startView));
			if (o.multidate !== true){
				o.multidate = Number(o.multidate) || false;
				if (o.multidate !== false)
					o.multidate = Math.max(0, o.multidate);
			}
			o.multidateSeparator = String(o.multidateSeparator);
			o.weekStart %= 7;
			o.weekEnd = (o.weekStart + 6) % 7;

			var format = DPGlobal.parseFormat(o.format);
			if (o.startDate !== -Infinity){
				if (!!o.startDate){
					if (o.startDate instanceof Date)
						o.startDate = this._local_to_utc(this._zero_time(o.startDate));
					else
						o.startDate = DPGlobal.parseDate(o.startDate, format, o.language, o.assumeNearbyYear);
				}
				else {
					o.startDate = -Infinity;
				}
			}
			if (o.endDate !== Infinity){
				if (!!o.endDate){
					if (o.endDate instanceof Date)
						o.endDate = this._local_to_utc(this._zero_time(o.endDate));
					else
						o.endDate = DPGlobal.parseDate(o.endDate, format, o.language, o.assumeNearbyYear);
				}
				else {
					o.endDate = Infinity;
				}
			}

			o.daysOfWeekDisabled = this._resolveDaysOfWeek(o.daysOfWeekDisabled||[]);
			o.daysOfWeekHighlighted = this._resolveDaysOfWeek(o.daysOfWeekHighlighted||[]);
			o.datesDisabled = o.datesDisabled||[];
			if (!$.isArray(o.datesDisabled)) {
				o.datesDisabled = o.datesDisabled.split(',');
			}
			o.datesDisabled = $.map(o.datesDisabled, function(d){
				return DPGlobal.parseDate(d, format, o.language, o.assumeNearbyYear);
			});

			var plc = String(o.orientation).toLowerCase().split(/\s+/g),
				_plc = o.orientation.toLowerCase();
			plc = $.grep(plc, function(word){
				return /^auto|left|right|top|bottom$/.test(word);
			});
			o.orientation = {x: 'auto', y: 'auto'};
			if (!_plc || _plc === 'auto')
				; // no action
			else if (plc.length === 1){
				switch (plc[0]){
					case 'top':
					case 'bottom':
						o.orientation.y = plc[0];
						break;
					case 'left':
					case 'right':
						o.orientation.x = plc[0];
						break;
				}
			}
			else {
				_plc = $.grep(plc, function(word){
					return /^left|right$/.test(word);
				});
				o.orientation.x = _plc[0] || 'auto';

				_plc = $.grep(plc, function(word){
					return /^top|bottom$/.test(word);
				});
				o.orientation.y = _plc[0] || 'auto';
			}
			if (o.defaultViewDate instanceof Date || typeof o.defaultViewDate === 'string') {
				o.defaultViewDate = DPGlobal.parseDate(o.defaultViewDate, format, o.language, o.assumeNearbyYear);
			} else if (o.defaultViewDate) {
				var year = o.defaultViewDate.year || new Date().getFullYear();
				var month = o.defaultViewDate.month || 0;
				var day = o.defaultViewDate.day || 1;
				o.defaultViewDate = UTCDate(year, month, day);
			} else {
				o.defaultViewDate = UTCToday();
			}
		},
		_events: [],
		_secondaryEvents: [],
		_applyEvents: function(evs){
			for (var i=0, el, ch, ev; i < evs.length; i++){
				el = evs[i][0];
				if (evs[i].length === 2){
					ch = undefined;
					ev = evs[i][1];
				} else if (evs[i].length === 3){
					ch = evs[i][1];
					ev = evs[i][2];
				}
				el.on(ev, ch);
			}
		},
		_unapplyEvents: function(evs){
			for (var i=0, el, ev, ch; i < evs.length; i++){
				el = evs[i][0];
				if (evs[i].length === 2){
					ch = undefined;
					ev = evs[i][1];
				} else if (evs[i].length === 3){
					ch = evs[i][1];
					ev = evs[i][2];
				}
				el.off(ev, ch);
			}
		},
		_buildEvents: function(){
			var events = {
				keyup: $.proxy(function(e){
					if ($.inArray(e.keyCode, [27, 37, 39, 38, 40, 32, 13, 9]) === -1)
						this.update();
				}, this),
				keydown: $.proxy(this.keydown, this),
				paste: $.proxy(this.paste, this)
			};

			if (this.o.showOnFocus === true) {
				events.focus = $.proxy(this.show, this);
			}

			if (this.isInput) { // single input
				this._events = [
					[this.element, events]
				];
			}

			else if (this.component && this.inputField.length) {
				this._events = [
					[this.inputField, events],
					[this.component, {
						click: $.proxy(this.show, this)
					}]
				];
			}
			else {
				this._events = [
					[this.element, {
						click: $.proxy(this.show, this),
						keydown: $.proxy(this.keydown, this)
					}]
				];
			}
			this._events.push(
				[this.element, '*', {
					blur: $.proxy(function(e){
						this._focused_from = e.target;
					}, this)
				}],
				[this.element, {
					blur: $.proxy(function(e){
						this._focused_from = e.target;
					}, this)
				}]
			);

			if (this.o.immediateUpdates) {
				this._events.push([this.element, {
					'changeYear changeMonth': $.proxy(function(e){
						this.update(e.date);
					}, this)
				}]);
			}

			this._secondaryEvents = [
				[this.picker, {
					click: $.proxy(this.click, this)
				}],
				[this.picker, '.prev, .next', {
					click: $.proxy(this.navArrowsClick, this)
				}],
				[this.picker, '.day:not(.disabled)', {
					click: $.proxy(this.dayCellClick, this)
				}],
				[$(window), {
					resize: $.proxy(this.place, this)
				}],
				[$(document), {
					'mousedown touchstart': $.proxy(function(e){
						// Clicked outside the datepicker, hide it
						if (!(
							this.element.is(e.target) ||
							this.element.find(e.target).length ||
							this.picker.is(e.target) ||
							this.picker.find(e.target).length ||
							this.isInline
						)){
							this.hide();
						}
					}, this)
				}]
			];
		},
		_attachEvents: function(){
			this._detachEvents();
			this._applyEvents(this._events);
		},
		_detachEvents: function(){
			this._unapplyEvents(this._events);
		},
		_attachSecondaryEvents: function(){
			this._detachSecondaryEvents();
			this._applyEvents(this._secondaryEvents);
		},
		_detachSecondaryEvents: function(){
			this._unapplyEvents(this._secondaryEvents);
		},
		_trigger: function(event, altdate){
			var date = altdate || this.dates.get(-1),
				local_date = this._utc_to_local(date);

			this.element.trigger({
				type: event,
				date: local_date,
				viewMode: this.viewMode,
				dates: $.map(this.dates, this._utc_to_local),
				format: $.proxy(function(ix, format){
					if (arguments.length === 0){
						ix = this.dates.length - 1;
						format = this.o.format;
					} else if (typeof ix === 'string'){
						format = ix;
						ix = this.dates.length - 1;
					}
					format = format || this.o.format;
					var date = this.dates.get(ix);
					return DPGlobal.formatDate(date, format, this.o.language);
				}, this)
			});
		},
		show: function(e){

			if (this.inputField.prop('disabled') || (this.inputField.prop('readonly') && this.o.enableOnReadonly === false))
				return;

			if (!this.isInline)
				this.picker.appendTo(this.o.container);
			this.place();
			this.picker.show();


			this._attachSecondaryEvents();
			this._trigger('show');
			if ((window.navigator.msMaxTouchPoints || 'ontouchstart' in document) && this.o.disableTouchKeyboard) {
				$(this.element).blur();
			}

			if (!this.isInline){
				this.picker.find(".p-datepicker-" + DPGlobal.viewModes[this.viewMode].clsName + " .p-datepicker-switch").focus();
			}
			return this;
		},
		hide: function(){
			if (this.isInline || !this.picker.is(':visible'))
				return this;
			this.focusDate = null;
			this.picker.hide().detach();
			this._detachSecondaryEvents();
			this.setViewMode(this.o.startView);
			if (this.o.forceParse && this.inputField.val())
				this.setValue();
			this._trigger('hide');
			this.picker.hide();
			return this;
		},

		destroy: function(){
			this.hide();
			this._detachEvents();
			this._detachSecondaryEvents();
			this.picker.remove();
			delete this.element.data().datepicker;
			if (!this.isInput){
				delete this.element.data().date;
			}
			return this;
		},

		paste: function(e){
			var dateString;
			if (e.originalEvent.clipboardData && e.originalEvent.clipboardData.types
				&& $.inArray('text/plain', e.originalEvent.clipboardData.types) !== -1) {
				dateString = e.originalEvent.clipboardData.getData('text/plain');
			} else if (window.clipboardData) {
				dateString = window.clipboardData.getData('Text');
			} else {
				return;
			}
			this.setDate(dateString);
			this.update();
			e.preventDefault();
		},

		_utc_to_local: function(utc){
			if (!utc) {
				return utc;
			}

			var local = new Date(utc.getTime() + (utc.getTimezoneOffset() * 60000));

			if (local.getTimezoneOffset() !== utc.getTimezoneOffset()) {
				local = new Date(utc.getTime() + (local.getTimezoneOffset() * 60000));
			}

			return local;
		},
		_local_to_utc: function(local){
			return local && new Date(local.getTime() - (local.getTimezoneOffset()*60000));
		},
		_zero_time: function(local){
			return local && new Date(local.getFullYear(), local.getMonth(), local.getDate());
		},
		_zero_utc_time: function(utc){
			return utc && UTCDate(utc.getUTCFullYear(), utc.getUTCMonth(), utc.getUTCDate());
		},

		getDates: function(){
			return $.map(this.dates, this._utc_to_local);
		},

		getUTCDates: function(){
			return $.map(this.dates, function(d){
				return new Date(d);
			});
		},

		getDate: function(){
			return this._utc_to_local(this.getUTCDate());
		},

		getUTCDate: function(){
			var selected_date = this.dates.get(-1);
			if (selected_date !== undefined) {
				return new Date(selected_date);
			} else {
				return null;
			}
		},

		clearDates: function(){
			this.inputField.val('');
			this.update();
			this._trigger('changeDate');

			if (this.o.autoclose) {
				this.hide();
			}
		},


		setDates: function(){
			var args = $.isArray(arguments[0]) ? arguments[0] : arguments;
			this.update.apply(this, args);
			this._trigger('changeDate');
			this.setValue();
			return this;
		},

		setUTCDates: function(){
			var args = $.isArray(arguments[0]) ? arguments[0] : arguments;
			this.setDates.apply(this, $.map(args, this._utc_to_local));
			return this;
		},

		setDate: alias('setDates'),
		setUTCDate: alias('setUTCDates'),
		remove: alias('destroy', 'Method `remove` 는 사용되지 않습니다. 대신 `destroy` 사용'),

		setValue: function(){
			var formatted = this.getFormattedDate();
			this.inputField.val(formatted);
			return this;
		},

		getFormattedDate: function(format){
			if (format === undefined)
				format = this.o.format;

			var lang = this.o.language;
			return $.map(this.dates, function(d){
				return DPGlobal.formatDate(d, format, lang);
			}).join(this.o.multidateSeparator);
		},

		getStartDate: function(){
			return this.o.startDate;
		},

		setStartDate: function(startDate){
			this._process_options({startDate: startDate});
			this.update();
			this.updateNavArrows();
			return this;
		},

		getEndDate: function(){
			return this.o.endDate;
		},

		setEndDate: function(endDate){
			this._process_options({endDate: endDate});
			this.update();
			this.updateNavArrows();
			return this;
		},

		setDaysOfWeekDisabled: function(daysOfWeekDisabled){
			this._process_options({daysOfWeekDisabled: daysOfWeekDisabled});
			this.update();
			return this;
		},

		setDaysOfWeekHighlighted: function(daysOfWeekHighlighted){
			this._process_options({daysOfWeekHighlighted: daysOfWeekHighlighted});
			this.update();
			return this;
		},

		setDatesDisabled: function(datesDisabled){
			this._process_options({datesDisabled: datesDisabled});
			this.update();
			return this;
		},

		place: function(){
			if (this.isInline)
				return this;
			var calendarWidth = this.picker.outerWidth(),
				calendarHeight = this.picker.outerHeight(),
				visualPadding = 10,
				container = $(this.o.container),
				windowWidth = container.width(),
				scrollTop = this.o.container === 'body' ? $(document).scrollTop() : container.scrollTop(),
				appendOffset = container.offset();

			var parentsZindex = [0];
			this.element.parents().each(function(){
				var itemZIndex = $(this).css('z-index');
				if (itemZIndex !== 'auto' && Number(itemZIndex) !== 0) parentsZindex.push(Number(itemZIndex));
			});
			var zIndex = Math.max.apply(Math, parentsZindex) + this.o.zIndexOffset;
			var offset = this.component ? this.component.parent().offset() : this.element.offset();
			var height = this.component ? this.component.outerHeight(true) : this.element.outerHeight(false);
			var width = this.component ? this.component.outerWidth(true) : this.element.outerWidth(false);
			var left = offset.left - appendOffset.left;
			var top = offset.top - appendOffset.top;

			if (this.o.container !== 'body') {
				top += scrollTop;
			}
			this.picker.removeClass(
				'p-datepicker-orient-top p-datepicker-orient-bottom '+
				'p-datepicker-orient-right p-datepicker-orient-left'
			);
			if (this.o.orientation.x !== 'auto'){
				this.picker.addClass('p-datepicker-orient-' + this.o.orientation.x);
				if (this.o.orientation.x === 'right')
					left -= calendarWidth - width;
			}
			else {
				if (offset.left < 0) {
					this.picker.addClass('p-datepicker-orient-left');
					left -= offset.left - visualPadding;
				} else if (left + calendarWidth > windowWidth) {
					this.picker.addClass('p-datepicker-orient-right');
					left += width - calendarWidth;
				} else {
					if (this.o.rtl) {
						// Default to right
						this.picker.addClass('p-datepicker-orient-right');
					} else {
						// Default to left
						this.picker.addClass('p-datepicker-orient-left');
					}
				}
			}
			var yorient = this.o.orientation.y,
				top_overflow;
			if (yorient === 'auto'){
				top_overflow = -scrollTop + top - calendarHeight;
				yorient = top_overflow < 0 ? 'bottom' : 'top';
			}
			this.picker.addClass('p-datepicker-orient-' + yorient);
			if (yorient === 'top')
				top -= calendarHeight + parseInt(this.picker.css('padding-top'));
			else
				top += height;

			if (this.o.rtl) {
				var right = windowWidth - (left + width);
				this.picker.css({
					top: top,
					right: right,
					zIndex: zIndex
				});
			} else {
				this.picker.css({
					top: top,
					left: left,
					zIndex: zIndex
				});
			}
			return this;
		},

		_allow_update: true,
		update: function(){
			if (!this._allow_update)
				return this;

			var oldDates = this.dates.copy(),
				dates = [],
				fromArgs = false;
			if (arguments.length){
				$.each(arguments, $.proxy(function(i, date){
					if (date instanceof Date)
						date = this._local_to_utc(date);
					dates.push(date);
				}, this));
				fromArgs = true;
			} else {
				dates = this.isInput
					? this.element.val()
					: this.inputField.val()  || this.element.data('date') ;
				if (dates && this.o.multidate)
					dates = dates.split(this.o.multidateSeparator);
				else
					dates = [dates];
				delete this.element.data().date;
			}

			dates = $.map(dates, $.proxy(function(date){
				return DPGlobal.parseDate(date, this.o.format, this.o.language, this.o.assumeNearbyYear);
			}, this));
			dates = $.grep(dates, $.proxy(function(date){
				return (
					!this.dateWithinRange(date) ||
					!date
				);
			}, this), true);
			this.dates.replace(dates);

			if (this.o.updateViewDate) {
				if (this.dates.length)
					this.viewDate = new Date(this.dates.get(-1));
				else if (this.viewDate < this.o.startDate)
					this.viewDate = new Date(this.o.startDate);
				else if (this.viewDate > this.o.endDate)
					this.viewDate = new Date(this.o.endDate);
				else
					this.viewDate = this.o.defaultViewDate;
			}

			if (fromArgs){
				this.setValue();
				this.element.change();
			}
			else if (this.dates.length){
				if (String(oldDates) !== String(this.dates) && fromArgs) {
					this._trigger('changeDate');
					this.element.change();
				}
			}
			if (!this.dates.length && oldDates.length) {
				this._trigger('clearDate');
				this.element.change();
			}

			this.fill();
			return this;
		},

		fillDow: function(){
			if (this.o.showWeekDays) {
				var dowCnt = this.o.weekStart,
					html = '<tr>';
				if (this.o.calendarWeeks){
					html += '<th class="cw">&#160;</th>';
				}
				while (dowCnt < this.o.weekStart + 7){
					html += '<th class="dow';
					if ($.inArray(dowCnt, this.o.daysOfWeekDisabled) !== -1)
						html += ' disabled';
					html += '">'+dates[this.o.language].daysMin[(dowCnt++)%7]+'</th>';
				}
				html += '</tr>';
				this.picker.find('.p-datepicker-days thead').append(html);
			}
		},

		fillMonths: function(){
			var localDate = this._utc_to_local(this.viewDate);
			var html = '';
			var focused;
			for (var i = 0; i < 12; i++){
				focused = localDate && localDate.getMonth() === i ? ' focused' : '';
				html += '<button  type="button" class="month' + focused + '">' + dates[this.o.language].monthsShort[i] + '</button>';
			}
			this.picker.find('.p-datepicker-months td').html(html);
		},

		setRange: function(range){
			if (!range || !range.length)
				delete this.range;
			else
				this.range = $.map(range, function(d){
					return d.valueOf();
				});
			this.fill();
		},

		getClassNames: function(date){
			var cls = [],
				year = this.viewDate.getUTCFullYear(),
				month = this.viewDate.getUTCMonth(),
				today = UTCToday();
			if (date.getUTCFullYear() < year || (date.getUTCFullYear() === year && date.getUTCMonth() < month)){
				cls.push('old');
			} else if (date.getUTCFullYear() > year || (date.getUTCFullYear() === year && date.getUTCMonth() > month)){
				cls.push('new');
			}
			if (this.focusDate && date.valueOf() === this.focusDate.valueOf())
				cls.push('focused');
			if (this.o.todayHighlight && isUTCEquals(date, today)) {
				cls.push('today');
			}
			if (this.dates.contains(date) !== -1)
				cls.push('active');
			if (!this.dateWithinRange(date)){
				cls.push('disabled');
			}
			if (this.dateIsDisabled(date)){
				cls.push('disabled', 'disabled-date');
			}
			if ($.inArray(date.getUTCDay(), this.o.daysOfWeekHighlighted) !== -1){
				cls.push('highlighted');
			}

			if (this.range){
				if (date > this.range[0] && date < this.range[this.range.length-1]){
					cls.push('range');
				}
				if ($.inArray(date.valueOf(), this.range) !== -1){
					cls.push('selected');
				}
				if (date.valueOf() === this.range[0]){
					cls.push('range-start');
				}
				if (date.valueOf() === this.range[this.range.length-1]){
					cls.push('range-end');
				}
			}
			return cls;
		},

		_fill_yearsView: function(selector, cssClass, factor, year, startYear, endYear, beforeFn){
			var html = '';
			var step = factor / 10;
			var view = this.picker.find(selector);
			var startVal = Math.floor(year / factor) * factor;
			var endVal = startVal + step * 9;
			var focusedVal = Math.floor(this.viewDate.getFullYear() / step) * step;
			var selected = $.map(this.dates, function(d){
				return Math.floor(d.getUTCFullYear() / step) * step;
			});

			var classes, tooltip, before;
			for (var currVal = startVal - step; currVal <= endVal + step; currVal += step) {
				classes = [cssClass];
				tooltip = null;

				if (currVal === startVal - step) {
					classes.push('old');
				} else if (currVal === endVal + step) {
					classes.push('new');
				}
				if ($.inArray(currVal, selected) !== -1) {
					classes.push('active');
				}
				if (currVal < startYear || currVal > endYear) {
					classes.push('disabled');
				}
				if (currVal === focusedVal) {
					classes.push('focused');
				}

				if (beforeFn !== $.noop) {
					before = beforeFn(new Date(currVal, 0, 1));
					if (before === undefined) {
						before = {};
					} else if (typeof before === 'boolean') {
						before = {enabled: before};
					} else if (typeof before === 'string') {
						before = {classes: before};
					}
					if (before.enabled === false) {
						classes.push('disabled');
					}
					if (before.classes) {
						classes = classes.concat(before.classes.split(/\s+/));
					}
					if (before.tooltip) {
						tooltip = before.tooltip;
					}
				}

				html += '<button type="button" class="' + classes.join(' ') + '"' + (tooltip ? ' title="' + tooltip + '"' : '') + '>' + currVal + '</button>';
			}

			var titleText = "이동 없음";
			if(step === 100){
				view.find('.p-datepicker-switch').text(startVal + dates[this.o.language].yearCentury + ' - ' + endVal + dates[this.o.language].yearCentury).attr("title", titleText);

			} else if(step === 10){
				if(this.o.maxViewMode > 3){
					titleText = "100년단위 연도 선택 이동";
				}
				view.find('.p-datepicker-switch').text(startVal + dates[this.o.language].yearCentury + ' - ' + endVal + dates[this.o.language].yearCentury).attr("title", titleText);
			}else{
				if(this.o.maxViewMode > 2){
					titleText = "10년단위 연도 선택 이동"
				}
				view.find('.p-datepicker-switch').text(startVal + dates[this.o.language].year + ' - ' + endVal + dates[this.o.language].year).attr("title", titleText) ;
			}
			view.find('td').html(html);

		},

		fill: function(){
			var d = new Date(this.viewDate),
				year = d.getUTCFullYear(),
				month = d.getUTCMonth(),
				startYear = this.o.startDate !== -Infinity ? this.o.startDate.getUTCFullYear() : -Infinity,
				startMonth = this.o.startDate !== -Infinity ? this.o.startDate.getUTCMonth() : -Infinity,
				endYear = this.o.endDate !== Infinity ? this.o.endDate.getUTCFullYear() : Infinity,
				endMonth = this.o.endDate !== Infinity ? this.o.endDate.getUTCMonth() : Infinity,
				todaytxt = dates[this.o.language].today || dates['en'].today || '',
				cleartxt = dates[this.o.language].clear || dates['en'].clear || '',
				closetxt = dates[this.o.language].close || dates['en'].close || '',
				titleFormat = dates[this.o.language].titleFormat || dates['en'].titleFormat,
				tooltip,
				before;
			if (isNaN(year) || isNaN(month))
				return;
			this.picker.find('.p-datepicker-days .p-datepicker-switch')
				.text(DPGlobal.formatDate(d, titleFormat, this.o.language))
				.attr("title","월 선택 이동");
			this.picker.find('.p-datepicker-footer  .today')
				.text(todaytxt)
				.css('display', this.o.todayBtn === true || this.o.todayBtn === 'linked' ? 'inline-block' : 'none');
			this.picker.find('.p-datepicker-footer .clear')
				.text(cleartxt)
				.css('display', this.o.clearBtn === true ? 'inline-block' : 'none');
			this.picker.find('.p-datepicker-footer .close')
				.text(closetxt)
				.css('display', this.o.closeBtn === true ? 'inline-block' : 'none');
			this.picker.find('.p-datepicker-title')
				.text(this.o.title)
				.css('display', typeof this.o.title === 'string' && this.o.title !== '' ? 'inline-block' : 'none');
			this.updateNavArrows();
			this.fillMonths();
			var prevMonth = UTCDate(year, month, 0),
				day = prevMonth.getUTCDate();
			prevMonth.setUTCDate(day - (prevMonth.getUTCDay() - this.o.weekStart + 7)%7);
			var nextMonth = new Date(prevMonth);
			if (prevMonth.getUTCFullYear() < 100){
				nextMonth.setUTCFullYear(prevMonth.getUTCFullYear());
			}
			nextMonth.setUTCDate(nextMonth.getUTCDate() + 42);
			nextMonth = nextMonth.valueOf();
			var html = [];
			var weekDay, clsName;
			while (prevMonth.valueOf() < nextMonth){
				weekDay = prevMonth.getUTCDay();
				if (weekDay === this.o.weekStart){
					html.push('<tr>');
					if (this.o.calendarWeeks){

						var
							ws = new Date(+prevMonth + (this.o.weekStart - weekDay - 7) % 7 * 864e5),
							th = new Date(Number(ws) + (7 + 4 - ws.getUTCDay()) % 7 * 864e5),
							yth = new Date(Number(yth = UTCDate(th.getUTCFullYear(), 0, 1)) + (7 + 4 - yth.getUTCDay()) % 7 * 864e5),
							calWeek = (th - yth) / 864e5 / 7 + 1;
						html.push('<td class="cw">'+ calWeek +'</td>');
					}
				}
				clsName = this.getClassNames(prevMonth);
				clsName.push('day');

				var content = prevMonth.getUTCDate();

				if (this.o.beforeShowDay !== $.noop){
					before = this.o.beforeShowDay(this._utc_to_local(prevMonth));
					if (before === undefined)
						before = {};
					else if (typeof before === 'boolean')
						before = {enabled: before};
					else if (typeof before === 'string')
						before = {classes: before};
					if (before.enabled === false)
						clsName.push('disabled');
					if (before.classes)
						clsName = clsName.concat(before.classes.split(/\s+/));
					if (before.tooltip)
						tooltip = before.tooltip;
					if (before.content)
						content = before.content;
				}


				if ($.isFunction($.uniqueSort)) {
					clsName = $.uniqueSort(clsName);
				} else {
					clsName = $.unique(clsName);
				}

				html.push('<td><button type="button" class="'+clsName.join(' ')+'"' + (tooltip ? ' title="'+tooltip+'"' : '') + ' data-date="' + prevMonth.getTime().toString() + '">' + content + '</button></td>');
				tooltip = null;
				if (weekDay === this.o.weekEnd){
					html.push('</tr>');
				}
				prevMonth.setUTCDate(prevMonth.getUTCDate() + 1);
			}
			this.picker.find('.p-datepicker-days tbody').html(html.join(''));


			var monthsTitle = dates[this.o.language].monthsTitle || dates['en'].monthsTitle || 'Months';

			var months = this.picker.find('.p-datepicker-months')
				.find('.p-datepicker-switch')
				.text(this.o.maxViewMode < 2 ? monthsTitle + dates[this.o.language].year : year + dates[this.o.language].year)
				.attr("title", "연도 선택 이동")
				.end()
				.find('tbody button').removeClass('active');

			$.each(this.dates, function(i, d){
				if (d.getUTCFullYear() === year)
					months.eq(d.getUTCMonth()).addClass('active');
			});

			if (year < startYear || year > endYear){
				months.addClass('disabled');
			}
			if (year === startYear){
				months.slice(0, startMonth).addClass('disabled');
			}
			if (year === endYear){
				months.slice(endMonth+1).addClass('disabled');
			}

			if (this.o.beforeShowMonth !== $.noop){
				var that = this;
				$.each(months, function(i, month){
					var moDate = new Date(year, i, 1);
					var before = that.o.beforeShowMonth(moDate);
					if (before === undefined)
						before = {};
					else if (typeof before === 'boolean')
						before = {enabled: before};
					else if (typeof before === 'string')
						before = {classes: before};
					if (before.enabled === false && !$(month).hasClass('disabled'))
						$(month).addClass('disabled');
					if (before.classes)
						$(month).addClass(before.classes);
					if (before.tooltip)
						$(month).prop('title', before.tooltip);
				});
			}

			this._fill_yearsView(
				'.p-datepicker-years',
				'year',
				10,
				year,
				startYear,
				endYear,
				this.o.beforeShowYear
			);

			this._fill_yearsView(
				'.p-datepicker-decades',
				'decade',
				100,
				year,
				startYear,
				endYear,
				this.o.beforeShowDecade
			);

			this._fill_yearsView(
				'.p-datepicker-centuries',
				'century',
				1000,
				year,
				startYear,
				endYear,
				this.o.beforeShowCentury
			);

			this.picker.find('button.disabled').attr("disabled", true);
		},

		updateNavArrows: function(){
			if (!this._allow_update)
				return;

			var d = new Date(this.viewDate),
				year = d.getUTCFullYear(),
				month = d.getUTCMonth(),
				startYear = this.o.startDate !== -Infinity ? this.o.startDate.getUTCFullYear() : -Infinity,
				startMonth = this.o.startDate !== -Infinity ? this.o.startDate.getUTCMonth() : -Infinity,
				endYear = this.o.endDate !== Infinity ? this.o.endDate.getUTCFullYear() : Infinity,
				endMonth = this.o.endDate !== Infinity ? this.o.endDate.getUTCMonth() : Infinity,
				prevIsDisabled,
				nextIsDisabled,
				factor = 1;
			switch (this.viewMode){
				case 4:
					factor *= 10;

				case 3:
					factor *= 10;
				case 2:
					factor *= 10;
				case 1:
					prevIsDisabled = Math.floor(year / factor) * factor <= startYear;
					nextIsDisabled = Math.floor(year / factor) * factor + factor > endYear;
					break;
				case 0:
					prevIsDisabled = year <= startYear && month <= startMonth;
					nextIsDisabled = year >= endYear && month >= endMonth;
					break;
			}

			this.picker.find('.prev').toggleClass('disabled', prevIsDisabled);
			this.picker.find('.next').toggleClass('disabled', nextIsDisabled);
		},

		click: function(e){
			e.preventDefault();
			e.stopPropagation();
			var target, dir, day, year, month;
			target = $(e.target);


			if (target.hasClass('p-datepicker-switch') && this.viewMode !== this.o.maxViewMode){
				this.setViewMode(this.viewMode + 1);
			}

			if (target.hasClass('today') && !target.hasClass('day')){
				this.setViewMode(0);
				this._setDate(UTCToday(), this.o.todayBtn === 'linked' ? null : 'view');
				var focusToday= this.picker.find('.table-condensed .today');
				focusToday.focus();
			}

			if (target.hasClass('clear')){
				this.clearDates();
			}
			if (target.hasClass('close')){
				this.hide();
				if(!this.isInput){
					this.component.focus();
				}
			}

			if (!target.hasClass('disabled')){
				if (target.hasClass('month')
					|| target.hasClass('year')
					|| target.hasClass('decade')
					|| target.hasClass('century')) {
					this.viewDate.setUTCDate(1);

					day = 1;
					if (this.viewMode === 1){
						month = target.parent().find('button').index(target);
						year = this.viewDate.getUTCFullYear();
						this.viewDate.setUTCMonth(month);
					} else {
						month = 0;
						year = Number(target.text());
						this.viewDate.setUTCFullYear(year);
					}

					this._trigger(DPGlobal.viewModes[this.viewMode - 1].e, this.viewDate);

					if (this.viewMode === this.o.minViewMode){
						this._setDate(UTCDate(year, month, day));
					} else {
						this.setViewMode(this.viewMode - 1);
						this.fill();
					}
				}
			}

			if (this.picker.is(':visible') && this._focused_from){
				//this._focused_from.focus();
			}
			delete this._focused_from;
		},

		dayCellClick: function(e){
			var $target = $(e.currentTarget);
			var timestamp = $target.data('date');
			var date = new Date(timestamp);

			if (this.o.updateViewDate) {
				if (date.getUTCFullYear() !== this.viewDate.getUTCFullYear()) {
					this._trigger('changeYear', this.viewDate);
				}

				if (date.getUTCMonth() !== this.viewDate.getUTCMonth()) {
					this._trigger('changeMonth', this.viewDate);
				}
			}
			this._setDate(date);
			this.inputField.focus();
		},

		navArrowsClick: function(e){
			var $target = $(e.currentTarget);
			var dir = $target.hasClass('prev') ? -1 : 1;
			if (this.viewMode !== 0){
				dir *= DPGlobal.viewModes[this.viewMode].navStep * 12;
			}
			this.viewDate = this.moveMonth(this.viewDate, dir);
			this._trigger(DPGlobal.viewModes[this.viewMode].e, this.viewDate);
			this.fill();

		},

		_toggle_multidate: function(date){
			var ix = this.dates.contains(date);
			if (!date){
				this.dates.clear();
			}

			if (ix !== -1){
				if (this.o.multidate === true || this.o.multidate > 1 || this.o.toggleActive){
					this.dates.remove(ix);
				}
			} else if (this.o.multidate === false) {
				this.dates.clear();
				this.dates.push(date);
			}
			else {
				this.dates.push(date);
			}

			if (typeof this.o.multidate === 'number')
				while (this.dates.length > this.o.multidate)
					this.dates.remove(0);
		},

		_setDate: function(date, which){
			if (!which || which === 'date')
				this._toggle_multidate(date && new Date(date));
			if ((!which && this.o.updateViewDate) || which === 'view')
				this.viewDate = date && new Date(date);

			this.fill();
			this.setValue();

			if (!which || which !== 'view') {
				this._trigger('changeDate');
			}
			this.inputField.trigger('change');

			if (this.o.autoclose && (!which || which === 'date')){
				this.hide();
			}
		},

		moveDay: function(date, dir){
			var newDate = new Date(date);
			newDate.setUTCDate(date.getUTCDate() + dir);

			return newDate;
		},

		moveWeek: function(date, dir){
			return this.moveDay(date, dir * 7);
		},

		moveMonth: function(date, dir){
			if (!isValidDate(date))
				return this.o.defaultViewDate;
			if (!dir)
				return date;
			var new_date = new Date(date.valueOf()),
				day = new_date.getUTCDate(),
				month = new_date.getUTCMonth(),
				mag = Math.abs(dir),
				new_month, test;
			dir = dir > 0 ? 1 : -1;
			if (mag === 1){
				test = dir === -1
					? function(){
						return new_date.getUTCMonth() === month;
					}

					: function(){
						return new_date.getUTCMonth() !== new_month;
					};
				new_month = month + dir;
				new_date.setUTCMonth(new_month);
				new_month = (new_month + 12) % 12;
			}
			else {
				for (var i=0; i < mag; i++)
					new_date = this.moveMonth(new_date, dir);
				new_month = new_date.getUTCMonth();
				new_date.setUTCDate(day);
				test = function(){
					return new_month !== new_date.getUTCMonth();
				};
			}

			while (test()){
				new_date.setUTCDate(--day);
				new_date.setUTCMonth(new_month);
			}
			return new_date;
		},

		moveYear: function(date, dir){
			return this.moveMonth(date, dir*12);
		},

		moveAvailableDate: function(date, dir, fn){
			do {
				date = this[fn](date, dir);

				if (!this.dateWithinRange(date))
					return false;

				fn = 'moveDay';
			}
			while (this.dateIsDisabled(date));

			return date;
		},

		weekOfDateIsDisabled: function(date){
			return $.inArray(date.getUTCDay(), this.o.daysOfWeekDisabled) !== -1;
		},

		dateIsDisabled: function(date){
			return (
				this.weekOfDateIsDisabled(date) ||
				$.grep(this.o.datesDisabled, function(d){
					return isUTCEquals(date, d);
				}).length > 0
			);
		},

		dateWithinRange: function(date){
			return date >= this.o.startDate && date <= this.o.endDate;
		},

		keydown: function(e){

		},

		setViewMode: function(viewMode){
			this.viewMode = viewMode;
			this.picker
				.children('div')
				.hide()
				.filter('.p-datepicker-' + DPGlobal.viewModes[this.viewMode].clsName)
				.show();
			this.updateNavArrows();
			this._trigger('changeViewMode', new Date(this.viewDate));
			var focusSwitch = this.picker.find('.p-datepicker-' + DPGlobal.viewModes[this.viewMode].clsName + ' .p-datepicker-switch');
			focusSwitch.focus();
		}
	};

	var DateRangePicker = function(element, options){
		$.data(element, 'p-datepicker', this);
		this.element = $(element);
		this.inputs = $.map(options.inputs, function(i){
			return i.jquery ? i[0] : i;
		});
		delete options.inputs;

		this.keepEmptyValues = options.keepEmptyValues;
		delete options.keepEmptyValues;

		datepickerPlugin.call($(this.inputs), options)
			.on('changeDate', $.proxy(this.dateUpdated, this));
		this.pickers = $.map(this.inputs, function(i){
			return $.data(i, 'datepicker');
		});
		this.updateDates();
	};

	DateRangePicker.prototype = {
		updateDates: function(){
			this.dates = $.map(this.pickers, function(i){
				return i.getUTCDate();
			});
			this.updateRanges();
		},
		updateRanges: function(){
			var range = $.map(this.dates, function(d){
				return d.valueOf();
			});
			$.each(this.pickers, function(i, p){
				p.setRange(range);
			});
		},
		clearDates: function(){
			$.each(this.pickers, function(i, p){
				p.clearDates();
			});

		},
		dateUpdated: function(e){
			if (this.updating)
				return;
			this.updating = true;

			var dp = $.data(e.target, 'datepicker');

			if (dp === undefined) {
				return;
			}

			var new_date = dp.getUTCDate(),
				keep_empty_values = this.keepEmptyValues,
				i = $.inArray(e.target, this.inputs),
				j = i - 1,
				k = i + 1,
				l = this.inputs.length;
			if (i === -1)
				return;

			$.each(this.pickers, function(i, p){
				if (!p.getUTCDate() && (p === dp || !keep_empty_values))
					p.setUTCDate(new_date);
			});

			if (new_date < this.dates[j]){
				while (j >= 0 && new_date < this.dates[j]){
					this.pickers[j--].setUTCDate(new_date);
				}
			} else if (new_date > this.dates[k]){
				while (k < l && new_date > this.dates[k]){
					this.pickers[k++].setUTCDate(new_date);
				}
			}
			this.updateDates();

			delete this.updating;
		},
		destroy: function(){
			$.map(this.pickers, function(p){ p.destroy(); });
			$(this.inputs).off('changeDate', this.dateUpdated);
			delete this.element.data().datepicker;
		},
		remove: alias('destroy', 'Method `remove` 는 사용되지 않습니다. 대신 `destroy` 사용')
	};

	function opts_from_el(el, prefix){
		// data-attrs
		var data = $(el).data(),
			out = {}, inkey,
			replace = new RegExp('^' + prefix.toLowerCase() + '([A-Z])');
		prefix = new RegExp('^' + prefix.toLowerCase());
		function re_lower(_,a){
			return a.toLowerCase();
		}
		for (var key in data)
			if (prefix.test(key)){
				inkey = key.replace(replace, re_lower);
				out[inkey] = data[key];
			}
		return out;
	}

	function opts_from_locale(lang){
		var out = {};
		if (!dates[lang]){
			lang = lang.split('-')[0];
			if (!dates[lang])
				return;
		}
		var d = dates[lang];
		$.each(locale_opts, function(i,k){
			if (k in d)
				out[k] = d[k];
		});
		return out;
	}

	var old = $.fn.datepicker;
	var datepickerPlugin = function(option){

		var args = Array.apply(null, arguments);
		args.shift();
		var internal_return;
		this.each(function(){
			var $this = $(this),
				data = $this.data('datepicker'),
				options = typeof option === 'object' && option;
				$that = $this.closest(".p-date");

			if(!$this.parent().hasClass("p-datepicker__wrap") && !$this.parents().hasClass("p-date__range")){
				$this.wrap( "<div class='p-datepicker__wrap'></div>" );
			}

			if (!data){
				this.btn = $this.hasClass('p-date__icon') ? $this.closest(".p-date")[0] : false;

				if(this.btn){
					this.group = this.btn;
				} else{
					this.group = this;
				}

				var elopts = opts_from_el(this.group, 'date'),
					// Preliminary otions
					xopts = $.extend({}, defaults, elopts, options),
					locopts = opts_from_locale(xopts.language),
					// Options priority: js args, data-attrs, locales, defaults
					opts = $.extend({}, defaults, locopts, elopts, options);

				if(opts.container === "body"){
					opts.container = $this.closest(opts.containerDefaultWrap);
				}

				if ($(this.group).hasClass('p-date__range') || opts.inputs){
					$.extend(opts, {
						inputs: opts.inputs || $(this.group).find('input').toArray()
					});
					data = new DateRangePicker(this, opts);
				}
				else {
					data = new Datepicker(this, opts);
				}
				$this.data('datepicker', data);
			}
			if (typeof option === 'string' && typeof data[option] === 'function'){
				internal_return = data[option].apply(data, args);
			}
		});

		if (
			internal_return === undefined ||
			internal_return instanceof Datepicker ||
			internal_return instanceof DateRangePicker
		)
			return this;

		if (this.length > 1)
			throw new Error('단일 요소 수집에만 허용 (' + option + ')');
		else
			return internal_return;
	};
	$.fn.datepicker = datepickerPlugin;

	var defaults = $.fn.datepicker.defaults = {
		assumeNearbyYear: false,
		autoclose: true,
		beforeShowDay: $.noop,
		beforeShowMonth: $.noop,
		beforeShowYear: $.noop,
		beforeShowDecade: $.noop,
		beforeShowCentury: $.noop,
		calendarWeeks: false,
		clearBtn: false,
		closeBtn: true,
		toggleActive: false,
		daysOfWeekDisabled: [],
		daysOfWeekHighlighted: [],
		datesDisabled: [],
		endDate: Infinity,
		forceParse: true,
		format: "yyyy-mm-dd",
		keepEmptyValues: false,
		keyboardNavigation: true,
		language: 'kr',
		minViewMode: 0,
		maxViewMode: 2,
		multidate: false,
		multidateSeparator: ',',
		orientation: "auto",
		rtl: false,
		startDate: -Infinity,
		startView: 0,
		todayBtn: true,
		todayHighlight: true,
		updateViewDate: true,
		weekStart: 0,
		disableTouchKeyboard: false,
		enableOnReadonly: true,
		showOnFocus: false,
		zIndexOffset: 100,
		container: 'body',
		containerDefaultWrap: '.p-datepicker__wrap',
		immediateUpdates: false,
		title: '',
		templates: {
			leftArrow: '이전 이동',
			rightArrow: '다음 이동'
		},
		showWeekDays: true
	};
	var locale_opts = $.fn.datepicker.locale_opts = [
		'format',
		'rtl',
		'weekStart'
	];
	$.fn.datepicker.Constructor = Datepicker;
	var dates = $.fn.datepicker.dates = {
		en: {
			days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
			daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
			daysMin: ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"],
			months: ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"],
			monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
			year: "",
			yearCentury: "",
			today: "Today",
			clear: "Clear",
			close: "Close",
			titleFormat: "MM yyyy"
		},
		kr: {
			days: ["일요일","월요일","화요일","수요일","목요일","금요일","토요일"],
			daysShort: ["일","월","화","수","목","금","토"],
			daysMin: ["일","월","화","수","목","금","토"],
			months: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
			monthsShort: ["1월","2월","3월","4월","5월","6월","7월","8월","9월","10월","11월","12월"],
			year: "년",
			yearCentury: "년대",
			today: "오늘",
			clear: "clear",
			close: "닫기",
			format:"yyyy-mm-dd",
			titleFormat:"yyyy년 mm월",
		}
	};

	var DPGlobal = {
		viewModes: [
			{
				names: ['days', 'month'],
				clsName: 'days',
				e: 'changeMonth'
			},
			{
				names: ['months', 'year'],
				clsName: 'months',
				e: 'changeYear',
				navStep: 1
			},
			{
				names: ['years', 'decade'],
				clsName: 'years',
				e: 'changeDecade',
				navStep: 10
			},
			{
				names: ['decades', 'century'],
				clsName: 'decades',
				e: 'changeCentury',
				navStep: 100
			},
			{
				names: ['centuries', 'millennium'],
				clsName: 'centuries',
				e: 'changeMillennium',
				navStep: 1000
			}
		],
		validParts: /dd?|DD?|mm?|MM?|yy(?:yy)?/g,
		nonpunctuation: /[^ -\/:-@\u5e74\u6708\u65e5\[-`{-~\t\n\r]+/g,
		parseFormat: function(format){
			if (typeof format.toValue === 'function' && typeof format.toDisplay === 'function')
				return format;

			var separators = format.replace(this.validParts, '\0').split('\0'),
				parts = format.match(this.validParts);
			if (!separators || !separators.length || !parts || parts.length === 0){
				throw new Error("Invalid date format.");
			}
			return {separators: separators, parts: parts};
		},
		parseDate: function(date, format, language, assumeNearby){
			if (!date)
				return undefined;
			if (date instanceof Date)
				return date;
			if (typeof format === 'string')
				format = DPGlobal.parseFormat(format);
			if (format.toValue)
				return format.toValue(date, format, language);
			var fn_map = {
					d: 'moveDay',
					m: 'moveMonth',
					w: 'moveWeek',
					y: 'moveYear'
				},
				dateAliases = {
					yesterday: '-1d',
					today: '+0d',
					tomorrow: '+1d'
				},
				parts, part, dir, i, fn;
			if (date in dateAliases){
				date = dateAliases[date];
			}
			if (/^[\-+]\d+[dmwy]([\s,]+[\-+]\d+[dmwy])*$/i.test(date)){
				parts = date.match(/([\-+]\d+)([dmwy])/gi);
				date = new Date();
				for (i=0; i < parts.length; i++){
					part = parts[i].match(/([\-+]\d+)([dmwy])/i);
					dir = Number(part[1]);
					fn = fn_map[part[2].toLowerCase()];
					date = Datepicker.prototype[fn](date, dir);
				}
				return Datepicker.prototype._zero_utc_time(date);
			}

			parts = date && date.match(this.nonpunctuation) || [];

			function applyNearbyYear(year, threshold){
				if (threshold === true)
					threshold = 10;

				if (year < 100){
					year += 2000;
					if (year > ((new Date()).getFullYear()+threshold)){
						year -= 100;
					}
				}

				return year;
			}

			var parsed = {},
				setters_order = ['yyyy', 'yy', 'M', 'MM', 'm', 'mm', 'd', 'dd'],
				setters_map = {
					yyyy: function(d,v){
						return d.setUTCFullYear(assumeNearby ? applyNearbyYear(v, assumeNearby) : v);
					},
					m: function(d,v){
						if (isNaN(d))
							return d;
						v -= 1;
						while (v < 0) v += 12;
						v %= 12;
						d.setUTCMonth(v);
						while (d.getUTCMonth() !== v)
							d.setUTCDate(d.getUTCDate()-1);
						return d;
					},
					d: function(d,v){
						return d.setUTCDate(v);
					}
				},
				val, filtered;
			setters_map['yy'] = setters_map['yyyy'];
			setters_map['M'] = setters_map['MM'] = setters_map['mm'] = setters_map['m'];
			setters_map['dd'] = setters_map['d'];
			date = UTCToday();
			var fparts = format.parts.slice();
			if (parts.length !== fparts.length){
				fparts = $(fparts).filter(function(i,p){
					return $.inArray(p, setters_order) !== -1;
				}).toArray();
			}
			function match_part(){
				var m = this.slice(0, parts[i].length),
					p = parts[i].slice(0, m.length);
				return m.toLowerCase() === p.toLowerCase();
			}
			if (parts.length === fparts.length){
				var cnt;
				for (i=0, cnt = fparts.length; i < cnt; i++){
					val = parseInt(parts[i], 10);
					part = fparts[i];
					if (isNaN(val)){
						switch (part){
							case 'MM':
								filtered = $(dates[language].months).filter(match_part);
								val = $.inArray(filtered[0], dates[language].months) + 1;
								break;
							case 'M':
								filtered = $(dates[language].monthsShort).filter(match_part);
								val = $.inArray(filtered[0], dates[language].monthsShort) + 1;
								break;
						}
					}
					parsed[part] = val;
				}
				var _date, s;
				for (i=0; i < setters_order.length; i++){
					s = setters_order[i];
					if (s in parsed && !isNaN(parsed[s])){
						_date = new Date(date);
						setters_map[s](_date, parsed[s]);
						if (!isNaN(_date))
							date = _date;
					}
				}
			}
			return date;
		},
		formatDate: function(date, format, language){
			if (!date)
				return '';
			if (typeof format === 'string')
				format = DPGlobal.parseFormat(format);
			if (format.toDisplay)
				return format.toDisplay(date, format, language);
			var val = {
				d: date.getUTCDate(),
				D: dates[language].daysShort[date.getUTCDay()],
				DD: dates[language].days[date.getUTCDay()],
				m: date.getUTCMonth() + 1,
				M: dates[language].monthsShort[date.getUTCMonth()],
				MM: dates[language].months[date.getUTCMonth()],
				yy: date.getUTCFullYear().toString().substring(2),
				yyyy: date.getUTCFullYear()
			};
			val.dd = (val.d < 10 ? '0' : '') + val.d;
			val.mm = (val.m < 10 ? '0' : '') + val.m;
			date = [];
			var seps = $.extend([], format.separators);
			for (var i=0, cnt = format.parts.length; i <= cnt; i++){
				if (seps.length)
					date.push(seps.shift());
				date.push(val[format.parts[i]]);
			}
			return date.join('');
		},
		titleTemplate: '<div class="p-datepicker__head">'+
							'<button type="button" class="p-datepicker-switch"></button>'+
							'<button type="button" class="prev">&laquo;</button>'+
							'<button type="button" class="next">&raquo;</button>'+
						'</div>',
		headTemplate:   '<caption>일자 선택용 달력</caption>'+
						'<thead>'+
						'<tr>'+
							'<th colspan="7" class="p-datepicker-title"></th>'+
						'</tr>'+
						'</thead>',
		contTemplate: '<tbody><tr><td colspan="7"></td></tr></tbody>',
		footTemplate: '<div class="p-datepicker-footer">'+
							'<button type="button" class="today" title="오늘로 이동"></button>'+
							'<button type="button" class="clear" title="선택내용 지우기"></button>'+
							'<button type="button" class="close" ></button>'+
						'</div>'
	};
	DPGlobal.template = '<div class="p-datepicker">'+
							'<div class="p-datepicker-days">'+
								DPGlobal.titleTemplate+
							'<table class="table-condensed">'+
								DPGlobal.headTemplate+
								'<tbody></tbody>'+
							'</table>'+
								DPGlobal.footTemplate+
						'</div>'+
						'<div class="p-datepicker-months">'+
							DPGlobal.titleTemplate+
							'<table class="table-condensed">'+
								DPGlobal.headTemplate+
								DPGlobal.contTemplate+
							'</table>'+
							DPGlobal.footTemplate+
						'</div>'+
						'<div class="p-datepicker-years">'+
							DPGlobal.titleTemplate+
							'<table class="table-condensed">'+
								DPGlobal.headTemplate+
								DPGlobal.contTemplate+
							'</table>'+
							DPGlobal.footTemplate+
						'</div>'+
						'<div class="p-datepicker-decades">'+
							DPGlobal.titleTemplate+
							'<table class="table-condensed">'+
								DPGlobal.headTemplate+
								DPGlobal.contTemplate+
							'</table>'+
							DPGlobal.footTemplate+
						'</div>'+
						'<div class="p-datepicker-centuries">'+
							DPGlobal.titleTemplate+
							'<table class="table-condensed">'+
								DPGlobal.headTemplate+
								DPGlobal.contTemplate+
							'</table>'+
							DPGlobal.footTemplate+
						'</div>'+
					'</div>';

	$.fn.datepicker.DPGlobal = DPGlobal;

	$(document).on(
		'click.p-date__icon click.p-input.start click.p-input end',
		'[data-date="datepicker"] .p-date__icon',
		function(e){
			var $this = $(this);
			if ($this.data('datepicker'))
				return;
			e.preventDefault();
			datepickerPlugin.call($this, 'show');
		}
	);

	$(function(){
		datepickerPlugin.call($('[data-date="datepicker-inline"]'));
	});

}));



if (navigator.appVersion.indexOf("MSIE 8.") == -1) {
    $(function(){
        var fileupload = function(btn, options) {
            $element            = $(btn);
            this.element        = btn;
            this.options        = options;
            this.clearselector  = ".clear";
            $region             = $element.closest(this.options.parent);
            $originalinput      = $region.find(this.options.original);
            $clearbtn           = $region.find(this.clearselector);
            $clearbtn.on('click.cancle',  $.proxy(this.clear, this));
            $originalinput.on('change',  $.proxy(this.change, this));
        };

        fileupload.prototype.change = function(){
            var $element            = this.element,
                $region             = $element.closest(this.options.parent),
                $originalinput      = $region.find(this.options.original),
                $showinput          = $region.find(this.options.showfilename),
                $clearbtn           = $region.find(this.clearselector);

            if(window.FileReader){
                filename = this.filestrip($originalinput[0].files[0].name);
                if($originalinput[0].files.length > 1){
                    var filelength = $originalinput[0].files.length - 1;
                }
            } else {
                filename = $originalinput.val().split('/').pop().split('\\').pop(); // 파일명만 추출
            }
            if(filelength) {
                filename = filename + " 외 " + filelength
            }


            $clearbtn.addClass("active");
            $showinput.html(filename);
        };

        fileupload.prototype.filestrip = function(name){
            var stripNumber;
            if($(window).width() < 640 && $(window).width() >= 420){
                stripNumber = 45;
            }
            else if($(window).width() < 419 && $(window).width() >= 400){
                stripNumber = 30;
            }else if($(window).width() < 400){
                stripNumber = 21;
            }

            if (name.length > stripNumber) {
                return name.substr(0, stripNumber/3) + ' ... ' + name.substr(name.length-8, name.length);
            }
            return name;
        };

        fileupload.prototype.clear = function(){
            var $element            = this.element,
                $region             = $element.closest(this.options.parent),
                $originalinput      = $region.find(this.options.original),
                $showinput          = $region.find(this.options.showfilename),
                $clearbtn           = $region.find(this.clearselector);

            $originalinput.replaceWith( $originalinput.val('').clone( true ) );
            $showinput.empty();
            $clearbtn.removeClass("active");
        };
        function checkFileupload(option){
                var $this = $(this);
                var data  = $this.data("upload");
                var options = typeof option === 'object' && option;
                if (!data) $this.data('upload', (data = new fileupload(this, options)));
                if (typeof option === 'string') data[option]()

        }
        $(window).on("load",function(){
            $("[data-button=\"upload\"]").each(function () {
                var $this = $(this);
                var option = $this.data();
                checkFileupload.call($this, option);
            });
        });
        $(".p-upload__file--hidden").on("focus",function(){
            $(this).closest(".p-upload").addClass("focus");
        });
        $(".p-upload__file--hidden").on("blur",function(){
            $(this).closest(".p-upload").removeClass("focus");
        });


        //input 추가
        var addFileInput = function(btn, options) {
            $element            = $(btn);
            this.element        = btn;
            this.options        = options;
            $element.on('click',  $.proxy(this.add, this));
        };

        addFileInput.prototype.add = function(){
            var countNumber = $(this.options.box).find(".p-upload").length;
            if(countNumber < this.options.count){
                var random = Math.floor(Math.random() * 100) + 1,
                    fileOrg = "fileorg" + random ,
                    showFileName = "showFileName" + random ;

                var template  = "<div class='p-upload'>";
                template += "   <div class='p-form-group'>";
                template += "       <div class='p-form-group__upload'>";
                template += "           <input type='file' name='attachImages[]' accept='image/!*' id='" + fileOrg + "' class='p-upload__file--hidden'>";
                template += "           <span id='" + showFileName + "' class='p-input disabled'></span>";
                template += "           <button type='button' class='p-upload__clear clear'>선택한 첨부 제거</button>";
                template += "       </div>";
                template += "       <div class='p-input__addon'>";
                template += "           <label for='" + fileOrg +"' class='p-button p-button--small primary' data-button='upload' data-parent='.p-upload' data-original='#" + fileOrg + "' data-showfilename='#" + showFileName + "'>파일선택</label>";
                template += "           <button type='button' class='p-button gray'  onclick='removeInput(\"" + fileOrg + "\")'>제거</button>";
                template += "       </div>";
                template += "   </div>";
                template += "   <input type=\"text\" id=\"\" class=\"p-input\" title=\"1번 첨부 이미지 대체 텍스트 입력\" value=\"\" placeholder=\"첨부 이미지 대체 텍스트 입력\">";
                template += "</div>";
                $(this.options.box).append(template);
                $("[data-button=\"upload\"]").each(function () {
                    var $this = $(this);   //버튼
                    var option = $this.data();
                    checkFileupload.call($this, option);
                });
            } else{
                alert("최대 " + this.options.count + "개 까지만 등록 가능합니다.")
            }
        };

        function checkAddInput(option){
            var $this = $(this);
            var data  = $this.data("addinput");
            var options = typeof option === 'object' && option;
            if (!data) $this.data('addinput', (data = new addFileInput(this, options)));
            if (typeof option === 'string') data[option]()
        }

        $(window).on("load",function(){
            $("[data-button=\"addinput\"]").each(function () {
                var $this = $(this);   //버튼
                var option = $this.data();
                checkAddInput.call($this, option);
            });
        });

    });
    var removeInput = function(name){
        var name = "#" + name;
        var removeItem = $(name).closest(".p-upload");
        removeItem.remove();
    };
}


$(function(){
    var checkedall = function(el, options) {
        $element            = $(el);
        this.element        = el;
        this.options        = options;
        this.checkBtn       =  $element.find(this.options.checkallid);
        this.checkItemName  = 'input[name=\"' + this.options.checkname +'\"]';
        this.checkItem      = $element.find(this.checkItemName);
        this.checkItemNum   = this.checkItem.length;

        this.checkBtn.on('change',  $.proxy(this.changeall, this));
        this.checkItem.on('change',  $.proxy(this.changeitem, this));
    };

    checkedall.prototype.changeall = function(){
        this.checkItem .prop('checked', this.checkBtn.prop("checked"));
        var checkItemStatus = $(this.checkItem).is(":checked");
        if(this.options.visibletarget){
            this.displayTarget(checkItemStatus);
        }
    };

    checkedall.prototype.changeitem = function(){

        this.checkedItem = $(this.element).find(this.checkItemName + ":checked").length;
        //checkItem 체크, 해제 되면
        if(false === this.checkItem.prop("checked")){
            this.checkBtn.prop('checked', false);
        }

        if( this.checkedItem > 0 &&  this.checkedItem < this.checkItemNum){
            this.checkBtn.prop('checked', false);
            this.targetStatus = true;
        }
        else if (this.checkedItem === this.checkItemNum ){
            this.checkBtn.prop('checked', true);
            this.targetStatus = true;
        }
        else{
            this.checkBtn.prop('checked', false);
            this.targetStatus = false;
        }

        if(this.options.visibletarget){
            this.displayTarget(this.targetStatus);
        }
    };


    checkedall.prototype.displayTarget = function(visible){
        var visibleStatus = $(this.options.visibletarget).is(":visible");
        if(visible === true){
            if(!visibleStatus){
                $(this.options.visibletarget).show();
            }
        } else{
            if(visibleStatus) {
                $(this.options.visibletarget).hide();
            }
        }
    };

    function checkAll(option){
        var $this = $(this);
        var data  = $this.data("select");
        var options = typeof option === 'object' && option;

        if (data) $this.data('select', (data = new checkedall(this, options)));
        if (typeof option === 'string') data[option]()

    }
    $(window).on("load",function(){
        $("[data-select=\"checkall\"]").each(function () {
            var $this = $(this);   //버튼
            var option = $this.data();
            checkAll.call($this, option);
        });
    });


});






$(function(){
    var CreateMap = function(element, options) {
        this.init(element, options)
    };
    CreateMap.DEFAULTS = {
        level : 3,
        draggable : true,
        zoomable : true,
        typecontrol : false
    };
    CreateMap.prototype.init = function(element, options){
        this.element        = $(element);
        this.options        = options;
        this.addMarker();
    };
    CreateMap.prototype.addMarker = function(){
        var mapContainer = this.element[0],
            mapOption = {
                center: new daum.maps.LatLng(this.options.lat, this.options.lng),
                level: this.options.level
            };

        var map = new daum.maps.Map(mapContainer, mapOption);

        map.setDraggable(this.options.draggable);
        map.setZoomable(this.options.zoomable);

        if(this.options.typecontrol) {
            var mapTypeControl = new daum.maps.MapTypeControl();
            map.addControl(mapTypeControl, daum.maps.ControlPosition.TOPRIGHT);

            var zoomControl = new daum.maps.ZoomControl();
            map.addControl(zoomControl, daum.maps.ControlPosition.RIGHT);
        }

        var imageSrc = '/common/images/program/map_marker.png',
            imageSize = new daum.maps.Size(32, 42),
            imageOption = {offset: new daum.maps.Point(13, 42)};


        var markerImage = new daum.maps.MarkerImage(imageSrc, imageSize, imageOption),
            markerPosition = new daum.maps.LatLng(this.options.lat, this.options.lng);

        var marker = new daum.maps.Marker({
            position: markerPosition,
            image: markerImage
        });

        marker.setMap(map);

        if(this.options.title || this.options.info ){
            var customOverlay = new daum.maps.CustomOverlay({
                position: markerPosition
            });

            var content = document.createElement('div');
            content.className = "p-map-info";


            var title = document.createElement('div');
            title.className ="p-map-info__title";
            title.appendChild(document.createTextNode(this.options.title));
            content.appendChild(title);

            if(this.options.info){
                var info = document.createElement('div');
                info.className ="p-map-info__content";
                info.appendChild(document.createTextNode(this.options.info));
                content.appendChild(info);

                content.className = "p-map-info p-map-info--multi";
            }
            customOverlay.setContent(content);
            customOverlay.setMap(map);
        }
    };

    function checkMapPlugin(option){
        var $this = $(this);
        var data  = $this.data('map');
        var options = $.extend({}, CreateMap.DEFAULTS, $this.data(), typeof option === 'object' && option);
        $this.data('map', (data = new CreateMap(this, options)));
        if (typeof option === 'string') data[option]()
    }
    $.fn.checkMap             = checkMapPlugin;

    $(window).on("load",function(){
        $("[data-map=\"map\"]").each(function () {
            var $this = $(this);   //버튼
            var option = $this.data();
            checkMapPlugin.call($this, option);
        });
    });

});


$(function() {
    var Modal = function(btn, options) {
        this.options            = options;
        this.$body              = $(document.body);
        this.$button            = $(btn);
        this.href               = this.$button.attr("href");
        this.$element           = $(this.options.target || (this.href && this.href.replace(/.*(?=#[^\s]+$)/, "")));

        this.backdropselector   = "modal__backdrop";
        this.widthtselector    = "modal__body";
        this.heightselector    = "modal__content";
        this.isShown            = null;
    };

    Modal.DEFAULTS = {
        backdrop    : true,
        show        : true,
        keyboard    : true,
        width: 600
    };

    Modal.prototype.show = function () {
        var that = this;
        var element = that.$element;

        var e    = $.Event('show.modal');
        this.$button.trigger(e);

        if (this.isShown) return;
        this.isShown = true;

        this.$body.addClass("modal__open");
        $("html").addClass("modal__open");

        this.setSize();
        element.show();

        var transition = element.hasClass("fade");
        if (transition) {
            element[0].offsetWidth;
        }

        element.addClass("active");

        if(this.options.backdrop){
            this.backdrop();
        }

        element.on('click.close', '[data-close=\'modal\']', $.proxy(this.hide, this));

        $(document)
        .off("focusin.modal")
        .on("focusin.modal", function (e) {
            if (element[0] !== e.target && !element.has(e.target).length) {
                element.trigger("focus");
            }
        });

        this.escape();

        this.resize();

        this.$button.trigger('shown.modal');
    };

    Modal.prototype.hide = function(e){
        var that = this;
        var element = that.$element,
            backdrop = "." + that.backdropselector,
            modalbtn = that.$button ;

        e = $.Event('hide.modal');
        this.$button.trigger(e);

        if (!this.isShown) return;

        this.isShown = false;

        if (e) e.preventDefault();

        element.hide().removeClass("active");
        $(document.body).removeClass("modal__open");
        $("html").removeClass("modal__open");

        element.find(backdrop).remove();
        modalbtn.trigger("focus");
        this.escape();

        this.$button.trigger('hidden.modal');
        this.$button.removeData("modal");
    };

    Modal.prototype.backdrop = function(){
        var element = this.$element,
            backdrop = $("<div class='" + this.backdropselector + "'></div>")
                        .prependTo(element)
                        .css("height", 0)
                        .css("height", element[0].scrollHeight)
                        .on("click", $.proxy(this.hide, this));
    };

    Modal.prototype.adjustBackdrop = function () {
        this.$element.find("."+this.backdropselector)
        .css('height', 0)
        .css('height', this.$element[0].scrollHeight)
    };

    Modal.prototype.setSize = function (width, height) {
        var element = this.$element,
            modalWidth = this.options.width,
            modalHeight = this.options.height;

        if( modalWidth > $(window).width() ){
            modalWidth = $(window).width() - 50;
        }
        element.find("." + this.widthtselector).css({
            width : modalWidth
        });

        if(modalHeight){
            element.find("." + this.heightselector).css({
                height : modalHeight
            });
        }
    };

    Modal.prototype.resize = function(){
         if (this.isShown) {
            $(window).on('resize.modal', $.proxy(this.adjustBackdrop, this))
        } else {
            $(window).off('resize.modal')
        }
    };

    Modal.prototype.escape = function () {
        if (this.isShown && this.options.keyboard) {
            this.$element.on('keyup', $.proxy(function (e) {
                e.which == 27 && this.hide()
            }, this))
        } else if (!this.isShown) {
            this.$element.off('keydown')
        }
    };

    function modalPlugin(option){
        return this.each(function(){
            var $this = $(this);
            var data  = $this.data("modal");
            var href = $this.attr("href");
            var $target = $(option.target || (href && href.replace(/.*(?=#[^\s]+$)/, "")));
            var options = $.extend({}, Modal.DEFAULTS, $this.data(), $target.data(), typeof option === 'object' && option);
            var btn =  option.parentbtn || this;

            if (!data) {
               $this.data("modal", (data = new Modal(btn, options)));
            }
            if (typeof option === "string") {
                data[option]();
            }
            else if (options.show) {
                data.show();
            }
        });
    }

    function modalRemotePlugin(option){
        var $this = $(this);
        if(!option.container) {
            console.log("외부 파일을 넣을 컨텐이너가 없습니다.");
            return;
        }

        $.ajax({
            type : "GET",
            url : option.remote,
            dataType : "text",
            async: false,
            error : function(){
                alert("파일을 호출하지 못했습니다.");
            },
            success : function(data){
                console.log("a");
                checkData = data.split("\n");
                var contains = (checkData.indexOf("<body>") > -1);

                data =  /<body[\s\S]*?>([\s\S]*?)<\/body>/.exec(data)[1];

                var $target     =  $(option.target),
                    $container  = $(option.container);
                    $btn        = $(option.parentbtn);

                $container.html(data);
                $target.addClass("loaded");
                $btn.trigger('loaded.modal');

                modalPlugin.call($this, option);

            }
        });
    }

    $.fn.madalPop             = modalPlugin;
    $.fn.madalRemotePop             = modalRemotePlugin;

    $(document).on("click.modal", "[data-button='modal']",function(e){
        e.preventDefault();
        var $this = $(this);
        var option = $this.data();
        var href    = $this.attr('href');

        if ($this.is("button") || $this.is("a")) {
            e.preventDefault();
        }

        if(option.remote && !$(option.target).hasClass("loaded")){
            modalRemotePlugin.call($this, option);
        } else{
            modalPlugin.call($this, option, this);
        }
    });
});


//new windows open
$(function(){
    var OpenWindow = function(element, options) {
        this.init(element, options)
    };
    OpenWindow.DEFAULTS = {
        resizable: "no",
        scrollbars: "yes",
        status: "yes",
        width: 1000,
        height: 650
    };

    OpenWindow.prototype.init = function(element, options){
        this.element        = $(element);
        this.options        = options;
        if(this.options.url){
            this.href       = this.options.url;
        } else{
            this.href        = this.element.attr("href");
        }
        var setWindow, windowLeft, windowTop;

        if(this.options.left){
            windowLeft = this.options.left;
        } else{
            var popWidth  = this.options.width;
            var winWidth  = window.innerWidth || document.body.clientWidth;
            var winX      = window.screenX || window.screenLeft || 0;
            windowLeft = winX + (winWidth - popWidth) / 2;
        }

        if(this.options.top){
            windowTop= this.options.top
        } else{
            var popHeight = this.options.height;
            var winHeight = window.innerHeight || document.body.clientHeight ;
            var winY      = window.screenY || window.screenTop || 0;
            windowTop = winY + (winHeight - popHeight) / 2;
        }

        setWindow = "menubar=no, ";
        setWindow += "location=no, ";
        setWindow += "resizable=" + this.options.resizable + ", ";
        setWindow += "scrollbars=" + this.options.scrollbars + ", ";
        setWindow += "status=" + this.options.status + ", ";
        setWindow += "width=" + this.options.width + ", ";
        setWindow += "height=" + this.options.height + ", ";
        setWindow += "left=" + windowLeft + ", ";
        setWindow += "top=" + windowTop;

        windowObjectReference = window.open(this.href, "", setWindow);

    };

    function openwindowPlugin(option){
        var $this = $(this);
        var data  = $this.data('openwindow');
        //var options = typeof option === 'object' && option;
        var options = $.extend({}, OpenWindow.DEFAULTS, $this.data(), typeof option === 'object' && option);
        $this.data('openwindow', (data = new OpenWindow(this, options)));
        if (typeof option === 'string') data[option]()
    }
    $.fn.checkOpenWindow             = openwindowPlugin;


    $(document).on("click", "[data-button='openwindow']",function(e){
        e.preventDefault();
        var $this = $(this);
        var option = $this.data();
        if ($this.is("button") || $this.is("a")) {
            e.preventDefault();
        }
        openwindowPlugin.call($this, option);
    });
});

$(function() {
    var createProgress = function (el, options) {
        var setDefault = {
            percent               : "0",
            duration              : 1000,
            color                 : "#fff"
        };
        this.element = el;
        this.options = $.extend({},setDefault,options);
        this.animated(this.element);
    };
    createProgress.prototype.animated = function (el) {
        this.element = $(el);
        this.element.animate({
           width: this.options.percent + '%'
        }, this.options.duration, function() {
            /* complate */
        });
    };
    function progressPlugin(option){
        return this.each(function(){

            var $this = $(this);
            var data  = $this.data("progress");
            var options = typeof option === "object" && option;
            if (data) {
                $this.data("progress", (data = new createProgress(this, options)));
            }
        });
    }
    $.fn.barAnimated    = progressPlugin;

    $(window).on("load",function(e){
        $("[data-progress=\"animated\"]").each(function () {
            var allprogress = $(this);
            var data = allprogress.data();
            progressPlugin.call(allprogress,data);
        });
    });
});


$(function() {
    var createChartCircle = function (el, options) {
        var setDefault = {
            percent               : 0,
            size                : 100,
            svgclassname        : "chart-circle__item",
            emptyclassName      : "chart-circle__background",
            emptyfill           : "#e9e9e9",
            valueclassname      : "chart-circle__value",
            valuefill           : "#00acc1",
            viewbox             : "0 0 33.83098862 33.83098862",
            cx                  : "16.91549431",
            strokewidth         : 3,
            r                   : "15.91549431"
        };
        this.element = el;
        this.firstChild = el.firstChild;
        this.options = $.extend({},setDefault,options);
        this.createSvg();
        this.createCircle(this.options.emptyclassName, this.options.emptyfill);
        this.createCircle(this.options.valueclassname, this.options.valuefill, this.options.percent - this.options.strokewidth);
    };

    createChartCircle.prototype.createSvg = function() {
        this.svg = document.createElementNS("http://www.w3.org/2000/svg", "svg");
        setAttributes(this.svg, {
            "class" : this.options.svgclassname,
            "width" : "100%",
            "height" : "100%",
            "viewBox" : this.options.viewbox
        });
        this.element.insertBefore(this.svg, this.firstChild);
    };

    createChartCircle.prototype.createCircle = function(classname, color, percent) {
        this.circle = document.createElementNS("http://www.w3.org/2000/svg", "circle");
        setAttributes(this.circle, {
            "class" : classname,
            "stroke-width" : this.options.strokewidth,
            "stroke" : color,
            "cx" : this.options.cx,
            "cy" : this.options.cx,
            "r" : this.options.cx - (this.options.strokewidth / 2)
        });

        if(percent)  setAttributes(this.circle, {"stroke-dasharray" : percent + ", 100"});

        this.svg.appendChild(this.circle);
    };

    function setAttributes(el, attrs) {
        for(var key in attrs) {
            el.setAttribute(key, attrs[key]);
        }
    }

    function ChartCirclePlugin(option){
        return this.each(function(){
            var $this = $(this);
            var data  = $this.data("chart-circle");
            var options = typeof option === "object" && option;

            if (!data) {
                $this.data("chart-circle", (data = new createChartCircle(this, options)));
            }
        });
    }

    $.fn.ChartCircle             = ChartCirclePlugin;

    if ($('.chart-circle').length) {
        $("[data-progress=\"circle\"]").each(function () {
            var allChartCircle = $(this);
            var data = allChartCircle.data();
            ChartCirclePlugin.call(allChartCircle,data);

        });
    }
});






/**
 * 출처 : svg4everybody
 * */
!function(root, factory) {
    "function" == typeof define && define.amd ?
    define([], function() {
        return root.svg4everybody = factory();
    }) : "object" == typeof module && module.exports ?

    module.exports = factory() : root.svg4everybody = factory();
}(this, function() {

    function embed(parent, svg, target) {
        if (target) {
            var fragment = document.createDocumentFragment(), viewBox = !svg.hasAttribute("viewBox") && target.getAttribute("viewBox");
            viewBox && svg.setAttribute("viewBox", viewBox);
            for (
            var clone = target.cloneNode(!0); clone.childNodes.length; ) {
                fragment.appendChild(clone.firstChild);
            }

            parent.appendChild(fragment);
        }
    }
    function loadreadystatechange(xhr) {
        xhr.onreadystatechange = function() {

            if (4 === xhr.readyState) {

                var cachedDocument = xhr._cachedDocument;

                cachedDocument || (cachedDocument = xhr._cachedDocument = document.implementation.createHTMLDocument(""),
                cachedDocument.body.innerHTML = xhr.responseText, xhr._cachedTarget = {}),
                xhr._embeds.splice(0).map(function(item) {

                    var target = xhr._cachedTarget[item.id];

                    target || (target = xhr._cachedTarget[item.id] = cachedDocument.getElementById(item.id)),

                    embed(item.parent, item.svg, target);
                });
            }
        };
        xhr.onreadystatechange();
    }
    function svg4everybody(rawopts) {
        function oninterval() {

            for (
            var index = 0; index < uses.length; ) {

                var use = uses[index], parent = use.parentNode, svg = getSVGAncestor(parent), src = use.getAttribute("xlink:href") || use.getAttribute("href");
                if (!src && opts.attributeName && (src = use.getAttribute(opts.attributeName)),
                svg && src) {
                    if (polyfill) {
                        if (!opts.validate || opts.validate(src, svg, use)) {
                            parent.removeChild(use);
                            var srcSplit = src.split("#"), url = srcSplit.shift(), id = srcSplit.join("#");

                            if (url.length) {
                                var xhr = requests[url];
                                xhr || (xhr = requests[url] = new XMLHttpRequest(), xhr.open("GET", url), xhr.send(),
                                xhr._embeds = []),
                                xhr._embeds.push({
                                    parent: parent,
                                    svg: svg,
                                    id: id
                                }),
                                loadreadystatechange(xhr);
                            } else {
                                embed(parent, svg, document.getElementById(id));
                            }
                        } else {

                            ++index, ++numberOfSvgUseElementsToBypass;
                        }
                    }
                } else {

                    ++index;
                }
            }

            (!uses.length || uses.length - numberOfSvgUseElementsToBypass > 0) && requestAnimationFrame(oninterval, 67);
        }
        var polyfill, opts = Object(rawopts), newerIEUA = /\bTrident\/[567]\b|\bMSIE (?:9|10)\.0\b/, webkitUA = /\bAppleWebKit\/(\d+)\b/, olderEdgeUA = /\bEdge\/12\.(\d+)\b/, edgeUA = /\bEdge\/.(\d+)\b/, inIframe = window.top !== window.self;
        polyfill = "polyfill" in opts ? opts.polyfill : newerIEUA.test(navigator.userAgent) || (navigator.userAgent.match(olderEdgeUA) || [])[1] < 10547 || (navigator.userAgent.match(webkitUA) || [])[1] < 537 || edgeUA.test(navigator.userAgent) && inIframe;

        var requests = {}, requestAnimationFrame = window.requestAnimationFrame || setTimeout, uses = document.getElementsByTagName("use"), numberOfSvgUseElementsToBypass = 0;

        polyfill && oninterval();
    }
    function getSVGAncestor(node) {
        for (var svg = node; "svg" !== svg.nodeName.toLowerCase() && (svg = svg.parentNode); ) {}
        return svg;
    }
    return svg4everybody;
});


$(function(){
    svg4everybody();
});




$(function() {
    var tableElement = function(table, options){
        var setDefault = {
            tabletype: "scroll",
            breakparent : "#container",
            addheadelement : "add-head",
            addwrapclass : "table-responsive",
            target: window,
            breakpoint : 640,
            breakstatus : false
        };
        this.element = $(table);
        this.options = $.extend({},setDefault,options);

        this.element.addClass(this.options.tabletype);
        this.$target = $(this.options.target)
        .on("resize", $.proxy(this.tableCheck, this));
        this.tableCheck();
    };

    tableElement.prototype.getState = function() {
        if($(window).innerWidth() > this.options.breakpoint){
            return "notRwd";
        } else {
            return "applyRwd";
        }
    };

    tableElement.prototype.getWidth = function() {
        this.element
        .css("width", this.options.breakpoint)
        .closest("." + this.options.addwrapclass).addClass("active")
        .addClass("mobile");
        this.options.breakstatus = true;
    };
    tableElement.prototype.removeWidth = function() {
        this.element
        .css("width", "")
        .closest("." + this.options.addwrapclass).removeClass("active")
        .removeClass("mobile");
        this.options.breakstatus = false;
    };

    tableElement.prototype.getWrap = function(classname) {
        var wrapElement = this.element,
            wrapClassName =  classname,
            addClassTarget;
        if(!wrapClassName) {
            wrapClassName = this.options.addwrapclass;
        }
        addClassTarget = wrapElement.closest("." + wrapClassName);
        if(!addClassTarget[0]) {
            wrapElement.wrap("<div class='" + wrapClassName + "' />");
        }
    };

    tableElement.prototype.getIcon = function() {
        addClassTarget = this.element.closest("." +this.options.addwrapclass);
        var hasClassName = this.hasClassName(addClassTarget, this.options.scrollguide);

        if(this.options.scrollguide ){
            var scrollBottomPosition =  ( this.element.offset().top  - $(window).outerHeight() ) <= $(window).scrollTop(),
                scrollTopPosition =   this.element.offset().top >= $(window).scrollTop();

            if (scrollBottomPosition && scrollTopPosition ) {
                if(!hasClassName){
                    addClassTarget
                    .removeClass("bounceout")
                    .addClass("bouncein " + this.options.scrollguide);
                    bounceTime = setTimeout($.proxy(function(){
                        this.bounceIcon();
                    }, this),3000);
                }
            }else{
                this.removeIcon()
            }
        }
    };
    tableElement.prototype.bounceIcon = function() {
        addClassTarget = this.element.closest("." +this.options.addwrapclass);
        if(this.options.scrollguide){
            addClassTarget
            .removeClass("bouncein")
            .addClass("bounceout");
        }
    };

    tableElement.prototype.removeIcon = function() {
        if(this.options.scrollguide){
            addClassTarget = this.element.closest("." +this.options.addwrapclass);
            var hasClassName = this.hasClassName(addClassTarget, this.options.scrollguide);
            if(hasClassName){
                addClassTarget.removeClass(this.options.scrollguide);
            }

        }
    };

    tableElement.prototype.hasClassName = function(el, className) {
        var name = el.hasClass(className);
        return name;
    };

    tableElement.prototype.getSimple = function() {
        var trs = this.element.find('tr');
        var trsChild;
        var grid = {};
        var cells;
        trs.each(function(index,item){
            if (!grid[index]) {
                grid[index] = {};
            }
            trsChild = item.childNodes;
            cells = 0;
            for (var j = 0, cntJ = trsChild.length; j < cntJ; j++) {
                grid[index][cells++] = trsChild[j];
            }
            var tds = $(item).find("td");
            tds.wrapInner( "<span class='tds'></span>")  //셀내용 span 감싸기
        });

        var cellHeader = "";
        for (row in grid) {
            if (row == 0) {
                continue;
            }
            for (cell in grid[row]) {
                if (cell == 0) {
                    continue;
                }
                var cellHeader =  $(grid[0][cell]).html();
                var insertCellHeader = "<span class=" + this.options.addheadelement + ">" + cellHeader + "</span>";
                var insertCellHeader = "<span class=" + this.options.addheadelement + ">" + cellHeader + "</span>";
                $(insertCellHeader).prependTo(grid[row][cell]);

            }
        }
    };

    tableElement.prototype.removeSimple = function(){
        this.element.find("." + this.options.addheadelement).remove();
        var tds = this.element.find(".tds");
        tds.contents().unwrap( ".tds")

    };


    tableElement.prototype.tableCheck = function() {
        var tableStatus = this.getState();

        if(this.tableStatus !== tableStatus) {
            this.tableStatus = tableStatus;

            switch (this.options.tabletype) {
                case "simple" :
                    if (this.tableStatus === "applyRwd") {
                        this.getSimple();
                        this.element.addClass("mobile");
                    } else {
                        this.removeSimple();
                        this.element.removeClass("mobile");
                    }
                    break;
                case "block" :
                    if (this.tableStatus === "applyRwd") {
                        this.element.addClass("mobile");
                    } else {
                        this.element.removeClass("mobile");
                    }
                    break;
                default :
                    this.getWrap();
                    if( this.tableStatus === "applyRwd") {
                        this.getWidth();
                        this.getIcon();
                        $(window).on('scroll', $.proxy(this.getIcon, this));

                    } else {
                        this.removeWidth();
                        this.removeIcon()
                    }
                    break;
            }
        }
    };

    function tableRwd(option){
        return this.each(function(){
            var $this = $(this);
            var data  = $this.data("rwd");
            var options = typeof option === "object" && option;

            if (!data) {
                $this.data("rwd", (data = new tableElement(this, options)));
            }
        });
    }


    $.fn.tableRwd             = tableRwd;

    if (navigator.appVersion.indexOf("MSIE 8.") === -1) {
        $(window).on("load",function(e){
            $("[data-table=\"rwd\"]").each(function () {
                var allTableRwd = $(this);
                var data = allTableRwd.data();
                tableRwd.call(allTableRwd,data);
            });
        });
    }
});


$(function(){
    var manageButton =  {
        body : $("tr"),
        buttons : $(".manage__show, .manage__body"),
        activeClass : "active"
    };

    manageButton.buttons.each(function(i){
        var area = manageButton.buttons.eq(i).closest(manageButton.body);

        var buttonHeight = area.outerHeight();
        $(this).css({height : buttonHeight-1});

        $(this).hover(function () {
            area.stop(true,true).addClass(manageButton.activeClass);
        }, function () {
            area.stop(true,true).removeClass(manageButton.activeClass);
        });
    });
});


//TabMenu
$(function(){
    var tab = function (element) {
        this.element = $(element);
    };
    tab.prototype.show = function () {
        var $this    = this.element,
            $ul      = $this.closest("ul"),
            $target,
            $targetGroup,
            selector = $this.attr("href");
        selector = selector && selector.replace(/.*(?=#[^\s]*$)/, "");

        if ($this.parent("li").hasClass("active")) {
            return;
        }
        $target = $(selector);
        $targetGroup = $(selector).parent().closest("div");

        this.activate($this.closest("li"), $ul, "> .active", "nav");
        this.activate( $target, $targetGroup, ".active");
    };

    tab.prototype.activate = function (element, container, cts, area) {
        var $active    = container.find(cts);
        if ($active.hasClass("p-tab__body--slide")) {
            $active
                .stop()
                .hide()
                .removeClass("active")
                .end();
            element
                .stop()
                .slideDown(500, function () {
                    $(this).addClass("active");
                });
        }
        else if ($active.hasClass("fade")) {
            $active
                .stop()
                .hide()
                .removeClass("active")
                .end();
            element
                .stop()
                .fadeIn(300, function () {
                    $(this).addClass("active");
                });
        }
        else {
            $active
                .removeClass("active")
                .end();
            element
                .addClass("active");
        }
        if(area === "nav"){
            $active.find("a, button")
                .attr("title","");
            element.find("a, button")
                .attr("title","선택됨");
        }
        if(area !== "nav"){
            $active
                .attr("title","숨김");
            element
                .attr("title","열림");
        }
    };

    $(document).on("click", "[data-button='tab']", function (e) {
        if( !$(this).data("url") ){
            e.preventDefault();
            $(this).each(function () {
                var $this, data, option;
                $this = $(this);
                data = $this.data("tab");
                option = "show";
                if (!data) {
                    $this.data("tab", (data = new tab(this)));
                }

                if (typeof option === "string") {
                    data[option]();
                }
                this.options = $this.data();
                if(this.options.dropdown){
                    Dropdown();
                }
            });
        }
    });
});


$(function(){
    var Accordion = function (element,option,options) {
        this.element = $(element);
        this.option = option;
        this.options = options;
    };

    Accordion.prototype.show = function () {
        var $this    = this.element,
            selector = $this.attr("href"),
            $target = $(selector);
        if(this.options.arange){
            this.openToggle(this.options.arange);
            return;
        }
        if ($this.hasClass("active")) {
           this.disabled($this);
           this.disabled($target, "display");
           return;
        }
        this.activate($this);
        this.activate($target, "display");
    };

    Accordion.prototype.activate = function (element, display) {
        element.addClass("active");
        if(display){
            element.show();
            element.attr("title","열림");
        }

    };
    Accordion.prototype.disabled = function (element, display) {
        element.removeClass("active");
        if(display){
            element.hide();
            element.attr("title","숨김");
        }
    };
    Accordion.prototype.openToggle= function (status) {
        var $target    = $(this.options.parent).find('[data-accordion]');
        $target.each(function () {
            var active = $(this).attr("href");

            if(status === "open"){
                $(this).addClass("active");
                $(active)
                .addClass("active")
                .show()
                .attr("title","열림");
            } else{
                $(this).removeClass("active");
                $(active)
                .removeClass("active")
                .hide()
                .attr("title","숨김");
            }
        });
    };
    $(document).on("click", "[data-accordion]", function (e) {
        e.preventDefault();
        $(this).each(function () {
            var $this = $(this);
            var data  = $this.data("accordion");
            var option = "show";
            var options = $this.data();
            if (!data) {
                $this.data("accordion", (data = new Accordion(this, option, options)));
            }
            if (typeof option === "string") {
                data[option]();
            }
            this.options = $this.data();
        });

    });
});

$(function() {
    var Tooltip = function (element, options) {
        this.init("tooltip", element, options)
    };

    Tooltip.DEFAULTS = {
        placement: "top",
        selector: false,
        template: '<div class="tooltip" role="tooltip"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>',
        trigger: "hover focus",
        title: "",
        delay: 0,
        container: false,
        viewport: {
            selector: "body",
            padding: 0
        }
    };

    Tooltip.prototype.init = function (type, element, options) {
        this.enabled   = true;
        this.type      = type;
        this.$element  = $(element);
        this.options   = this.getOptions(options);
        this.$viewport = this.options.viewport && $(this.options.viewport.selector || this.options.viewport);

        var triggers = this.options.trigger.split(" ");

        for (var i = triggers.length; i--;) {
            var trigger = triggers[i];

            if (trigger !== "manual") {
                var eventIn  = trigger === "hover" ? "mouseenter" : "focusin";
                var eventOut = trigger === "hover" ? "mouseleave" : "focusout";

                this.$element.on(eventIn  + "." + this.type, this.options.selector, $.proxy(this.enter, this));
                this.$element.on(eventOut + "." + this.type, this.options.selector, $.proxy(this.leave, this));
            }
        }
        if(this.options.selector) {
            //data-selector 있으면
            this._options = $.extend({}, this.options, { trigger: "manual", selector: "" });
        } else{
            this.fixTitle()
        }
    };

    Tooltip.prototype.getDefaults = function () {
        return Tooltip.DEFAULTS
    };


    Tooltip.prototype.getOptions = function (options) {
        options = $.extend({}, this.getDefaults(), this.$element.data(), options);

        return options
    };


    Tooltip.prototype.getDelegateOptions = function () {
        var options  = {};
        var defaults = this.getDefaults();

        this._options && $.each(this._options, function (key, value) {
            if (defaults[key] !== value) options[key] = value
        });

        return options
    };

    Tooltip.prototype.enter = function (obj) {
        var self = $(obj.currentTarget).data(this.type);

        self.hoverState = "in";
        if (self.hoverState === "in") {
            self.show()
        }
    };

    Tooltip.prototype.leave = function (obj) {

        var self = $(obj.currentTarget).data(this.type);

        self.hoverState = "out";

        if (self.hoverState === "out") {
           self.hide()
        }


    };

    Tooltip.prototype.show = function () {
        var e = $.Event("show." + this.type);

        if (this.hasContent() && this.enabled) {


            var that = this;
            var $tip = this.tip();
            var tipId = this.getUID(this.type);

            this.setContent();

            $tip.attr("id", tipId);
            this.$element.attr("aria-describedby", tipId);
            // 위치 지정 - 
            var placement = this.options.placement;

            var autoToken = /\s?auto?\s?/i;
            var autoPlace = autoToken.test(placement);
            if (autoPlace) placement = placement.replace(autoToken, "") || "top";

            $tip
            .detach()
            .css({ top: 0, left: 0, display: "block" })
            .addClass(placement)
            .data(this.type, this);


            if(this.options.container){
                $tip.appendTo(this.options.container)

            } else{
                $tip.insertAfter(this.$element);
            }

            var pos          = this.getPosition();
            var actualWidth  = $tip[0].offsetWidth;
            var actualHeight = $tip[0].offsetHeight;

            if (autoPlace) {
                var orgPlacement = placement;
                var $container   = this.options.container ? $(this.options.container) : this.$element.parent();
                var containerDim = this.getPosition($container);

                placement = placement === "bottom" && pos.bottom + actualHeight > containerDim.bottom ? "top"    :
                placement === "top"    && pos.top    - actualHeight < containerDim.top    ? "bottom" :
                placement ==="right"  && pos.right  + actualWidth  > containerDim.width  ? "left"   :
                placement === "left"   && pos.left   - actualWidth  < containerDim.left   ? "right"  :
                placement;

                $tip
                .removeClass(orgPlacement)
                .addClass(placement)
            }


            var calculatedOffset = this.getCalculatedOffset(placement, pos, actualWidth, actualHeight);

            this.applyPlacement(calculatedOffset, placement);

        }
    };

    Tooltip.prototype.applyPlacement = function (offset, placement) {
        var $tip   = this.tip();
        var width  = $tip[0].offsetWidth;
        var height = $tip[0].offsetHeight;

        var marginTop = parseInt($tip.css("margin-top"), 10);
        var marginLeft = parseInt($tip.css("margin-left"), 10);


        if (isNaN(marginTop))  marginTop  = 0;
        if (isNaN(marginLeft)) marginLeft = 0;

        offset.top  = offset.top  + marginTop;
        offset.left = offset.left + marginLeft;

        $.offset.setOffset($tip[0], $.extend({
            using: function (props) {
                $tip.css({
                    top: Math.round(props.top),
                    left: Math.round(props.left)
                })
            }
        }, offset), 0);


        $tip.addClass("active");

        var actualWidth  = $tip[0].offsetWidth;
        var actualHeight = $tip[0].offsetHeight;

        if (placement === "top" && actualHeight !== height) {
            offset.top = offset.top + height - actualHeight;
        }

        var delta = this.getViewportAdjustedDelta(placement, offset, actualWidth, actualHeight);

        if (delta.left) offset.left += delta.left;
        else offset.top += delta.top;

        var isVertical          = /top|bottom/.test(placement);
        var arrowDelta          = isVertical ? delta.left * 2 - width + actualWidth : delta.top * 2 - height + actualHeight;
        var arrowOffsetPosition = isVertical ? "offsetWidth" : "offsetHeight";

        $tip.offset(offset);


        this.replaceArrow(arrowDelta, $tip[0][arrowOffsetPosition], isVertical)
    };

    Tooltip.prototype.replaceArrow = function (delta, dimension, isHorizontal) {
        this.arrow()
        .css(isHorizontal ? "left" : "top", 50 * (1 - delta / dimension) + "%")
        .css(isHorizontal ? "top" : "left", "")
    };

    Tooltip.prototype.setContent = function () {
        var $tip  = this.tip();
        var title = this.getTitle();

        $tip.find(".tooltip-inner")["text"](title);
        $tip.removeClass("fade in top bottom left right active")


        if(this.options.maxwidth){
            $tip.find(".tooltip-inner").css({
                maxWidth: this.options.maxwidth
            });
        }

    };

    Tooltip.prototype.hide = function (callback) {
        var that = this;
        var $tip = this.tip();
        var e    = $.Event("hide." + this.type);

        function complete() {
            if (that.hoverState !== "in") $tip.detach();
            that.$element
            .removeAttr("aria-describedby")
            .trigger("hidden." + that.type);
            callback && callback()
        }

        this.$element.trigger(e);

        if (e.isDefaultPrevented()) return;

        $tip.removeClass("active");

        complete();

        this.hoverState = null;

        return this
    };


    Tooltip.prototype.fixTitle = function () {
        var $e = this.$element;
        if ($e.attr("title") || typeof (this.options.original_title) !== "string") {
            $e.attr("data-original_title", $e.attr("title") || "").attr("title", "")
        }

    };


    Tooltip.prototype.hasContent = function () {
        return this.getTitle()
    };


    Tooltip.prototype.getPosition = function ($element) {
        $element   = $element || this.$element;

        var el     = $element[0];
        var isBody = el.tagName === "BODY";

        var elRect    = el.getBoundingClientRect();

        if (elRect.width == null) {

            elRect = $.extend({}, elRect, { width: elRect.right - elRect.left, height: elRect.bottom - elRect.top })
        }
        var elOffset  = isBody ? { top: 0, left: 0 } : $element.offset();
        var scroll    = { scroll: isBody ? document.documentElement.scrollTop || document.body.scrollTop : $element.scrollTop() };
        var outerDims = isBody ? { width: $(window).width(), height: $(window).height() } : null;

        return $.extend({}, elRect, scroll, outerDims, elOffset)
    };


    Tooltip.prototype.getCalculatedOffset = function (placement, pos, actualWidth, actualHeight) {
        return placement === "bottom" ? { top: pos.top + pos.height,   left: pos.left + pos.width / 2 - actualWidth / 2 } :
                placement === "top"    ? { top: pos.top - actualHeight, left: pos.left + pos.width / 2 - actualWidth / 2 } :
                placement === "left"   ? { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left - actualWidth } :
                /* placement === "right" */ { top: pos.top + pos.height / 2 - actualHeight / 2, left: pos.left + pos.width }

    };


    Tooltip.prototype.getViewportAdjustedDelta = function (placement, pos, actualWidth, actualHeight) {
        var delta = { top: 0, left: 0 };
        if (!this.$viewport) return delta;

        var viewportPadding = this.options.viewport && this.options.viewport.padding || 0;
        var viewportDimensions = this.getPosition(this.$viewport);

        if (/right|left/.test(placement)) {
            var topEdgeOffset    = pos.top - viewportPadding - viewportDimensions.scroll;
            var bottomEdgeOffset = pos.top + viewportPadding - viewportDimensions.scroll + actualHeight;
            if (topEdgeOffset < viewportDimensions.top) {
                delta.top = viewportDimensions.top - topEdgeOffset
            } else if (bottomEdgeOffset > viewportDimensions.top + viewportDimensions.height) {
                delta.top = viewportDimensions.top + viewportDimensions.height - bottomEdgeOffset
            }
        } else {
            var leftEdgeOffset  = pos.left - viewportPadding;
            var rightEdgeOffset = pos.left + viewportPadding + actualWidth;
            if (leftEdgeOffset < viewportDimensions.left) {
                delta.left = viewportDimensions.left - leftEdgeOffset
            } else if (rightEdgeOffset > viewportDimensions.width) {
                delta.left = viewportDimensions.left + viewportDimensions.width - rightEdgeOffset
            }
        }

        return delta
    };

    Tooltip.prototype.getTitle = function () {
        var title;
        var $e = this.$element;
        title = $e.attr("data-original_title");
        if(!title){
            title = this.options.original_title;
        }
        return title
    };


    Tooltip.prototype.getUID = function (prefix) {
        do prefix += ~~(Math.random() * 1000000);
        while (document.getElementById(prefix));
        return prefix
    };


    Tooltip.prototype.tip = function () {
        return (this.$tip = this.$tip || $(this.options.template))
    };

    Tooltip.prototype.arrow = function () {
        return (this.$arrow = this.$arrow || this.tip().find(".tooltip-arrow"))
    };

    Tooltip.prototype.toggle = function (e) {

        var self = this;
        if (e) {
            self = $(e.currentTarget).data(this.type);
            if (!self) {
                self = new this.constructor(e.currentTarget);
                $(e.currentTarget).data(this.type, self)
            }
        }
        if (self.tip().hasClass("active")) {
            self.leave(self)
        } else {
            self.enter(self)
        }
    };
    function tooltipPlugin(option) {
        return this.each(function () {
            var $this   = $(this);
            var data    = $this.data("tooltip");
            var options = typeof option === "object" && option;
            if (!data) {
                $this.data("tooltip", (data = new Tooltip(this, options)));
            }

        })
    }

    $.fn.tooltip             = tooltipPlugin;
    $.fn.tooltip.Constructor = Tooltip;


    //Popover
    var Popover = function (element, options) {
        this.init('popover', element, options)
    };

    if (!$.fn.tooltip) throw new Error('Popover requires tooltip.js');

    Popover.DEFAULTS = $.extend({}, $.fn.tooltip.Constructor.DEFAULTS, {
        placement: 'right',
        trigger: 'hover focus',
        content: '',
        template: '<div class="popover" role="tooltip"><div class="arrow"></div><div class="popover-title"></div><div class="popover-content"></div></div>'
    });


    Popover.prototype = $.extend({}, $.fn.tooltip.Constructor.prototype);

    Popover.prototype.constructor = Popover;

    Popover.prototype.getDefaults = function () {
        return Popover.DEFAULTS
    };

    Popover.prototype.setContent = function () {
        var $tip    = this.tip();
        var title   = this.getTitle();
        var content = this.getContent();

        $tip.find('.popover-title')["text"](title);
        $tip.find('.popover-content').children().detach().end()["text"](content);
        $tip.removeClass('fade top bottom left right in active');


        if (!$tip.find('.popover-title').html()) $tip.find('.popover-title').hide();



        if(this.options.maxwidth){
            $tip.css({
                maxWidth: this.options.maxwidth
            });
        }

    };

    Popover.prototype.hasContent = function () {
        return this.getTitle() || this.getContent()
    };

    Popover.prototype.getContent = function () {
        var $e = this.$element;

        return $e.attr('data-content') || (typeof this.options.content === 'function' ?
                this.options.content.call($e[0]) :
                this.options.content)
    };

    Popover.prototype.arrow = function () {
        return (this.$arrow = this.$arrow || this.tip().find('.arrow'))
    };

    Popover.prototype.tip = function () {
        if (!this.$tip) this.$tip = $(this.options.template);
        return this.$tip
    };

    function popoverPulgin(option) {
        return this.each(function () {
            var $this   = $(this);
            var data    = $this.data('popover');
            var options = typeof option === 'object' && option;


            if (!data) $this.data('popover', (data = new Popover(this, options)));
            if (typeof option === 'string') data[option]()

        })
    }

    $.fn.popover             = popoverPulgin;
    $.fn.popover.Constructor = Popover;


    $(window).on("load",function(e){
        $("[data-button=\"tooltip\"]").each(function () {
            if($(this).is('a')) {
                $(this).on("click",function(e){
                    e.preventDefault();
                });
            }
            var allTooltip = $(this);
            var data = allTooltip.data();
            tooltipPlugin.call(allTooltip,data);

        });
    });

    $(window).on("load",function(e){
        $("[data-button=\"popover\"]").each(function () {
            if($(this).is('a')) {
                $(this).on("click",function(e){
                    e.preventDefault();
                });
            }
            var allPopover = $(this);
            var data = allPopover.data();
            popoverPulgin.call(allPopover,data);
        });

    });

});






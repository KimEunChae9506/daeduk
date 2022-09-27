var autoCompleteUse = true;
var keywdownUse = false;
var mousePoint = -1;
var searchForm = "#prosearch";
var textQuery = "in_srchParam";
var textQueryId = "#"+textQuery;
var autoId = "auto";
var autoCompleteId = "auto_complete";
var autoCompleteListId = "autocomplete_content_list";
var totalCount = 0;
var autoCompleteUrl = "./api/autoQuery.jsp"; 
var preQuery = "";

//var keyboardFix = new beta.fix(textQuery);

var browser = "";
// Opera 8.0+
var isOpera = (!!window.opr && !!opr.addons) || !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;

// Firefox 1.0+
var isFirefox = typeof InstallTrigger !== 'undefined';

// Safari 3.0+ "[object HTMLElementConstructor]" 
var isSafari = /constructor/i.test(window.HTMLElement) || (function (p) { return p.toString() === "[object SafariRemoteNotification]"; })(!window['safari'] || (typeof safari !== 'undefined' && safari.pushNotification));

// Internet Explorer 6-11
var isIE = /*@cc_on!@*/false || !!document.documentMode;

// Edge 20+
var isEdge = !isIE && !!window.StyleMedia;

// Chrome 1 - 71
//var isChrome = !!window.chrome && (!!window.chrome.webstore || !!window.chrome.runtime);
var isChrome = /Chrome/.test(navigator.userAgent) && /Google Inc/.test(navigator.vendor);
if (isIE) {
	browser = "IE";
} else if (isFirefox) {
	browser = "FF";
} else if (isOpera) {
	browser = "OPERA";
} else if (isChrome) {
	browser = "CHROME";
}

//alert(browser);
function settingLocation() {
	var qWidth = parseInt($(textQueryId).width());
	var qHeight = parseInt($(textQueryId).height());
	
	var offsetTop = "";
	var offsetLeft = "";
	
	var arkWidth  = 138;
	
	var left = 0;
	var right = 2;
	
	var chrome_top = 0;
	var chrome_left = "";
	var ie_top = "";
	var ie_left = "";
 
 
	if(browser = "CHROME"){
		offsetLeft = offsetLeft + chrome_left;
		offsetTop = offsetLeft + chrome_top;
	}
 
	//$("#" + autoCompleteId).css({"position" : "relative", "z-index":"999999", "top" : offsetTop + "px", "left" : offsetLeft + "px", "width" : (qWidth + arkWidth) + "px"});
	
	
	
	//$("#autocomplete_content").css({"position" : "absolute", "top" : 0 + "px" , "left" : left + "px", "width" : (qWidth + arkWidth) + "px"});
	
}
 
function makeArkScript() {
	var htmls = ""; 
	htmls += "<div class=\"" + autoCompleteId + "\" id=\"" + autoCompleteId  +"\" >";
	htmls += "</div>";

	$("." + autoCompleteId).html(htmls);


}


 

function AutoCompleteHide() {
	
	//$("#" + autoId).hide();
	$("." + autoCompleteId).hide();
}

$(document).ready(function() {
	
    makeArkScript();
	//settingLocation();
	
	$(textQueryId).click(function(){
		autoComplateJson($(textQueryId).val()); //##
	});
	
	if (isOpera || isFirefox) {
		$(document).keydown(function(event) {
			var searchQuery = $(textQueryId).val();
			
			if (event.which == 38 || event.which == 40) {
				if (searchQuery != "") {
					AutoCompleteShow();
				}
				moveFocusEvent(event);
			} else {
				if ($(event.target).is(textQueryId)) {
					keywdownUse = true;
					eventKeydown();
				}
			}
		});
	} else if (isIE || isEdge || isChrome) {
		$(document).keyup(function(event) {
			var searchQuery = $(textQueryId).val();
			if (event.keyCode == 38 || event.keyCode == 40) {
				// 아래(40), 위(38) 방향키 조작시의 이벤트 처리
				if (searchQuery != "") {
					AutoCompleteShow();
				}
				setTimeout(moveFocusEvent, 7, event); //##
			} else if (event.keyCode == 16) {
			} else if (event.keyCode == 8 && searchQuery == "") {
				//$("#" + autoCompleteListId).html("");
				AutoCompleteHide();
			} else {
				if ($(event.target).is(textQueryId)) {
					if (autoCompleteUse && $(textQueryId).val() != "") {
						autoComplateJson($(textQueryId).val());
						
					} else if ($(textQueryId).val() == "") {
						AutoCompleteHide();
					}
				}
			}
		});
	}
	
	// Backspace 에 대한 처리
	$(textQueryId).keyup(function(event) {
		if(event.keyCode == 8 && $(this).val() == "") {
			//$("#" + autoCompleteListId).html("");
			AutoCompleteHide();
		}
	});
	// 브라우저에서 일어나는 클릭 이벤트를 체크한다.
	$(document).click(function(event) {
		stopEventBubble(event);
		if ($(event.target).is(textQueryId)) {
			if (autoCompleteUse) {
				var query = $(textQueryId).val();
				if (query != "") {
					autoComplateJson($(textQueryId).val());
					keyword = query;
				}
				keywdownUse = true;
			}
		} else if (!$(event.target).is("." + autoCompleteId)) {
			AutoCompleteHide();
		}
	});

	
});


function stopEventBubble(evt) {
	var eventReference = (typeof evt !== "undefined") ? evt : event;
	if(eventReference.stopPropagation) {
		eventReference.stopPropagation();
	} else {
		eventReference.cancelBubble = true;
	}
}





function autoComplateJson(searchQuery) {
	jQuery.support.cors = true;
	mousePoint = -1;
	$.ajaxSetup({cache:false});
	$.ajax({
		url: autoCompleteUrl,
		type: "POST",
		dataType: 'json',
		data: { "query":searchQuery
		},
				
		success: function(data) {
			if(data==null && data.count == 0 ) {
				totalCount = 0;
				return;
			}
			totalCount = data.count;

			var str = "";
			var num = -1;
			$.each(data.result, function(v, item) {
				if(v > 4){return;} //자동완성 5개까지만 노출
				if (totalCount > 0) {
					var hkeword = item.highlight.replace("<em>","<span>").replace("</em>","</span>");
					num=num+1;
					str += "<div id=\"bg" + num + "\" onclick=\"onClickKeyword(" + num + ");\" onmouseover=\"onMouseOverKeyword(" + num + ");\"";
					str += " onmouseout=\"onMouseOutKeyword(" + num + ");\">" +hkeword ;
					str += " <span id=\"f" + num + "\" style=display:none;>" + item.word + "</span>";
					str += "</div>";
				}
				
			});
			
			if ((totalCount) == 0) {
				AutoCompleteHide();
				//$("#" + autoCompleteListId).html("<li style=\" padding:10px 30px;border-radius:18px;\">해당 단어로 시작하는 검색어가 없습니다.</li>");
			} else {
				$("." + autoCompleteId).html(str);
				AutoCompleteShow(); //##
			}
		},
		error:function(request,status,error){
        alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
       }

    });
	
}


var keyword = "";


function eventKeydown() { 
	if(!keywdownUse) {
		return;
	}

	if (keyword != $(textQueryId).val()) {
		keyword = $(textQueryId).val();
		autoComplateJson($(textQueryId).val());
	}
	setTimeout("eventKeydown()", 20);
}



function moveFocusEvent(event) {
	keywdownUse = false;
	if (event.keyCode == 38) {
		if (mousePoint==-1 || mousePoint==0) {
			mousePoint = -1;
			AutoCompleteHide();
			$(textQueryId).val(preQuery);
			preQuery = "";
		} else {
			onMouseOutKeyword(mousePoint);
			mousePoint = mousePoint - 1;
			onMouseOverKeyword(mousePoint);
			$(textQueryId).val($("#f" + mousePoint).text());
		}
	} else if (event.keyCode == 40) {
		if(mousePoint == -1) {
			preQuery = $(textQueryId).val();
		}
		if ((totalCount ) > (mousePoint + 1)) {
			onMouseOutKeyword(mousePoint);
			mousePoint = mousePoint + 1;
			onMouseOverKeyword(mousePoint);
			$(textQueryId).val($("#f" + mousePoint).text());
		}
	}
}


function onMouseOverKeyword(cursorNum) {
	clearCursorPos();
	mousePoint = cursorNum;
	$("#bg" + cursorNum).css({"backgroundColor" : "#eeeeee"});
	$("#bg" + cursorNum).css({"cursor" : "pointer"});
}


function onMouseOutKeyword(curSorNum) {
	mousePoint = curSorNum;
	$("#bg" + mousePoint).css({"backgroundColor" : "#ffffff"});
}


function clearCursorPos() {
	for(var i=0; i<( totalCount ); i++){
		$("#bg" + i).css({"backgroundColor" : "#ffffff"});
	}
}


function onClickKeyword(mousePoint) {
    document.searchUserTopForm.srchParam.value =  $("#f" + mousePoint).text();	
    document.searchUserTopForm.tagSchYn.value = "y";
    document.searchUserTopForm.pageNo.value = "1";
	document.searchUserTopForm.submit();
}


function AutoCompleteShow() {
  if(  $(textQueryId).val() != ""){
	    //$("#" + autoId).show();
	    $("." + autoCompleteId).show();
	   
	}
}




var preview = "";
var gobj = "";

function attachEvent_(obj, evt, fuc, useCapture) {
	if (!useCapture) {
		useCapture = false;
	}

	if (obj.addEventListener) {
		// W3C DOM 지원 브라우저
		return obj.addEventListener(evt,fuc,useCapture);
	} else if (obj.attachEvent) {
		// MSDOM 지원 브라우저
		return obj.attachEvent("on"+evt, fuc);
	} else {
		// NN4 나 IE5mac 등 비 호환 브라우저
		MyAttachEvent(obj, evt, fuc);
		obj['on'+evt]=function() { MyFireEvent(obj,evt) };
	}
}

function detachEvent_(obj, evt, fuc, useCapture) {
  if(!useCapture) useCapture=false;
  if(obj.removeEventListener) {
    return obj.removeEventListener(evt,fuc,useCapture);
  } else if(obj.detachEvent) {
    return obj.detachEvent("on"+evt, fuc);
  } else {
    MyDetachEvent(obj, evt, fuc);
    obj['on'+evt]=function() { MyFireEvent(obj,evt) };
  }
}

function MyAttachEvent(obj, evt, fuc) {
  if(!obj.myEvents) obj.myEvents= {};
  if(!obj.myEvents[evt]) obj.myEvents[evt]=[];
  var evts = obj.myEvents[evt];
  evts[evts.length]=fuc;
}

function MyFireEvent(obj, evt) {
  if(!obj.myEvents || !obj.myEvents[evt]) return;
  var evts = obj.myEvents[evt];
  for (var i=0;i<len;i++) {
    len=evts.length;
    evts[i]();
  }
}

function previewShow(e, obj, pv) {
  preview=pv;
  gobj=obj;
  attachEvent_(obj, "mousemove", previewMove, false);
  attachEvent_(obj, "mouseout", previewHide, false);
}

function previewMove(e) {
  var hb = document.getElementById(preview);
  if(hb.parentElement) {
	  hb.parentElement.style.display="block";
  } else {
	  hb.parentNode.style.display="";
  }
  var evt = e ? e : window.event;
  var posx=0;
  var posy=0;

  if (evt.pageX || evt.pageY) { // pageX/Y 표준 검사
    posx = evt.pageX +8;
    posy = evt.pageY +16;
  } else if (evt.clientX || evt.clientY) { //clientX/Y 표준 검사 Opera
    posx = evt.clientX +10;
    posy = evt.clientY +20;
    if (window.event) { // IE 여부 검사
      posx += document.body.scrollLeft - 80;
      posy += document.body.scrollTop;
     }
  }

  hb.style.left = posx + "px";
  hb.style.top = posy + "px";
}

function previewHide() {
  var hb = document.getElementById(preview);
  if(hb.parentElement) hb.parentElement.style.display="none";
  else hb.parentNode.style.display="none";

  detachEvent_(gobj,"mousemove", previewMove, false);
}



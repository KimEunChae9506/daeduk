
var _interval_duration = 5000;
var _animation_duration = 1000;

/* -------------------------------------------------
 * #�대�吏� �щ씪�대뱶
 -------------------------------------------------*/
var _slide_interval = null;
var _slide_isMoving = false;
function slide_start(){
	if(_slide_isMoving){
		_slide_interval = setInterval(function(){
			if(!_slide_isMoving){
				clearInterval(_slide_interval);
			}else{
				slide_move_right();
			}
		}, _interval_duration);
	}
}

function slide_stop(){
    clearInterval(_slide_interval);
}

function slide_active(){
    $("ul.action > li.pause").removeClass("active");
    $("ul.action > li.play").addClass("active");
    _slide_isMoving = true;
}

function slide_pause(){
    $("ul.action > li.play").removeClass("active");
    $("ul.action > li.pause").addClass("active");
    _slide_isMoving = false;
}

function slide_action(gbn){
	var paging = $("ul.page > li");
    var item_wrap = $("ul.slider");
    
    var pagingFn = function(i){
    	paging.removeClass("active");
    	paging.filter(function(){ return $(this).is("[item-index='"+i+"']")}).addClass("active");
    }
    
    if("next" == gbn){
    	item_wrap.find("li:first-child").animate({"margin-left": "-200%"}, _animation_duration, "swing", function(){
    		item_wrap.find("li:first-child").appendTo(item_wrap);
    		item_wrap.find("li").attr("style", "");
    		item_wrap.find("li:first-child").attr("style", "margin-left: -100%;");
    		
    		var i = item_wrap.find("li:first-child").next().attr("item-index");
    		pagingFn(i);
		});
    }else if("prev" == gbn){
    	item_wrap.find("li:first-child").animate({"margin-left": "0%"}, _animation_duration, "swing", function(){
    		item_wrap.find("li:last-child").prependTo(item_wrap);
    		item_wrap.find("li").attr("style", "");
    		item_wrap.find("li:first-child").attr("style", "margin-left: -100%;");
    		
    		var i = item_wrap.find("li:first-child").next().attr("item-index");
    		pagingFn(i);
		});
    }
}

function slide_move(idx){
	var paging = $("ul.page > li");
	var item_wrap = $("ul.slider");
	var items = item_wrap.find("li");
	var len = items.length;
	for(var i=idx-1; i<idx+len-1; i++){
		var ti = i%len;
		if(ti == 0) ti = len;
		item_wrap.append(item_wrap.find("li[item-index='"+ti+"']"));
	}
	item_wrap.find("li").attr("style", "");
	item_wrap.find("li:first-child").attr("style", "margin-left: -100%;");
	paging.removeClass("active");
	paging.filter(function(){ return $(this).is("[item-index='"+idx+"']")}).addClass("active");
}

function slide_move_right(){
	var paging = $("ul.page > li");
	var items = $("ul.slider > li");
    
    if(items.is(":animated")){
    	return;
    }

    slide_action("next");
}

function slide_move_left(){
	var paging = $("ul.page > li");
	var items = $("ul.slider > li");
    
    if(items.is(":animated")){
    	return;
    }

    slide_action("prev");
}

function initSlider(){
	var $slider_wrap = $("section.visual");
    
    _slide_isMoving = true;
	
	$slider_wrap.hover(slide_stop, slide_start);
	
	var isMoveSwiper = function(e) {
		var ww = $(window).outerWidth(true);
		if(1024 < ww){
			return false;
		}
		
		//swipe �꾩튂�� �묒そ 50留뚰겮 �쒖쇅�섍퀬 �댁빞��
		var startingPosition = 0;
		if("swiperight" == e.type){
			startingPosition = e.changedPointers[0].pageX - e.deltaX;
		}else if("swipeleft" == e.type){
			var startingPosition = ww - (e.changedPointers[0].pageX - e.deltaX);
		}
		if(startingPosition < 50){
			return false;
		}
		
		return true;
	}
	var swiper = new Hammer($slider_wrap[0]);
	swiper.get('swipe').set({
		direction: 	Hammer.DIRECTION_HORIZONTAL,
		velocity:	0.5
	});
	swiper.on('swipeleft', function (e) {
		if(isMoveSwiper(e)) {
			slide_move_right();
		}
	});
	swiper.on('swiperight', function (e) {
		if(isMoveSwiper(e)) {
			slide_move_left();
		}
	});
    
    slide_start();
}

/* -------------------------------------------------
 * #faq �띿뒪�� 濡ㅻ쭅
 -------------------------------------------------*/
var _rolling_interval = null;
function rolling_start(){
	_rolling_interval = setInterval(function(){
		var $faq_wrap = $("section.faq ul");
		$faq_wrap.find("li:first-child").animate({"margin-left": "-100%"}, _animation_duration, "swing", function(){
			$faq_wrap.find("li:first-child").appendTo($faq_wrap);
			$faq_wrap.find("li").attr("style", "");
		});
	}, _interval_duration);
}

function rolling_stop(){
	clearInterval(_rolling_interval);
}

function initRolling(){
	var $faq_wrap = $("section.faq ul");
	$faq_wrap.hover(rolling_stop, rolling_start);
	
	rolling_start();
}
 
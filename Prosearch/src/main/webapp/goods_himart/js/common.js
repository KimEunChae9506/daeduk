$(function(){
	/*액티브 박스-공통*/
	$('.active_box button.active_btn').on('click', function() {
		var $this = $(this);
		if(!$this.hasClass('on')) {
			$this.parents('.active_box').addClass('active').find('.active_btn').attr('title','하위내용 축소').addClass('on');
		}else{
			$this.parents('.active_box').removeClass('active').find('.active_btn').attr('title','하위내용 확장').removeClass('on');
		}
	});
});

// 탭메뉴 공통적으로 사용
function tabOn(tab,num,img) {
	var $tab,$tab_btn;
	var tabid=tab, n=num-1, btn_img=img;

	$tab = $(tabid+'> ul > li');
	$tab_btn = $(tabid+'> ul > li > a');

	$tab_btn.siblings().hide();
	$tab.eq(n).addClass('active');
	$tab.eq(n).children('a').siblings().show();

	if(btn_img =='img'){
		var btn = $tab.eq(n).children('a').find("img");
		btn.attr("src",btn.attr("src").replace("_off","_on"));
	}

	$tab_btn.on("click",function(event){
		var realTarget = $(this).attr('href');

		if(realTarget != "#"){
			return
		}
		if(btn_img =='img'){
			for(var i=0;i<$tab.size();i++){
				var btn = $tab.eq(i).children('a').find("img");
				btn.attr("src",btn.attr("src").replace("_on","_off"));
			}
			var active = $(this).parent().attr('class');
			if(active != 'active'){
				var btn_img_off = $(this).find('img')[0];
				btn_img_off.src =  btn_img_off.src.replace('_off','_on');
			}
		}
		$tab_btn.siblings().hide();
		$tab_btn.parent().removeClass('active');

		$(this).siblings().show();
		$(this).parent().addClass('active');

		event.preventDefault();
	});
}

function tabOrg(tabid,a,img) {
	var $tab, $tab_btn,$obj,$obj_view;
	var tabid = tabid, num = a, btn_img = img;

	$tab = $(tabid+' .tab_item  > li');
	$tab_btn = $(tabid+' .tab_item > li > a');
	$obj = $(tabid+' .tab_obj');
	$obj_view = $(tabid+' .tab_obj.n'+num);

	$tab.eq(num-1).addClass('active');
	$obj_view.show();

	if(btn_img =='img'){
		var btn = $tab.eq(num-1).children('a').find("img");
		btn.attr("src",btn.attr("src").replace("_off","_on"));
	}

	$tab.bind("click",function(event){
		if(btn_img =='img'){
			for(var i=0;i<$tab.size();i++){
				var btn = $tab.eq(i).children('a').find("img");
				btn.attr("src",btn.attr("src").replace("_on","_off"));
			}
			var active = $(this).parent().attr('class');
			if(active != 'active'){
				var btn_img_off = $(this).find('img')[0];
				btn_img_off.src =  btn_img_off.src.replace('_off','_on');
			}
		}

		var this_eq = $tab.index( $(this) );
		$tab.removeClass('active');
		$tab.eq(this_eq).addClass('active');

		$obj.hide();
		$(tabid+' .tab_obj.n'+(this_eq+1)).show();

		event.preventDefault ();
	});
}

$(document).ready(function(){
	//이미지 롤오버 
	 $('.overimg').mouseover(function (){
		var file = $(this).attr('src').split('/');
		var filename = file[file.length-1];
		var path = '';
		for(i=0 ; i < file.length-1 ; i++){
		 path = ( i == 0 )?path + file[i]:path + '/' + file[i];
		}
		$(this).attr('src',path+'/'+filename.replace('_off.','_on.'));
		
	 }).mouseout(function(){
		var file = $(this).attr('src').split('/');
		var filename = file[file.length-1];
		var path = '';
		for(i=0 ; i < file.length-1 ; i++){
		 path = ( i == 0 )?path + file[i]:path + '/' + file[i];
		}
		$(this).attr('src',path+'/'+filename.replace('_on.','_off.'));
	 });
});





'use strict';

try {
	this.mode = '';
	
	//제이쿼리가 있으면
	this.jQuery = this.jQuery || undefined;

	if(jQuery) {
		//$ 중복방지
		(function($) {
			//태그객체
			$.tag = {
				wdw : $(window),
				dcmt : $(document),
				html : $('html')
			};

			$(function() {
				var $wrapper = $('#wrapper');
				//여기서부터 코드 작성해주세요

				// 코로나 팝업
				$('html').addClass('pop_open');
				$('.covid_close, .btn_top_popup').on('click', function() {

					var $html = $('html'),
						IsOpen = $html.is('.pop_open');

					if(IsOpen){
						$html.removeClass('pop_open');
						$('.btn_top_popup span').text('팝업열기');
						$('.popup_covid19').slideUp(300);
					} else{
						$html.addClass('pop_open');
						$('.btn_top_popup span').text('팝업닫기');
						$('.popup_covid19').slideDown(300);
					}
				});

				//language
				$('.language .language_btn').on('click', function() {
					var $this = $(this),
						$Parent = $this.parent('.language'),
						IsActive = $Parent.is('.active'),
						$Layer = $this.siblings('.layer');
					if(!IsActive){
						$Parent.addClass('active');
						$this.attr('title', '언어선택 닫기');
						$Layer.fadeIn(200);
					} else{
						$Parent.removeClass('active');
						$this.attr('title', '언어선택 열기');
						$Layer.fadeOut(200);
					};
				});
				$('.language .layer .lang_close').on('click', function() {
					var $this = $(this),
						$Parent = $this.parents('.language'),
						$Layer = $this.parent('.layer'),
						$language_btn = $('.language .language_btn');
					$Layer.fadeOut(200, function() {
						$Parent.removeClass('active');
						$language_btn.attr('title', '언어선택 열기').focus();
					});

				});


				$('.detail_search').on('click', function(){
					var $detailbox = $('.detailbox'),
						IsActive = $detailbox.is('.active');
					if(!IsActive){
						$detailbox.addClass('active').slideDown();
						$wrapper.addClass('search_open');
					} else{
						$detailbox.removeClass('active').slideUp();
						$wrapper.removeClass('search_open');
					};
				});
				$('.detail_close').on('click', function(){
					var $detailbox = $('.detailbox'),
						$detailsearchbtn = $('.detail_search');
					$wrapper.removeClass('search_open');
					$detailbox.removeClass('active').slideUp();
					$detailsearchbtn.focus();
				});

				$('.searchbox .detailbox .itembox .period_btn').on('click', function(){
					var $this = $(this),
						period = $this.attr('data-period'),
						IsActive = $this.is('.active');
					if(!IsActive){
						//$this.addClass('active').siblings('.period_btn').removeClass('active');
						//setDate(period);
					};
				});

				$('.searchbox .detailbox .listbox .itembox.range .sd_input input[type="checkbox"]').on('click', function(){
					var $this = $(this),
						$MyParent = $this.parent('.sd_input'),//다 갖고 와야되니까 상위로 parent
						$OtherParents = $MyParent.siblings('.sd_input'), //상위 형제들
						$OtherCheckbox = $OtherParents.find('input[type="checkbox"]'),
						DATAAll = $this.attr('data-all'),
						AllBtn = $('.searchbox .detailbox .listbox .itembox.range').find('input[type="checkbox"][data-all="y"]'),
						IAmChecked = $this.is(':checked'), //안 씀
						AllBtnIsChecked = AllBtn.is(':checked');
					if(DATAAll=='y'){
						if(AllBtnIsChecked){
							$OtherCheckbox.prop('checked', false);
						} else{
							$OtherCheckbox.prop('checked', false);
						};
					} else{
						if(AllBtnIsChecked){
							AllBtn.prop('checked', false);
						};
					};
				});

				$.tag.wdw.on('responsive.common', function(event) {

					if(event.state == 'wide' || event.state == 'web') {
						mode = 'pc';

					}else if(event.state == 'tablet') {
						mode = 'tablet';
					}else if(event.state == 'phone') {
						mode = 'mobile';
					};
					
					if(event.state == 'wide') {
						
						
					};
					

					//태블릿 || 모바일
					if(event.state == 'tablet' || event.state == 'phone') {
					};
					
				});
			});

			$.tag.dcmt.on('ready.common', function(event) {
			   $.responsive({
					range : {
						wide : {
							horizontal : {
								from : 9999,
								to : 1281
							}
						},
						web : {
							horizontal : {
								from : 1280,
								to : 1001
							}
						},
						tablet : {
							horizontal : {
								from : 1000,
								to : 641
							}
						},
						phone : {
							horizontal : {
								from : 640,
								to : 0
							}
						}
					},
					lowIE : {
						property : ['web']
					},
					inheritClass : false
				});
			});
		})(jQuery);
	}
}catch(e) {
	console.error(e);
}

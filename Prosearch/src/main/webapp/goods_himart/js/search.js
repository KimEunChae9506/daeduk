$(function() {

	var $window = $(window),
	$document = $(document);

	$document.on('ready.responsive', function(event) {
	   $.responsive({
			range : {
				wide : {
					horizontal : {
						from : 9999,
						to : 1201
					}
				},
				web : {
					horizontal : {
						from : 1200,
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
			}
		});
	});
});

$(function() {
	// 검색어 입력시 삭제버튼
	$('#total_search').on('focus', function(){
		console.log('in');
		$(this).parents('.inner_box').addClass('active');
	})

	// 클릭시 입력한 검색어 삭제
	$('.search  .search_clear').on('click', function() {
		document.getElementById("total_search").value = "";
		$('.search').find('.inner_box').removeClass('active');
		return false;
	});

	//달력 열기
	$('.ctgr_group  button.calendar_open').on('click', function() {
		var $this = $(this);
		$('body').addClass('calendar_active');
		$this.addClass('on').next('.calendar_layer').show();
	});
	$('.calendar_layer  button.calendar_close').on('click', function() {
		var $this = $(this);
		$('body').removeClass('calendar_active');
		$this.parents('.calendar_layer').hide();
		$('.ctgr_group button.calendar_open').removeClass('on');
	});

	$('.calendar_wrap .calendar button').on('click', function(){
		var $this = $(this);
		$('.calendar_wrap').removeClass('focus');
		$this.parents('.calendar_wrap').addClass('focus')
	})

	// 모바일시 검색조건 열기
	$('.ctgr_group .group_title button.mobile_btn').on('click', function() {

		var $this = $(this);
		if(!$this.hasClass('on')) {
			$('.ctgr_group .group_title button.mobile_btn').removeClass('on');
			$('.ctgr_group').removeClass('active')
			$this.html('메뉴 닫기').addClass('on').parents('.ctgr_group').addClass('active');
		}else{
			$this.html('메뉴 열기').removeClass('on').parents('.ctgr_group').removeClass('active');
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

	$tab = $(tabid+' .tab_item  li');
	$tab_btn = $(tabid+' .tab_item li a');
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


$(function() {

	$.datepicker.setDefaults({
	    dateFormat: 'yy-mm-dd',
	    prevText: '이전 달',
	    nextText: '다음 달',
	    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
	    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
	    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
	    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
	    showMonthAfterYear: true,
	    yearSuffix: '년'
	});

	var $window = $(window),
	$document = $(document);

	$document.on('ready.responsive', function(event) {
	   $.responsive({
			range : {
				wide : {
					horizontal : {
						from : 9999,
						to : 1201
					}
				},
				web : {
					horizontal : {
						from : 1200,
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
			}
		});
	});
});

$(function() {
	// 검색어 입력시 삭제버튼
	$('#total_search').on('focus', function(){
		console.log('in');
		$(this).parents('.inner_box').addClass('active');
	})

	// 클릭시 입력한 검색어 삭제
	$('.search  .search_clear').on('click', function() {
		document.getElementById("total_search").value = "";
		$('.search').find('.inner_box').removeClass('active');
		return false;
	});

	//달력 열기
	$('.ctgr_group  button.calendar_open').on('click', function() {
		var $this = $(this);
		$('body').addClass('calendar_active');
		$this.addClass('on').next('.calendar_layer').show();
	});
	$('.calendar_layer  button.calendar_close').on('click', function() {
		var $this = $(this);
		$('body').removeClass('calendar_active');
		$this.parents('.calendar_layer').hide();
		$('.ctgr_group button.calendar_open').removeClass('on');
	});

	$('.calendar_wrap .calendar button').on('click', function(){
		var $this = $(this);
		$('.calendar_wrap').removeClass('focus');
		$this.parents('.calendar_wrap').addClass('focus')
	})

	// 모바일시 검색조건 열기
	$('.ctgr_group .group_title button.mobile_btn').on('click', function() {

		var $this = $(this);
		if(!$this.hasClass('on')) {
			$('.ctgr_group .group_title button.mobile_btn').removeClass('on');
			$('.ctgr_group').removeClass('active')
			$this.html('메뉴 닫기').addClass('on').parents('.ctgr_group').addClass('active');
		}else{
			$this.html('메뉴 열기').removeClass('on').parents('.ctgr_group').removeClass('active');
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

	$tab = $(tabid+' .tab_item  li');
	$tab_btn = $(tabid+' .tab_item li a');
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

//인기검색어, 내가찾은 검색어
function doKeyword(query) {
	var searchForm = document.search;
	searchForm.startCount.value = "0";
	searchForm.collection.value = "ALL";
	//searchForm.sort.value = "RANK";
	searchForm.query.value = query;
	doSearch2();
}

// 쿠키값 조회
function getCookie(c_name) {
	var i,x,y,cookies=document.cookie.split(";");
	for (i=0;i<cookies.length;i++) {
		x=cookies[i].substr(0,cookies[i].indexOf("="));
		y=cookies[i].substr(cookies[i].indexOf("=")+1);
		x=x.replace(/^\s+|\s+$/g,"");

		if (x==c_name) {
			return unescape(y);
		}
	}
}

// 쿠키값 설정
function setCookie(c_name,value,exdays) {
	var exdate=new Date();
	exdate.setDate(exdate.getDate() + exdays);
	var c_value=escape(value) + ((exdays==null) ? "" : "; expires="+exdate.toUTCString());
	document.cookie=c_name + "=" + c_value;
}

// 내가 찾은 검색어 조회
function getMyKeyword(keyword, totCount) {
	var MYKEYWORD_COUNT = 6; //내가 찾은 검색어 갯수 + 1
	var myKeyword = getCookie("mykeyword");
	if( myKeyword== null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");

	if( totCount > 0 ) {
		var existsKeyword = false;
		for( var i = 0; i < myKeywords.length; i++) {
			if( myKeywords[i] == keyword) {
				existsKeyword = true;
				break;
			}
		}

		if( !existsKeyword ) {
			myKeywords.push(keyword);
			if( myKeywords.length == MYKEYWORD_COUNT) {
				myKeywords = myKeywords.slice(1,MYKEYWORD_COUNT);
			}
		}
		setCookie("mykeyword", myKeywords.join("^%"), 365);
	}

	showMyKeyword(myKeywords.reverse());
}


// 내가 찾은 검색어 삭제
function removeMyKeyword(keyword) {
	var myKeyword = getCookie("mykeyword");
	if( myKeyword == null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");

	var i = 0;
	while (i < myKeywords.length) {
		if (myKeywords[i] == keyword) {
			myKeywords.splice(i, 1);
		} else {
			i++;
		}
	}

	setCookie("mykeyword", myKeywords.join("^%"), 365);

	showMyKeyword(myKeywords);
}

// 내가 찾은 검색어
function showMyKeyword(myKeywords) {
	var str = "";
	str += "<ul class=\"clearfix\">";
	for( var i = 0; i < myKeywords.length; i++) {
		if( myKeywords[i] == "") continue;
		str += "<li><a href=\"#none\" class=\"log_query\" onClick=\"javascript:doKeyword('"+myKeywords[i]+"');\">"+myKeywords[i]+"</a><a href=\"#none\" class=\"log_delete\" onClick=\"removeMyKeyword('"+myKeywords[i]+"');\">검색어 삭제</button></li>";
	}
	str += "</ul>";
	$("#mykeyword").html(str);
}

//인기 검색어
function getPopkeyword(ranges) {
	var str = "";
	var target		= "popword";
	var range		= ranges;
	var collection  = "_ALL_";
    var datatype   = "text";
    $("a[name='popwords']").removeClass("active");
    if(range == 'D'){
    	$('#popToday').addClass("active");
    }else{
    	$('#popWeek').addClass("active");
    }

	$.ajax({
	  type: "POST",
	  url: "./popword/popword.jsp",
	  dataType: datatype,
	  data: { "target" : target, "range" : range, "collection" : collection , "datatype" : datatype },
	  success: function(text) {
		  text = trim(text);
		  var xml = $.parseXML(text);
		  	if(range == 'D'){
				$('#day').empty();
		    	$('#day').append(str);
		    }else{
		    	$('#week').empty();
		    	$('#week').append(str);
		    }
			str += "	<ol>";
			$(xml).find("Query").each(function(i){
				str += "<li><a href=\"#none\" onclick=\"javascript:doKeyword('" + $(this).text() + "');\">" + $(this).text() + "</a><span class=\"rank_state\">";

				if ($(this).attr("updown") == "U") {
					str += "<span class=\"up\">상승</span>" + $(this).attr("count");
				} else if ($(this).attr("updown") == "D") {
					str += "<span class=\"down\">하락</span>" + $(this).attr("count");
				} else if ($(this).attr("updown") == "N") {
					str += "<span class=\"new\">new</span>";
				} else if ($(this).attr("updown") == "C") {
					str += "<span class=\"same\">동일</span>" + $(this).attr("count");
				}
				str += "</span></li>";
			});
			str += "	</ul>";
			str += "</div>";
			if(range == 'D'){
				$('#day').empty();
		    	$('#day').append(str);
		    }else{
		    	$('#week').empty();
		    	$('#week').append(str);
		    }
	  }
	});
}

// 오타 조회
function getSpell(query) {
	$.ajax({
	  type: "POST",
	  url: "./popword/popword.jsp?target=spell&charset=",
	  dataType: "xml",
	  data: {"query" : query},
	  success: function(xml) {
		if(parseInt($(xml).find("Return").text()) > 0) {
			var str = "<div class=\"resultall\">";

			$(xml).find("Data").each(function(){
				if ($(xml).find("Word").text() != "0" && $(xml).find("Word").text() != query) {
					str += "<span>이것을 찾으셨나요? </span><a href=\"#none\" onClick=\"javascript:doKeyword('"+$(xml).find("Word").text()+"');\">" + $(xml).find("Word").text() + "</a>";
				}
			});

			str += "</div>";

			$("#spell").html(str);
		}
	  }
	});

	return true;
}

// 기간 설정
function fn_setDate(range) {
	var startDate = "";
	var endDate = "";

	var currentDate = new Date();
	var year = currentDate.getFullYear();
	var month = currentDate.getMonth() +1;
	var day = currentDate.getDate();

	if (parseInt(month) < 10) {
		month = "0" + month;
	}

	if (parseInt(day) < 10) {
		day = "0" + day;
	}

	var toDate = year + "." + month + "." + day;
/*
	// 기간 버튼 이미지 초기화
	for (i = 1;i < 5 ;i++) {
		$("#range"+i).attr ("src", "images/btn_term" + i + ".gif");
	}
	*/
	// 기간 버튼 이미지 선택
	if (range == "D") {
		startDate = getAddDay(currentDate, -0);
//		$("#range2").attr ("src", "images/btn_term22.gif");
	} else if (range == "W") {
		startDate = getAddDay(currentDate, -6);
//		$("#range3").attr ("src", "images/btn_term32.gif");
	} else if (range == "M") {
		startDate = getAddDay(currentDate, -29);
//		$("#range4").attr ("src", "images/btn_term42.gif");
	} else {
		startDate = "1970.01.01";
		endDate = toDate;
//		$("#range1").attr ("src", "images/btn_term12.gif");
	}

	if (range != "A" && startDate != "") {
		year = startDate.getFullYear();
		month = startDate.getMonth()+1;
		day = startDate.getDate();

		if (parseInt(month) < 10) {
			month = "0" + month;
		}

		if (parseInt(day) < 10) {
			day = "0" + day;
		}

		startDate = year + "." + month + "." + day;
		endDate = toDate;
	}
	var searchForm = document.search;

	searchForm.startDate.value = startDate;
	searchForm.endDate.value = endDate;
	searchForm.range.value = range;
	searchForm.reQuery.value = "2";
	searchForm.submit();

}

//기간 설정
function fn_setUserDate(range) {
	var startDate = "";
	var endDate = "";

	var currentDate = new Date();
	var year = currentDate.getFullYear();
	var month = currentDate.getMonth() +1;
	var day = currentDate.getDate();

	if (parseInt(month) < 10) {
		month = "0" + month;
	}

	if (parseInt(day) < 10) {
		day = "0" + day;
	}

	var toDate = year + "." + month + "." + day;
	// 기간 버튼 이미지 선택
	if (range == "D") {
		startDate = getAddDay(currentDate, -0);
	} else if (range == "W") {
		startDate = getAddDay(currentDate, -6);
	} else if (range == "M") {
		startDate = getAddDay(currentDate, -29);
	} else {
		startDate = "1970.01.01";
		endDate = toDate;
	}

	if (range != "A" && startDate != "") {
		year = startDate.getFullYear();
		month = startDate.getMonth()+1;
		day = startDate.getDate();

		if (parseInt(month) < 10) {
			month = "0" + month;
		}

		if (parseInt(day) < 10) {
			day = "0" + day;
		}

		startDate = year + "." + month + "." + day;
		endDate = toDate;
	}
	var searchForm = document.user;

	searchForm.startDate.value = startDate;
	searchForm.endDate.value = endDate;
	searchForm.range.value = range;
	searchForm.reQuery.value = "2";
	searchForm.submit();

}

// 날짜 계산
function getAddDay ( targetDate, dayPrefix )
{
	var newDate = new Date( );
	var processTime = targetDate.getTime ( ) + ( parseInt ( dayPrefix ) * 24 * 60 * 60 * 1000 );
	newDate.setTime ( processTime );
	return newDate;
}

// 정렬
function doSorting(sort) {
	var searchForm = document.search;
	searchForm.sort.value = sort;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}
//정렬
function doUserSorting(sort) {
	var searchForm = document.user;
	searchForm.sort.value = sort;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 검색
function doSearch(val) {
	var searchForm;
	if(val != "user"){
		searchForm = document.search;
		searchForm.collection.value = $("#collectionSelectBox").val();
		searchForm.submit();
	}else{
		searchForm = document.user;
		searchForm.collection.value = "custom";
		searchForm.userCustom.value = "";
		var userCustomVal = [];
		if($('input:checkbox[name="userCustomCheck"]').is(":checked") ==  true){
			$('input:checkbox[name="userCustomCheck"]:checked').each(function() {
				userCustomVal.push($(this).val());
			});
		}
		searchForm.userCustomCheck.value = "";
		searchForm.userCustom.value = userCustomVal;
		searchForm.gbn.value = "user";
		searchForm.submit();
	}
}


// 검색페이지 전용 검색
function doSearch2() {
	var searchForm = document.search; 
	searchForm.collection.value = "ALL";
	searchForm.searchField.value = "ALL";
	//searchForm.sort.value = "RANK";
	searchForm.submit();
}

// 컬렉션별 검색
function doCollection(coll) {
	var searchForm = document.search;
	searchForm.collection.value = coll;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}
function doUserCollection(coll) {
	var searchForm = document.user;
	var userCustomVal = [];
	if($('input:checkbox[name="userCustomCheck"]').is(":checked") ==  true){
		$('input:checkbox[name="userCustomCheck"]:checked').each(function() {
			userCustomVal.push($(this).val());
		});
	}
	searchForm.userCustom.value = userCustomVal;
	searchForm.collection.value = coll;
	searchForm.gbn.value = "user";
//	searchForm.reQuery.value = "2";
	searchForm.submit();
}


// 엔터 체크
function pressCheck() {
	if (event.keyCode == 13) {
		if(searchForm.query.value == ""){
			alert("검색어를 입력하십시오.");
			return false;
		}else{
			return doSearch2();
		}
	}else{
		return false;
	}
}

var temp_query = "";

// 결과내 재검색
function checkReSearch() {
	var searchForm = document.search;
	var query = searchForm.query;
	var reQuery = searchForm.reQuery;

	if (document.getElementById("reChk").checked == true) {
		temp_query = query.value;
		reQuery.value = "1";
		query.value = "";
		query.focus();
	} else {
		query.value = trim(temp_query);
		reQuery.value = "";
		temp_query = "";
	}
}

// 페이징
function doPaging(count) {
	var searchForm = document.search;
	searchForm.startCount.value = count;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

//페이징
function doUserPaging(count) {
	var searchForm = document.user;
	searchForm.startCount.value = count;
	var userCustomVal = [];
	if($('input:checkbox[name="userCustomCheck"]').is(":checked") ==  true){
		$('input:checkbox[name="userCustomCheck"]:checked').each(function() {
			userCustomVal.push($(this).val());
		});
	}
	searchForm.gbn.value = "user";
//	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 기간 적용
function doRange() {
	var searchForm = document.search;

	if($("#startDate").val() != "" || $("#endDate").val() != "") {
		if($("#startDate").val() == "") {
			alert("시작일을 입력하세요.");
			$("#startDate").focus();
			return;
		}

		if($("#endDate").val() == "") {
			alert("종료일을 입력하세요.");
			$("#endDate").focus();
			return;
		}

		if(!compareStringNum($("#startDate").val(), $("#endDate").val(), ".")) {
			alert("기간이 올바르지 않습니다. 시작일이 종료일보다 작거나 같도록 하세요.");
			$("#startDate").focus();
			return;
		}
	}

	searchForm.startDate.value = $("#startDate").val();
	searchForm.endDate.value = $("#endDate").val();
	searchForm.range.value = $("#range").val();
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

//기간 적용
function doUserRange() {
	var searchForm = document.user;

	if($("#startDate").val() != "" || $("#endDate").val() != "") {
		if($("#startDate").val() == "") {
			alert("시작일을 입력하세요.");
			$("#startDate").focus();
			return;
		}

		if($("#endDate").val() == "") {
			alert("종료일을 입력하세요.");
			$("#endDate").focus();
			return;
		}

		if(!compareStringNum($("#startDate").val(), $("#endDate").val(), ".")) {
			alert("기간이 올바르지 않습니다. 시작일이 종료일보다 작거나 같도록 하세요.");
			$("#startDate").focus();
			return;
		}
	}
	var userCustomVal = [];
	if($('input:checkbox[name="userCustomCheck"]').is(":checked") ==  true){
		$('input:checkbox[name="userCustomCheck"]:checked').each(function() {
			userCustomVal.push($(this).val());
		});
	}
	searchForm.startDate.value = $("#startDate").val();
	searchForm.endDate.value = $("#endDate").val();
	searchForm.range.value = $("#range").val();
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 영역
function doSearchField(field) {
	var searchForm = document.search;
	searchForm.searchField.value = field;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

//영역
function doUserSearchField(field) {
	alert(field);
	var searchForm = document.user;
	searchForm.searchField.value = field;
	searchForm.reQuery.value = "2";
	var userCustomVal = [];
	if($('input:checkbox[name="userCustomCheck"]').is(":checked") ==  true){
		$('input:checkbox[name="userCustomCheck"]:checked').each(function() {
			userCustomVal.push($(this).val());
		});
	}
	searchForm.submit();
}

// 문자열 숫자 비교
function compareStringNum(str1, str2, repStr) {
	var num1 =  parseInt(replaceAll(str1, repStr, ""));
	var num2 = parseInt(replaceAll(str2, repStr, ""));

	if (num1 > num2) {
		return false;
	} else {
		return true;
	}
}

// Replace All
function replaceAll(str, orgStr, repStr) {
	return str.split(orgStr).join(repStr);
}

// 공백 제거
function trim(str) {
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}


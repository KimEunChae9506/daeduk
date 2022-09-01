<script src="/home/static/homepage/js/jquery.tmpl.js"></script> 
// 상세 검색
function goDetailSearch() {
	var searchForm = document.prosearch; 
	searchForm.mode.value = "detail";
	searchForm.pageNo.value = "1";
	searchForm.sort.value = "";
	searchForm.submit();
}


function detailSearch() {
	var searchForm = document.prosearch;
	if ( searchForm.mode.value == "detail" ) {
		$(".detail_search").css('display','none');	
		searchForm.mode.value = "basic";
		searchForm.title.value = "";
		searchForm.content.value = "";
		searchForm.writer.value = ""; 
 
	}else{
		$(".detail_search").css('display','block') 
		searchForm.mode.value = "detail";
	}
	
}


function goKeywordSearch(query) {
	var searchForm = document.prosearch; 
	searchForm.pageNo.value = "1";
	searchForm.query.value = query;
	searchForm.index.value = "TOTAL";
	searchForm.sort.value = "";
	searchForm.query.value = query;
	goSearch();
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
function getSearchMyKeyword(keyword, totCount) {
	var MYKEYWORD_COUNT = 10; //내가 찾은 검색어 갯수 + 1
	var myKeyword = getCookie("mySearchKeyword");
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
		setCookie("mySearchKeyword", myKeywords.join("^%"), 365);
	}

	searchMyKeyword(myKeywords.reverse());
}

// 내가 찾은 검색어 조회
function getSearchMyKeywords(keyword) {
	var MYKEYWORD_COUNT = 10; //내가 찾은 검색어 갯수 + 1
	var myKeyword = getCookie("mySearchKeyword");
	if( myKeyword== null) {
		myKeyword = "";
	}

	var myKeywords = myKeyword.split("^%");
 
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
	setCookie("mySearchKeyword", myKeywords.join("^%"), 365);

	searchMyKeyword(myKeywords.reverse());
}


// 내가 찾은 검색어 삭제
function removeMyKeyword(keyword) {
	var myKeyword = getCookie("mySearchKeyword");
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

	setCookie("mySearchKeyword", myKeywords.join("^%"), 365);

	searchMyKeyword(myKeywords);
}
 
// 내가 찾은 검색어 
function searchMyKeyword(myKeywords) {
	//var str = "<p class=\"tit\">내가 찾은 검색어</p>";

	str = "";
	
	for( var i = 0; i < myKeywords.length; i++) {
		if( myKeywords[i] == "") continue;

		str += "<li><a href=\"#\" onClick=\"javascript:goKeywordSearch('"+myKeywords[i]+"');\">"+myKeywords[i]+"</a> <a href=\"#\" onClick=\"javascript:removeMyKeyword('"+myKeywords[i]+"');\" class=\"btn_del\"></a></li>";
	}

	//alert(str);
	$("#mySearchKeyword").html(str);
}
 
 
// 기간 설정
function setDate(range) {
	var sDate = "";
	var eDate = "";
	
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

	var toDate = year + "/" + month + "/" + day;
 
	var startDate = "";
	// 기간 버튼 이미지 선택
	if (range == "week1") {
		startDate = getAddDay(currentDate, -6);
	} else if (range == "month1") {
		startDate = getAddDay(currentDate, -29);
	} else if (range == "month3") {
		startDate = getAddDay(currentDate, -87);
	} else if (range == "year1") {
		startDate = getAddDay(currentDate, -365);
	} else if (range == "year3") {
		startDate = getAddDay(currentDate, -1095);
	}  
	
	if (range != "ALL" && startDate != "") { 
		year = startDate.getFullYear();
		month = startDate.getMonth()+1; 
		day = startDate.getDate();

		if (parseInt(month) < 10) {
			month = "0" + month;
		}

		if (parseInt(day) < 10) {
			day = "0" + day;
		}

		startDate = year + "/" + month + "/" + day;				
		endDate = toDate;
	}
	 
	if ( range != "range" ) {
		endDate = toDate;
				
		$("#range").val(range);
		$("#startDate").val(startDate);
		$("#endDate").val(endDate);		
		document.prosearch.submit();		
	}
	
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
function goPage(pageNo) {
    //alert("sort=" + sort);
	var searchForm = document.prosearch;
	searchForm.pageNo.value = pageNo;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}
// 정렬
function goSorting(sort) {
    //alert("sort=" + sort);
	var searchForm = document.prosearch;
	searchForm.sort.value = sort;
	searchForm.reQuery.value = "2";
	searchForm.pageNo.value = "1";
	searchForm.submit();
}

function goDetailInit() {
	
	var searchForm = document.prosearch;
	
		if ( searchForm.title.value != "undefined" ) 
			searchForm.title.value = "";
			
		if ( searchForm.content.value  != "undefined" ) 
			searchForm.content.value = "";
		
		if ( searchForm.writer.value  != "undefined" ) 
			searchForm.writer.value = "";
		
		if ( searchForm.attach.value  != "undefined" ) 
			searchForm.attach.value = "";
		
	
	searchForm.extactstring.value = "";
	searchForm.andstring.value = "";
	searchForm.orstring.value = "";
	searchForm.notstring.value = "";
	 
	
}

// 검색
function goSearch() {
	var searchForm = document.prosearch; 


	if ( searchForm.mode.value != "detail" ) {
	
		if (searchForm.query.value == "") {
			alert("검색어를 입력하세요.");
			searchForm.query.focus();
			return;
		}
	
	
		searchForm.range.value = "ALL";
		searchForm.sDate.value = "";
		searchForm.eDate.value = "";
	
	}
	
	searchForm.range.value = "ALL";
	searchForm.sDate.value = "";
	searchForm.eDate.value = "";

	
	searchForm.pageNo.value = "1";
	searchForm.sfield.value = "";
	searchForm.sort.value = "";
	
	searchForm.submit();
}

// index별 검색
function goIndexSearch(idx) {
	var searchForm = document.prosearch; 
	searchForm.index.value = idx;
	searchForm.pageNo.value = "1";
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

//엔터 체크	
function pressCheckEnter() {   
	if (event.keyCode == 13) {
		var searchForm = document.prosearch;
		
		if ( searchForm.mode.value == "detail") {
			return goDetailSearch();
		} else {
			return goSearch();		
		}
	}else{
		return false;
	}
} 


//엔터 체크	
function pressDetailCheckEnter() {   

	if (event.keyCode == 13) {
		return goDetailSearch();
	}else{
		return false;
	}
} 

// 결과내 재검색
function resultReSearch() {
	var searchForm = document.prosearch;
	var query = searchForm.query;
	var reQuery = searchForm.reQuery;
	var imsi_query = "";
	//alert("reQuery=" + query.value);
	if (document.getElementById("reChk").checked == true) {
		imsi_query = query.value;
		reQuery.value = "1";
		query.value = "";
		query.focus();
	} else {
		query.value = trim(imsi_query);
		reQuery.value = "";
		imsi_query = "";
	}
}
  


// 세부정보 검색
function resultTypeSearch() {
	var searchForm = document.prosearch;
	var checkedValue = ""; 
	var inputElements = document.getElementsByName('typeCode');
	//alert(inputElements.length);
	for(var i=0; inputElements[i]; ++i){
		  if(inputElements[i].checked){
			   if(checkedValue!=""){
				   checkedValue +="|";
			   }
			   checkedValue += inputElements[i].value;
          }
	}
	searchForm.category.value = checkedValue;
}

// 페이징
function goPaging(page) {
	var searchForm = document.prosearch;
	searchForm.pageNo.value = page;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}

// 기간 적용
function goRange() {
	var searchForm = document.prosearch;
	
	if($("#sDate").val() != "" || $("#eDate").val() != "") {
		if($("#sDate").val() == "") {
			alert("시작일을 입력하세요.");
			$("#sDate").focus();
			return;
		}

		if($("#eDate").val() == "") {
			alert("종료일을 입력하세요.");
			$("#eDate").focus();
			return;
		}

		if(!compareStringNum($("#sDate").val(), $("#eDate").val(), ".")) {
			alert("기간이 올바르지 않습니다. 시작일이 종료일보다 작거나 같도록 하세요.");
			$("#sDate").focus();
			return;
		}		
	}

	searchForm.sDate.value = $("#sDate").val();
	searchForm.eDate.value = $("#eDate").val();
	searchForm.range.value = $("#range").val();
	searchForm.reQuery.value = "2";
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
  

// 그룹핑 검색(좌측메뉴)
function doPrefixLeft(targetName) {
	// 대상 오브젝트가 하나이상 체크 되어 있는지
	var targetObjectName = "input[name='" + targetName + "']";
	var len = $(targetObjectName + ":checked").length; // 체크된 객체수
	if (len < 1) {
		alert("선택되지 않았습니다.");
		return false;
	}
	doSearch();
}



// 영역
function goSearchField(field) {
	var searchForm = document.prosearch;
	searchForm.sfield.value = field;
	searchForm.reQuery.value = "2";
	searchForm.submit();
}
 

// Replace All
function replaceAll(str, orgStr, repStr) {
	return str.split(orgStr).join(repStr);
}

// 공백 제거
function trim(str) {
	return str.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
}
function doSearchKeyword(searchkeyword) {
	var searchForm = document.prosearch; 

	searchForm.pageNo.value = "1";
	searchForm.sfield.value = "";
	searchForm.sort.value = "";
	searchForm.query.value = searchkeyword;
	searchForm.submit();
}

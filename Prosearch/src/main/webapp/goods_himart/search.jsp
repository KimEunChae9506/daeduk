<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="./api/common/ProSearch.jsp" %><% request.setCharacterEncoding("UTF-8");%><%

    boolean isDebug = false;
	boolean isParamLog = true;

    int totalViewCount 	= 3;    //통합검색시 출력건수
    int indexViewCount 	= 10;    //더보기시 출력건수

	// 결과 시작 넘버
	String pageNo 			= ProUtils.getRequest(request, "pageNo", "1");			//시작 번호
	String query 			= ProUtils.getRequest(request, "query", "");			//검색어
	String index 			= ProUtils.getRequest(request, "index", "TOTAL");		//index이름
	String reQuery 			= ProUtils.getRequest(request, "reQuery", "");			//결과내 재검색 체크필드
	String realQuery 		= ProUtils.getRequest(request, "realQuery", "");		//실제 검색어
	String mode 			= ProUtils.getRequest(request, "mode", "");				//상세검색(detail)
	String sort 			= ProUtils.getRequest(request, "sort", "SCORE/DESC");	//정렬필드
	String range 			= ProUtils.getRequest(request, "range", "ALL");			//기간관련필드
	String sDate 			= ProUtils.getRequest(request, "sDate", "");			//시작날짜
	String eDate 			= ProUtils.getRequest(request, "eDate", "");			//끝날짜

	String subject 			= ProUtils.getRequest(request, "subject", "");			//제목
	String body 			= ProUtils.getRequest(request, "body", "");				//본문
	String writer 			= ProUtils.getRequest(request, "writer", "");			//작성자
	String attach 			= ProUtils.getRequest(request, "attach", "");			//첨부내용

	String sfield 			= ProUtils.getRequest(request, "sfield", "ALL");		//검색필드
	String pageNum			= ProUtils.getRequest(request, "pageNum", "10");		//페이지 갯수 10개
	
	String andstring		= ProUtils.getRequest(request, "andstring", "");		//상세검색 조건 andstring
	String extactstring		= ProUtils.getRequest(request, "extactstring", "");	//상세검색 조건 extactstring
	String orstring			= ProUtils.getRequest(request, "orstring", "");		//상세검색 조건 orstring
	String notstring		= ProUtils.getRequest(request, "notstring", "");		//상세검색 조건 notstring

	String userid			= ProUtils.getRequest(request, "userid", "");			//사용자 id
	String debug			= ProUtils.getRequest(request, "debug", "");			//debug
	String sign				= ProUtils.getRequest(request, "sign", "");			//sign

	String saleChk			= ProUtils.getRequest(request, "saleChk", "");			//saleChk 품절여부
	String schyn			= ProUtils.getRequest(request, "schyn", "");			//schyn 검색허용여부
	String dispNo			= ProUtils.getRequest(request, "dispNo", "");			//dispNo 검색
	
	//##
	String categoryField     = ProUtils.getRequest(request, "categoryField", "CATEGORY");  //검색할 카테고리 필드 ##
	String cateBoostStr     = ProUtils.getRequest(request, "cateBoostStr", "");			//카테고리부스팅 스트링 ##
	String cateBoostIndex = ProUtils.getRequest(request, "cateBoostIndex", "@prosearch_categoryboost");			//카테고리부스팅 인덱스 ##
	
	if ( debug.equals("yes")) isDebug = true;

	if ( "ALL".equals(range)) {
		sDate = "";
		eDate = "";
	}

	/*******************
	* 조회할 모든 인덱스 세팅 *
	********************/
	String [] indexs = INDEX_LIST;
	
	if ( !index.equals("TOTAL") ) {
		//indexs = new String [] { index } ;
	}

	if (reQuery.equals("1")) {
		realQuery = realQuery + " " + query;
	} else if (!reQuery.equals("2")) {
		realQuery = query;
	}
	
	
	//##
	/*****************************
	* 조회할 모든 인덱스 세팅(카테고리부스팅) *
	*****************************/
	
	if(!realQuery.equals("")){
		ProSearch cateBoostSearch = new ProSearch(isDebug, new String[]{});	//카테고리 부스팅용 Prosearch 생성자 생성. 기본 ProSearch 생성자를 타지만 전체 index리스트를 다 돌지 않게 하기 위해 빈 index리스트 넘겨줌
		
		cateBoostSearch.addIndex( cateBoostIndex );	
		cateBoostSearch.setAlias(cateBoostIndex, cateBoostIndex);
		cateBoostSearch.setSearchField(cateBoostIndex, "word");	
		cateBoostSearch.setFilterQuery(cateBoostIndex, "( useYn:y OR useYn:Y )"); //사용여부 y인 것만
		
		boolean isSearchCate = cateBoostSearch.doSearch(realQuery, new String [] { cateBoostIndex });
		
		MultiSearchResponse.Item sitemCate =  cateBoostSearch.getMultiSearchResponse().getResponses()[0];
		SearchHit [] cateHits =  sitemCate.getResponse().getHits().getHits(); //@prosearch_categoryboost 인덱스에 검색을 던져 받아옴.
		
			for ( SearchHit hit : cateHits ) { 
				String category	   = cateBoostSearch.getFieldData(hit,"category","",false);
				cateBoostStr       = category;
			}
	}
	



    ProSearch proSearch = new ProSearch(isDebug, indexs);
	ProPaging proPaging = null;

    int setViewCount = totalViewCount;
    if ( !index.equals("TOTAL") ) {
        setViewCount = ProUtils.parseInt(pageNum,10);
	}

	//권한이 있으면 해당 변수에 담는다
	String filter = "";

	//상세조건들을 처리하는 변수
	String extendQuery = "";

	//상세조건중 not 을 처리하는 변수
	String notQuery = "";

	
	//필터조건(품절/검색허용여부)		
	if("02".equals(saleChk)){//품절
		if(!"".equals(filter)) {
			filter += " AND ";
		}
		filter += "(SALESTATCD:(02))";
	} 

	if("Y".equals(schyn)){//검색허용
		if(!"".equals(filter)) {
			filter += " AND ";
		}
		filter += "(SCH_EXP_YN:(Y))"; //ex (SCH_EXP_YN:(Y N)) 하면 모든 조건(OR)/ 롯데는 애초 키값이 넘어오지만 나는 선택 하는 거자나
	}
			

	
	
	if ( !"".equals(andstring) ) {
		extendQuery += "(" +  andstring + ")";
	}
	if ( !"".equals(orstring) ) {
		String [] str = orstring.split(" ");
		String imsi = "";
		for ( int idk=0; idk < str.length; idk++) {
			imsi = imsi + str[idk] ;
			if ( idk+1< str.length) imsi = imsi +" | "; //맨 마지막 추가는 | 추가
		}
		extendQuery += "(" +  imsi + ")";
	}

	if ( !"".equals(extactstring) ) {
		extendQuery += "(\"" +  extactstring + "\")";
	}
	if ( !"".equals(notstring) ) {
		notQuery += "(\"" +  notstring + "\")";
	}

	int startNo = ( ProUtils.parseInt(pageNo,1) - 1 ) * setViewCount;

    for (int x=0; x< indexs.length; x++) {


		if ( !"".equals(sort) ) {
			proSearch.setSortField(indexs[x], sort);
		}

		if ( !"TOTAL".equals(index) ) {
			if ( indexs[x].equals(index) ) {
				proSearch.setPage(indexs[x], startNo + "," + indexViewCount);
			} else {
				proSearch.setPage(indexs[x], "0,1");
			}
		} else {
			proSearch.setPage(indexs[x], "0,3");
		}
		
		if ( !"ALL".equals(sfield) ) {
			//sfield = "BRNDNM,GOODSNM,MDLNM";
			proSearch.setSearchField(indexs[x], sfield);
		}

		if ( !"".equals(subject) ) {
			proSearch.setMapValue(indexs[x], "FIELD_SUBJECT", "subject");
			proSearch.setMapValue(indexs[x], "VALUE_SUBJECT", subject);
		}

		if ( !"".equals(body) ) {
			proSearch.setMapValue(indexs[x], "FIELD_BODY", "body");
			proSearch.setMapValue(indexs[x], "VALUE_BODY", body);
		}

		if ( !"".equals(attach) ) {
			proSearch.setMapValue(indexs[x], "FIELD_ATTACH", "attach");
			proSearch.setMapValue(indexs[x], "VALUE_ATTACH", sfield);
		}
		if ( !"".equals(writer) ) {
			proSearch.setMapValue(indexs[x], "FIELD_ATTACH", "writer");
			proSearch.setMapValue(indexs[x], "VALUE_WRITER", sfield);
		}

		//term Query
		if ( !"".equals(index) ) {
			//proSearch.setQueryString(indexs[x], "NONDLEXYN:Y,SALESTATNM:품절");
		}
		
		if ( !"".equals(extendQuery) ) {
			proSearch.setQueryString(indexs[x],extendQuery);
		}

		if ( !"".equals(notQuery) ) {
			proSearch.setNotQueryString(indexs[x],notQuery);
		}

		if ( !"".equals(filter) && indexs[x].equals("goods_himart")) {//##
			proSearch.setFilterQuery(indexs[x],filter);
		}

		if ( !"ALL".equals(range) && !"".equals(sDate) && !"".equals(eDate)) {
			proSearch.setDateRange(indexs[x], "DATES," +  sDate.replaceAll("-","") + "000000" + "," + eDate.replaceAll("-","")+"000000"+"," + "yyyyMMddHHmmss");
		}
		if ( !"TOTAL".equals(index) ) {
			proSearch.setPage(indexs[x], startNo + "," + setViewCount);
		}
		//##
		/**카테고리 부스팅 설정 추가**/
		if ( !"".equals(cateBoostStr) && indexs[x].equals("goods_himart")) {
			proSearch.setCategoryBoost(indexs[x],cateBoostStr); //카테고리 부스팅 인덱스에서 설정한 카테고리 부스팅 쿼리 (ex) 1011000000@tv/냉장고/세탁기/건조기^10000)
			proSearch.setCategoryField(indexs[x],categoryField); //카테고리를 aggrigation 해서 불러올 필드
		}
		
		//그룹핑
		if (indexs[x].equals("goods_himart")) {//##
			proSearch.setAggs(indexs[x],"CATEGORY:ASC");
			proSearch.setTreeAggs(indexs[x],"CATEGORY.keyword/0/1");
		}
	}


	
    boolean isSearch = proSearch.doSearch(realQuery, indexs,index); //서비스별 인기검색어

	if ( isParamLog ) {
		String params = ProUtils.getRequestParamString(request);
		proSearch.setParameterLog("test", params);
	}

	long searchTotalCount = 0L;


	// 전체건수 구하기
	for (int i = 0; i < indexs.length; i++) {
		searchTotalCount += proSearch.getTotalHitsCount(i);
	}
	
	//개별건수 구하기
	if ( !index.equals("TOTAL") ) {
		long searchIndexCount = proSearch.getTotalHitsCount(index);

		int intTotalCount =  (int)searchIndexCount;
		proPaging = new ProPaging(intTotalCount, indexViewCount, Integer.parseInt(pageNo) );
		proPaging.makePaging();

	}

	if ( !realQuery.equals("")) {
		long took = proSearch.getTook(index);
		proSearch.setQueryLog(realQuery,index, took, searchTotalCount,userid);
	}


	// 디버그 메시지 출력
    String debugMessage = proSearch.printDebugView() != null ? proSearch.printDebugView().trim() : "";

	if ( isDebug ) {
		out.println(debugMessage);
	}

    int indexIdx = 0;

    String thisIndexName = "";
	
%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta name="viewport" content="width=device-width, height=device-height, initial-scale=1.0, maximum-scale=2.0, minimum-scale=1.0, user-scalable=yes" />
    <meta name="keywords" content="프로텐" />
    <meta name="description" content="프로텐" />
	<meta http-equiv="Cache-Control" content="no-cache"/>
	<meta http-equiv="Expires" content="Mon, 06 Jan 1990 00:00:01 GMT"/>
	<META HTTP-EQUIV="Expires" CONTENT="-1">
	<meta http-equiv="Pragma" content="no-cache"/>
	
    <link rel="stylesheet" type="text/css" href="css/font.css" />
    <link rel="stylesheet" type="text/css" href="css/neoKeyboard_style.css">
    <link rel="stylesheet" type="text/css" href="css/sub.css" />
    
	<script src="js/jquery-1.12.4.HS-20200709.min.js"></script>
    <script src="js/jquery.responsive.min.js"></script>
    <script src="js/jquery-ui.min.js"></script>
    <script src="js/NeoVirtualKeyboard.min.js"></script>
    <script src="js/program.min.js"></script>
    <script src="js/common.js"></script>
	

	<script type="text/javascript" src="./js/autofix.js"></script>
	<script type="text/javascript" src="./js/autokeyword.js"></script>
	<script type="text/javascript" src="./js/prosearch.js"></script><!--  검색관련 js -->
	
	<!--슬라이더 관련-->
	<link rel="stylesheet" type="text/css" href="./css/nouislider.css">
	<script type="text/javascript" src="./js/desktop_all.min.js"></script>
	<script type="text/javascript" src="./js/nouislider.js"></script>
	<script type="text/javascript" src="./js/moment.js"></script>
	<script type="text/javascript" src="./js/script.js"></script>
	<!-- -->
<!--	<script src="js/search.js" type="text/javascript"></script>  검색관련 js -->
    <script src="./js/sub.js"></script>

    <script>

	$(document).ready(function () {
		$( "#sDate" ).datepicker({
			dateFormat: 'yy-mm-dd',
			changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
			changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
			nextText: '다음 달', // next 아이콘의 툴팁.
			prevText: '이전 달', // prev 아이콘의 툴팁.
			numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
			//stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가.
			yearRange: '1970:c', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
			currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
			closeText: '닫기',  // 닫기 버튼 패널
			showAnim: "slide", //애니메이션을 적용한다.
			showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
			dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
			monthNamesShort: ['01','02','03','04','05','06','07','08','09','10','11','12'] // 월의 한글 형식
		});
		$( "#eDate" ).datepicker({
			dateFormat: 'yy-mm-dd',
			changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
			changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
			nextText: '다음 달', // next 아이콘의 툴팁.
			prevText: '이전 달', // prev 아이콘의 툴팁.
			numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
			//stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가.
			yearRange: '1970:c', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
			currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
			closeText: '닫기',  // 닫기 버튼 패널
			showAnim: "slide", //애니메이션을 적용한다.
			showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
			dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
			monthNamesShort: ['01','02','03','04','05','06','07','08','09','10','11','12'] // 월의 한글 형식
		});

		$('#sDate').click(function(){
			$("input[name=range][value=user]").attr("checked", true);
		});

		$('#eDate').click(function(){
			$("input[name=range][value=user]").attr("checked", true);
		});

		$(".p-input__split").click(function(){ //달력 클릭시 사용자 버튼으로 체크되게
			$("input[name=range]").val('user');
			checkingBt("user");
			//document.prosearch.submit();
		});
	    getSearchMyKeyword("<%=realQuery%>", <%=searchTotalCount%>);

	});







	</script>

	<script>
<%
	if ( !"".equals(query) ) {
%>


	$.ajax({
		type: "POST",
		url: "./api/suggestQuery.jsp",
		dataType: 'json',
		data: { "query" : "<%=query%>"},
		success: function(data) {
			if (  data != null && data.isOk != null && data.isOk ) {
				var str = "";
				var num = 0;
				$.each(data.result, function(v, item) {
					str += "<a href=\"#\" onClick=\"javascript:doSearchKeyword('"+item+"');\">"+item+"</a>&nbsp;";
					num ++;
					if ( num < data.result.length ) {
						str += ",&nbsp;";
					}
				});
				if ( str != "" ) {
					str = "추천검색어 : " + str;
				}
				$("#tagPopword").html(str);
			}
		}
    });

	$.ajax({
		type: "POST",
		url: "./api/spellerQuery.jsp",
		dataType: 'json',
		data: { "query" : "<%=query%>"},
		success: function(data) {
			if (  data != null &&  data.speller != null && data.speller ) {
				var str = "";
				str += "<a href=\"#\" onClick=\"javascript:doSearchKeyword('"+data.speller+"');\"><b>"+data.speller+"</b></a>&nbsp;";
				if ( str != "" ) {
					str = "다음 검색어로 검색 하기 -> " + str;
				}
				$("#popKeyword").html(str);
			}
		}
    });
	

<%
	}
%>



	$.ajax({
		type: "POST",
		url: "./api/popQuery.jsp",
		dataType: 'json',
		data: { "service" : "TOTAL", "type" : "PWD"},
		success: function(data) {
			if ( data != null && data.isOk ) {
				var str = "";
				var num = 0;
				$.each(data.result, function(v, item) {
					str += "<li><a href=\"#\" onClick=\"javascript:doSearchKeyword('"+item.word+"');\">"+item.word+"</a></li>";
					num ++;
				});
				$("#popword_d").append(str);
			}
		}
    });
	
$(document).ready(function () {//이거 써줘야 로드 되면서 append
	$.ajax({
		type: "POST",
		url: "./api/popQuery.jsp",
		dataType: 'json',
		data: { "service" : "TOTAL", "type" : "PWW"},
		success: function(data) {
			if ( data != null && data.isOk ) {
				var str = "";
				var num = 0;
				$.each(data.result, function(v, item) {
					str += "<li><a href=\"#\" onClick=\"javascript:doSearchKeyword('"+item.word+"');\">"+item.word+"</a></li>";
					num ++;
				});
				$("#popword_w").append(str);
			}
		}
    });
});	
	
	</script>
    <title>통합검색</title>
</head>

<body id="sub" class="sub">
<div class="accessibility">
    <a href="#contents">본문 바로가기</a>
</div>
<div id="wrapper<%=mode.equals("detail") ? " search_open" : "" %>">
    <header id="header">
        <div class="header_top">
            <div class="wrap">
                <div class="gnb clearfix">
                    <div class="site_link">
                        <ul class="clearfix">
                            <li class="active"><a href="#" target="_blank" title="새창" rel="noopener noreferrer">통합검색</a></li>
                            <li><a href="http://naver.com" target="_blank" title="새창" rel="noopener noreferrer">링크1</a></li>
                            <li><a href="http://naver.com" target="_blank" title="새창" rel="noopener noreferrer">링크2</a></li>
                            <li><a href="http://naver.com" target="_blank" title="새창" rel="noopener noreferrer">링크3</a></li>
                            <li><a href="http://naver.com" target="_blank" title="새창" rel="noopener noreferrer">링크4</a></li>
                        </ul>
                    </div>
                    <ul class="clearfix">
<!--  
						<li class="list login"><a href="" class="tit">본인인증</a></li>
                        <li class="list sitemap"><a href="" class="tit">전체메뉴</a></li>
-->
                        <li class="list language">
                            <button type="button" class="language_btn tit active" title="언어선택 열기">KOR</button>
                            <div class="layer">
                                <button type="button" class="lang_close" title="언어선택 닫기">KOR</button><!-- 현재 언어 -->
                                <ul>
                                    <li><a href="" target="_blank" title="새창" class="text">ENG</a></li>
                                    <li><a href="" target="_blank" title="새창" class="text">CHI</a></li>
                                    <li><a href="" target="_blank" title="새창" class="text">JAP</a></li>
                                </ul>
                            </div>
                        </li>
<!--                       
					   <li class="list service"><button type="button" class="big service_button tit"><span>맞춤복지서비스</span></button></li>
                        <li class="list home"><button type="button" class="big family_button tit"><span>연천 패밀리 홈</span></button></li> 
-->
                    </ul>
                </div>
            </div>
        </div>
        <div class="header_box">
            <div class="wrap">
                <h1 class="logo">
                    <a href=""> 
                        <span class="ir">프로텐-프로서치</span>
                        <span class="department">통합검색</span>
                    </a>
                </h1>   <!--//logo-->
                <section class="searchbox">
					<form name="prosearch" id="prosearch" action="<%=request.getRequestURI()%>" method="POST" onsubmit="return false;">
						<input type="hidden" name="mode" 	value="<%=mode%>">
						<input type="hidden" name="sort" 	value="<%=sort%>">
						<input type="hidden" name="index" 	value="<%=index%>">
						<input type="hidden" name="sfield" value="<%=sfield%>">
						<input type="hidden" name="reQuery" />
						<input type="hidden" name="realQuery" value="<%=realQuery%>" />
						<input type="hidden" name="pageNo" value="">
						<input type="hidden" name="range" id="range" value="<%=range%>">
						<input type="hidden" name="saleChk" id="saleChk" value="<%=saleChk%>">
						<input type="hidden" name="schyn" id="schyn" value="<%=schyn%>">
						<input type="hidden" name="dispNo" id="dispNo" value="<%=dispNo%>">
						
                        <fieldset>
                            <legend>통합검색</legend>
                            <div class="search clearfix">
                                <h2 class="skip">통합검색</h2>
                                <div class="search_wrap">
                                    <div class="search_inner">
                                        <label for="total_search" class="skip">검색어 입력</label>
                                        <input type="search" name="query" id="query" class="total_search" placeholder="" value="<%=query%>" onKeypress="javascript:pressCheckEnter((event));" autocomplete="off" style="outline-width: 0"/>
                                        <div class="input_box">
                                            <input type="submit" href="#" onClick="javascript:goSearch();" value="검색" class="search_submit" />
                                        </div>  <!--//input_box-->
                                        <button type="button" id="openNVK_sj" class="keyboard">가상키보드</button>
                                    </div>  <!--//search_inner-->
                                </div>  <!--//search_wrap-->
							    <div id="auto" name="auto"  style="display:none;">
								</div> <!--//자동완성-->
                                <div class="popular_keyword clearfix">
                                    <h3 class="title">추천검색어</h3>
                                    <div class="list clearfix" id="tagPopword">
									<!--
                                        <div class="slide"><a href="#" onclick="javascript:goKeywordSearch('프로텐');">#프로텐</a></div> 
                                        <div class="slide"><a href="#" onclick="javascript:goKeywordSearch('검색엔진');">#검색엔진</a></div> 
                                        <div class="slide"><a href="#" onclick="javascript:goKeywordSearch('챗봇');">#챗봇</a></div> 
                                        <div class="slide"><a href="#" onclick="javascript:goKeywordSearch('인공지능');">#인공지능</a></div> 
										-->
                                    </div>
                                </div>  <!--//popular_keyword-->

                                <button type="button" class="detail_search" onclick="javascript:detailMode();">상세검색</button>
                                <div class="research">
									<span class="temp_checkbox">
										<input type="checkbox" name="reChk" id="reChk" onClick="javascript:resultReSearch();" />
									    <label for="reChk">결과내 재검색</label>
									</span> <!--//temp_checkbox-->
                                </div>
                            </div>
                            <div class="detailbox<%=mode.equals("detail") ? " active" : ""%>" style="display:<%=mode.equals("detail") ? " block" : "none"%>">
                                <div class="innerbox">
                                    <ul>
                                        <li class="list list01 period">
                                            <span class="icon">검색기간</span>
                                            <div class="listbox clearfix">
                                                <div class="itembox item01">
													<span class="sd_input">
														<input type="checkbox" onClick="javascript:setDate('ALL');" id="check_001" <%=range.equals("ALL") ? "checked":""%>/>
														<label for="check_001"  >전체기간</label>
													</span>
                                                </div>
                                                <div class="itembox item02">
                                                    <div class="p-date-group textbox">
                                                        <div class="p-form-group p-date" data-date="datepicker">
                                                            <input type="text" name="sDate" id="sDate" title="검색기간 시작일" class="p-input period_start" value="<%=sDate%>" placeholder="yyyy-mm-dd" />
                                                            <div class="p-input__split">
                                                                <button type="button" class="p-input__item p-date__icon">달력 열기</button>
                                                            </div>
                                                        </div>
                                                        <span class="p-form__split">~</span>
                                                        <div class="p-form-group p-date"  data-date="datepicker">
                                                            <input type="text" name="eDate" id="eDate" title="검색기간 종료일" class="p-input period_end" value="<%=eDate%>" placeholder="yyyy-mm-dd" />
                                                            <div class="p-input__split">
                                                                <button type="button" class="p-input__item p-date__icon">달력 열기</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div><!--//.itembox-->
                                                <div class="itembox item03"><!--as-is : 검색을 날릴 시에만 파라미터가 바뀌며 새로고침. to-be : 스크립트로 페이지 그려줌-->
													<button type="button" id = "user" onClick="javascript:setDate('user');checkingBt(this.id);" class="period_btn" >사용자지정</button>
													<button type="button" id = "day" onClick="javascript:setDate('day');checkingBt(this.id);" class="period_btn" >오늘</button>
                                                    <button type="button" id = "week" onClick="javascript:setDate('week');checkingBt(this.id);" class="period_btn" >1주</button>
                                                    <button type="button" id = "month" onClick="javascript:setDate('month');checkingBt(this.id);" class="period_btn">1개월</button>
                                                    <button type="button" id = "year" onClick="javascript:setDate('year');checkingBt(this.id);" class="period_btn">1년</button>
                                                </div><!--//.itembox-->
                                            </div>
                                        </li>
                                        <li class="list list02">
										 <span class="icon">정렬방식</span>
										 <div class="listbox">
											<div class="itembox">
											<span class="sd_input">
														<input type="radio"  id="check_02"  onclick="javascript:goSorting('SCORE/DESC');" value="SCORE/DESC" <%=sort.equals("SCORE/DESC") ? "checked" : ""%> />
														<label for="check_02">정확도순</label>
													</span>
											<span class="sd_input">
														<input type="radio"  id="check_03"  onclick="javascript:goSorting('DATES/DESC');" value="DATES/DESC" <%=sort.equals("DATES/DESC") ? "checked" : ""%>/>
														<label for="check_03">최신순</label>
													</span>
											</div> 
										 
										 </div>
										</li>
                                        <li class="list list03">
                                            <span class="icon">검색범위</span>
                                            <div class="listbox">
                                                <div class="itembox range item01">
													<span class="sd_input">
														<input type="checkbox" data-all="y" id="check_all"  onClick="javascript:fieldAdd('ALL');" value="ALL" <%=sfield.indexOf("ALL") > -1 ? "checked" : ""%>/>
														<label for="check_all">전체</label>
													</span>
                                                    <span class="sd_input">
														<input type="checkbox" id="check_005"  onClick="javascript:fieldAdd('GOODSNM');" value="GOODSNM" <%=sfield.indexOf("GOODSNM") > -1 ? "checked" : ""%>/>
														<label for="check_005">제목</label>
													</span>
                                                    <span class="sd_input">
														<input type="checkbox" id="check_006" onClick="javascript:fieldAdd('MDLNM');" value="MDLNM" <%=sfield.indexOf("MDLNM") > -1 ? "checked" : ""%>/>
														<label for="check_006">모델명</label>
													</span>
                                                    <span class="sd_input">
														<input type="checkbox" id="check_007" onClick="javascript:fieldAdd('BRNDNM');" value="BRNDNM" <%=sfield.indexOf("BRNDNM") > -1? "checked" : ""%>/>
														<label for="check_007">브랜드</label>
													</span>
													<span class="sd_input">
														<input type="checkbox" id="check_008" onClick="javascript:saleChkf();" value="saleChk" <%=saleChk.indexOf("02") > -1 ? "checked" : ""%>/>
														<label for="check_008">품절</label>
													</span>
													<span class="sd_input">
														<input type="checkbox" id="check_009" onClick="javascript:schynChk();" value="schyn" <%=schyn.indexOf("Y") > -1 ? "checked" : ""%>/>
														<label for="check_009">검색허용</label>
													</span>
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <button type="button" class="detail_close" onclick="javascript:closeDetailMode();">닫기</button>
								
                            </div>
                        </fieldset>
                    </form>
                </section><!--//search-->
                <div class="lnb">
                    <nav class="menu">
                        <h2 class="skip">주메뉴</h2>
                        <div class="depth depth1">
                            <ul class="depth_list depth1_list clearfix">
                            	<li class="depth_item depth1_item <%=index.equals("TOTAL") ? "active" : "" %>"><a href="#none" onClick="javascript:goIndexSearch('TOTAL');" class="depth_text depth1_text">통합검색</a></li> 
                            <% for (int i = 0; i < indexs.length; i++) {%>
                                <li class="depth_item depth1_item <%=index.equals(indexs[i]) ? "active" : "" %>"><a href="#none" class="depth_text depth1_text" onClick="javascript:goIndexSearch('<%=indexs[i]%>');"><%=proSearch.getMapValue(indexs[i],"INDEX_VIEW_NAME")%>(<%=proSearch.getTotalHitsCount(i)%>)</a></li>
                            <% } %>
								<!--<li class="depth_item depth1_item>"><a href="#none" onClick="" class="depth_text depth1_text">카테고리</a></li> -->
                            </ul>
                        </div>
                    </nav>
                </div>
            </div><!--//wrap-->
        </div>
    </header>
    <div id="container">
        <div class="wrap clearfix">
            <main class="colgroup">
                <article>
                    <header class="sub_head">
                        <div class="sub_title">
                        	<h2>검색어 <strong>“<%=realQuery%>”</strong>에 대한 전체 <mark>“<%=ProUtils.numberFormat((int)searchTotalCount) %>”</mark>개의 결과를 찾았습니다.</h2>
                        </div>
                    </header>
                    <div id="contents">
<%
			if ( searchTotalCount == 0 ||(!"TOTAL".equals(index) && (int)proSearch.getTotalHitsCount(index) == 0)) {
%>

				<!--  결과없음  -->
				<div class="no-result">
					<h3 class="title"><strong>'<%=query%>'</strong> 에 대한 <strong ><%=proSearch.getMapValue(index,"INDEX_VIEW_NAME")%></strong> 검색 결과가 없습니다.</h3>
					- 단어의 철자가 정확한지 확인해보세요<br />
					- 한글을 영어로 혹은 영어를 한글로 입력했는지 확인해 보세요<br />
					- 검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해보세요
				</div>
<%

			} else {
%>
						<%@ include file="./result/goods_himart.jsp" %>
						<%@ include file="./result/lawcontent.jsp" %>
						<!--<%@ include file="./result/category.jsp" %>-->

				<% if ( !"TOTAL".equals(index) && proPaging != null ) { %>
				<div class="p-pagination">
					<div class="p-page">
					
					<span class="p-page__control">
						<a href="#" class="p-page__link prev-end" onclick="javascript:goPage(<%=proPaging.getFirstPageNo()%>);" ><span class="skip">처음 페이지</span></a>
						<a href="#" class="p-page__link prev" onclick="javascript:goPage(<%=proPaging.getPrevPageNo()%>);" ><span class="skip">이전 페이지</span></a>
					</span>
					
					<span class="p-page__link-group">
<%
					for ( int i=proPaging.getStartPageNo(); i <= proPaging.getEndPageNo(); i++) {
						if(pageNo.equals(String.valueOf(i))){ 
%>
									<strong href="#" title="<%=i%>페이지 이동" class="p-page__link <%=pageNo.equals(String.valueOf(i)) ? "\"active\"" : ""%>" onclick="javascript:goPage(<%=i%>)"><%=i%></strong>
<%
						}else{
%>
									<a href="#" title="<%=i%>페이지 이동" class="p-page__link <%=pageNo.equals(String.valueOf(i)) ? "\"active\"" : ""%>" onclick="javascript:goPage(<%=i%>)"><%=i%></a>
<%
						}
					}
%>
					</span>
								<span class="p-page__control">
									<a href="#" class="p-page__link next" onclick="javascript:goPage(<%=proPaging.getNextPageNo()%>);"><span class="skip" >다음 페이지</span></a>
									<a href="#" class="p-page__link next-end" onclick="javascript:goPage(<%=proPaging.getFinalPageNo()%>);"><span class="skip" >끝 페이지</span></a>
								</span>
					</div>
				</div><!--//page nate -->
<%
				}
			} 
%>
				</div>  <!--//contents-->
                </article>
            </main>
            <div class="side">
                <div class="rank">
                    <h2>인기검색어</h2>
                    <div class="tab_menu">
                        <div class="tab_nav">
                            <a href="#day" class="active">일간</a>
                            <a href="#week">주간</a>
                        </div>
                        <div class="tab_contents">
                            <div id="day" class="tab_content active">
                                <ol id="popword_d" name="popword_d">
                                </ol>
                            </div>
                            <div id="week" class="tab_content">
                                <ol id="popword_w" name="popword_w">
                                </ol>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="my">
                    <h2>내가찾은검색어</h2>
                    <div class="my_content">
                        <ul class="bu clearfix" id="mykeyword">
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- //#container -->
    <footer id="footer">
        <div class="wrap">
            <div class="footer_info">
                <address class="address">
                    <span>[08508] 서울특별시 금천구 가산동 371 6번지 404호 </span>
                    <span class="blue">대표전화 : 02-3289-9020</span>
                </address>  <!--//address-->
                <p class="copyright">Copyright ⓒ 2021 Pro10 </span> ALL RIGHTS RESERVED</p>
            </div>
        </div>  <!--//wrap-->
    </footer>   <!--//#footer-->
</div>  <!-- //#wrapper-->

<script>
    var nvk = new NeoVirtualKeyboard({keyLayout:'KOREAN', keyLayoutType:'SIMPLE'});
    $('#openNVK_sj').click(function() {
        nvk.showKeyboard(this, {
            inputElement: '#query',
            offset: {
                top: 0,
                left: 0
            }
        });
        $('#neoVirtualKeyboard .close').focus();
    });
    $(document).on('click', '#neoVirtualKeyboard .close', function() {
        $('#header .header_box .search .keyboard').focus();
    });
</script>
</body>
<%if ( proSearch != null ) proSearch.close();%>
</html>

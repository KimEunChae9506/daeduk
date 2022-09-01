<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="./api/common/ProSearch.jsp" %><% request.setCharacterEncoding("UTF-8");%><%

    boolean isDebug = false;
	boolean isParamLog = true;

    int totalViewCount 	= 3;    //통합검색시 출력건수
    int indexViewCount 	= 10;    //더보기시 출력건수

	// 결과 시작 넘버
	String pageNo 			= ProUtils.getRequest(request, "pageNo", "1");			//시작 번호
	String query 			= ProUtils.getRequest(request, "query", "");			//검색어
	String index 			= ProUtils.getRequest(request, "index", "doc");		//index이름
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

	String[] chngTags 		= new String[]{};
	long searchTagCount 	= 0;
	
	if ( debug.equals("yes")) isDebug = true;

	if ( "ALL".equals(range)) {
		sDate = "";
		eDate = "";
	}
	
	if (reQuery.equals("1")) {
		realQuery = query + " " +  realQuery;
	} else if (!reQuery.equals("2")) {
		realQuery = query;
	}
	
	/*******************
	* 태그 검색 세팅 *
	********************/

	if(!realQuery.equals("")){
		ProSearch tagSearch = new ProSearch(isDebug);
		tagSearch.addIndex( "tag" );	
		tagSearch.setAlias("tag", "tag");
		tagSearch.setSearchField("tag", "chng_tag_orgnm");	
		
		boolean isSearchTag = tagSearch.doSearch(realQuery, new String [] { "tag" });		
		searchTagCount = tagSearch.getTotalHitsCount("tag"); //태그검색용 카운트
		
		MultiSearchResponse.Item sitemTag =  tagSearch.getMultiSearchResponse().getResponses()[0];
		SearchHit [] tagHits =  sitemTag.getResponse().getHits().getHits(); 
		
			for ( SearchHit hit : tagHits ) { 
				String chngTagNm	= tagSearch.getFieldData(hit,"chng_tag_nm","",false);
				chngTags 			= chngTagNm.split(",");
			}
	}

	/*******************
	* 조회할 모든 인덱스 세팅 *
	********************/
	String [] indices = INDEX_LIST;

	if ( !index.equals("TOTAL") ) {
		indices = new String [] { index } ;
	}

    ProSearch proSearch = new ProSearch(isDebug,indices);
	ProPaging proPaging = null;

    int setViewCount = totalViewCount;
    if ( !index.equals("TOTAL") ) {
        setViewCount = ProUtils.parseInt(pageNum,10);
	}

	//권한이 있으면 해당 변수에 담는다
	String filter = "";
/**
	//상세조건들을 처리하는 변수
	String extendQuery = "";

	//상세조건중 not 을 처리하는 변수
	String notQuery = "";


	if ( !"".equals(andstring) ) {
		extendQuery += "(" +  andstring + ")";
	}
	if ( !"".equals(orstring) ) {
		String [] str = orstring.split(" ");
		String imsi = "";
		for ( int idk=0; idk < str.length; idk++) {
			imsi = imsi + str[idk] ;
			if ( idk+1< str.length) imsi = imsi +" | ";
		}
		extendQuery += "(" +  imsi + ")";
	}

	if ( !"".equals(extactstring) ) {
		extendQuery += "(\"" +  extactstring + "\")";
	}
	if ( !"".equals(notstring) ) {
		notQuery += "(\"" +  notstring + "\")";
	}

**/
	int startNo = ( ProUtils.parseInt(pageNo,1) - 1 ) * setViewCount;

    for (int x=0; x< indices.length; x++) {


		if ( !"".equals(sort) ) {
			proSearch.setSortField(indices[x], sort);
		}

		if ( !"TOTAL".equals(index) ) {
			if ( indices[x].equals(index) ) {
				proSearch.setPage(indices[x], startNo + "," + indexViewCount);
			} else {
				proSearch.setPage(indices[x], "0,1");
			}
		} else {
			proSearch.setPage(indices[x], "0,3");
		}

		if ( !"ALL".equals(sfield) ) {
			proSearch.setSearchField(indices[x], sfield);
		}
		/**
		if ( !"".equals(extendQuery) ) {
			proSearch.setQueryString(indices[x],extendQuery);
		}

		if ( !"".equals(notQuery) ) {
			proSearch.setNotQueryString(indices[x],notQuery);
		}
		**/
		if ( !"".equals(filter) ) {
			proSearch.setFilterQuery(indices[x],filter);
		}

		if ( !"ALL".equals(range) && !"".equals(sDate) && !"".equals(eDate)) {
			proSearch.setDateRange(indices[x], "date," +  sDate.replaceAll("/","") + "000000" + "," + eDate.replaceAll("/","")+"000000"+"," + "yyyyMMddHHmmss");
		}
		if ( !"TOTAL".equals(index) ) {
			proSearch.setPage(indices[x], startNo + "," + setViewCount);
		}
	}

    boolean isSearch = proSearch.doSearch(query, indices);

	if ( isParamLog ) {
		String params = ProUtils.getRequestParamString(request);
		proSearch.setParameterLog("test", params);
	}

	long searchTotalCount = 0L;


	// 전체건수 구하기
	for (int i = 0; i < indices.length; i++) {
		searchTotalCount += proSearch.getTotalHitsCount(i);
	}
	
	//개별건수 구하기
	if ( !index.equals("TOTAL") ) {
		long searchIndexCount = proSearch.getTotalHitsCount(index);

		int intTotalCount =  (int)searchTotalCount;
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
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지식검색포탈</title>
<link rel="stylesheet" type="text/css" href="./css/common.css">
<link rel="stylesheet" type="text/css" href="./css/style.css">
<link rel="stylesheet" type="text/css" href="./css/font.css">
<link rel="stylesheet" href="./css/mcustomscrollbar.css">
<script src="./js/jquery.min.js"></script>
<script src="./js/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="./js/jquery-ui.js"></script>
<script src="./js/common.js"></script>
<script src="./js/prosearch.js"></script>
<script src="./js/program.min.js"></script>
	<!--
	$(document).ready(function () {
		$( "#sDate" ).datepicker({
			dateFormat: 'yy/mm/dd',
			changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
			changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
			nextText: '다음 달', // next 아이콘의 툴팁.
			prevText: '이전 달', // prev 아이콘의 툴팁.
			numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
			//stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가.
			yearRange: '2000:c', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
			currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
			closeText: '닫기',  // 닫기 버튼 패널
			showAnim: "slide", //애니메이션을 적용한다.
			showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
			dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
			monthNamesShort: ['01','02','03','04','05','06','07','08','09','10','11','12'] // 월의 한글 형식
		});
		$( "#eDate" ).datepicker({
			dateFormat: 'yy/mm/dd',
			changeMonth: true, // 월을 바꿀수 있는 셀렉트 박스를 표시한다.
			changeYear: true, // 년을 바꿀 수 있는 셀렉트 박스를 표시한다.
			nextText: '다음 달', // next 아이콘의 툴팁.
			prevText: '이전 달', // prev 아이콘의 툴팁.
			numberOfMonths: [1,1], // 한번에 얼마나 많은 월을 표시할것인가. [2,3] 일 경우, 2(행) x 3(열) = 6개의 월을 표시한다.
			//stepMonths: 3, // next, prev 버튼을 클릭했을때 얼마나 많은 월을 이동하여 표시하는가.
			yearRange: '2000:c', // 년도 선택 셀렉트박스를 현재 년도에서 이전, 이후로 얼마의 범위를 표시할것인가.
			currentText: '오늘 날짜' , // 오늘 날짜로 이동하는 버튼 패널
			closeText: '닫기',  // 닫기 버튼 패널
			showAnim: "slide", //애니메이션을 적용한다.
			showMonthAfterYear: true , // 월, 년순의 셀렉트 박스를 년,월 순으로 바꿔준다.
			dayNamesMin: ['월', '화', '수', '목', '금', '토', '일'], // 요일의 한글 형식.
			monthNamesShort: ['01','02','03','04','05','06','07','08','09','10','11','12'] // 월의 한글 형식
		});

		$('#sDate').click(function(){
			$("input[name=range][value=range]").attr("checked", true);
		});

		$('#eDate').click(function(){
			$("input[name=range][value=range]").attr("checked", true);
		});

	    getSearchMyKeyword("<%=query%>", <%=searchTotalCount%>);

	});






	-->
	</script>

	<script>
<%
	if ( !"".equals(query) ) {
%>
 

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
		data: { "service" : "@ALL", "type" : "PWD"},
		success: function(data) {
			if ( data != null && data.isOk ) {
				var str = "";
				var num = 0;
				$.each(data.result, function(v, item) {
					str += "<li><a href=\"#\" onClick=\"javascript:doSearchKeyword('"+item.word+"');\">"+item.word+"</a></li>";
					num ++;
				});
				$("#popword").append(str);
			}
		}
    });
	</script>
</head>
<body>
<div class="search_wrap">
<form name="prosearch" id="prosearch" action="<%=request.getRequestURI()%>" method="POST" onsubmit="return false;">
		<input type="hidden" name="sort" 	value="<%=sort%>">
		<input type="hidden" name="index" 	value="<%=index%>">
		<input type="hidden" name="sfield" value="<%=sfield%>">
		<input type="hidden" name="realQuery" value="<%=realQuery%>" />
		<input type="hidden" name="reQuery" value="<%=reQuery%>" />
		<input type="hidden" name="pageNo" value="">
        <div class="header">
            <h1 class="logo inline-block">
                <a href="main.html">
                    <img src="./images/svg/logo.svg" alt="로고">
                    <span class="inline-block applesb ms5">기술문서검색포탈</span>
                </a>
            </h1>
            <div class="search_box">
                <div class="search_bar inline-block">
                    <input type="text" name="query" id="query" value="<%=query%>" onKeypress="javascript:pressCheckEnter((event),this);" autocomplete="off" placeholder="검색어를 입력하세요">
                    <span class="sc_icon" onclick="javascript:goSearch()" ></span>
                </div>
                <div class="filter_check inline-block">
                    <div class="type01">
                        <input type="checkbox" name="check01">
                        <label for="check01" class="applesb">업무검색</label>
                    </div>
                    <div class="type02">
                        <input type="checkbox" name="check02">
                        <label for="check02" class="applesb">문서분류</label>
                    </div>
                </div>
            </div>
            <div class="user_if">
                <div class="user_info relative">
                    <span class="level_img">
                        <img src="./images/level01.png">
                    </span>
                    <div class="user_name inline-block">
                        <div class="name"><span class="level">[열심회원]</span><span>홍길동님</span></div>
                    </div>
                    <div class="name_card">
                        <div>
                            <span class="user_level inline-block">
                                <img src="./images/big_level01.png">
                            </span>
                            <dl class="inline-block">
                                <dt class="appleb">홍길동</dt>
                                <dd>열심회원</dd>
                            </dl>
                        </div>
                        <div class="card_btm mt35">
                            <div class="card_list">
                                <span class="inline-block">게시글수</span>
                                <span class="inline-block"><a href="#">10개</a></span>
                            </div>
                            <div class="card_list">
                                <span class="inline-block">댓글</span>
                                <span class="inline-block"><a href="#">30개</a></span>
                            </div>
                        </div>
                        <div class="close_btn"></div>
                    </div>
                </div>
                <div class="logout applesb">로그아웃</div>
            </div>
        </div>
<<<<<<< HEAD
        <div class="top_menu">
            <div class="q_link"></div>
            <div class="center_menu push_tag">
            <%	if(searchTagCount > 0 && !"".equals(realQuery)) {
			%>
                <div class="inline-block applesb">추천 해시태그</div>
                <ul class="inline-block">
                <%
                for(String tag:chngTags){
                %>
                	<li class="inline-block"><a href="#" class="block applesb">#<%= tag %></a></li>
                <%}
                %>
                </ul>
                <%}
                %>
            </div>
        </div>
        <div class="filter_box">
            <div class="filter_inner">
                <div class="filter_tit">문서분류</div>
                <div class="filter_category">
                    <div class="cate_list">
                        <div class="main_category appleb">Q1. 내/외부 문서 구분</div>
                        <div class="sub_category cate_type02">
                            <div class="sub_menu">
                                <div class="sub_tit applesb">내부</div>
                                <ul>
=======
    </header>
    <div id="container">
        <div class="wrap clearfix">
            <main class="colgroup">
                <article>
                    <header class="sub_head">
                       
                        <div class="sub_title">
                            <h2>검색어 <strong>“전자결재”</strong>에 대한 검색결과는 <mark class="em_red"><%=searchTotalCount%></mark>건입니다.</h2>
                        </div>
                    </header>
                    <div id="contents">
                    
                       <%@ include file="./result/view_list.jsp" %>
                       
                        <section class="result result_news">
                            <h3></h3>
                           <div class="resultbox">
                                <div class="title"><a href="#n">전자결재 제목<mark class="em_red">전자결재</mark> 전자결재</a></div>
                                <div class="text">전자결재 내용 <mark class="em_red">전자결재 내용 </mark>전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용 전자결재 내용  ....</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle">첨부파일: 첨부파일.pptx, 첨부파일.pptx</div> 
                                        </li>
                                        
                                    </ul>
                                </div>
								<div class="atch_prvw" id=""  >첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용.... </div>
                                <div class="path">부서명 > 작성자</div>
                            </div>
                            <!--a href="#none" class="more skip">더보기</a-->
                        </section>
                        <!-- 철원 소식 -->
                        <section class="result">
                            <h3>민원서식 (총<mark class="em_red">12</mark>건)</h3>
                            <div class="resultbox">
                                <div class="title"><a href="#n">통신판매업신고</a></div>
                                <div class="text">통신판매업자의 신규 신고 서식</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle icons folder">구매안전서비스 비적용 대상 확인서.hwp</div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="resultbox">
                                <div class="title"><a href="#n">통신판매업신고</a></div>
                                <div class="text">통신판매업자의 신규 신고 서식</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle icons folder">구매안전서비스 비적용 대상 확인서.hwp</div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <div class="resultbox">
                                <div class="title"><a href="#n">통신판매업신고</a></div>
                                <div class="text">통신판매업자의 신규 신고 서식</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle icons folder">구매안전서비스 비적용 대상 확인서.hwp</div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                            <a href="#none" class="more skip">더보기</a>
                        </section>
                        <!--민원서식 -->
                        <section class="result">
                            <h3>웹페이지 (총<mark class="em_red">12</mark>건)</h3>
                            <div class="resultbox">
                                <div class="title"><a href="#n">지역특성</a></div>
                                <div class="text">경기도의 최북단에 위치하고 있으며, 동쪽은 철원읍과 청산면이 포천시와 접하고 있음. 서쪽은 장남면이 파주시와,북쪽은 신서면이 황해도의 금천로 및 강원도 <mark class="em_red"></mark>과 인접해 있으며 … 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력 …</div>
                                <div class="path">[청] 소개 &gt; 지역특성</div>
                            </div>
                            <div class="resultbox">
                                <div class="title"><a href="#n">지역특성</a></div>
                                <div class="text">경기도의 최북단에 위치하고 있으며, 동쪽은 철원읍과 청산면이 포천시와 접하고 있음. 서쪽은 장남면이 파주시와,북쪽은 신서면이 황해도의 금천로 및 강원도 <mark class="em_red"></mark>과 인접해 있으며 … 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력 …</div>
                                <div class="path">[청] 소개 &gt; 지역특성</div>
                            </div>
                            <div class="resultbox">
                                <div class="title"><a href="#n">지역특성</a></div>
                                <div class="text">경기도의 최북단에 위치하고 있으며, 동쪽은 철원읍과 청산면이 포천시와 접하고 있음. 서쪽은 장남면이 파주시와,북쪽은 신서면이 황해도의 금천로 및 강원도 <mark class="em_red"></mark>과 인접해 있으며 … 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력해주세요 3줄이내 출력 …</div>
                                <div class="path">[청] 소개 &gt; 지역특성</div>
                            </div>
                            <a href="#none" class="more skip">더보기</a>

                        </section>
                        <!--웹페이지 -->
                        <section class="result result_board">
                            <h3>게시판</h3>
                            <div class="resultbox">
                                <div class="title"><a href="#n">[<mark class="em_red">철원</mark>소식] <mark class="em_red"> </mark> 마을자치센터 직원 채용공고</a></div>
                                <div class="text">「사단법인 마을」은 <mark class="em_red">철원</mark>군로부터 철원마을자치센터 수탁기관에 선정되었습니다. 주민주도와 민관협치로 마을공동체 활성화와 주민자치를 촉진하여 민주주의 발전에 기여하고 인간존중, 소통과 「사단법인 마을」은 <mark class="em_red"></mark>으로부터 철원마을자치센터 수탁기관에 선정되었습니다. 주민주도와...</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle icons folder">[공고문] 철원마을자치센터직원채용공고[1].hwp</div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="filetitle icons folder">[붙임] 응시원서 개인정보동의서[1].hwp </div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <div class="path">[청] 소개 &gt; 구정소식 &gt; 소식 </div>
                            </div>
                            <div class="resultbox">
                                <div class="title"><a href="#n">[<mark class="em_red">철원</mark>소식] <mark class="em_red"> </mark> 마을자치센터 직원 채용공고</a></div>
                                <div class="text">「사단법인 마을」은 <mark class="em_red">철원</mark>군로부터 철원마을자치센터 수탁기관에 선정되었습니다. 주민주도와 민관협치로 마을공동체 활성화와 주민자치를 촉진하여 민주주의 발전에 기여하고 인간존중, 소통과 「사단법인 마을」은 <mark class="em_red"></mark>으로부터 철원마을자치센터 수탁기관에 선정되었습니다. 주민주도와...</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle icons folder">[공고문] 철원마을자치센터직원채용공고[1].hwp</div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="filetitle icons folder">[붙임] 응시원서 개인정보동의서[1].hwp </div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <div class="path">[청] 소개 &gt; 구정소식 &gt; 소식 </div>
                            </div>
                            <div class="resultbox">
                                <div class="title"><a href="#n">[<mark class="em_red">철원</mark>소식] <mark class="em_red"> </mark> 마을자치센터 직원 채용공고</a></div>
                                <div class="text">「사단법인 마을」은 <mark class="em_red">철원</mark>군로부터 철원마을자치센터 수탁기관에 선정되었습니다. 주민주도와 민관협치로 마을공동체 활성화와 주민자치를 촉진하여 민주주의 발전에 기여하고 인간존중, 소통과 「사단법인 마을」은 <mark class="em_red"></mark>으로부터 철원마을자치센터 수탁기관에 선정되었습니다. 주민주도와...</div>
                                <div class="filebox">
                                    <ul class="bu">
                                        <li>
                                            <div class="filetitle icons folder">[공고문] 철원마을자치센터직원채용공고[1].hwp</div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                        <li>
                                            <div class="filetitle icons folder">[붙임] 응시원서 개인정보동의서[1].hwp </div>
                                            <div class="downbox">
                                                <a href="#n" class="down"><span>HWP파일</span></a>
                                                <a href="#n" class="view">미리보기</a>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <div class="path">[청] 소개 &gt; 구정소식 &gt; 소식 </div>
                            </div>

                            <a href="#none" class="more skip">더보기</a>

                        </section>
                        <!--게시글 -->
                        <section class="result">
                            <h3>멀티미디어 (총 <mark class="em_red">12</mark>건)</h3>
                            <div class="photo">
                                <ul class="clearfix">
>>>>>>> branch 'master' of https://github.com/KimEunChae9506/daeduk.git
                                    <li>
                                        <input type="checkbox">
                                        <span>PCN</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>ECN</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>고객자료 (개발)</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>고객자료 (품질)</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>기술보고서</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>ES Test 결과보고서</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>제품완료보고서</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>제품양산이관</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>원소재 종합결과</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>분석의뢰 결과보고</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>설치완료 보고서</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>L/R 결과 보고서</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="sub_menu mt40">
                                <div class="sub_tit applesb">외부</div>
                                <ul>
                                    <li>
                                        <input type="checkbox">
                                        <span>Seminar</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>협력사 (원소재, 약품, 설비) 공개자료</span>
                                    </li>
                                    <li>
                                        <input type="checkbox">
                                        <span>논문, 특허, 인터넷 강의자료</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="cate_list">
                        <div class="main_category appleb">Q2. 공정연관 구분</div>
                        <div class="sub_category">
                            <ul>
                                <li>
                                    <input type="checkbox">
                                    <span>PCB 외 조립공정</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>PCB 내부 공정</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>Drill Laser</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>적충</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>토큰</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>이미지</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>SR</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>Finish (Soft Gold, ENEPIG, OSP)</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>ABF Lami</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>후공정 (AFM/VRS/RM/ 최종수세)</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>Bump (MBM/SPP/Cioning)</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>Saving Unit</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>AOI</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>BBT</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>기타</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <div class="cate_list">
                        <div class="main_category appleb">Q3. 상세업무 구분</div>
                        <div class="sub_category">
                            <ul>
                                <li>
                                    <input type="checkbox">
                                    <span>원가</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>Capacity</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>공정능력(Capabillity)</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>수율</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>신뢰성</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>고객사 교류회</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>고객CAR</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>원자재</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>기술/시장동향</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>공법</span>
                                </li>
                                <li>
                                    <input type="checkbox">
                                    <span>설비</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="filter_search">검색</div>
                <div class="filter_close">닫기</div>
            </div>
        </div>
        </form>
        <div class="container relative">
            <div class="total_search">
<%				if(searchTotalCount > 0 && !"".equals(realQuery)) {
%>
                <div class="sc_result"><span style="color:#ff5544;"><%=realQuery%></span>에 대한 <span><%=searchTotalCount %>건</span>의 검색 결과가 있습니다.</div>
                <div class="result_btm">
                    <div class="results_list">
                        <ul>
                            <li class="active"><a href="#">전체</a></li>
                            <li><a href="#">Seminar</a></li>
                            <li><a href="#">협력사(원소재, 약품, 설비) 공개자료</a></li>
                            <li><a href="#">논문, 특허, 인터넷 강의자료</a></li>
                            <li><a href="#">원가</a></li>
                            <li><a href="#">Capacity</a></li>
                            <li><a href="#">공정능력 (Capability)</a></li>
                            <li><a href="#">수율</a></li>
                            <li><a href="#">신뢰성</a></li>
                        </ul>
                    </div>

                    	<div class="result_con">
                        <div class="type_op">
                            <span class="list_type1 active">
                                <a href="#type1_con"></a>
                            </span>
                            <span class="list_type2">
                                <a href="#type2_con"></a>
                            </span>
                        </div>
                        <div class="types_con">        
                            <%@ include file="./result/view_list.jsp" %>
                            <%@ include file="./result/view_grid.jsp" %>
                        </div>
                    </div>                 
                </div>
<%				} else if(searchTotalCount <= 0){
%>
                <div class="sc_result"><span style="color:#ff5544;"><%=realQuery%></span>에 대한 검색 결과가 없습니다.</div>
<%				}
%>
                
            </div>
        </div>
        <div class="footer">
            <div class="contact inline-block">
                <span class="inline-block">
                    <a href="#" class="applesb">개인정보취급방침</a>
                </span>
                <span class="inline-block applesb">연락처 안내 : 031-8040-8000</span>
            </div>
            <div class="inline-block ms30">Copyright© DAEDUCK ELECTRONICS Co.,Ltd. All rights reserved.</div>
        </div>
</div>
</body>
</html>
</html>
<%
	if ( proSearch != null ) proSearch.close();
%>
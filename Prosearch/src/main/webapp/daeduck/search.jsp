<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="./api/common/ProSearch.jsp" %><% request.setCharacterEncoding("UTF-8");%><%

    boolean isDebug = true;
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


	if ( debug.equals("yes")) isDebug = true;

	if ( "ALL".equals(range)) {
		sDate = "";
		eDate = "";
	}

	/*******************
	* 조회할 모든 인덱스 세팅 *
	********************/
	String [] indices = INDEX_LIST;

	if ( !index.equals("TOTAL") ) {
		indices = new String [] { index } ;
	}


	if (reQuery.equals("1")) {
		realQuery = query + " " +  realQuery;
	} else if (!reQuery.equals("2")) {
		realQuery = query;
	}

    ProSearch proSearch = new ProSearch(isDebug,indices);
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

		if ( !"".equals(subject) ) {
			proSearch.setMapValue(indices[x], "FIELD_SUBJECT", "subject");
			proSearch.setMapValue(indices[x], "VALUE_SUBJECT", subject);
		}

		if ( !"".equals(body) ) {
			proSearch.setMapValue(indices[x], "FIELD_BODY", "body");
			proSearch.setMapValue(indices[x], "VALUE_BODY", body);
		}

		if ( !"".equals(attach) ) {
			proSearch.setMapValue(indices[x], "FIELD_ATTACH", "attach");
			proSearch.setMapValue(indices[x], "VALUE_ATTACH", sfield);
		}
		if ( !"".equals(writer) ) {
			proSearch.setMapValue(indices[x], "FIELD_ATTACH", "writer");
			proSearch.setMapValue(indices[x], "VALUE_WRITER", sfield);
		}


		if ( !"".equals(extendQuery) ) {
			proSearch.setQueryString(indices[x],extendQuery);
		}

		if ( !"".equals(notQuery) ) {
			proSearch.setNotQueryString(indices[x],notQuery);
		}

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
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, height=device-height, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <meta name="keywords" content="청, 통합검색" />
    <meta name="description" content=" 통합검색에 오신것을 환영합니다." />
    <link rel="stylesheet" type="text/css" href="./css/default.css" />
    <link rel="stylesheet" type="text/css" href="./css/template.css" />
    <link rel="stylesheet" type="text/css" href="./css/font.css" />
    <link rel="stylesheet" type="text/css" href="./css/program.css" />
    <link rel="stylesheet" type="text/css" href="./css/program2.css" />
    <link rel="stylesheet" type="text/css" href="./css/common_layout.css" />
    <script src="./js/jquery-1.12.4.HS-20200709.min.js"></script>
    <script src="./js/program.min.js"></script>
    <script src="./js/common.js"></script>
    <script src="./js/datepicker.js"></script>
    <title>Document</title>
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
<div id="wrapper">
    <header id="header">
        <div class="accessibility">
            <a href="#contents">본문 바로가기</a>
        </div>
       
        <div class="header_box">
            <div class="wrap">
                <h1 class="logo"><a href="/www/index.do"><img src="./images/common/lotte.png"/><span class="department">전자결재 검색</span></a></h1>
                <section class="searchbox">
                    <form name="search" id="search" action="/search/search_page.jsp" method="POST"><!--action 항목이 비어있지 않도록 개발요망!!-->
                        <fieldset>
                            <legend>통합검색</legend>
                            <div class="search clearfix">
                                <h2 class="skip">통합검색</h2>
                                <div class="search_wrap">
                                    <label for="query" class="skip">검색어 입력  </label>
                                    <input type="search" name="query" id="query" class="total_search" value="" autocomplete="off">
<!--                                    <input type="hidden" name="startCount" value="0">-->
<!--                                    <input type="hidden" name="sort" value="DATE">-->
<!--                                    <input type="hidden" name="collection" value="ALL">-->
<!--                                    <input type="hidden" name="range" value="A">-->
<!--                                    <input type="hidden" name="startDate" value="1970.01.01">-->
<!--                                    <input type="hidden" name="endDate" value="2020.11.17">-->
<!--                                    <input type="hidden" name="searchField" value="ALL">-->
<!--                                    <input type="hidden" name="reQuery">-->
<!--                                    <input type="hidden" name="realQuery" value="">-->
                                    <button type="button" class="removetext">검색어 제거</button>
                                    <input type="submit" value="검색" class="search_submit">
                                </div>
                                <button type="button" class="detail_search">상세검색</button>
                                <div class="research">
									<span class="temp_checkbox">
										<input type="checkbox" name="reChk" id="reChk">
									<label for="reChk">결과 내 재검색</label>
									</span>
                                </div>
                                
                            </div>
                            <div class="detailbox">
                                <div class="innerbox">
                                    <ul>
                                        <li class="list list01 period">
                                            <span class="icon">검색기간</span>
                                            <div class="listbox clearfix">
                                                <div class="itembox item01">
													<span class="temp_checkbox">
														<input type="checkbox" id="check_001">
														<label for="check_001">전체기간</label>
													</span>
                                                </div>
                                                <div class="itembox item02">
                                                    <div class="p-date-group textbox">
                                                        <div class="p-form-group p-date" data-date="datepicker" data-date-format="yyyy.mm.dd">
                                                            <input type="text" title="검색기간 시작일" class="p-input period_start" id="period_start" placeholder="yyyy.mm.dd" value="1970.01.01">
                                                            <div class="p-input__split">
                                                                <button type="button" class="p-input__item p-date__icon">달력 열기</button>
                                                            </div>
                                                        </div>
                                                        <span class="p-form__split">~</span>
                                                        <div class="p-form-group p-date" data-date="datepicker" data-date-format="yyyy.mm.dd">
                                                            <input type="text" title="검색기간 종료일" class="p-input period_end" id="period_end" placeholder="yyyy.mm.dd" value="2020.11.17">
                                                            <div class="p-input__split">
                                                                <button type="button" class="p-input__item p-date__icon">달력 열기</button>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div><!--//.itembox-->
                                                <div class="itembox item03">
                                                    <button type="button" class="period_btn active" data-period="w" >1주</button>
                                                    <button type="button" class="period_btn" data-period="m" >1개월</button>
                                                    <button type="button" class="period_btn" data-period="y" >1년</button>
                                                </div><!--//.itembox-->
                                            </div>
                                        </li>
                                        <li class="list list02">
                                            <span class="icon">검색방법</span>
                                            <div class="listbox clearfix">
                                                <div class="itembox item01">
													<span class="temp_checkbox">
														<input type="radio" name="searchMethod" id="check_002" value="include">
														<label for="check_002">하나라도 포함된 결과(OR)</label>
													</span>
                                                </div>
                                                <div class="itembox item02">
													<span class="temp_checkbox">
														<input type="radio" name="searchMethod" id="check_003" value="exclude">
														<label for="check_003">제외하는 단어</label>
													</span>
                                                    <span class="textbox">
														<label for="searchQuery" class="skip">제외하는 단어</label>
														<input type="text" id="searchQuery" class="p-input" name="searchQuery" value="">
													</span>
                                                </div>
                                            </div>
                                        </li>
                                        <li class="list list03">
                                            <span class="icon">검색범위</span>
                                            <div class="listbox">
                                                <div class="itembox range item01">
													<span class="temp_checkbox">
														<input type="checkbox" data-all="y" id="check_004">
														<label for="check_004">전체</label>
													</span>
                                                    <span class="temp_checkbox">
														<input type="checkbox" id="check_005" name="search_field" value="TITLE">
														<label for="check_005">제목</label>
													</span>
                                                    <span class="temp_checkbox">
														<input type="checkbox" id="check_006" name="search_field" value="CONTENT">
														<label for="check_006">내용</label>
													</span>
                                                    <span class="temp_checkbox">
														<input type="checkbox" id="check_007" name="search_field" value="FILE_NM">
														<label for="check_007">파일명</label>
													</span>
                                                    
                                                </div>
                                            </div>
                                        </li>
                                    </ul>
                                </div>
                                <button type="button" class="detail_close">닫기</button>
                            </div>
                        </fieldset>
                    </form>
                </section><!--//search-->
                <div class="lnb">
                    <nav class="menu">
                        <h2 class="skip">주메뉴</h2>
                        <div class="depth depth1">
                            <ul class="depth_list depth1_list clearfix">
                                <li class="depth_item depth1_item  active"><a href="#n" class="depth_text depth1_text">통합검색</a></li>
                                <li class="depth_item depth1_item"><a href="#n" class="depth_text depth1_text">완료함</a></li>
                                <li class="depth_item depth1_item"><a href="#n" class="depth_text depth1_text">참조함</a></li>
                                <li class="depth_item depth1_item"><a href="#n" class="depth_text depth1_text">자동결재함</a></li>
                                <li class="depth_item depth1_item"><a href="#n" class="depth_text depth1_text">보안문서함</a></li>
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
                                    <li>
                                        <a href="#n" title="새창" target="_blank" style="background-image:url('/search/images/common/media_sample.jpg');">
                                            <span class="photo_title">-평화의 소년상 후원의 밤평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" style="background-image:url('/search/images/common/media_sample.jpg');">
                                            <span class="photo_title">-평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" style="background-image:url('/search/images/common/media_sample.jpg');">
                                            <span class="photo_title">-평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" >
                                            <span class="photo_title">-평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" >
                                            <span class="photo_title">-평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" >
                                            <span class="photo_title">-평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" >
                                            <span class="photo_title">-평화의 소년상 후원의 밤</span>
                                            <time datetime="2019-08-15">[2019-08-15]</time>
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#n" title="새창" target="_blank" >
                                            <span class="skip">등록된 이미지가 없습니다.</span>
                                        </a>
                                    </li>

                                </ul>
                            </div>
                            <a href="#none" class="more skip">더보기</a>
                        </section>
                        <!-- 멀티미디어 -->
                        <section class="result result_file">
                            <h3>첨부파일 (총 <mark class="em_red">12</mark>건)</h3>
                            <div class="file_result">
                                <ul class="clearfix">
                                    <li>
                                        <div class="inner">
                                            <span class="extension">HWP</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">HWP</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">HWP</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">PDF</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">HWP</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">HWP</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">HWP</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                    <li>
                                        <div class="inner">
                                            <span class="extension">PDF</span>
                                            <span class="title">철원걷기대회개최계획(안).hwp</span>
                                            <div class="btn_box">
                                                <a href="#n" class="btn down">다운로드</a><a href="#n" class="btn view">미리보기</a>
                                            </div>
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            <a href="#none" class="more skip">더보기</a>
                        </section>
                        <!-- SNS -->
                        <div class="p-pagination">
                            <div class="p-page">
								<span class="p-page__control">
									<a href="#" class="p-page__link prev-end"><span class="skip">처음 페이지</span></a>
									<a href="#" class="p-page__link prev"><span class="skip">이전 10 페이지</span></a>
									<a href="#" class="p-page__link prev-one">이전 페이지</a>
								</span>
                                <span class="p-page__link-group">
									<strong title="현재 1페이지" class="p-page__link">1</strong>
									<a href="" title="2페이지 이동" class="p-page__link active">2</a>
									<a href="" title="3페이지 이동" class="p-page__link">3</a>
									<a href="" title="4페이지 이동" class="p-page__link">4</a>
									<a href="" title="5페이지 이동" class="p-page__link">5</a>
									<a href="" title="6페이지 이동" class="p-page__link">6</a>
									<a href="" title="7페이지 이동" class="p-page__link">7</a>
									<a href="" title="8페이지 이동" class="p-page__link">8</a>
									<a href="" title="9페이지 이동" class="p-page__link">9</a>
									<a href="" title="10페이지 이동" class="p-page__link">110</a>
								</span>
                                <span class="p-page__control">
									<a href="#" class="p-page__link next-one">다음 페이지</a>
									<a href="#" class="p-page__link next"><span class="skip">다음 10 페이지</span></a>
									<a href="#" class="p-page__link next-end"><span class="skip">끝 페이지</span></a>
								</span>
                            </div>
                        </div>
                    </div>
                </article>
            </main>
            <div class="side">
                    <div class="rank">
                        <h2>인기검색어</h2>
                        <div class="tab_menu">
                            <div class="tab_nav">
                                <a href="#day" class="active">일간</a>
                                <a href="#week" class="">주간</a>
                            </div>
                            <div class="tab_contents">
                                <div id="day" class="tab_content active">
                                <ol>
                                    <li>
                                        <a href="#n" >소상공인 새희망자금</a>
                                        <span class="rank_state">
                                            <span class="up">상승</span>12</span>
                                    </li>
                                    <li>
                                        <a href="#n" >폐기물 인터넷 접수</a>
                                        <span class="rank_state"><span class="down">하강</span>1</span>
                                    </li>
                                    <li>
                                        <a href="#n" >대학생 아르바이트</a>
                                        <span class="rank_state"><span class="up">상승</span>3</span>
                                    </li>
                                    <li>
                                        <a href="#n">보일러</a>
                                        <span class="rank_state"><span class="same">0</span>0</span>
                                    </li>
                                    <li>
                                        <a href="#n">소형 폐기물</a>
                                        <span class="rank_state"><span class="new">NEW</span></span>
                                    </li>
                                    <li>
                                        <a href="#n" >소형가전 폐기물</a>
                                        <span class="rank_state"><span class="new">NEW</span></span>
                                    </li>
                                    <li>
                                        <a href="#n">테스트</a>
                                        <span class="rank_state"><span class="new">NEW</span></span>
                                    </li>
                                    <li>
                                        <a href="#n">테스트 검사</a>
                                        <span class="rank_state"><span class="new">NEW</span></span>
                                    </li>
                                    <li>
                                        <a href="#n" >전자결재</a>
                                        <span class="rank_state"><span class="new">NEW</span></span>
                                    </li>
                                    <li>	<a href="#n" >위기가정통합지원센터</a>
                                        <span class="rank_state"><span class="new">NEW</span></span>
                                    </li>
                                </ol>
                            </div>
                                <div id="week" class="tab_content">
                                    <ol>
                                        <li>
                                            <span class="rank">1</span>
                                            <a href="#n" class="txt">실업급여</a>
                                            <span class="rank_state"><span class="up">상승</span>12</span>
                                        </li>
                                        <li>
                                            <span class="rank">2</span>
                                            <a href="#n" class="txt">내일배움카드</a>
                                            <span class="rank_state"><span class="down">하강</span>1</span>
                                        </li>
                                        <li>
                                            <span class="rank">3</span>
                                            <a href="#n" class="txt">고용보험</a>
                                            <span class="rank_state"><span class="up">상승</span>3</span>
                                        </li>
                                        <li>
                                            <span class="rank">4</span>
                                            <a href="#n" class="txt">근로기준법</a>
                                            <span class="rank_state"><span class="new">NEW</span></span>
                                        </li>
                                        <li>
                                            <span class="rank">5</span>
                                            <a href="#n" class="txt">요양원</a>
                                            <span class="rank_state"><span class="new">NEW</span></span>
                                        </li>
                                        <li>
                                            <span class="rank">6</span>
                                            <a href="#n" class="txt">임금체불신고</a>
                                            <span class="rank_state"><span class="new">NEW</span></span>
                                        </li>
                                        <li>
                                            <span class="rank">7</span>
                                            <a href="#n" class="txt">기준중위소득</a>
                                            <span class="rank_state"><span class="same">0</span>0</span>
                                        </li>
                                        <li>
                                            <span class="rank">8</span>
                                            <a href="#n" class="txt">임금체불</a>
                                            <span class="rank_state"><span class="new">NEW</span></span>
                                        </li>
                                        <li>
                                            <span class="rank">9</span>
                                            <a href="#n" class="txt">퇴직금</a>
                                            <span class="rank_state"><span class="new">NEW</span></span>
                                        </li>
                                        <li>
                                            <span class="rank">10</span>
                                            <a href="#n" class="txt">임금</a>
                                            <span class="rank_state"><span class="new">NEW</span></span>
                                        </li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="my">
                        <h2>내가찾은검색어</h2>
                        <div class="my_content">
                            <ul class="clearfix">
                                <li>
                                    <div>
                                        <a href="#n" class="my_query">철원</a>
                                        <a href="#n" class="my_delete">삭제</a>
                                    </div>
                                </li>
                                <li>
                                    <div>
                                        <a href="#n" class="my_query">기간</a>
                                        <a href="#n" class="my_delete">삭제</a>
                                    </div>
                                </li>
                                <li>
                                    <div>
                                        <a href="#n" class="my_query">2020년</a>
                                        <a href="#n" class="my_delete">삭제</a>
                                    </div>
                                </li>
                            </ul>
                        </div>
                    </div>
            </div>

        </div>
    </div>
    <div id="footer">
        <div class="wrap">
            <div class="footer_info">
                <p class="copyright">COPYRIGHTⓒ CHEORWON-GUN. ALL RIGHTS RESERVED. </p>
            </div>
        </div>
    </div>
</div>
</body>
</html>
<%
	if ( proSearch != null ) proSearch.close();
%>
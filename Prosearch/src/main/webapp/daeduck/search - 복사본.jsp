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

    ProSearch proSearch = new ProSearch(isDebug);
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

	<div class="wrap_search">
		<!-- 로고 -->
		<!--div class="top_logo"><img src="images/daedong-logo.jpg" width="150" ></div-->
		
		<!-- 검색 영역 -->
		<div class="search_box">
		<form name="prosearch" id="prosearch" action="<%=request.getRequestURI()%>" method="POST" onsubmit="return false;">
		<input type="hidden" name="mode" 	value="<%=mode%>">
		<input type="hidden" name="sort" 	value="<%=sort%>">
		<input type="hidden" name="index" 	value="<%=index%>">
		<input type="hidden" name="sfield"value="<%=sfield%>">
		<input type="hidden" name="reQuery" />
		<input type="hidden" name="realQuery" value="<%=realQuery%>" />
		<input type="hidden" name="pageNo" value="">
			<div class="main_search">
				<h1>통합검색</h1>
				<input class="input-type" name="query" id="query" type="text" value="<%=query%>" onKeypress="javascript:pressCheckEnter((event),this);" autocomplete="off"/>

				<button class="btn_seach" onClick="javascript:goSearch();">검색</button>
				<label class="futher_search">
					<input type="checkbox" id="reChk" onclick="javascript:resultReSearch();">
					결과내 재검색
				</label>
				<!-- AutoComplete search suggest -->
				<div id="proAutoComplete"></div>
				<a href="#" class="btn_view_detail" onclick="javascript:detailSearch();"> 상세검색</a>
			</div>
			<div class="detail_search" style="<%=mode.equals("detail") ? "display:block" : "display:none"%>">
				<ul>
					<li>
						<span class="name">제목</span>
						<input type="text" class="input-type" name="subject" value="<%=subject%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
						<span class="name">본문</span>
						<input type="text" class="input-type" name="body" value="<%=body%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
					</li>
					<li>
						<span class="name">작성자</span>
						<input type="text" class="input-type" name="writer" value="<%=writer%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
						<span class="name">첨부파일</span>
						<input type="text" class="input-type" name="attach" value="<%=attach%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
					</li>
					<li>
						<span class="name">완전일치구문</span>
						<input type="text" class="input-type" name="extactstring" value="<%=extactstring%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
						<span class="name">모든단어포함</span>
						<input type="text" class="input-type" name="andstring" value="<%=andstring%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
					</li>
					<li>
						<span class="name">일부단어포함</span>
						<input type="text" class="input-type" name="orstring" value="<%=orstring%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
						<span class="name">해당단어제외</span>
						<input type="text" class="input-type" name="notstring" value="<%=notstring%>" onKeypress="javascript:pressDetailCheckEnter((event),this);">
					</li>
					<li>
						<p>
						<button class="btn_search_detail" onClick="javascript:goDetailSearch();">상세검색</button>
						<button class="btn_search_detail" onClick="javascript:goDetailInit();">초기화</button>
						</p>
					</li>
				</ul>
				<ul>
					<li style="text-align:right">
						<button class="btn_seach" onClick="$('.btn_view_detail, .detail_search').toggleClass('view');">닫기</button>
					</li>
				</ul>
				<!-- 물음표 클릭시 나오는 설명창 -->
			</div>
			<!--div class="popKeyword">
			</div-->
		</div><!-- End div // 'search_box' -->

		<div class="search_result">
			<!-- 검색결과 인덱스 -->
			<div class="search_index">
				<div class="box">
					<ul class="category">
						<li><a href="#" onclick="goIndexSearch('TOTAL');" <%= index.equals("TOTAL") ? "class='on'" : "" %> >통합검색 (<span><%=searchTotalCount%></span>)</a></li>
						<%
							for (int i = 0; i < indices.length; i++) {
						%>
							<li><a href="#" onclick="goIndexSearch('<%=indices[i]%>');" <%=index.equals(indices[i]) ? "class='on'" : "" %> ><%=proSearch.getMapValue(indices[i],"INDEX_VIEW_NAME")%> (<span><%=proSearch.getTotalHitsCount(indices[i])%></span>) </a></li>
						<% } %>

						<!--li><a href="javascript:;" onclick="">ECM (<span>100</span>)</a></li>
						<li><a href="javascript:;" onclick="">게시판 (<span>100</span>)</a></li-->
					</ul>
				</div>
				<div class="box">
					<p class="tit">검색범위</p>
					<a onclick="javascript:goSearchField('ALL');" class="range <%=sfield.equals("ALL") ? "on" : ""%>">전체</a>
					<a onclick="javascript:goSearchField('subject');" class="range <%=sfield.equals("subject") ? "on" : ""%>">제목</a>
					<a onclick="javascript:goSearchField('body');" class="range <%=sfield.equals("body") ? "on" : ""%>">본문</a>
					<a onclick="javascript:goSearchField('writer');" class="range <%=sfield.equals("writer") ? "on" : ""%>">작성자</a>
				</div>

				<div class="box">
					<p class="tit">기간</p>
					<a onclick="javascript:setDate('ALL');" class="range <%=range.equals("ALL") ? "on" : ""%>">전체</a>
					<a onclick="javascript:setDate('week1');" class="range <%=range.equals("week1") ? "on" : ""%>">1주</a>
					<a onclick="javascript:setDate('month1');" class="range <%=range.equals("month1") ? "on" : ""%>">1개월</a>
					<a onclick="javascript:setDate('year1');" class="range <%=range.equals("year1") ? "on" : ""%>">1년</a>
					<a onclick="javascript:setDate('year3');" class="range <%=range.equals("year3") ? "on" : ""%>">3년</a>
					<a onclick="javascript:setDate('range');" class="range <%=range.equals("range") ? "on" : ""%>">기간</a>

					&nbsp;시작일 <input type="text" name="sDate" id="sDate" style="border:2px solid #C4C4C4; border-radius:3px;width:100px;" value="<%=sDate%>" readonly="true">
					<br>
					&nbsp;종료일 <input type="text" name="eDate" id="eDate" style="border:2px solid #C4C4C4; border-radius:3px;width:100px;" value="<%=eDate%>" readonly="true">

					<input type="hidden" name="range" id="range" value="<%=range%>">


					<p class="tit"><button class="btn_seach" onClick="javascript:goRange();">적용</button></p>
				</div>
			</form>
			</div><!-- End div // 'search_index' -->
			<div class="popword_index">
				<div class="box">
					<div class="box keyword">
						<p class="tit">인기검색어</p>
						<ul class="popword" id="popword"></ul>
					</div>
				</div>
				<br>
				<div class="box">
					<div class="box keyword">
						<p class="tit">내가찾은검색어</p>
						<ul class="myword" id="mySearchKeyword"></ul>
					</div>
				</div>				
			</div>
			
			<!-- 검색결과 리스트 -->
			<div class="result_list">

				<div class="result_header">
					<div class="header_sort">
						<a href="#" onClick="javascript:goSorting('SCORE/DESC');" class="btn_sort"><%=sort.equals("SCORE/DESC") ? "<b>" : ""%>정확도순 <%=sort.equals("SCORE/DESC") ? "</b>" : ""%></a>
						<a href="#" onClick="javascript:goSorting('DATE/DESC');" class="btn_sort"><%=sort.equals("DATE/DESC") ? "<b>" : ""%>날짜순 <%=sort.equals("DATE/DESC") ? "</b>" : ""%></a>
					</div>
					"<b><%=realQuery%></b>"에 대한 통합 검색 결과는 총 <b><%=ProUtils.numberFormat((int)searchTotalCount)%></b> 건 입니다.
				</div>
	 
<%
			if ( searchTotalCount == 0 ) {
%>

				<!--  결과없음  -->
				<div class="no-result">
					<h3 class="title"><span class="txt_spot">'<%=query%>'</span> 에 대한 검색 결과가 없습니다.</h3>
					- 단어의 철자가 정확한지 확인해보세요<br />
					- 한글을 영어로 혹은 영어를 한글로 입력했는지 확인해 보세요<br />
					- 검색어의 단어 수를 줄이거나, 보다 일반적인 검색어로 다시 검색해보세요
				</div>
<%

			} else {
%>
				<%@ include file="./result/view_exnews.jsp" %>
				<%@ include file="./result/view_exbbs.jsp" %>


<%
				if ( !"TOTAL".equals(index) && proPaging != null ) {

%>
				<div class="paging">
					<a href="#" onclick="javascript:goPage(<%=proPaging.getFirstPageNo()%>);" class="first"></a>
					<a href="#" onclick="javascript:goPage(<%=proPaging.getPrevPageNo()%>);" class="before"></a>
<%
				for ( int i=proPaging.getStartPageNo(); i <= proPaging.getEndPageNo(); i++) {
%>
				<a href="#" onclick="javascript:goPage(<%=i%>)" class=<%=pageNo.equals(String.valueOf(i)) ? "\"on\"" : ""%>><%=i%></a>

<%
				}
%>
					<a href="#" onclick="javascript:goPage(<%=proPaging.getNextPageNo()%>);" class="next"></a>
					<a href="#" onclick="javascript:goPage(<%=proPaging.getFinalPageNo()%>);" class="end"></a>
				</div>

<%
				}
			}
%>

			</div><!-- End div // 'result_list' -->
		</div><!-- End div // 'search_result' -->

	</div><!-- End div // 'wrap_search' -->

</body>
</html>
<%
	if ( proSearch != null ) proSearch.close();
%>
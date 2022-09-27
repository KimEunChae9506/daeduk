<%@ page contentType="text/html; charset=UTF-8"%><%@ include file="./api/common/ProSearch.jsp" %><% request.setCharacterEncoding("UTF-8");%><%

    boolean isDebug = false;
	boolean isParamLog = true;

    int totalViewCount 	= 3;    //통합검색시 출력건수
    int indexViewCount 	= 10;    //더보기시 출력건수

	// 결과 시작 넘버
	String pageNo 			= ProUtils.getRequest(request, "pageNo", "1");			//시작 번호
	String srchParam 		= ProUtils.getRequest(request, "srchParam", "");		//검색어
	String index 			= ProUtils.getRequest(request, "index", "doc");			//index이름
	String reQuery 			= ProUtils.getRequest(request, "reQuery", "");			//결과내 재검색 체크필드
	String realQuery 		= ProUtils.getRequest(request, "realQuery", "");		//실제 검색어
	String mode 			= ProUtils.getRequest(request, "mode", "");				//상세검색(detail)
	String sort 			= ProUtils.getRequest(request, "sort", "SCORE/DESC");	//정렬필드

	String sfield 			= ProUtils.getRequest(request, "sfield", "ALL");		//검색필드
	String pageNum			= ProUtils.getRequest(request, "pageNum", "10");		//페이지 갯수 10개
 
	String userid			= ProUtils.getRequest(request, "userid", "");			//사용자 id
	String debug			= ProUtils.getRequest(request, "debug", "");			//debug
	
	String tagSchYn 		= ProUtils.getRequest(request, "tagSchYn", "y");		//추천태그검색 플래그
	String techDocOpt 		= ProUtils.getRequest(request, "techDocOpt", "");	    //문서분류옵션
		
	if (debug.equals("yes")) isDebug = true;

	/*******************
	*    태그 검색 세팅    *
	********************/

	long searchTagCount = 0L;
	String debugMessage2 = "";
	String chngTagNm 	 = "";		//추천태그명
	
	if("y".equals(tagSchYn)){
		ProSearch tagSearch = new ProSearch(isDebug);
		tagSearch.addIndex("tag");	
		tagSearch.setAlias("tag", "tag");
		tagSearch.setSearchField("tag", "chng_tag_orgnm");	
		
		boolean isSearchTag     = tagSearch.doSearch(srchParam, new String [] { "tag" });	
		searchTagCount 	= tagSearch.getTotalHitsCount("tag"); //태그검색용 카운트
		
		if(searchTagCount > 0){
			MultiSearchResponse.Item sitemTag =  tagSearch.getMultiSearchResponse().getResponses()[0];
			SearchHit [] tagHits =  sitemTag.getResponse().getHits().getHits(); 
			
			for ( SearchHit hit : tagHits ) { 
				chngTagNm = tagSearch.getFieldData(hit,"chng_tag_nm","",false);
			}
		}
				
		debugMessage2 = tagSearch.printDebugView() != null ? tagSearch.printDebugView().trim() : "";
		tagSearch.setQueryLog(chngTagNm,"daeduck", tagSearch.getTook("tag"), searchTagCount,userid);
		
		if ( tagSearch != null ) tagSearch.close();
		
	} else {
		chngTagNm 	 = "";
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
	
	String q1Filter = "";
	String q2Filter = "";
	String q3Filter = "";
	
	//문서분류 필터 검색 조건
	if(!"".equals(techDocOpt)) {
		
		String techOpts[] = techDocOpt.split("\\|");
		
		for (String opts : techOpts) {
			if (opts.contains("GR001") || opts.contains("GR002")) {
				if (!"".equals(q1Filter)) {
					q1Filter += " ";
				}
				q1Filter += opts;
			} else if (opts.contains("GR003")) {
				if (!"".equals(q2Filter)) {
					q2Filter += " ";
				}
				q2Filter += opts;
			} else if (opts.contains("GR004")) {
				if (!"".equals(q3Filter)) {
					q3Filter += " ";
				}
				q3Filter += opts;
			}
		}		
				
		if (!"".equals(q1Filter)) {
			if (!"".equals(filter)) {
				filter += " AND ";
			}
			filter += "(divd_filter.search:"+q1Filter+")";
		}
		
		if (!"".equals(q2Filter)) {
			if (!"".equals(filter)) {
				filter += " AND ";
			}
			filter += "(divd_filter.search:"+q2Filter+")";
		}
		
		if (!"".equals(q3Filter)) {
			if (!"".equals(filter)) {
				filter += " AND ";
			}
			filter += "(divd_filter.search:"+q3Filter+")";
		}

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
		if ( "n".equals(tagSchYn) && !"".equals(chngTagNm)) {
			proSearch.setQueryString(indices[x], "tag_nm:("+chngTagNm+")");
		}
		
		if ( !"".equals(filter) ) {
			proSearch.setFilterQuery(indices[x],filter);
		}
		
		proSearch.setAggs(indices[x], "divd_filter");
			
	}

    boolean isSearch = proSearch.doSearch(srchParam, indices);
	
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

	if ( !srchParam.equals("")) {
		long took = proSearch.getTook(index);
		proSearch.setQueryLog(srchParam,"daeduck", took, searchTotalCount,userid); //대덕전자용 쿼리로그+인기검색어
	}


	// 디버그 메시지 출력
    String debugMessage = proSearch.printDebugView() != null ? proSearch.printDebugView().trim() : "";
    
	if ( isDebug ) {
		out.println(debugMessage);
		out.println("<br>"+debugMessage2);
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

<link rel="stylesheet" href="/resources/css/daeduck/mcustomscrollbar.css">
<script src="/resources/js/search/jquery.min.js"></script>
<script src="/resources/js/search/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="/resources/js/search/jquery-ui.js"></script>
<script src="/resources/js/search/prosearch.js"></script>
<script src="/resources/js/search/autokeyword.js"></script>

<script>
$(document).ready(function () {
	$.ajax({ //검색화면 처음 로딩시 기본 주간 인기검색어
		type: "POST",
		url: "./api/popQuery.jsp",
		dataType: 'json',
		data: { "service" : "daeduck", "type" : "PWW" },
		success: function(data) {
			if ( data != null && data.isOk ) {
				var str = "";
				$.each(data.result, function(v, item) {
					str += "<tr><td class=\"popular_nmb appleb\"><div>"+(v+1)+".</div></td>";
					str += "<td class=\"popular_name\"><div style='cursor:pointer;' onClick=\"javascript:doSearchKeyword('"+item.word+"');\">"+item.word+"</div></td></tr>";
				});
				$("#popWord").html(str);
			}
		}
	});
	
	if(!$(".docFilterTabs").hasClass("active")){
		$(".docFilterTabAll").addClass("active");
	}
	
	$('.docFilterTabAll').click(function () {
		if($(".docFilterTabs").hasClass("active")){
			$(".docFilterTabs").removeClass("active");
		}
	});
	
	$('.docFilterTabs').click(function () {
		if($(".docFilterTabAll").hasClass("active")){
			$(".docFilterTabAll").removeClass("active");
		}
		
	});

});

function popResult(period){
    $('.select_txt').siblings('.menu_list').toggleClass('active');
    var pTxt = period == "PWW" ? "주간" : "월간";
    $('.select_txt').text(pTxt);
    
	$.ajax({
		type: "POST",
		url: "./api/popQuery.jsp",
		dataType: 'json',
		data: { "service" : "daeduck", "type" : period },
		success: function(data) {
			if ( data != null && data.isOk ) {
				var str = "";
				$.each(data.result, function(v, item) {
					str += "<tr><td class=\"popular_nmb appleb\"><div>"+(v+1)+".</div></td>";
					str += "<td class=\"popular_name\"><div style='cursor:pointer;' onClick=\"javascript:doSearchKeyword('"+item.word+"');\">"+item.word+"</div></td></tr>";
				});
				$("#popWord").html(str);
			}
		}
    });
}	

</script>
</head>
<body>
<div class="search_wrap">

        <div class="top_menu">
            <div class="q_link"></div>
            <div class="center_menu push_tag">
<%			if(!"".equals(chngTagNm) && !"".equals(srchParam)) {
%>
                <div class="inline-block applesb">추천 해시태그</div>
                <ul class="inline-block">
                <li class="inline-block"><a href="javascript:addTagSearch();" class="block applesb">#<%= chngTagNm %></a></li>
                </ul>
<%			}
%>
            </div>
        </div>
        <div class="filter_box" style="<%=!"".equals(techDocOpt) ? "display: block;" : ""%>">
            <div class="filter_inner">
                <div class="filter_tit">문서분류</div>
                <div class="filter_category">
                    <div class="cate_list">
                        <div class="main_category appleb">Q1. 내/외부 문서 구분</div>
                        <div class="sub_category cate_type02">
                            <div class="sub_menu">
                                <div class="sub_tit applesb">내부</div>
                                <ul>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001001" value="GR001001" class="<%=techDocOpt.contains("GR001001") ? "checked" : "" %>">
                                        <span>기술보고서</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001002" value="GR001002" class="<%=techDocOpt.contains("GR001002") ? "checked" : "" %>">
                                        <span>ES Test 결과보고서</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001003" value="GR001003" class="<%=techDocOpt.contains("GR001003") ? "checked" : "" %>">
                                        <span>T-ECN 양산평가</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001004" value="GR001004" class="<%=techDocOpt.contains("GR001004") ? "checked" : "" %>">
                                        <span>제품완료보고</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001005" value="GR001005" class="<%=techDocOpt.contains("GR001005") ? "checked" : "" %>">
                                        <span>제품양산이관</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001006" value="GR001006" class="<%=techDocOpt.contains("GR001006") ? "checked" : "" %>">
                                        <span>원소재 종합결과</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR001007" value="GR001007" class="<%=techDocOpt.contains("GR001007") ? "checked" : "" %>">
                                        <span>분석의뢰 결과보고</span>
                                    </li>
                                </ul>
                            </div>
                            <div class="sub_menu mt40">
                                <div class="sub_tit applesb">외부</div>
                                <ul>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR002001" value="GR002001" class="<%=techDocOpt.contains("GR002001") ? "checked" : "" %>">
                                        <span>Seminar</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR002002" value="GR002002" class="<%=techDocOpt.contains("GR002002") ? "checked" : "" %>">
                                        <span>협력사 (원소재, 약품, 설비) 공개자료</span>
                                    </li>
                                    <li>
                                        <input type="checkbox" name="top_tech_doc_divd" id="GR002003" value="GR002003" class="<%=techDocOpt.contains("GR002003") ? "checked" : "" %>">
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
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003001" value="GR003001" class="<%=techDocOpt.contains("GR003001") ? "checked" : "" %>">
                                    <span>PCB 외 조립공정</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003002" value="GR003002" class="<%=techDocOpt.contains("GR003002") ? "checked" : "" %>">
                                    <span>PCB 내부공정(All)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003003" value="GR003003" class="<%=techDocOpt.contains("GR003003") ? "checked" : "" %>">
                                    <span>Drill Laser</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003004" value="GR003004" class="<%=techDocOpt.contains("GR003004") ? "checked" : "" %>">
                                    <span>적충</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003005" value="GR003005" class="<%=techDocOpt.contains("GR003005") ? "checked" : "" %>">
                                    <span>도금</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003006" value="GR003006" class="<%=techDocOpt.contains("GR003006") ? "checked" : "" %>">
                                    <span>이미지</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003007" value="GR003007" class="<%=techDocOpt.contains("GR003007") ? "checked" : "" %>">
                                    <span>SR</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003008" value="GR003008" class="<%=techDocOpt.contains("GR003008") ? "checked" : "" %>">
                                    <span>Finish (Soft Gold, ENEPIG, OSP)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003009" value="GR003009" class="<%=techDocOpt.contains("GR003009") ? "checked" : "" %>">
                                    <span>ABF Lami</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003010" value="GR003010" class="<%=techDocOpt.contains("GR003010") ? "checked" : "" %>">
                                    <span>후공정 (AFM/VRS/RM/ 최종수세)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003011" value="GR003011" class="<%=techDocOpt.contains("GR003011") ? "checked" : "" %>">
                                    <span>Bump (MBM/SPP/Cioning)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003012" value="GR003012" class="<%=techDocOpt.contains("GR003012") ? "checked" : "" %>">
                                    <span>Sawing (Unit)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003013" value="GR003013" class="<%=techDocOpt.contains("GR003013") ? "checked" : "" %>">
                                    <span>AOI</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003014" value="GR003014" class="<%=techDocOpt.contains("GR003014") ? "checked" : "" %>">
                                    <span>BBT</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR003015" value="GR003015" class="<%=techDocOpt.contains("GR003015") ? "checked" : "" %>">
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
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004001" value="GR004001" class="<%=techDocOpt.contains("GR004001") ? "checked" : "" %>">
                                    <span>원가</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004002" value="GR004002" class="<%=techDocOpt.contains("GR004002") ? "checked" : "" %>">
                                    <span>Capacity</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004003" value="GR004003" class="<%=techDocOpt.contains("GR004003") ? "checked" : "" %>">
                                    <span>공정능력 (Capabillity)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004004" value="GR004004" class="<%=techDocOpt.contains("GR004004") ? "checked" : "" %>">
                                    <span>수율</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004005" value="GR004005" class="<%=techDocOpt.contains("GR004005") ? "checked" : "" %>">
                                    <span>신뢰성</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004006" value="GR004006" class="<%=techDocOpt.contains("GR004006") ? "checked" : "" %>">
                                    <span>고객사 교류회</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004007" value="GR004007" class="<%=techDocOpt.contains("GR004007") ? "checked" : "" %>">
                                    <span>고객 CAR</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004008" value="GR004008" class="<%=techDocOpt.contains("GR004008") ? "checked" : "" %>">
                                    <span>원자재</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004009" value="GR004009" class="<%=techDocOpt.contains("GR004009") ? "checked" : "" %>">
                                    <span>기술/시장동향</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004010" value="GR004010" class="<%=techDocOpt.contains("GR004010") ? "checked" : "" %>">
                                    <span>공법</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004011" value="GR004011" class="<%=techDocOpt.contains("GR004011") ? "checked" : "" %>">
                                    <span>설비</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004012" value="GR004012" class="<%=techDocOpt.contains("GR004012") ? "checked" : "" %>">
                                    <span>고객자료 (개발)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004013" value="GR004013" class="<%=techDocOpt.contains("GR004013") ? "checked" : "" %>">
                                    <span>고객자료 (품질)</span>
                                </li>
                                <li>
                                    <input type="checkbox" name="top_tech_doc_divd" id="GR004014" value="GR004014" class="<%=techDocOpt.contains("GR004014") ? "checked" : "" %>">
                                    <span>PCN</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="filter_search" onclick="javascript:funRunSrchEngn();">검색</div>
                <div class="filter_close">닫기</div>
            </div>
        </div>
        <div class="container relative">
            <div class="total_search">
<%				if(searchTotalCount > 0) {
%>
                <div class="sc_result"><span style="color:#ff5544;">"<%=srchParam%>"</span>에 대한 <span><%=searchTotalCount %>건</span>의 검색 결과가 있습니다.</div>
                <div class="result_btm">
                    <div class="results_list">
                        <ul>
                            <li class="docFilterTabAll"><a href="javascript:goGroupSearch('');">전체</a></li>
<%								
							List<Map<String,Object>> aggsList = proSearch.getAggsList(0, "divd_filter", "");		
							
							Collections.sort(aggsList, new Comparator<Map<String,Object>>() {
						        public int compare(Map<String,Object> o1, Map<String,Object> o2) {
						            return extractInt(o1) - extractInt(o2);
						        }

						        int extractInt(Map<String,Object> s) {
						        	String num = "";
						        	if (s.get("key") instanceof String) {
						        		num = s.get("key").toString().replaceAll("\\D", "");
						        	}
						        	return num.isEmpty() ? 0 : Integer.parseInt(num);
						        }
						    });
							
							for(Map<String,Object> map : aggsList){
								String key = (String)map.get("key");	
								String keyStr = key.split("@")[1];
								key = key.split("@")[0];
%>								
							<li class="docFilterTabs <%=(key.equals(techDocOpt)) ? "active" : "" %>"><a href="javascript:goGroupSearch('<%=key %>');"><%=keyStr %></a></li>
<%										
							}
%>
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
                    <!-- 인기검색어 추가 -->
                    <div class="popular_search">
                        <div class="popular_top">
                            <div class="popular_tit appleb">인기검색어</div>
                            <div class="select_box">
                                <div class="select_txt">주간</div>
                                <div class="menu_list absolute">
                                    <div onclick="javascript:popResult('PWW')">주간</div>
                                    <div onclick="javascript:popResult('PWM')">월간</div>
                                </div>
                            </div>
                        </div>
                        <div class="popular_list mt13">
                            <table>
                                <colgroup>
                                    <col style="width:17%;">
                                    <col style="width:83%;">
                                </colgroup>
                                <tbody id="popWord">
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <!-- 인기검색어 추가(e) -->                
                </div>
<%				} 
				if(searchTotalCount <= 0){
%>
                <div class="sc_result"><span style="color:#ff5544;"><%=srchParam%></span>에 대한 검색 결과가 없습니다.</div>
<%				}
%>
                
            </div>
        </div>
        <div class="footer">
            <div class="contact inline-block">
                <span class="inline-block">
                    <a href="javascript:;" class="applesb">개인정보취급방침</a>
                </span>
                <span class="inline-block applesb">연락처 안내 : 031-8040-8000</span>
            </div>
            <div class="inline-block ms30">Copyright© DAEDUCK ELECTRONICS Co.,Ltd. All rights reserved.</div>
        </div>
</div>
</body>
</html>
<%
	if ( proSearch != null ) proSearch.close();
%>
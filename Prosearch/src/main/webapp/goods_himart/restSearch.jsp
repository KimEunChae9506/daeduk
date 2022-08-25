<%@ page contentType="text/json; charset=UTF-8"%><%@ include file="./api/common/ProEncrypt.jsp" %><%@ include file="./api/common/ProSearch.jsp" %><% request.setCharacterEncoding("UTF-8");%><%

	/*
	* subject: 오픈 API Header 페이지
	* @original author: ProTen Moons
	* 검색조건 세팅
	*/

	//html 보안문제 해결
	response.setHeader("Access-Control-Allow-Origin", "*");

	//오타 후 추천 검색어 화면 출력
	String suggestQuery = "";

	//디버깅 보기 설정
	boolean isDebug = false;
	boolean isParamLog = false;

	/*******************
	*검색에 필요한 파라미터 세팅 *
	********************/

	/*  보안 키
	*	설정시 encKey default값을 빈값으로 변경 후 ProSearchProperties.jsp에 TOKEN_KEY값을 실제 사용할 키값 설정
	*   결과 값만 암호화하려면 USE_DATA_ENCRYPT 값을 true로 설정
	*/
	String encKey			= ProUtils.getRequestXSS(request, "encKey", "PROTEN_ENCPT_KEY");	//보안키

	String query			= ProUtils.getRequestXSS(request, "query", "");          //검색어
	String requery			= ProUtils.getRequestXSS(request, "requery", "");        //결과내 검색어

	int pageNo				 = Integer.parseInt(ProUtils.getRequestXSS(request, "page", "1")); // 결과 시작 넘버
	String totalsize		 = ProUtils.getRequestXSS(request, "totalsize", "3"); //다수 인덱스 검색시 각 인덱스의 출력 개수
	String indexsize		 = ProUtils.getRequestXSS(request, "indexsize", "10"); //인덱스별 검색시 출력 개수

	int startNo =  pageNo - 1;

	String index   = ProUtils.getRequestXSS(request, "index", "TOTAL");  //컬렉션이름

	/*  정렬필드
	*	sort=bbs@RANK/DESC;sample_kms:BBB/ASC
	*   sort=TOTAL@RANK,1
	*/
	String sort			= ProUtils.getRequestXSS(request, "sort", "TOTAL@SCORE/DESC");   //정렬필드

	/*  검색필드 정의
	*   sfield=bbs@TITLE,CONTENT;sample_kms:AAA,BBB
	*   sfield=bbs@TITLE/100,CONTENT/50;sample_kms:AAA,BBB
	*   sfield=TOTAL@TITLE,CONTENT
	*/
	String sfield		= ProUtils.getRequestXSS(request, "sfield", "");

	/*  querystring 조건 필드 정의
	*   querystring=bbs@AUTH:(1111 AND 222);edms@(AUTH:1111 OR 222)
	*   querystring=TOTAL@AUTH:(1111 OR 222)
	*/
	String querystring		= ProUtils.getRequestXSS(request, "querystring", "");


	/*  Filter Query 조건 필드 정의
	*   filter=b@[TYPE:111] [SOURCE:111];sample_kms@[TYPE:111] [SOURCE:111]
	*   filter=TOTAL@[TYPE:111] [SOURCE:111]
	*/
	String filter		= ProUtils.getRequestXSS(request, "filter", "");
	filter = ProUtils.replace(filter,"gte",">=");
	filter = ProUtils.replace(filter,"lte","=<");
	filter = ProUtils.replace(filter,"lt","<");
	filter = ProUtils.replace(filter,"gt",">");

	/*  Group By 조건 필드 정의
	*   groupby=sample@ALIAS:1/SC
	*/
	String groupby		= ProUtils.getRequestXSS(request, "group", "");
	//groupby = "CATEGORY";
	/*  기간설정 조건 필드 정의
	*   daterange=sample_kms@DATE,1970/01/01,2030/01/01
	*   daterange=TOTAL@DATE,1970/01/01,2030/01/01
	*/
	String daterange	= ProUtils.getRequestXSS(request, "daterange", "");		//시작날짜

	String range	= ProUtils.getRequestXSS(request, "range", "");				//숫자 비교 연산

	String userId		= ProUtils.getRequestXSS(request, "userId", "");		//권한처리를 위한 값(사이트별 개발필요)
	String isdebug		= ProUtils.getRequestXSS(request, "isDebug", "n");      //디버그 유무
	String isAuth		= ProUtils.getRequestXSS(request, "isAuth", "y");		//검색어 엾을 경우 전체데이터 보기 유무
	String isUidSearch	= ProUtils.getRequestXSS(request, "isUid", "");         //uid search 유무 ?
	String isEncode     = ProUtils.getRequestXSS(request, "isEncode", "y");     //filter operator, prefix 필드에 대해 인코딩 유무, 기본 yes
	String isMulti     	= ProUtils.getRequestXSS(request, "isMulti", "n");      //filter operator, prefix 필드에 대해 인코딩 유무, 기본 yes ?

	String isSuggest = ProUtils.getRequestXSS(request, "isSuggest", "");		//추천검색어 사용여부

	String notQuery = ProUtils.getRequestXSS(request, "notQuery", "");			//제외 검색어

	String pretty = ProUtils.getRequestXSS(request, "pretty", "n");				//json 구조를 보기편하게 확인하기위한 view

	if ( isdebug.equals("y") ) {
		isDebug = true;
	}

	ProSearch proSearch = new ProSearch(isDebug,new String [] { "goods_himart" , "lawcontent"}); //search 객체 생성 //여기 바꿔줌

    ProEncrypts proEncrypts = new ProEncrypts(TOKEN_KEY); //데이터 암호화를 위한 객체 생성

	/*******************
	* 조회할 모든 인덱스 세팅 *
	********************/
	String [] indexs = INDEX_LIST ;//검색대상 모든 index 필수 지정

	if ( !index.equals("TOTAL") ) {
		indexs = new String [] { index };
	}

	/*******************
	*    검색 조건 세팅    *
	*******************/
	String search = query ;

	if ( !query.equals("") && !requery.equals("") ) {
		search = query + " " + requery;
	}

	String[] searchFields = null;

	Hashtable sfieldHash	= ProUtils.getRequestHash(sfield);
	Hashtable sortHash		= ProUtils.getRequestHash(sort);
	Hashtable dateHash		= ProUtils.getRequestHash(daterange);
	Hashtable rangeHash		= ProUtils.getRequestHash(range);
	Hashtable groupbyHash	= ProUtils.getRequestHash(groupby);
	Hashtable notqueryHash	= ProUtils.getRequestHash(notQuery);

	Hashtable querystringHash	= null;
	Hashtable filterHash	= null;

	//filter = ("SCH_EXP_YN:N"); //강제설정
	
	if ( isEncode.equals("y") ) {
		querystringHash = ProUtils.getRequestHash(indexs,querystring);
		filterHash		= ProUtils.getRequestHash(indexs,filter);
	}

	for (int i = 0; i < indexs.length; i++) {

        //출력건수
		if ( indexs.length > 1 ) {
				int numStartNo = startNo * Integer.parseInt(totalsize);
				proSearch.setPage(indexs[i], numStartNo + "," + totalsize );
		} else {
				int numStartNo = startNo * Integer.parseInt(indexsize);
				proSearch.setPage(indexs[i], numStartNo + "," + indexsize );
		}

        //검색어가 없으면 DATE_RANGE 로 전체 데이터 출력
		if ( !query.equals("") ) {
			if ( sortHash.containsKey("TOTAL") ) {
				proSearch.setSortField(indexs[i], (String) sortHash.get("TOTAL") );
			} else if (  sortHash.containsKey(indexs[i]) ) {
				proSearch.setSortField(indexs[i], (String) sortHash.get(indexs[i]) );
			}
		} else {
			if ( isAuth.equals("n") ) {
				if ( sortHash.containsKey("TOTAL") ) {
					proSearch.setSortField(indexs[i],  (String) sortHash.get("TOTAL") );
				} else if (  sortHash.containsKey(indexs[i]) ) {
					proSearch.setSortField(indexs[i], (String) sortHash.get(indexs[i]) );
				}
			} else {

				if ( sortHash.containsKey("TOTAL") ) {
					proSearch.setSortField(indexs[i], (String) sortHash.get("TOTAL") );
				} else if (  sortHash.containsKey(indexs[i]) ) {
					proSearch.setSortField(indexs[i],  (String) sortHash.get(indexs[i]) );
				}
			}
		}

        //sfield 값이 있으면 설정, 없으면 기본검색필드
		if ( sfieldHash.size() > 0 ) {
			if ( sfieldHash.containsKey("TOTAL") ) {
				proSearch.setSearchField(indexs[i], (String) sfieldHash.get("TOTAL") );
			} else if (  sfieldHash.containsKey(indexs[i]) ) {
				proSearch.setSearchField(indexs[i], (String) sfieldHash.get(indexs[i]) );
			}
		}

		//filter 설정
		if ( filterHash.size() > 0 && filterHash != null) {
			if ( filterHash.containsKey("TOTAL") ) {
				//proSearch.setFilterQuery(indexs[i], (String) filterHash.get("TOTAL") );
			} else if ( filterHash.containsKey(indexs[i] ) ){
				proSearch.setFilterQuery(indexs[i], (String) filterHash.get(indexs[i]) );
			} 
		}

		//filter 설정!!!!!!!!!!!!!!!!!!!
		//proSearch.setFilterQuery("goods_himart", ("SCH_EXP_YN:N"));
		//proSearch.setQueryString(indexs[i], "SALESTATCD:02 03,GOODSCMPSNM:일반형" ); -> terms 쿼리를 쓰려면 구분자 쉼표로 2개 이상 쿼리 써야한다. 한 쿼리식 내 value는 공백 구분자로 넣어준다.
		//proSearch.setQueryString(indexs[i], "(02 03)" );
        //querystring 설정
		if ( querystringHash.size() > 0 && querystringHash != null) {
			if ( querystringHash.containsKey("TOTAL") ) {
				//proSearch.setQueryString(indexs[i], (String) querystringHash.get("TOTAL") );
			} else if ( querystringHash.containsKey(indexs[i] ) ){
				proSearch.setQueryString(indexs[i], (String) querystringHash.get(indexs[i]) );
			}
		}

        //기간 설정 , 날짜가 있을때
		if ( dateHash.size() > 0  ) {
			if ( dateHash.containsKey("TOTAL") ) {
				 proSearch.setDateRange(indexs[i], (String) dateHash.get("TOTAL"));
			} else if (  dateHash.containsKey(indexs[i]) ) {
				 proSearch.setDateRange(indexs[i], (String) dateHash.get(indexs[i]) );
			}
		}

        //숫자조회
		if ( rangeHash.size() > 0  ) {
			if ( rangeHash.containsKey("TOTAL") ) {
				 proSearch.setValueRange(indexs[i], (String) rangeHash.get("TOTAL"));
			} else if (  rangeHash.containsKey(indexs[i]) ) {
				 proSearch.setValueRange(indexs[i], (String) rangeHash.get(indexs[i]) );
			}
		}

		//그룹바이
		if ( groupbyHash.size() > 0 ) {
			if ( groupbyHash.containsKey("TOTAL") ) {
				proSearch.setAggs(indexs[i], (String) groupbyHash.get("TOTAL") );
			} else if (  groupbyHash.containsKey(indexs[i]) ) {
				proSearch.setAggs(indexs[i], (String) groupbyHash.get(indexs[i]) );
			}
		}

		//제외쿼리
		if( notqueryHash.size() > 0 ){
			if ( notqueryHash.containsKey("TOTAL") ) {
				proSearch.setNotQueryString(indexs[i], (String) notqueryHash.get("TOTAL") );
			} else if (  notqueryHash.containsKey(indexs[i]) ) {
				proSearch.setNotQueryString(indexs[i], (String) notqueryHash.get(indexs[i]) );
			}
		}
	}

	if ( isParamLog ) {
		String params = ProUtils.getRequestParamString(request);

	}

    boolean isSearch = proSearch.doSearch(search, indexs, index);



%><%-- 검색 조회에 관련된 jsp Include --%><%@ include file="./api/searchResult.jsp" %>
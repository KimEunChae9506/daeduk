<% request.setCharacterEncoding("UTF-8");%><%

	int searchTotalCount = 0; 
	
	Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
 
	 // 전체건수 구하기
	if ( index.equals("TOTAL") ) {
		for (int i = 0; i < indexs.length; i++) {
		   searchTotalCount += (int)proSearch.getTotalHitsCount(i);
		}
	} else { 
	  //개별건수 구하기
		searchTotalCount = (int)proSearch.getTotalHitsCount(0); 
		int intTotalCount =  (int)searchTotalCount;
	}
	
	if ( !search.equals("")) {
		long took = proSearch.getTook(index);
		//proSearch.setQueryLog(search,index, took, searchTotalCount,userId);
	}

	// 디버그 메시지 출력
    String debugMessage = proSearch.printDebugView() != null ? proSearch.printDebugView().trim() : "";
	if ( isDebug ) {
		//logger.info(debugMessage);
		mainMap.put("Debug",debugMessage);			
	}
	
	mainMap.put("isOk",isSearch);
	
	String errorMessage = proSearch.printDebugView("error") != null ? proSearch.printDebugView("error").trim() : "";
	if ( !isSearch  ) {
		mainMap.put("returnMsg","[ERROR] " + errorMessage);
	} else {
		if ( !"".equals(errorMessage)) 
			mainMap.put("returnMsg","[WARN] " + errorMessage);
		else 
			mainMap.put("returnMsg","");
				
	}
	
	mainMap.put("query",query);
	mainMap.put("index",index);	
	mainMap.put("pageNo",pageNo); 
	mainMap.put("totalCount",searchTotalCount);
	
	
    if( "y".equals(isSuggest) ) {
    	suggestQuery = proSearch.callSuggestQuery(search);
		mainMap.put("suggestQuery",suggestQuery);
    }
	
	List<Map<String,Object>> resultListMain = new LinkedList<>();
	
	
	for ( String thisIndexName : indexs ) {
		
			Map<String,Object> indexList = new LinkedHashMap<>();
			int indexIdx = proSearch.getMultiIdx(thisIndexName);
			long count = proSearch.getHitsCount(indexIdx);
			long thisIndexCount = proSearch.getTotalHitsCount(indexIdx);
			indexList.put("indexName" , thisIndexName); 
			indexList.put("indexGetCount" , count); 
			indexList.put("indexTotalCount" , thisIndexCount); 
			
			if ( !"".equals(proSearch.getMapValue(thisIndexName, "AGGREGATION") )  ) {

				List<Map<String,Object>> groupList = new LinkedList<>();
				List<Map<String,Object>> categoryList = new LinkedList<>();
				
				String [] aggs = ProUtils.split(proSearch.getMapValue(thisIndexName, "AGGREGATION"),",");
				
				if ( aggs.length == 1 ) {
					categoryList = proSearch.getAggsList(indexIdx, aggs[0],"");
				} else if ( aggs.length == 2 ) {
					categoryList = proSearch.getAggsList(indexIdx, aggs[0],aggs[1]);
				}
				
				for ( Map<String,Object> map :  categoryList ) {
					String mapKey = (String) map.get("key"); 				
					long mapCount = (long) map.get("count")  ;
					
					Map<String,Object> resultMap = new LinkedHashMap<>();
					
					//데이터 암호화
					if(USE_DATA_ENCRYPT){
						String encValue = proEncrypts.returnEncryptCode(mapKey.toString());
						if(TOKEN_KEY.equals(encKey)){
							encValue = proEncrypts.returnDecryptCode(encValue);
						}
						resultMap.put("name" , encValue);
					}else{
						resultMap.put("name" , mapKey);
					}
					resultMap.put("count" , mapCount);
					
					groupList.add(resultMap);
				}
				
				indexList.put("groups" , groupList);				
			}			

			List<Map<String,Object>> itemList = new LinkedList<>();
			if ( thisIndexCount > 0 ) {
				MultiSearchResponse.Item [] items = proSearch.getMultiSearchResponse().getResponses();
				MultiSearchResponse.Item item = null;
				if ( items.length == 1 ) {
					item  = proSearch.getMultiSearchResponse().getResponses()[0];
				} else {
					item  = proSearch.getMultiSearchResponse().getResponses()[indexIdx];
				}
				
				SearchHit [] hits =  item.getResponse().getHits().getHits();
				
				for ( SearchHit hit : hits ) { 
				
					Map<String,Object> resultMap = new LinkedHashMap<>();
					String [] highlightFields 	= ProUtils.split(proSearch.getMapValue(thisIndexName,"HIGHLIGHT"),","); 
						
					List<String> arrays =  Arrays.asList(highlightFields);
					
					//hit.getSourceAsMap() 에서 출력순서가 바뀌므로 새로 정렬함.
					LinkedHashMap<String, Object> resultListMap = ProUtils.setCustomSortAsMap(hit.getSourceAsMap(), PRIORITY_SORT);
					
					for (Map.Entry<String, Object> entry: resultListMap.entrySet()) {
						
						String fieldName = (String) entry.getKey();
						Object value = entry.getValue();
						
						if ( arrays.contains(fieldName) ) {
							
								Map<String, HighlightField> _highMap = hit.getHighlightFields();
								HighlightField hlObj = _highMap.get(fieldName);

								if(hlObj !=null) {
									Text[] objss =hlObj.getFragments();
									if(objss!=null && objss.length>0) {
										value = objss[0].toString();
									}else {
										value = String.valueOf(resultListMap.getOrDefault(fieldName,""));
									}
								}else {
									value = String.valueOf(resultListMap.getOrDefault(fieldName,""));
								}
						} else {
							value = String.valueOf(resultListMap.getOrDefault(fieldName,""));					
						}
						
						//데이터 암호화
						if(USE_DATA_ENCRYPT){
							String encValue = proEncrypts.returnEncryptCode(value.toString());
							if(TOKEN_KEY.equals(encKey)){
								encValue = proEncrypts.returnDecryptCode(encValue);
							}
							resultMap.put(fieldName, encValue);
						}else{
							resultMap.put(fieldName, value);
						}
					}

					if ( !"".equals( proSearch.getMapValue(thisIndexName ,"NEST_SEARCH") ) ) {
                        Object nestedFiles = proSearch.getNestedData(hit,"FILE_INFO","REAL_FILE_NM","REAL_FILE_NM:REAL_FILE_NM,FILE_PATH:FILE_PATH","",false,"0");
                        resultMap.put("FILE_INFO" , nestedFiles);
					}

					itemList.add(resultMap);
				}
			}
			indexList.put("items" , itemList);
	
			resultListMain.add(indexList);
	}
	
	mainMap.put("result",resultListMain);
	
	Gson gson = new GsonBuilder().disableHtmlEscaping().create();
	if(pretty.equals("y") || pretty.equals("Y")){
		 gson = new GsonBuilder().disableHtmlEscaping().setPrettyPrinting().create();
	}
	
	String tokenKey = ProEncrypts.createToken(TOKEN_KEY, mainMap); // 암호화 token key 생성
	
	if(USE_DATA_ENCRYPT){ //데이터만 암호화하기위한 조건
		encKey = TOKEN_KEY;
	}
	
	out.print(gson.toJson(ProEncrypts.getTokenFromJwtString(encKey, tokenKey, mainMap)));
	
	if ( proSearch != null ) proSearch.close();
%>
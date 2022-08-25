<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "goods_himart";

	if (index.equals("TOTAL") || index.equals(thisIndexName)) {
		indexIdx = proSearch.getIndexIdx(thisIndexName);
		long count = proSearch.getHitsCount(indexIdx);
		long thisIndexCount = proSearch.getTotalHitsCount(indexIdx);

		if ( thisIndexCount > 0 ) {
%>
		<section class="result">
			<div class="sectit">
				<h3><%=proSearch.getMapValue(thisIndexName,"INDEX_VIEW_NAME")%> ( <mark class="em_red"><%=thisIndexCount%></mark>건 )</h3>
			</div>
<%
				List<Map<String,Object>>  cateList = proSearch.getAggsList(indexIdx,"CATEGORY",""); //인덱스의 인덱스,필드명,서브필드?
				out.println(proSearch.getAggsDepthList(0,"tree", "",""));
				int num = 0;
				out.println(cateList);
				for(Map<String,Object> map : cateList){
					//for(Map.Entry<String,Object>entry : map.entrySet()){
						
						String key = (String) map.get("key");
						String[] keys = key.split("\\|");
						
						long cnt = (long) map.get("count");
						
						key = keys[0];

						
						/**
						if("key".equals(key)){
							key = (String)entry.getValue();
						}
						if(entry.getKey().equals("count")){
							cnt = (long)entry.getValue();
						}
						**/
						
						String cateNo = ""; 
						cateNo = key.substring(key.lastIndexOf(":")+1);
						if(!key.equals("")){
%>						
							 <div class="resultbox">
								<div class="text" id = "<%=num%>"><a href="#" onclick="javascript:cateSearch('<%=cateNo%>');"><%=key%></a>  (<%=cnt%>)</div>
							 </div>
<%					//}	
						}  num++;
				}
%>			
				

	</section>
<%		}
	}
%>
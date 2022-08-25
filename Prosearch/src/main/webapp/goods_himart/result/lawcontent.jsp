<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "lawcontent";

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

            MultiSearchResponse.Item sitem =  proSearch.getMultiSearchResponse().getResponses()[indexIdx];
            SearchHit [] hits =  sitem.getResponse().getHits().getHits();


            for ( SearchHit hit : hits ) {


		        String CONT_KNM					= proSearch.getFieldData(hit,"CONT_KNM","",true);
		        String URL = "URL 정책에 맞게 작성해야 합니다.";
				//하이라이팅시 처리
				CONT_KNM 			= ProUtils.getHighlightTag(CONT_KNM,"<font color=red>","</font>");



%>
				<div class="resultbox">
					 <div class="text"><%=CONT_KNM%>    </div> 
				</div>
<%
			}
			if ( "TOTAL".equals(index)  && thisIndexCount > 3 ) {
%>
				<br><a href="#" onClick="javascript:goIndexSearch('<%=thisIndexName%>');" style="float:right;" >뉴스 더보기 &gt;</a>
<%
			}
%>
	</section>
<%		}
	}
%>
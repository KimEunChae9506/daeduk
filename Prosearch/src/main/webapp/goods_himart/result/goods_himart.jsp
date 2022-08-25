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

            MultiSearchResponse.Item sitem =  proSearch.getMultiSearchResponse().getResponses()[indexIdx];
            SearchHit [] hits =  sitem.getResponse().getHits().getHits();


            for ( SearchHit hit : hits ) {


		        String goodsNm					= proSearch.getFieldData(hit,"GOODSNM","",true);
				String CATEGORY					= proSearch.getFieldData(hit,"CATEGORY","",true);
				String DOCID					= proSearch.getFieldData(hit,"GOODSNO","",true);
		        String URL = "URL 정책에 맞게 작성해야 합니다.";
				String date = proSearch.getFieldData(hit,"DATES","",false);
				//하이라이팅시 처리
				goodsNm 			= ProUtils.getHighlightTag(goodsNm,"<font color=red>","</font>");

				date  = ProUtils.convertDateFormat(date,"yyyyMMddhhmmss","yyyy/MM/dd");


%>
				<div class="resultbox">
					 <div class="text"><%=goodsNm%>   <%=DOCID%>   </div> 
					 <div class="text">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;(<%=CATEGORY%>)    </div> 
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
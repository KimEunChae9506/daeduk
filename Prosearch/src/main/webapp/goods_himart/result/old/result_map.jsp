<%@page import="org.springframework.util.ObjectUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: map 페이지
* @original author: SearchTool
*/
	thisCollection = "map";
	if ("custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>
			<div class="sectit">
				<h2><%=wnsearch.getCollectionKorName(thisCollection)%></h2>
				<p>| 검색결과 <%=numberFormat(thisTotalCount)%>건</p>
			</div>
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String URL                      = wnsearch.getField(thisCollection,"URL",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_blue'>","</mark>");
%>
				<dl class="resultsty1">
					<dt>
						<p class="date"><%=DATE%></p>
						<p class="fl"><a href="#"><%=TITLE%></a></p>
					</dt>
              <dd class="lh18"> DOCID : <%=DOCID%></dd>
              <dd class="lh18"> DATE : <%=DATE%></dd>
              <dd class="lh18"> URL : <%=URL%></dd>
              <dd class="lh18"> ALIAS : <%=ALIAS%></dd>
				</dl>
 <%
			}

			if ("custom".equals(collection) && thisTotalCount > Integer.parseInt(TOTALVIEWCOUNT)) {
				if(ObjectUtils.isEmpty(gbn)){
%>
				<div class="moreresult"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');">더보기</a></div>
<%
				}else{
%>
				<div class="moreresult"><a href="#none" onClick="javascript:doUserCollection('<%=thisCollection%>');">더보기</a></div>
<%
				}
			}
		}
	}
%>
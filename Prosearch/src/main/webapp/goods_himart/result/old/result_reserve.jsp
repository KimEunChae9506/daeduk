<%@page import="org.springframework.util.ObjectUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: reserve 페이지
* @original author: SearchTool
*/
	thisCollection = "reserve";
	if (collection.equals("ALL") || "custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
%>
<section class="result">
<%
		if ( thisTotalCount > 0 ) {
%>
		<div class="sectit">
				<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총<mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
			</div>
			<div class="board">
					<ul class="bu">
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String URL                      = wnsearch.getField(thisCollection,"URL",idx,false);
                String USER_CUSTOM              = wnsearch.getField(thisCollection,"USER_CUSTOM",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_blue'>","</mark>");
%>
<!-- 				<dl class="resultsty1"> -->
<!-- 					<dt> -->
<%-- 						<p class="date"><%=DATE%></p> --%>
<%-- 						<p class="fl"><a href="#"><%=TITLE%></a></p> --%>
<!-- 					</dt> -->
<%--               <dd class="lh18"> DOCID : <%=DOCID%></dd> --%>
<%--               <dd class="lh18"> DATE : <%=DATE%></dd> --%>
<%--               <dd class="lh18"> URL : <%=URL%></dd> --%>
<%--               <dd class="lh18"> USER_CUSTOM : <%=USER_CUSTOM%></dd> --%>
<%--               <dd class="lh18"> ALIAS : <%=ALIAS%></dd> --%>
<!-- 				</dl> -->
				<li>
					<a href="<%=URL %>" title="새창" target="_blank" class="blank"><%=TITLE%></a>
                       <div class="board_info">
                           <span class="blt type2">홈 &gt;통합예약</span>
                           <time datetime="<%=DATE%>">[<%=DATE%>]</time>
                       </div>
				</li>
 <%
			}
%>
			</ul>
		</div>
<%

			if ((collection.equals("ALL") || "custom".equals(collection)) && thisTotalCount > Integer.parseInt(TOTALVIEWCOUNT) ) {
				if(ObjectUtils.isEmpty(gbn)){
%>
<%-- 				<div class="moreresult"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');">더보기</a></div> --%>
				<a href="#n" class="more" onClick="javascript:doCollection('<%=thisCollection%>');">더보기</a>
<%
				}else{
%>
				<a href="#n" class="more" onClick="javascript:doUserCollection('<%=thisCollection%>');">더보기</a>
<%
				}
			}
		}
%>
</section>
<%
	}
%>
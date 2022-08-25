<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: menu 페이지
* @original author: SearchTool
*/
	thisCollection = "menu";
	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
%>
		<section class="result">
			<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h2>
<%
	if ( thisTotalCount > 0 ) {
%>
			<ul class="bu type2">
<%
			for(int idx = 0; idx < count; idx ++) {
					String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
	                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
	                String TITLE                    = wnsearch.getField(thisCollection,"MENU_NM",idx,false);
	                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
	                String LINK_URL                 = wnsearch.getField(thisCollection,"MENU_URL",idx,false);
	                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
	                String BBS_NO                   = wnsearch.getField(thisCollection,"BBS_NO",idx,false);
	                String SITE_ID                  = wnsearch.getField(thisCollection,"SITE_ID",idx,false);
	                String MENU_TY                  = wnsearch.getField(thisCollection,"MENU_TY",idx,false);
	                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
	                TITLE= wnsearch.getKeywordHl(TITLE,"<em class=\"em_blue\">","</em>");
	                CONTENT= wnsearch.getKeywordHl(CONTENT,"<em class=\"em_blue\">","</em>");
	                MENU_COURS= wnsearch.getKeywordHl(MENU_COURS,"<em class=\"em_blue\">","</em>");
%>
				<li><a href="<%=LINK_URL%>" title="새창" target="_blank"><%=MENU_COURS%></a></li>
<%
			}
%>
			</ul>
<%
			if ( collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT ) {
%>
			<a href="javascript:void(0);"  onClick="javascript:doCollection('<%=thisCollection%>');" class="more"><%=wnsearch.getCollectionKorName(thisCollection)%> 더보기</a>
<%
			}
		}
%>
		</section>
<%
	}
%>
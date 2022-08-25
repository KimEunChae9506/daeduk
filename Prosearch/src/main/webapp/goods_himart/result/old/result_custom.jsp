<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="kr.co.hanshinit.NeoCMS.cmm.util.StringUtil"%>
<%
/*
* subject: webpage 페이지
* @original author: SearchTool
*/
	thisCollection = "custom";
	if (collection.equals("custom") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
%>
		<section class="result">
			<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
<%
		if ( thisTotalCount > 0 ) {
%>
			<div class="board">
				<ul class="bu">
<%
			for(int idx = 0; idx < count; idx ++) {
                String FIXES_INFO			= wnsearch.getField(thisCollection,"FIXES_INFO",idx,false);
                String FIXES_SE				= wnsearch.getField(thisCollection,"FIXES_SE",idx,false);
                String SN					= wnsearch.getField(thisCollection,"SN",idx,false);
                String FIXES_CODE			= wnsearch.getField(thisCollection,"FIXES_CODE",idx,false);
                String SITE_ID				= wnsearch.getField(thisCollection,"SITE_ID",idx,false);
                String FIXES_DC				= wnsearch.getField(thisCollection,"FIXES_DC",idx,false);
                String WEB_URL				= wnsearch.getField(thisCollection,"WEB_URL",idx,false);
                String FRST_REGISTER_PNTTM	= wnsearch.getField(thisCollection,"FRST_REGISTER_PNTTM",idx,false);
                String FRST_REGISTER_ID		= wnsearch.getField(thisCollection,"FRST_REGISTER_ID",idx,false);
                String FRST_REGISTER_IP		= wnsearch.getField(thisCollection,"FRST_REGISTER_IP",idx,false);

// 				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_blue'>","</mark>");
// 				CONTENT= wnsearch.getKeywordHl(StringUtil.cutOffUTF8String(CONTENT,580,"..."),"<mark class=\"em_blue\">","</mark>");
// 				MENU_PATH = wnsearch.getKeywordHl(MENU_PATH,"<em class=\"em_blue\">","</em>");

%>
<!-- 				<dl class="resultsty1"> -->
					<li>
						<p class="date"><%=FRST_REGISTER_PNTTM%></p>
						<p class="fl"><a href="#"><%=FIXES_DC%></a></p>
<!-- 					</dt> -->
<%--               <dd class="lh18"> FIXES_INFO : <%=FIXES_INFO%></dd> --%>
					</li>
 <%
			}
%>
				</ul>
				</div>
<%
			if ( collection.equals("custom") && thisTotalCount > Integer.parseInt(TOTALVIEWCOUNT) ) {
%>
							<a href="javascript:void(0);"  onClick="javascript:doCollection('<%=thisCollection%>');" class="more"><%=wnsearch.getCollectionKorName(thisCollection)%> 검색결과 더보기</a>
<%
			}
		}
%>
		</section>
<%
	}
%>
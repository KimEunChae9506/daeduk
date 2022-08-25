<%@page import="java.net.URLEncoder"%>
<%@page import="kr.co.hanshinit.NeoCMS.cmm.util.StringUtil"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
/*
* subject: minwon 페이지
* @original author: SearchTool
*/
	thisCollection = "minwon";
	if (collection.equals("ALL") || "custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
%>
		<section class="result">
        	<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>

<%
		if ( thisTotalCount > 0 ) {
%>
			<div class="format">
				<ul class="clearfix">
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String URL                      = wnsearch.getField(thisCollection,"URL",idx,false);
                String WEIGHT_CUSTOM            = wnsearch.getField(thisCollection,"WEIGHT_CUSTOM",idx,false);
                String FILE_NM                  = wnsearch.getField(thisCollection,"FILE_NM",idx,false);
                String FILE_PATH             	= wnsearch.getField(thisCollection,"FILE_PATH",idx,false);
//                 String USER_CUSTOM              = wnsearch.getField(thisCollection,"USER_CUSTOM",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_red'>","</mark>");

				FILE_NM = FILE_NM.replaceAll("<(/)?([a-zA-Z]*)(\\s[a-zA-Z]*=[^>]*)?(\\s)*(/)?>", "");
				FILE_NM = URLEncoder.encode(StringUtil.Encrypt(FILE_NM, "dhfemghavpdlwl!!"));
				FILE_PATH = URLEncoder.encode(StringUtil.Encrypt(FILE_PATH, "dhfemghavpdlwl!!"));
%>
				<li>
                	<span class="format_title"><%=TITLE%></span>
                	<a href="./fileDownloadUrl.do?filePath=<%=FILE_PATH%>&amp;fileName=<%=FILE_NM %>" class="btn download" title="새창" target="_blank">다운로드</a>
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
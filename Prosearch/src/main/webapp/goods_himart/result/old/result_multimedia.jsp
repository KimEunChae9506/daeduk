<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: bbs 페이지
* @original author: SearchTool
*/
	thisCollection = "multimedia";
	if (collection.equals("ALL") || "custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
%>
		<section class="result">
			<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
<%
		if ( thisTotalCount > 0 ) {
%>
<div class="photo">
		<ul class="clearfix">
<%
			for(int idx = 0; idx < count; idx ++) {
				 String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
	                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
	                String TITLE                    = wnsearch.getField(thisCollection,"NTT_SJ",idx,false);
	                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
	                String IMG_PATH                 = wnsearch.getField(thisCollection,"IMG_PATH",idx,false);
	                String LINK_URL                 = wnsearch.getField(thisCollection,"LINK_URL",idx,false);
	                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
                TITLE= wnsearch.getKeywordHl(TITLE,"<em class=\"em_red\">","</em>");
                CONTENT= wnsearch.getKeywordHl(CONTENT,"<em class=\"em_red\">","</em>");
				%>
				 <li>
					<a href="<%=LINK_URL%>"  title="새창" target="_blank"  style="background-image:url('<%=IMG_PATH%>');">
						  <span class="photo_title"><%=TITLE %></span>
						  <time datetime="<%=DATE %>">[<%=DATE %>]</time>
					</a>
                </li>
<%
			}
%>
			</ul>
			</div>
<%
			if ((collection.equals("ALL") || "custom".equals(collection)) && thisTotalCount > TOTALVIEWCOUNT ) {
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
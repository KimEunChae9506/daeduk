<%@page import="org.springframework.util.ObjectUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="kr.co.hanshinit.NeoCMS.cmm.util.StringUtil"%>
<%
/*
* subject: news 페이지
* @original author: SearchTool
*/
	thisCollection = "news";
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
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String WRITER                   = wnsearch.getField(thisCollection,"WRITER",idx,false);
                String URL                      = wnsearch.getField(thisCollection,"URL",idx,false);
                String MENU_URL                 = wnsearch.getField(thisCollection,"MENU_URL",idx,false);
                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
                String REG_DATE                 = wnsearch.getField(thisCollection,"REG_DATE",idx,false);
                String USER_CUSTOM              = wnsearch.getField(thisCollection,"USER_CUSTOM",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_blue'>","</mark>");
				CONTENT= wnsearch.getKeywordHl(StringUtil.cutOffUTF8String(CONTENT,580,"..."),"<mark class=\"em_blue\">","</mark>");
				WRITER= wnsearch.getKeywordHl(WRITER,"<mark class='em_blue'>","</mark>");
%>

					<li>
						<a href="<%=URL %>" title="새창" target="_blank" class="blank"><%=TITLE%></a>
						<p><%=CONTENT%></p>
                        <div class="board_info">
                            <span class="blt type2">홈 &gt;<%=MENU_COURS%></span>
                            <time datetime="<%=DATE%>">[<%=DATE%>]</time>
                        </div>
					</li>
 <%
			}

			if ((collection.equals("ALL") || "custom".equals(collection)) && thisTotalCount > Integer.parseInt(TOTALVIEWCOUNT) ) {
%>
					</ul>
				</div>
				<%
				if(ObjectUtils.isEmpty(gbn)){
				%>
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
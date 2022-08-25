<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: webpage 페이지
* @original author: SearchTool
*/
	thisCollection = "webpage";
	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>			
			<section class="result">
            <h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총<mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"Date",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
                String STORE_PATH               = wnsearch.getField(thisCollection,"STORE_PATH",idx,false);
                String MENU_URL                 = wnsearch.getField(thisCollection,"MENU_URL",idx,false);
                String SITE_ID                  = wnsearch.getField(thisCollection,"SITE_ID",idx,false);
                String ATTACH_CONT              = wnsearch.getField(thisCollection,"ATTACH_CONT",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<font color=red>","</font>");
				ATTACH_CONT= wnsearch.getKeywordHl(ATTACH_CONT,"<font color=red>","</font>");
            String URL = "URL 정책에 맞게 작성해야 합니다.";

%>
				<div class="resultbox">
	                <div class="title">
	                    <a href=""><%=TITLE%></a>
	                </div>  <!--//title-->
	                <div class="text">
	                    <%=STORE_PATH%>
	                </div>  <!--//text-->
	                <div class="path"><%=MENU_COURS%></div>
	            </div>  <!--//resultbox-->
<%
			}

			if ( collection.equals("ALL") && thisTotalCount > TOTALVIEWCOUNT ) {
%>
				<a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');" class="more">더보기</a>
<%
			}
%>
			</section>  <!--//result--><!--//메뉴 검색 출력-->
<%
		}
	}
%>
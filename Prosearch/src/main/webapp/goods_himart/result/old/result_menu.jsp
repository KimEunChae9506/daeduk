<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: menu 페이지
* @original author: SearchTool
*/
	thisCollection = "menu";
	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>
			<section class="result menu_result">
	            <h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총<mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
	            <ul class="bu">
	            
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
                String MENU_URL                 = wnsearch.getField(thisCollection,"MENU_URL",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<font color=red>","</font>");
            String URL = "URL 정책에 맞게 작성해야 합니다.";

%>				
                <li>
                    <a href="<%=MENU_URL%>" title="새창" target="_blank">
                        <span class="site">[<%=TITLE%>]</span>
                        <span class="path_text"><%=MENU_COURS%></span>
                    </a>
                </li>
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
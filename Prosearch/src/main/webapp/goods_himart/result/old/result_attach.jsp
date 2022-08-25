<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: attach 페이지
* @original author: SearchTool
*/
	thisCollection = "attach";
	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>
			<section class="result attach">
            	<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
            	<div class="attach_box">
                	<ul class="attach_list clearfix">
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"Date",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String MENU_NM                  = wnsearch.getField(thisCollection,"MENU_NM",idx,false);
                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
                String LINK_URL                 = wnsearch.getField(thisCollection,"LINK_URL",idx,false);
                String IMAGE_VIEW_URL           = wnsearch.getField(thisCollection,"IMAGE_VIEW_URL",idx,false);
                String THUMBNAIL_URL            = wnsearch.getField(thisCollection,"THUMBNAIL_URL",idx,false);
                String DOWN_URL                 = wnsearch.getField(thisCollection,"DOWN_URL",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<font color=red>","</font>");
				CONTENT= wnsearch.getKeywordHl(CONTENT,"<font color=red>","</font>");
            String URL = "URL 정책에 맞게 작성해야 합니다.";

%>
				<li class="attach_item">
                    <div class="wrap">
                        <span class="btn icon hwp">한글파일</span>
                        <span class="attach_text"><%=TITLE%></span>   <!--//attach_text-->
                        <div class="attach_down">
                            <a href="<%=IMAGE_VIEW_URL%>" class="btn type3 small preview_icon">미리보기</a>
                            <a href="<%=DOWN_URL%>" title="다운로드" class="btn type3 small down_icon">다운로드</a>
                        </div>  <!--//attach_down-->
                    </div>  <!--//wrap-->
                </li>   <!--//attach_item-->
<%
			}
%>
               </ul>   <!--//photo_list-->
           </div>  <!--//photo-->
<%
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
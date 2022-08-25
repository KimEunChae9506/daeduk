<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: media 페이지
* @original author: SearchTool
*/
	thisCollection = "media";
	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>		
			<section class="result multi">
	            <h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
	            <div class="photo">
	                <ul class="photo_list clearfix">
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"Date",idx,false);
                String SITE_ID                  = wnsearch.getField(thisCollection,"SITE_ID",idx,false);
                String MENU_NM                  = wnsearch.getField(thisCollection,"MENU_NM",idx,false);
                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
                String BBS_NO                   = wnsearch.getField(thisCollection,"BBS_NO",idx,false);
                String BBS_NM                   = wnsearch.getField(thisCollection,"BBS_NM",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String LINK_URL                 = wnsearch.getField(thisCollection,"LINK_URL",idx,false);
                String IMAGE_VIEW_URL           = wnsearch.getField(thisCollection,"IMAGE_VIEW_URL",idx,false);
                String THUMBNAIL_URL            = wnsearch.getField(thisCollection,"THUMBNAIL_URL",idx,false);
                String DOWN_URL                 = wnsearch.getField(thisCollection,"DOWN_URL",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<font color=red>","</font>");
				CONTENT= wnsearch.getKeywordHl(CONTENT,"<font color=red>","</font>");
            String URL = "URL 정책에 맞게 작성해야 합니다.";

%>
				<li class="photo_item">
                    <a href="<%=LINK_URL%>" class="photo_link">
                        <div class="wrap">
                            <div class="p_text">
                                <div class="text_wrap">
                                    <span class="p_title">
                                        <mark class="em_red"><%=TITLE%></mark><br>
                                        <%=CONTENT%>
                                    </span> <!--//p_title-->
                                    <time datetime="<%=DATE%>"><%=DATE%></time>
                                </div>  <!--//text_wrap-->
                            </div>  <!--//p_text-->
                            <div class="p_box">
                                <div class="p_wrap" style="background-image:url('<%=THUMBNAIL_URL%>')"></div>  <!--//p_wrap-->
                                <div class="p_img">
                                    <img src="/search/images/main/covid19_img.jpg" alt="해당 이미지의 설명">
                                </div>  <!--//p_img-->
                            </div>  <!--//p_box-->
                        </div>  <!--//wrap-->
                    </a>    <!--//photo_link-->
                </li>   <!--//photo_item-->
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
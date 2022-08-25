<%@ page contentType="text/html; charset=UTF-8"%>
<%@page import="org.springframework.util.ObjectUtils"%>
<%
/*
* subject: attach 페이지
* @original author: SearchTool
*/
	thisCollection = "attach";
	if (collection.equals("ALL") || "custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>
			<div class="sectit">
				<h2><%=wnsearch.getCollectionKorName(thisCollection)%></h2>
				<p>| 검색결과 <%=numberFormat(thisTotalCount)%>건</p>
			</div>
<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String FILE_SIZE                = wnsearch.getField(thisCollection,"FILE_SIZE",idx,false);
                String ATCHMNFL_NO              = wnsearch.getField(thisCollection,"ATCHMNFL_NO",idx,false);
                String PRG_NM                   = wnsearch.getField(thisCollection,"PRG_NM",idx,false);
                String NTT_SJ                   = wnsearch.getField(thisCollection,"NTT_SJ",idx,false);
                String NTT_CN                   = wnsearch.getField(thisCollection,"NTT_CN",idx,false);
                String URL                      = wnsearch.getField(thisCollection,"URL",idx,false);
                String MENU_COURS               = wnsearch.getField(thisCollection,"MENU_COURS",idx,false);
                String REG_DATE                 = wnsearch.getField(thisCollection,"REG_DATE",idx,false);
                String FILE_PATH                = wnsearch.getField(thisCollection,"FILE_PATH",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_blue'>","</mark>");
				CONTENT= wnsearch.getKeywordHl(CONTENT,"<mark class='em_blue'>","</mark>");
%>
				<dl class="resultsty1">
					<dt>
						<p class="date"><%=DATE%></p>
						<p class="fl"><a href="#"><%=TITLE%></a></p>
					</dt>
					<dd class="lh18"><%=CONTENT%></dd>
              <dd class="lh18"> DOCID : <%=DOCID%></dd>
              <dd class="lh18"> DATE : <%=DATE%></dd>
              <dd class="lh18"> FILE_SIZE : <%=FILE_SIZE%></dd>
              <dd class="lh18"> ATCHMNFL_NO : <%=ATCHMNFL_NO%></dd>
              <dd class="lh18"> PRG_NM : <%=PRG_NM%></dd>
              <dd class="lh18"> NTT_SJ : <%=NTT_SJ%></dd>
              <dd class="lh18"> NTT_CN : <%=NTT_CN%></dd>
              <dd class="lh18"> URL : <%=URL%></dd>
              <dd class="lh18"> MENU_COURS : <%=MENU_COURS%></dd>
              <dd class="lh18"> REG_DATE : <%=REG_DATE%></dd>
              <dd class="lh18"> FILE_PATH : <%=FILE_PATH%></dd>
              <dd class="lh18"> ALIAS : <%=ALIAS%></dd>
				</dl>
 <%
			}

			if ((collection.equals("ALL") || "custom".equals(collection)) && thisTotalCount > Integer.parseInt(TOTALVIEWCOUNT) ) {
				if(ObjectUtils.isEmpty(gbn)){
%>
				<div class="moreresult"><a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');">더보기</a></div>
<%
				}else{
%>
				<div class="moreresult"><a href="#none" onClick="javascript:doUserCollection('<%=thisCollection%>');">더보기</a></div>
<%
				}
			}
		}
	}
%>
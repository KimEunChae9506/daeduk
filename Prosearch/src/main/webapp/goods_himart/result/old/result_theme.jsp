<%@page import="org.springframework.util.ObjectUtils"%>
<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: attach 페이지
* @original author: SearchTool
*/
	thisCollection = "theme";
	if (collection.equals("ALL") || "custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>
			<section class="result">
				<h3>테마센터  (총<mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>

<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
                String TITLE                    = wnsearch.getField(thisCollection,"TITLE",idx,false);
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String URL                      = wnsearch.getField(thisCollection,"URL",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<mark class='em_blue'>","</mark>");
				CONTENT= wnsearch.getKeywordHl(CONTENT,"<mark class='em_blue'>","</mark>");
%>
				<div>
<%-- 					<h4 class="box_title margin_t_0"><a href="<%=URL%>" title="새창" target="_blank"><%=TITLE%></a></h4> --%>
<!-- 					  <dt> -->
<%-- 							<p class="date"><%=DATE%></p> --%>
<%-- 							<p class="fl"><%=CONTENT%></p> --%>
<!-- 							<div class="box_img"> -->
								<%=CONTENT%>
<!-- 							</div> -->
<!-- 					  </dt> -->

<%-- 					  <p class="indent"><%=CONTENT%></p> --%>
<%-- 		              <dd class="lh18"> DOCID : <%=DOCID%></dd> --%>
<%-- 		              <dd class="lh18"> DATE : <%=DATE%></dd> --%>
<%-- 		              <dd class="lh18"> URL : <%=URL%></dd> --%>
<%-- 		              <dd class="lh18"> ALIAS : <%=ALIAS%></dd> --%>
				</div>

<!--                             <h3>연천구 테마센터 (총<mark class="em_red">23</mark>건)</h3> -->
<!--                             <div class="box"> -->
<!--                                 <div class="box_img"><img src="images/sub/box_img.jpg" alt="" /></div> -->
<!--                                 <h4 class="box_title margin_t_0"><a href="#n" title="새창" target="_blank">대형폐기물신청</a></h4> -->
<!--                                 <p class="indent">관할 동주민센터 혹은 우리구 홈페이지상에서 대형 생활폐기물의 종류에 따라 배출신고 하신 후 수수료 납부(결제)하시고 배출하면 됩니다. <span class="label">아동</span> <span class="label type2">청소년</span> <span class="label type3">청년</span> <span class="label type4">어르신</span> <span class="label type5">임신&middot;출산</span> <span class="label type6">장애인</span> <span class="label type7">구직자</span> <span class="label type8">사업자</span></p> -->
<!--                                 <div class="box_list"> -->
<!--                                     <ul class="bu indent"> -->
<!--                                         <li><span class="bu_title">주요내용</span> : <a href="#n" title="새창" target="_blank">대형폐기물배출신고</a></li> -->
<!--                                         <li><span class="bu_title">문의전화</span> : 청소행정과 02-1234-5671 ~ 9</li> -->
<!--                                     </ul> -->
<!--                                 </div> -->

<!--                             <a href="#n" class="more">더보기</a> -->
<!--                         </section> -->
 <%
			}

			if ((collection.equals("ALL") || "custom".equals(collection)) && thisTotalCount > Integer.parseInt(TOTALVIEWCOUNT) ) {
				if(ObjectUtils.isEmpty(gbn)){
%>
				<a href="#none" onClick="javascript:doCollection('<%=thisCollection%>');">더보기</a>
<%
				}else{
%>
				<a href="#none" onClick="javascript:doUserCollection('<%=thisCollection%>');">더보기</a>
<%
				}
			}
			%>
			</section>
			<%
		}
	}
%>
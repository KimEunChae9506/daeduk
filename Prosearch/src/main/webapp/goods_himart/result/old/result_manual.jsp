<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: manual 페이지
* @original author: SearchTool
*/
	thisCollection = "manual";
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
                String CONTENT                  = wnsearch.getField(thisCollection,"CONTENT",idx,false);
                String ATTACH_CONT              = wnsearch.getField(thisCollection,"ATTACH_CONT",idx,false);
                String DOWN_URL                 = wnsearch.getField(thisCollection,"DOWN_URL",idx,false);
                String LINK_URL                 = wnsearch.getField(thisCollection,"LINK_URL",idx,false);
                String FILE_NM                  = wnsearch.getField(thisCollection,"FILE_NM",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				TITLE= wnsearch.getKeywordHl(TITLE,"<font color=red>","</font>");
				CONTENT= wnsearch.getKeywordHl(CONTENT,"<font color=red>","</font>");
				ATTACH_CONT= wnsearch.getKeywordHl(ATTACH_CONT,"<font color=red>","</font>");
				FILE_NM= wnsearch.getKeywordHl(FILE_NM,"<font color=red>","</font>");
	            String URL = "URL 정책에 맞게 작성해야 합니다.";
				String[] FILES_NM = FILE_NM.split("\\|\\|");
				String[] DOWNS_URL = DOWN_URL.split("\\|\\|");

%>
				<div class="resultbox">
	                  <div class="title">
	                      <a href="<%=LINK_URL%>"><%=TITLE%></a>
	                  </div>  <!--//title-->
	                  <div class="text">
	                      <%=CONTENT%>
	                  </div>  <!--//text-->
	                  <div class="filebox">
	                      <ul class="bu">
	                          <%
		                        	if(!FILE_NM.equals("")){
		                        		for(int i = 0; i < FILES_NM.length; i ++) {
		                        			String extension = FILES_NM[i].substring(FILES_NM[i].length()-3, FILES_NM[i].length());
		                        			%>
		                        			<li>
				                                <div class="filetitle btn <%=extension %>">
				                                    <span class="text"><%=FILES_NM[i] %></span>
				                                </div>
				                                <div class="downbox">
				                                    <a href="<%=DOWNS_URL[i]%>" target="_blank" title="다운로드" class="down">해당파일 다운로드</a>
				                                    <a href="" target="_blank" title="새창" class="view">미리보기</a>
				                                </div>  <!--//downbox-->
				                            </li>
		                        			<%
		                        		}
		                        	}
		                        %>
	                      </ul>
	                  </div>  <!--//filebox-->
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
<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "s_app";

	if (index.equals("TOTAL") || index.equals(thisIndexName)) {
		indexIdx = proSearch.getIndexIdx(thisIndexName);
		long count = proSearch.getHitsCount(indexIdx);
		long thisIndexCount = proSearch.getTotalHitsCount(indexIdx);

		if ( thisIndexCount > 0 ) {
%>
				<!--  카테고리 1  -->
			<h2 class="tit_category"><%=proSearch.getMapValue(thisIndexName,"INDEX_VIEW_NAME")%> (<span><%=thisIndexCount%></span>)</h2>
<%

            MultiSearchResponse.Item sitem =  proSearch.getMultiSearchResponse().getResponses()[indexIdx];
            SearchHit [] hits =  sitem.getResponse().getHits().getHits();
%>
<section class="result result_news">
<%
            for ( SearchHit hit : hits ) {
				
		        String FIELD_SUBJECT		= proSearch.getFieldData(hit,"FIELD_SUBJECT","",false);
		        String FIELD_CONTENT			= proSearch.getFieldData(hit,"FIELD_CONTENT","",false);
		        String FIELD_OWNER_NAME			= proSearch.getFieldData(hit,"FIELD_OWNER_NAME","",false);
		        String FIELD_REAL_FILE_NAME			= proSearch.getFieldData(hit,"FIELD_REAL_FILE_NAME","",false);

				//하이라이팅시 처리
				FIELD_SUBJECT 			= ProUtils.getHighlightTag(FIELD_SUBJECT,"<font color=red>","</font>");
				FIELD_CONTENT 				= ProUtils.getHighlightTag(FIELD_CONTENT,"<font color=red>","</font>");
				
				//String[] file = FIELD_CONTENT.split("!@!");
				
				FIELD_REAL_FILE_NAME = FIELD_REAL_FILE_NAME.replaceAll("!@!",",");
%>
              
                      <h3></h3>
						<div class="resultbox">
                              <div class="title"><a href="#n"><%=FIELD_SUBJECT%></a></div>
                              <div class="text"><%=FIELD_CONTENT%></div>
                              <div class="filebox">
                                  <ul class="bu">
                                      <li>
                                          <div class="filetitle"><%=FIELD_REAL_FILE_NAME%></div> 
                                      </li>
                                      
                                  </ul>
                              </div>
						<div class="atch_prvw" id=""  >첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용 첨부내용.... </div>
                              <div class="path">부서명 > 작성자</div>
                            </div>
                      <!--a href="#none" class="more skip">더보기</a-->   
            
<%
			}
%>
            </section>
<%			if ( "TOTAL".equals(index)  && thisIndexCount > 3 ) {
%>
				<p class="view_more">
					<a href="javascript:goIndexSearch('<%=thisIndexName%>');" onclick="">더보기</a>
				</p>

<%
			}
		}
	}
%>
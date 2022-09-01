<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "doc";

	if (index.equals("TOTAL") || index.equals(thisIndexName)) {
		indexIdx = proSearch.getIndexIdx(thisIndexName);
		long count = proSearch.getHitsCount(indexIdx);
		long thisIndexCount = proSearch.getTotalHitsCount(indexIdx);

		if ( thisIndexCount > 0 ) {
            MultiSearchResponse.Item sitem =  proSearch.getMultiSearchResponse().getResponses()[indexIdx];
            SearchHit [] hits =  sitem.getResponse().getHits().getHits();
%>
            <div id="type1_con">
            <table>
                <colgroup>
                    <col style="width:3%;">
                    <col style="width:47%;">
                    <col style="width:12%;">
                    <col style="width:12%;">
                    <col style="width:8%;">
                    <col style="width:18%;">
                </colgroup>
                <thead>
                    <tr>
                        <th>
                            
                        </th>
                        <th>
                            <div>제목</div>
                        </th>
                        <th>
                            <div>작성일</div>
                        </th>
                        <th>
                            <div>작성자</div>
                        </th>
                        <th>
                            <div>조회</div>
                        </th>
                        <th>
                            <div>해시태그</div>
                        </th>
                    </tr>
                </thead>
                <tbody>
<% 
            for ( SearchHit hit : hits ) {
		        String atch_file_nm		= proSearch.getFieldData(hit,"atch_file_nm","",true);
		        String title			= proSearch.getFieldData(hit,"title.ngram","",true);
		        String content			= proSearch.getFieldData(hit,"content","",true);
		        String regt_id			= proSearch.getFieldData(hit,"regt_id","",true);
		        String regt_dt			= proSearch.getFieldData(hit,"regt_dt","",false);
		        String view_cnt			= proSearch.getFieldData(hit,"view_cnt","",false);
		        String tag_nm			= proSearch.getFieldData(hit,"tag_nm","",true);

				//하이라이팅시 처리
				title 					= ProUtils.getHighlightTag(title,"<font color=red>","</font>");
				content 				= ProUtils.getHighlightTag(content,"<font color=red>","</font>");
				regt_id 				= ProUtils.getHighlightTag(regt_id,"<font color=red>","</font>");
				atch_file_nm 			= ProUtils.getHighlightTag(atch_file_nm,"<font color=red>","</font>");
				tag_nm 					= ProUtils.getHighlightTag(tag_nm,"<font color=red>","</font>");
				
				String[] tags 			= tag_nm.split("#");
				atch_file_nm			= atch_file_nm.replaceAll("!@!",", ");
		        regt_dt 				= ProUtils.convertDateFormat(regt_dt,"yyyyMMddHHmmss","yyyy-MM-dd");
				
%>
				
                                        <tr>
                                            <td>
                                                <div>
                                                    <span class="clip"></span>
                                                </div>
                                            </td>
                                            <td class="result_tit">
                                                <div><%=title %></div>
                                            </td>
                                            <td>
                                                <div><%=regt_dt %></div>
                                            </td>
                                            <td>
                                                <div><%=regt_id %></div>
                                            </td>
                                            <td>
                                                <div><%=view_cnt %></div>
                                            </td>
                                            <td>
                                            	<div>
<%									for(int i = 1; i < tags.length; i ++){ //##
%>	
                                       			#<%=tags[i] %>&nbsp;
<%									} %>
												</div>
                                            </td>
                                        </tr>                                   
<%
			}
%>
							</tbody>
                          </table>
                          
                          
<% if (proPaging != null ) { %>                             
            <div class="pagin_bar center font0">
            <div class="pg_ctr_01 inline-block">
                <span class="pg_fprev" onclick="javascript:goPage(<%=proPaging.getFirstPageNo()%>);"></span>
                <span class="pg_prev ms3" onclick="javascript:goPage(<%=proPaging.getPrevPageNo()%>);"></span>
            </div>
            <div class="page_count inline-block">
            
            <%
					for ( int i=proPaging.getStartPageNo(); i <= proPaging.getEndPageNo(); i++) {
%>							<span title="<%=i%>페이지 이동" class="<%=pageNo.equals(String.valueOf(i)) ? "active": ""%>" onclick="javascript:goPage(<%=i%>)"><%=i%></span>
<% 					}
%>
            </div>
            <div class="pg_ctr_01 inline-block">
                <span class="pg_next" onclick="javascript:goPage(<%=proPaging.getNextPageNo()%>);"></span>
                <span class="pg_fnext ms3" onclick="javascript:goPage(<%=proPaging.getFinalPageNo()%>);"></span>
            </div>
        </div>
      
      
<%} %>  

    </div>
      
<%
		}
	}
%>
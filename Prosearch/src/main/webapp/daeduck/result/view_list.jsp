<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
<<<<<<< HEAD
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
=======
	thisIndexName = "news";

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


            for ( SearchHit hit : hits ) {
				
		        String p_filetype		= proSearch.getFieldData(hit,"filetype","",false);
		        String p_auth			= proSearch.getFieldData(hit,"auth","",false);
		        String p_fauth			= proSearch.getFieldData(hit,"fauth","",false);
		        String p_subject		= proSearch.getFieldData(hit,"subject","",false);
				p_subject				= ProUtils.getHighlightTag(p_subject,"<font color=red>","</font>");
		        String p_expiredate		= proSearch.getFieldData(hit,"expiredate","",false);
		        String p_body			= proSearch.getFieldData(hit,"body","",false);
				p_body					= ProUtils.getHighlightTag(p_body,"<font color=red>","</font>");
		        String p_userid			= proSearch.getFieldData(hit,"userid","",false);
		        String p_deldate			= proSearch.getFieldData(hit,"deldate","",false);
		        String p_expireddate			= proSearch.getFieldData(hit,"expireddate","",false);
		        String p_companyid			= proSearch.getFieldData(hit,"companyid","",false);
		        String p_modifydate			= proSearch.getFieldData(hit,"modifydate","",false);
		        String p_filepath			= proSearch.getFieldData(hit,"filepath","",false);
		        String p_fullpath			= proSearch.getFieldData(hit,"fullpath","",false);
		        String p_alias			= proSearch.getFieldData(hit,"alias","",false);
		        String p_attach			= proSearch.getFieldData(hit,"attach","",false);
		        String p_bbsname			= proSearch.getFieldData(hit,"bbsname","",false);
		        String p_id			= proSearch.getFieldData(hit,"id","",false);
		        String p_tag			= proSearch.getFieldData(hit,"tag","",false);
		        String p_fileid			= proSearch.getFieldData(hit,"fileid","",false);
		        String p_category2			= proSearch.getFieldData(hit,"category2","",false);
		        String p_summary			= proSearch.getFieldData(hit,"summary","",false);
		        String p_category1			= proSearch.getFieldData(hit,"category1","",false);
		        String p_companydomain			= proSearch.getFieldData(hit,"companydomain","",false);
		        String p_dept			= proSearch.getFieldData(hit,"dept","",false);
		        String p_fileext			= proSearch.getFieldData(hit,"fileext","",false);
		        String p_menu			= proSearch.getFieldData(hit,"menu","",false);
		        String p_deptname			= proSearch.getFieldData(hit,"deptname","",false);
		        String p_bbs			= proSearch.getFieldData(hit,"bbs","",false);
		        String p_filename			= proSearch.getFieldData(hit,"filename","",false);
		        String p_companyname			= proSearch.getFieldData(hit,"companyname","",false);
		        String p_fullpathname			= proSearch.getFieldData(hit,"fullpathname","",false);
		        String p_regdate			= proSearch.getFieldData(hit,"regdate","",false);
		        String p_anonymous			= proSearch.getFieldData(hit,"anonymous","",false);
		        String p_linkurl			= proSearch.getFieldData(hit,"linkurl","",false);
		        String p_category			= proSearch.getFieldData(hit,"category","",false);
		        String p_username			= proSearch.getFieldData(hit,"username","",false);
		        String p_viewcount			= proSearch.getFieldData(hit,"viewcount","",false); // 조회수
		        String p_hashtag			= proSearch.getFieldData(hit,"hashtag","",false); // 해시태그
		        String file			= proSearch.getFieldData(hit,"file","",false); // 임시
		        
		        file = "Y";
		        String viewSubject = ""; 
		        String viewBody    = ""; 
		        String viewDate    = ""; 
		        String viewEtc     = ""; 
				viewSubject			 = viewSubject + p_subject;
				viewDate			 = viewDate + p_regdate;
				viewBody			 = viewBody + p_body;
				viewEtc			 = viewEtc + p_username;
				
				if ( !"".equals(viewDate) ) {
					viewDate          = ProUtils.convertDateFormat(viewDate,"yyyyMMddhhmmss","yyyy/MM/dd");
				}
				  
				//하이라이팅시 처리
				viewSubject 			= ProUtils.getHighlightTag(viewSubject,"<font color=red>","</font>");
				viewBody 				= ProUtils.getHighlightTag(viewBody,"<font color=red>","</font>");
				
				  

				
%>
				<div class="types_con">
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
                                        <tr>
                                            <td>
                                         	   <% if ("Y".equals(file)) { %>
                                                <div>
                                                    <span class="clip"></span>
                                                </div>
                                                <% } else { %>
                                                <div></div>
												<%                                                    												
                                                    }
                                         	  	%>
                                                
                                            </td>
                                            <td class="result_tit">
                                                <div><%=viewSubject%></div>
                                            </td>
                                            <td>
                                                <div><%=viewDate%></div>
                                            </td>
                                            <td>
                                                <div><%=p_username%></div>
                                            </td>
                                            <td>
                                                <div><%=p_viewcount%></div>
                                            </td>
                                            <td>
                                                <div><%=p_hashtag%></div>
                                            </td>
                                        </tr>
									</tbody>
                             	 </table>
				<div class="list_sc">
					<h3 class="tit_list"><%=viewSubject%></h3>
					<p class="desc"><%=viewBody%></p>
					<p class="sc_footer">
						<span><%=viewDate%></span>
						<span><%=viewEtc%></span>
					</p>
				</div>
				
				<!-- 페이징 시작-->
				<div class="pagin_bar center font0">
					<div class="page_count inline-block">
						<span class="pg_fprev"><a class="first" href="#" onclick="javascript:goPage(<%=proPaging.getFirstPageNo()%>);"></a></span>
						<span class="pg_prev ms3"><a class="prev" href="#" onclick="javascript:goPage(<%=proPaging.getPrevPageNo()%>);"></a></span> 
		
<%
					for ( int i=proPaging.getStartPageNo(); i <= proPaging.getEndPageNo(); i++) {
						if(pageNo.equals(String.valueOf(i))){
%>	
						<span class="active"><strong><%=i%></strong></span>
<%						
						} else {
%>				
						<div class="page_count inline-block">
							
							<a class="p-page__link" href="#" onclick="javascript:goPage(<%=i%>);" ><%=i%></a>
						</div>
<%				
						}
					}
%>						
						<span class="pg_next"><a class="next" href="#" onclick="javascript:goPage(<%=proPaging.getNextPageNo()%>);"><img src="images/btn_next.gif" width="12" height="15" alt="" /></a></span>
						<span class="pg_fnext ms3"><a class="end" href="#"onclick="javascript:goPage(<%=proPaging.getFinalPageNo()%>);"><img src="images/btn_end.gif" width="12" height="15" alt="" /></a></span>
					
					</div>
				</div>
				<!-- 페이징 끝-->
				
<%
			}

			if ( "TOTAL".equals(index)  && thisIndexCount > 3 ) {
%>
				<p class="view_more">
					<a href="javascript:goIndexSearch('<%=thisIndexName%>');" onclick="">더보기</a>
				</p>

<%
			}
>>>>>>> branch 'master' of https://github.com/KimEunChae9506/daeduk.git
		}
	}
%>
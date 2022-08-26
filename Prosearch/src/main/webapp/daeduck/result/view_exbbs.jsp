<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "exbbs";

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

				<div class="list_sc">
					<h3 class="tit_list"><%=viewSubject%></h3>
					<p class="desc"><%=viewBody%></p>
					<p class="sc_footer">
						<span><%=viewDate%></span>
						<span><%=viewEtc%></span>
					</p>
				</div>
<%
			}

			if ( "TOTAL".equals(index)  && thisIndexCount > 3 ) {
%>
				<p class="view_more">
					<a href="javascript:goIndexSearch('<%=thisIndexName%>');" onclick="">더보기</a>
				</p>

<%
			}
		}
	}
%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "exnews";

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

		        String p_date					= proSearch.getFieldData(hit,"date","",false);
		        String p_xml_path				= proSearch.getFieldData(hit,"xml_path","",false);
		        String p_body_text				= proSearch.getFieldData(hit,"body_text","",false);
		        String p_admission_u_time		= proSearch.getFieldData(hit,"admission_u_time","",false);
		        String p_category_nm			= proSearch.getFieldData(hit,"category_nm","",false);
		        String p_section				= proSearch.getFieldData(hit,"section","",false);
		        String p_body					= proSearch.getFieldData(hit,"body","",true);
		        String p_type					= proSearch.getFieldData(hit,"type","",false);
		        String p_origin_body			= proSearch.getFieldData(hit,"origin_body","",false);
		        String p_category_list			= proSearch.getFieldData(hit,"category_list","",false);
		        String p_is_card				= proSearch.getFieldData(hit,"is_card","",false);
		        String p_rep_photo				= proSearch.getFieldData(hit,"rep_photo","",false);
		        String p_creator_email			= proSearch.getFieldData(hit,"creator_email","",false);
		        String p_plat					= proSearch.getFieldData(hit,"plat","",false);
		        String p_tag					= proSearch.getFieldData(hit,"tag","",false);
		        String p_admission_id			= proSearch.getFieldData(hit,"admission_id","",false);
		        String p_body_photo_list		= proSearch.getFieldData(hit,"body_photo_list","",false);
		        String p_level					= proSearch.getFieldData(hit,"level","",false);
		        String p_admission_n_time		= proSearch.getFieldData(hit,"admission_n_time","",false);
		        String p_pub_day				= proSearch.getFieldData(hit,"pub_day","",false);
		        String p_doc9					= proSearch.getFieldData(hit,"doc9","",false);
		        String p_doc8					= proSearch.getFieldData(hit,"doc8","",false);
		        String p_reg_date				= proSearch.getFieldData(hit,"reg_date","",false);
		        String p_creator_id				= proSearch.getFieldData(hit,"creator_id","",false);
		        String p_page					= proSearch.getFieldData(hit,"page","",false);
		        String p_movie_list				= proSearch.getFieldData(hit,"movie_list","",false);
		        String p_publish_date			= proSearch.getFieldData(hit,"publish_date","",false);
		        String p_status					= proSearch.getFieldData(hit,"status","",false);
		        String p_code					= proSearch.getFieldData(hit,"code","",false);
		        String p_is_movie				= proSearch.getFieldData(hit,"is_movie","",false);
		        String p_refer_list				= proSearch.getFieldData(hit,"refer_list","",false);
		        String p_title					= proSearch.getFieldData(hit,"title","",true);
		        String p_cms_source_path		= proSearch.getFieldData(hit,"cms_source_path","",false);
		        String p_doc7					= proSearch.getFieldData(hit,"doc7","",false);
		        String p_doc6					= proSearch.getFieldData(hit,"doc6","",false);
		        String p_doc5					= proSearch.getFieldData(hit,"doc5","",false);
		        String p_doc4					= proSearch.getFieldData(hit,"doc4","",false);
		        String p_doc3					= proSearch.getFieldData(hit,"doc3","",false);
		        String p_doc2					= proSearch.getFieldData(hit,"doc2","",false);
		        String p_doc1					= proSearch.getFieldData(hit,"doc1","",false);
		        String p_alias					= proSearch.getFieldData(hit,"alias","",false);
		        String p_is_photo				= proSearch.getFieldData(hit,"is_photo","",false);
		        String p_sub_title				= proSearch.getFieldData(hit,"sub_title","",false);
		        String p_docid					= proSearch.getFieldData(hit,"docid","",false);
		        String p_by_line_list			= proSearch.getFieldData(hit,"by_line_list","",false);
		        String p_is_graphic				= proSearch.getFieldData(hit,"is_graphic","",false);
		        String p_cs_code				= proSearch.getFieldData(hit,"cs_code","",false);
		        String p_creator_name			= proSearch.getFieldData(hit,"creator_name","",false);
		        String p_created_date			= proSearch.getFieldData(hit,"created_date","",false);
		        String p_updated_date			= proSearch.getFieldData(hit,"updated_date","",false);
		        String p_category				= proSearch.getFieldData(hit,"category","",false);
		        String p_embago_time			= proSearch.getFieldData(hit,"embago_time","",false);


		        String viewSubject = ""; 
		        String viewBody    = ""; 
		        String viewDate    = ""; 
		        String viewEtc     = ""; 
				viewSubject			 = viewSubject + p_title;
				viewDate			 = viewDate + p_date;
				viewBody			 = viewBody + p_body;
				viewEtc			 = viewEtc + p_creator_name;


				if ( !"".equals(viewDate) ) {
					viewDate          = ProUtils.convertDateFormat(viewDate,"yyyyMMddhhmmss","yyyy/MM/dd");
				}
				
				//하이라이팅시 처리
				viewSubject 			= ProUtils.getHighlightTag(viewSubject,"<font color=red>","</font>");
				viewBody 				= ProUtils.getHighlightTag(viewBody,"<font color=red>","</font>");


                String URL = "URL 정책에 맞게 작성해야 합니다.";
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

			if ( "TOTAL".equals(index)  ) {
%>
				<p class="view_more">
					<a href="javascript:goIndexSearch('<%=thisIndexName%>');" onclick="">더보기</a>
				</p>

<%
			}
		}
	}
%>
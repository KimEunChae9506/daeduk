<%@ page contentType="text/html; charset=UTF-8"%>
<%
 
	thisIndexName = "exbbs";

	if (index.equals("TOTAL") || index.equals(thisIndexName)) {
		indexIdx = proSearch.getIndexIdx(thisIndexName);
		long count = proSearch.getHitsCount(indexIdx);
		long thisIndexCount = proSearch.getTotalHitsCount(indexIdx);

			if ( thisIndexCount > 0 ) {
%>
			<section class="result">
				<div class="sectit">
					<h3><%=proSearch.getMapValue(thisIndexName,"INDEX_VIEW_NAME")%> ( <mark class="em_red"><%=thisIndexCount%></mark>건 )</h3>
				</div>
<%

            MultiSearchResponse.Item sitem =  proSearch.getMultiSearchResponse().getResponses()[indexIdx];
            SearchHit [] hits =  sitem.getResponse().getHits().getHits();


            for ( SearchHit hit : hits ) {
				
		        String p_filetype		= proSearch.getFieldData(hit,"filetype","",false);
		        String p_auth			= proSearch.getFieldData(hit,"auth","",false);
		        String p_fauth			= proSearch.getFieldData(hit,"fauth","",false);
		        String p_subject		= proSearch.getFieldData(hit,"subject","",true);
		        String p_expiredate		= proSearch.getFieldData(hit,"expiredate","",false);
		        String p_body			= proSearch.getFieldData(hit,"body","",true);
		        String p_userid			= proSearch.getFieldData(hit,"userid","",false);
		        String p_deldate			= proSearch.getFieldData(hit,"deldate","",false);
		        String p_expireddate			= proSearch.getFieldData(hit,"expireddate","",false);
		        String p_companyid			= proSearch.getFieldData(hit,"companyid","",false);
		        String p_modifydate			= proSearch.getFieldData(hit,"modifydate","",false);
		        String p_filepath			= proSearch.getFieldData(hit,"filepath","",false);
		        String p_fullpath			= proSearch.getFieldData(hit,"fullpath","",false);
		        String p_alias			= proSearch.getFieldData(hit,"alias","",false);
		        String p_attach			= proSearch.getFieldData(hit,"attach","",true);
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
		        String p_filename			= proSearch.getFieldData(hit,"filename","",true);
		        String p_companyname			= proSearch.getFieldData(hit,"companyname","",false);
		        String p_fullpathname			= proSearch.getFieldData(hit,"fullpathname","",false);
		        String p_regdate			= proSearch.getFieldData(hit,"regdate","",false);
		        String p_anonymous			= proSearch.getFieldData(hit,"anonymous","",false);
		        String p_linkurl			= proSearch.getFieldData(hit,"linkurl","",false);
		        String p_category			= proSearch.getFieldData(hit,"category","",false);
		        String p_username			= proSearch.getFieldData(hit,"username","",true);
		        String URL	= "";

				//하이라이팅시 처리
				p_subject				= ProUtils.getHighlightTag(p_subject,"<font color=red>","</font>");
				p_body					= ProUtils.getHighlightTag(p_body,"<font color=red>","</font>");
				p_filename				= ProUtils.getHighlightTag(p_filename,"<font color=red>","</font>");
				p_attach				= ProUtils.getHighlightTag(p_attach,"<font color=red>","</font>");
				p_username				= ProUtils.getHighlightTag(p_username,"<font color=red>","</font>");
				
				p_filename = p_filename.replace("[","").replace("]","");
				
				String[] files = {};
				
				if(!"".equals(p_filename)){
					files	=	p_filename.split("[,]");
				}
			

		        String viewSubject = ""; 
		        String viewBody    = ""; 
		        String viewDate    = ""; 
		        String viewEtc     = ""; 
				String viewFile    = "";
				String viewAttach   = "";
				String viewUsername = ""; 
				
				viewSubject			 = viewSubject + p_subject;
				viewDate			 = viewDate + p_regdate;
				viewBody			 = viewBody + p_body;
				viewAttach		 = viewAttach + p_attach;
				viewUsername		 = viewUsername + p_username;

				if ( !"".equals(viewDate) ) {
					viewDate          = ProUtils.convertDateFormat(viewDate,"yyyyMMddhhmmss","yyyy/MM/dd");
				}
				
%>				
				<div class="resultbox">
                    <div class="title"><a href="#">[게시판 명] <%=viewSubject%></a></div> 
                    <div class="text"><%=viewBody%></div>  
                    <div class="filebox">
                        <ul class="bu">
<%				
			for(int f = 0; f < files.length; f++){
				viewFile =  files[f];
				viewEtc	 = ProUtils.getFileExt(files[f]).replace("<font color=red>","").replace("</font>","");

				if(!"[]".equals(viewFile)){ %>
							<li>
								<div class="filetitle">
									<span class="text"><img src="images/files/data_<%=viewEtc%>.gif" alt=""> <%=viewFile%></span>
								</div>
								<div class="downbox">
									<a href="#" target="_blank" title="다운로드" class="down">해당파일 다운로드</a>
									<a href="" target="_blank" title="새창" class="view">미리보기</a>
								</div>  
							</li>
<%				}
			} 
%>
                        </ul>
                    </div>  
                </div> 
				<div><%=viewDate%> | <%=viewUsername%></div> 

<%
			}
			if ( "TOTAL".equals(index)  && thisIndexCount > 3 ) {
%>
				<a href="#" onClick="javascript:goIndexSearch('<%=thisIndexName%>');" style="float:right;" >게시판 더보기 &gt;</a>
<%
			}

%>
</section>
<%
		}
	}
%>
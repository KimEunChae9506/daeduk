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
			
            <div id="type2_con">
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
		        regt_dt 				= ProUtils.convertDateFormat(regt_dt,"yyyyMMddHHmmss","yyyy.MM.dd HH:mm:ss");
				
%>

			
                               <div class="type2_list">
                                   <div class="doc_tit applesb"><a href="#"><%=title%></a></div>
                                   <div class="left">
                                       <span><%=regt_id %></span>
                                       <span><%=regt_dt%></span>
                                       <span>조회수 : <em><%=view_cnt%>건</em></span>
                                   </div>
                                   <div class="doc_con"><%=content%></div>
                                   <div class="att_list">
                                       <div><span class="clip"></span>첨부파일 : <em><%=atch_file_nm%></em></div>
                                       <!-- 첨부파일 내용이 있을떄 
                                       <div class="att_con"><div>산업통상자원부, 과학기술정보통신부, 국방부, 국토교통부, 해양수산부, 방위사업청이 주최하고, 한국무인이동체연구조합, 한국드론산업진흥협회, 코엑스가 주관하는 무인이동체 전시회 및 컨퍼런스인 ‘2022 무인이동체산업엑스포(UWC, Unmanned World Congress)’가 17일부터 19일까지 3일간 서울 코엑스에서 개최된다. 무인이동체산업엑스포(UWC)는 지난 2018년 산업부ㆍ과기정통부 주최로 시작된 국내 최초 무인이동체 전문 행사로, 국가 R&D 혁신성</div></div>
                                   		-->
                                   </div>
                                   <div class="tag_list">
                                       <div>지식태그</div>
                                       <ul>
<%									for(int i = 1; i < tags.length; i ++){ //##
%>	
                                       	<li>#<%=tags[i] %></li>
<%									} %>
                                       </ul>
                                   </div>
                               </div>
                               
            
<%
			}
%>			<div class="more_view">검색결과 더보기<span></span></div>
            </div>
<%
		}
	}
%>
<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: dept 페이지
* @original author: SearchTool
*/
	thisCollection = "dept";
	if (collection.equals("ALL") || "custom".equals(collection) || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);
%>
		<section class="result" style="padding:0px; border:0px;">
			<h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
<%
		if ( thisTotalCount > 0 ) {
%>
                <table class="p-table simple" data-table="rwd" data-tabletype="simple" data-breakpoint="765">
                    <caption>직원 및 담당업무 - 부서명, 팀명, 직책, 담당자, 담당업무, 연락처 순으로 내용을 제공하고 있습니다.</caption>
					<colgroup>
						<col style="width:125px">
						<col style="width:150px">
						<col style="width:100px">
						<col style="width:135px">
						<col>
					<colgroup>
					<thead>
                         <tr>
	                         <th scope="col">소속</th>
	                         <th scope="col">직책</th>
	                         <th scope="col">담당자</th>
	                         <th scope="col">연락처</th>
	                         <th scope="col">담당업무</th>
	                     </tr>
                    </thead>
                    <tbody class="small">
<%
			for(int idx = 0; idx < count; idx ++) {
				 String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
	                String DATE                     = wnsearch.getField(thisCollection,"DATE",idx,false);
	                String TITLE                    = wnsearch.getField(thisCollection,"EMPL_NM",idx,false);
	                String CONTENT                  = wnsearch.getField(thisCollection,"EMPL_JOB",idx,false);
	                String CHRG_DEPT_NM             = wnsearch.getField(thisCollection,"CHRG_DEPT_NM",idx,false);
	                String RSPOFC                   = wnsearch.getField(thisCollection,"CLSF",idx,false);
	                String EMPL_TELNO               = wnsearch.getField(thisCollection,"EMPL_TELNO",idx,false);
	                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
	            TITLE= wnsearch.getKeywordHl(TITLE,"<em class=\"em_blue\">","</em>");
				EMPL_TELNO= wnsearch.getKeywordHl(EMPL_TELNO,"<em class=\"em_blue\">","</em>");
				CONTENT= wnsearch.getKeywordHl(CONTENT,"<em class=\"em_blue\">","</em>");
				CHRG_DEPT_NM= wnsearch.getKeywordHl(CHRG_DEPT_NM,"<em class=\"em_blue\">","</em>");
%>
                		<tr>
                            <td class="text_center"><%=CHRG_DEPT_NM%></td>
                            <td class="text_center"><%=RSPOFC%></td>
                            <td class="text_center"><%=TITLE%></td>
                            <td class="text_center"><%=EMPL_TELNO%></td>
                            <td><%=CONTENT%></td>
                        </tr>
<%
			}
%>
					</tbody>
				</table>
<%
			if ((collection.equals("ALL") || "custom".equals(collection)) && thisTotalCount > TOTALVIEWCOUNT ) {
%>
			<a href="javascript:void(0);"  onClick="javascript:doCollection('<%=thisCollection%>');" class="more"><%=wnsearch.getCollectionKorName(thisCollection)%> 검색결과 더보기</a>
<%
			}
		}
%>
		</section>
<%
	}
%>
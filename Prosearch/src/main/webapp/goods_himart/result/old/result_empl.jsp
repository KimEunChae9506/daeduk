<%@ page contentType="text/html; charset=UTF-8"%><%
/*
* subject: empl 페이지
* @original author: SearchTool
*/
	thisCollection = "empl";
	if (collection.equals("ALL") || collection.equals(thisCollection)) {
		int count = wnsearch.getResultCount(thisCollection);
		int thisTotalCount = wnsearch.getResultTotalCount(thisCollection);

		if ( thisTotalCount > 0 ) {
%>
            <section class="result staff">
                <h3><%=wnsearch.getCollectionKorName(thisCollection)%> (총 <mark class="em_red"><%=numberFormat(thisTotalCount)%></mark>건)</h3>
                <table class="table responsive">
                    <caption>직원 및 담당업무 - 부서명, 성명/직위, 전화번호, 담당업무</caption>
                    <colgroup>
                        <col style="width:25%;">
                        <col style="width:25%;">
                        <col style="width:25%;">
                        <col style="width:25%;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th scope="col">부서명</th>
                            <th scope="col">성명/직위</th>
                            <th scope="col">전화번호</th>
                            <th scope="col">담당업무</th>
                        </tr>
					</thead>

<%
			for(int idx = 0; idx < count; idx ++) {
                String DOCID                    = wnsearch.getField(thisCollection,"DOCID",idx,false);
                String DEPT_NM                  = wnsearch.getField(thisCollection,"DEPT_NM",idx,false);
                String EMPL_NM                  = wnsearch.getField(thisCollection,"EMPL_NM",idx,false);
                String EMPL_JOB                 = wnsearch.getField(thisCollection,"EMPL_JOB",idx,false);
                String EMPL_TELNO               = wnsearch.getField(thisCollection,"EMPL_TELNO",idx,false);
                String ALIAS                    = wnsearch.getField(thisCollection,"ALIAS",idx,false);
				DEPT_NM= wnsearch.getKeywordHl(DEPT_NM,"<font color=red>","</font>");
				EMPL_NM= wnsearch.getKeywordHl(EMPL_NM,"<font color=red>","</font>");
				EMPL_JOB= wnsearch.getKeywordHl(EMPL_JOB,"<font color=red>","</font>");
				EMPL_TELNO= wnsearch.getKeywordHl(EMPL_TELNO,"<font color=red>","</font>");
            String URL = "URL 정책에 맞게 작성해야 합니다.";

%>
	                <tr>
	                    <td><%=DEPT_NM%></td>
	                    <td>
	                        <strong><%=EMPL_NM%></strong><br>
	                        주무관
	                    </td>
	                    <td><%=EMPL_TELNO%></td>
	                    <td class="text_left">
	                        <%=EMPL_JOB%>
	                    </td>
	                </tr>
 <%
			}

%>
	             </tbody>
	         </table>
<%
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
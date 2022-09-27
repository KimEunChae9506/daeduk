// /srchengn/openSrchMain.do => 원래 검색페이지 주소

//추천태그 확장 검색
function addTagSearch() {
	var searchForm = document.searchUserTopForm;
	searchForm.tagSchYn.value = "n";
	searchForm.pageNo.value = "1";
	searchForm.action = "saerom.jsp";

	searchForm.submit();
}

// 검색
function goSearch() {
	var searchForm = document.searchUserTopForm; 

	if (searchForm.srchParam.value == "") {
		alert("검색어를 입력하세요.");
		searchForm.srchParam.focus();
		return;
	}
	
	searchForm.pageNo.value = "1";
	searchForm.tagSchYn.value = "y";
	searchForm.action = "saerom.jsp";
	
	searchForm.submit();
}

//엔터 체크	
function pressCheckEnter() {   
	if (event.keyCode == 13) {
		return funRunSrchEngn();		
	}else{
		return false;
	}
} 

// 정렬
function goPage(pageNo) {
    //alert("sort=" + sort);
	var searchForm = document.searchUserTopForm;
	searchForm.srchParam.value = document.getElementById("in_srchParam").value;
	searchForm.pageNo.value = pageNo;
	searchForm.action = "saerom.jsp";
	searchForm.submit();
}

function doSearchKeyword(searchkeyword) {
	var searchForm = document.searchUserTopForm; 

	searchForm.pageNo.value = "1";
	searchForm.srchParam.value = searchkeyword;
	searchForm.tagSchYn.value = "y";
	searchForm.action = "saerom.jsp";
	searchForm.submit();
}

//문서분류 필터검색
function docFilterSearch()  {
	// 선택된 목록 가져오기
	$("input:checkbox[class='checked']").prop("checked", true);
	var qCode = "input[class='checked']:checked";
	var selectedChks = document.querySelectorAll(qCode);
	
	// 선택된 목록에서 value 찾기
	var result = '';
	var searchForm = document.searchUserTopForm;  

  	selectedChks.forEach(function(item){
	   if (result != '') {
		 result += "|";
  	   }
  	   if(item.value != 'on'){
		 result += item.value;
	   }
	 })
	searchForm.techDocOpt.value = result;
}

//그룹핑 검색(좌측메뉴)
function goGroupSearch(key)  {

	var searchForm = document.searchUserTopForm; 
	searchForm.srchParam.value = document.getElementById("in_srchParam").value;
	searchForm.pageNo.value = "1";
	searchForm.tagSchYn.value = "y";
	searchForm.techDocOpt.value = key;
	searchForm.action = "saerom.jsp";
	
	searchForm.submit();
}


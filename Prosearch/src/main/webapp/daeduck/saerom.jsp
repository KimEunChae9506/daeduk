<%@ page contentType="text/html; charset=UTF-8"%><% request.setCharacterEncoding("UTF-8");%>
<!doctype html>
<html lang="ko">
<head>
<meta charset="utf-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>지식검색포탈</title>
<link rel="stylesheet" type="text/css" href="/resources/css/daeduck/common.css">
<link rel="stylesheet" type="text/css" href="/resources/css/daeduck/style.css">
<link rel="stylesheet" type="text/css" href="/resources/css/daeduck/font.css">
<link rel="stylesheet" href="/resources/css/mcustomscrollbar.css">
<link rel="stylesheet" href="/resources/css/daeduck/mcustomscrollbar.css">
<script src="/resources/js/search/jquery.min.js"></script>
<script src="/resources/js/search/jquery.mCustomScrollbar.concat.min.js"></script>
<script src="/resources/js/search/jquery-ui.js"></script>
<script src="/resources/js/search/common.js"></script>
<script src="/resources/js/search/prosearch.js"></script>
<script src="/resources/js/search/autokeyword.js"></script>

</head>
<body>
<div class="search_wrap">
        
<form id="searchUserTopForm" name="searchUserTopForm" method="post">
<input type="hidden" id="srchParam" name="srchParam"/>
<input type="hidden" id="techDocOpt" name="techDocOpt"/>
<input type="hidden" name="pageNo" value="1">
<input type="hidden" name="tagSchYn" value="">
</form>	
        <div class="header">
            <h1 class="logo inline-block">
                <a href="main.html">
                    <img src="./images/svg/logo.svg" alt="로고">
                    <span class="inline-block applesb ms5">기술문서검색포탈</span>
                </a>
            </h1>
            <div class="search_box">
                <div class="search_bar inline-block">
                    <input type="text" name="in_srchParam" id="in_srchParam" value="" onKeypress="javascript:pressCheckEnter((event),this);" autocomplete="off" placeholder="검색어를 입력하세요">
                    <span class="sc_icon" onclick="javascript:goSearch()"></span>
                    <!-- 자동완성(s) -->
                    	<div class="auto_complete">
	                    </div>
                    <!-- 자동완성(e) -->
            	</div>
	            <div class="filter_check inline-block">
	               <div class="type01 ty_pe">
	                   <input type="checkbox" name="check01">
	                   <label for="check01" class="applesb">업무검색</label>
	               </div>
	               <div class="type02 ty_pe">
	                   <input type="checkbox" name="check02">
	                   <label for="check02" class="applesb">문서분류</label>
	               </div>
	            </div>
            </div>
            <div class="user_if">
                <div class="user_info relative">
                    <span class="level_img">
                        <img src="./images/level01.png">
                    </span>
                    <div class="user_name inline-block">
                        <div class="name"><span class="level">[열심회원]</span><span>홍길동님</span></div>
                    </div>
                    <div class="name_card">
                        <div>
                            <span class="user_level inline-block">
                                <img src="./images/big_level01.png">
                            </span>
                            <dl class="inline-block">
                                <dt class="appleb">홍길동</dt>
                                <dd>열심회원</dd>
                            </dl>
                        </div>
                        <div class="card_btm mt35">
                            <div class="card_list">
                                <span class="inline-block">게시글수</span>
                                <span class="inline-block"><a href="javascript:;">10개</a></span>
                            </div>
                            <div class="card_list">
                                <span class="inline-block">댓글</span>
                                <span class="inline-block"><a href="javascript:;">30개</a></span>
                            </div>
                        </div>
                        <div class="close_btn"></div>
                    </div>
                </div>
                <div class="logout applesb">로그아웃</div>
            </div>
        </div>
        <%@ include file="./search.jsp" %>
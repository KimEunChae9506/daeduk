$(function(){ 
   $(".modal-exp").click(function() { 
	 $('.modal').hide();  
	 setCookie("mycookie", 'popupEnd', 31); //만기일 31일
    });
  
	var checkCookie = getCookie("mycookie");

	if(checkCookie == 'popupEnd') {
		$('.modal').css('display','none');  
	} else {
		$('.modal').css('display','block');  
	}
  
  	$(".modal-close").click(function() {   
  	  $('.modal').hide();        
  	});

});


function setCookie(name, value, expiredays){
  var today = new Date();
  
  today.setDate(today.getDate() + expiredays); // 현재시간에 더함
  document.cookie = name + '=' + escape(value) + '; expires=' + today.toGMTString();
}
	
function getCookie(name) {

 var cookie = document.cookie;

 if (document.cookie != "") {
	var cookie_array = cookie.split("; ");
	console.log(cookie_array)
	for ( var index in cookie_array) {
		var cookie_name = cookie_array[index].split("=");
		if (cookie_name[0] == "mycookie") {
			return cookie_name[1];
		}
	}
 }
 return;
}
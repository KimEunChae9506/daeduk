$(document).ready(function(){
    $('.name').on('click',function(){
        $('.name_card').addClass('active');
    });
    $('.close_btn').on('click',function(){
        $('.name_card').removeClass('active');
    });
    $('.more_menu').on('click',function(){
        $(this).siblings('.menu_list').toggleClass('active');
        $(this).parent('.list_item').siblings('.list_item').find('.menu_list').removeClass('active');
    });
    $('.select_txt').on('click',function(){
        $(this).siblings('.menu_list').toggleClass('active');
    });
    $( function() {
        $(".move_area").sortable({
            handle:".move_ic",
        });
    });
    
    // 게시판 리스트
    $('.depth02 li a').on('click',function(){
        $(this).parent('li').addClass('active');
        $(this).parent('li').siblings('li').removeClass('active');
        $(this).parents('.gnb_item').siblings('.gnb_item').find('.depth02 li').removeClass('active');
    });
    $('.fav_ic').on('click',function(){
        $(this).toggleClass('active');
    });
    $('.tg_btn').on('click',function(){
        $(this).toggleClass('active');
        $(this).parent('div').siblings('.depth02').slideToggle();
    });
    $('.write_btn').on('click',function(){
		$(location).attr("href", "")
	})
    $('.page_count span').on('click',function(){
        $(this).addClass('active');
        $(this).siblings('span').removeClass('active');
    });
    // 게시판 쓰기
    $('.del_btn').on('click',function(){
        $(this).parent('.doc_item').remove();
    });
    $('.con_inner textarea').on('click',function(){
        $(this).siblings('.tag_box').toggleClass('active');
    });
    $('.doc_select').on('click',function(){
        $('.category_box').addClass('active');
    });
    $('.box_close').on('click',function(){
        $('.category_box').removeClass('active');
    });
    $('.all_btn').on('click',function(){
        $('.file_all label').toggleClass('checked');
		var checked = $('.file_all label').hasClass('checked');
		if(checked)
			$('.fl_check label').addClass('checked');
        else{
            $('.fl_check label').removeClass('checked');
        }
	});
    $('.file_all label').on('click',function(){
        $(this).toggleClass('checked');
		var checked = $('.file_all label').hasClass('checked');
		if(checked)
			$('.fl_check label').addClass('checked');
        else{
            $('.fl_check label').removeClass('checked');
        }
	});
    $('.fl_check label').on('click',function(){
        $(this).toggleClass('checked');
        $('.file_all label').removeClass('checked');
    });
    // 게시판 보기
    $('.like_box').on('click',function(){
        $(this).addClass('active');
    });
    $('.input_box input').on('click',function(){
        $(this).parent('.input_box').toggleClass('active');
    });
    $('.w_com').on('click',function(){
        $(this).parent('.sub_btns').siblings('.in_box02').toggleClass('active');
    });
    $('.v_com').on('click',function(){
        $(this).parent('.sub_btns').siblings('.dep1_com_line02').toggleClass('active');
    });
    
    /* 서브페이지 filter_box */
    $('.filter_check .type02 input').on('click',function(){
        $(this).toggleClass('checked');
        var checked = $('.filter_check .type02 input').hasClass('checked');
		if(checked)
			$('.filter_box').slideDown();
        else {
            $('.filter_box').slideUp();
        }
    });
    $('.filter_close').on('click',function(){
        $('.filter_check .type02 input').removeClass('checked');
        $('.filter_box').slideUp();
    });
    // 통합검색 페이지
    $('.types_con > div').hide();
    $('.type_op span a').on('click',function () { 
        $(this).parent('span').addClass('active');
        $(this).parent('span').siblings('span').removeClass('active');
        $('.types_con > div').hide().filter(this.hash).show();
        return false; 
    }).filter(':eq(0)').click(); 
    $('.results_list ul li a').on('click',function(){
        $(this).parent('li').addClass('active');
        $(this).parent('li').siblings('li').removeClass('active');
    });

});
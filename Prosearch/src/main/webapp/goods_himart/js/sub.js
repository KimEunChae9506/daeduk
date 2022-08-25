var $widnow = $(window);

$widnow.on('load', function(event) {


    function setScrollWidth(element) {
        var $element = $(element),
            $item = $element.children(),
            width = 0;

        $item.each(function(index, element) {
            width += ($item.eq(index).outerWidth(true) || 0) + 1;
        });

        $element.width(width);
    }

    //스크롤 처리
    $widnow.on('resize', function(event) {
        var nowstate = $.responsive.setting.nowState[0];

        if(nowstate != 'wide'){
            setScrollWidth('.fit ul');
            setScrollWidth('.lnb ul');
        }
        if(nowstate == 'wide'){
            $('.lnb .depth1 .depth_list').removeAttr('style');
        }
    }).triggerHandler('resize');

	//검색어 제거
	$('.removetext').on('click', function(event) {
		var $totalsearch = $('.total_search');
		$totalsearch.prop('value', '');
	});

    //인기검색어
    var $rank = $('.rank'),
        $rankTabContent = $rank.find('.tab_content');

    $rank.find('.tab_nav a').on('click', function(event) {
        var $this = $(this);

        $this.addClass('active').siblings('a').removeClass('active');
        $rankTabContent.removeClass('active').eq($this.index()).addClass('active');

        event.preventDefault();
    });

    //옵션
    $('.option_btn').on('click', function(event) {
        var $this = $(this),
            $optionType = $this.parents('.option_type'),
            $optionList = $optionType.children('ul');

        //애니메이션이 끝났을 때
        if(!$optionList.is(':animated')) {
            $optionList.slideToggle(250);
            $optionType.toggleClass('active').siblings('.option_type').removeClass('active').children('ul').slideUp(250);
        }
    });

    //달력 토글
    $('.calendar_btn').on('click', function(event) {
        var $this = $(this),
            $calendarContent = $this.next('.calendar_content');

        //애니메이션이 끝났을 때
        if(!$calendarContent.is(':animated')) {
            $calendarContent.slideToggle(250).parent('.calendar').toggleClass('active');
        }
    });

    //달력 닫기
    $('.calendar_close, .calendar_submit').on('click', function(event) {
        var $this = $(this),
            $calendarContent = $this.parents('.calendar_content');

        //애니메이션이 끝났을 때
        if(!$calendarContent.is(':animated')) {
            $calendarContent.slideUp(250).parents('.calendar').removeClass('active');
        }
    });
    
    //반응형 테이블
    $('table.table.responsive').not($('.prettyprint').children()).not('.call_table').each(function() {
        var RowSpanExist = $(this).find('td, th').is('[rowspan]'),
            TheadExist = $(this).find('thead').length;
        if((RowSpanExist==false) && (TheadExist!=0)){//rowspan이 없을 경우만 실행 (rowspan이 있으면 지원불가)
            $(this).children('tbody').children('tr').find('th, td').each(function() {
                var ThisIndex = $(this).index(),
                    TheadText = $(this).parents('tbody').siblings('thead').find('th').eq(ThisIndex).text();
                $(this).attr('data-content', TheadText);
            });
            $(this).children('tfoot').children('tr').find('th, td').each(function() {
                var ThisIndex = $(this).index(),
                    TheadText = $(this).parents('tfoot').siblings('thead').find('th').eq(ThisIndex).text();
                $(this).attr('data-content', TheadText);
            });
        };
    });

    //가상키보드 포커스 처리


});
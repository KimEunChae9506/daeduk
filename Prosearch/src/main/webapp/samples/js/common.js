(function($) {
    'use strict';

    /* 브라우저마다 클래스 추가 */
    var $window = $(window),
        $html = $('html');

    //브라우저
    var _browser = navigator.userAgent.toLowerCase();

    //ie7일 때
    if(_browser.indexOf('msie 7.0') > -1) {
        _browser = 'ie ie7';

        //ie8일 때
    }else if(_browser.indexOf('msie 8.0') > -1) {
        _browser = 'ie ie8';

        //ie9일 때
    }else if(_browser.indexOf('msie 9.0') > -1) {
        _browser = 'ie ie9';

        //ie10일 때
    }else if(_browser.indexOf('msie 10.0') > -1) {
        _browser = 'ie ie10';

        //ie11일 때
    }else if(_browser.indexOf('trident/7.0') > -1) {
        _browser = 'ie ie11';

        //edge일 때
    }else if(_browser.indexOf('edge') > -1) {
        _browser = 'edge';

        //opera일 때
    }else if(_browser.indexOf('opr') > -1) {
        _browser = 'opera';

        //chrome일 때
    }else if(_browser.indexOf('chrome') > -1) {
        _browser = 'chrome';

        //firefox일 때
    }else if(_browser.indexOf('firefox') > -1) {
        _browser = 'firefox';

        //safari일 때
    }else if(_browser.indexOf('safari') > -1) {
        _browser = 'safari';
    }else{
        _browser = 'unknown';
    }

    /**
     * @name 브라우저 얻기
     * @since 2017-12-06
     * @return {string}
     */
    window.getBrowser = function() {
        return _browser;
    };

    //브라우저 클래스 추가
    $html.addClass(_browser);

    $(function() {
        /*맞춤복지서비스*/
        var $service_open = $('.header_top .service_button'),
            $service_close = $('.welfare_service .layer_close');
        $('.service_button, .welfare_service .layer_close').on('click', function() {
            var IsOpen = $html.is('.layer_open');

            if(IsOpen){
                $html.removeClass('layer_open');
                $('.welfare_service').fadeOut(300);
                $service_open.focus();
            } else{
                $html.addClass('layer_open');
                $('.welfare_service').fadeIn(300);
                $service_close.focus();
                // if(mode === 'mobile'){
                //     $html.removeClass('lnb_show');
                // }
            }
        });
        $('.welfare_service .btn_wrap .bt.search').on('focusout', function() {
            // $html.removeClass('layer_open');
            // $('.welfare_service').fadeOut(300);
            $service_close.focus();
        });

        /*철원 패밀리사이트*/
        var $family_open = $('.header_top .family_button'),
            $family_close = $('.family_home .layer_close');
        $('.family_button, .family_home .layer_close').on('click', function() {
            var IsOpen = $html.is('.layer_open.family'),
                max_h = 0;

            if(IsOpen){
                $html.removeClass('layer_open family');
                $('.family_home').fadeOut(300);
                $family_open.focus();
            } else{
                $html.addClass('layer_open family');
                $('.family_home').fadeIn(300);
                $family_close.focus();
                // if(mode === 'mobile'){
                //     $html.removeClass('lnb_show');
                // }
            }
            /*높이*/
            // if($.screen.settings.state[0] === 'tablet' || mode === 'pc') {
            //     $(".family_home .site_list > ul > li").each(function(){
            //         var h = parseInt($(this).outerHeight() + 10);
            //         if(max_h < h){ max_h = h; }
            //     });
            //     $(".family_home .site_list > ul > li").each(function(){
            //         $(this).css({height:max_h});
            //     });
            // }
        });

        $('.family_home .site_list > ul > li:last-child .list li:last-child a').on('focusout', function() {
            // $html.removeClass('layer_open');
            // $('.family_home').fadeOut(300);
            $family_close.focus();
        });

        $('.detail_search').on('click', function(){
            var $detailbox = $('.detailbox'),
                IsActive = $detailbox.is('.active');
            if(!IsActive){
                $detailbox.addClass('active').slideDown();
            } else{
                $detailbox.removeClass('active').slideUp();
            };
        });
        $('.detail_close').on('click', function(){
            var $detailbox = $('.detailbox'),
                $detailsearchbtn = $('.detail_search');
            $detailbox.removeClass('active').slideUp();
            $detailsearchbtn.focus();
        });

        $('.searchbox .detailbox .itembox .period_btn').on('click', function(){
            var $this = $(this),
                period = $this.attr('data-period'),
                IsActive = $this.is('.active');
            if(!IsActive){
                $this.addClass('active').siblings('.period_btn').removeClass('active');
                //setDate(period);
            };
        });

        $('.searchbox .detailbox .listbox .itembox.range .temp_checkbox input[type="checkbox"]').on('click', function(){
            var $this = $(this),
                $MyParent = $this.parent('.temp_checkbox'),
                $OtherParents = $MyParent.siblings('.temp_checkbox'),
                $OtherCheckbox = $OtherParents.find('input[type="checkbox"]'),
                DATAAll = $this.attr('data-all'),
                AllBtn = $('.searchbox .detailbox .listbox .itembox.range').find('input[type="checkbox"][data-all="y"]'),
                IAmChecked = $this.is(':checked'),
                AllBtnIsChecked = AllBtn.is(':checked');
            if(DATAAll=='y'){
                if(AllBtnIsChecked){
                    $OtherCheckbox.prop('checked', true);
                } else{
                    $OtherCheckbox.prop('checked', false);
                };
            } else{
                if(AllBtnIsChecked){
                    AllBtn.prop('checked', false);
                };
            };
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
        

    });

})(window.jQuery);
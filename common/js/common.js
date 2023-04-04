function lyp(i){//레이어팝업용
	$("body").append("<div class='dimm'></div>");
	a = $("."+i).outerHeight();
	console.log(a);
	$("."+i).show();
};

$(function(){
	$(".btn_close").on("click",function(e){
		e.preventDefault();
		$(".lypp_adm_default").hide();
		$(".dimm").remove();
	});
});
$(function(){
	$(document).on("click",".tab_box ul li a",function(e){
		e.preventDefault();
		$(this).parent().siblings("li").removeClass("on");
		$(this).parent().addClass("on");
		var tab_id_href = $(this).attr("href");
		var tab_id = tab_id_href.substring(1);
		$(this).parent().parent().parent().siblings(".tab_cont").removeClass("on");
		$("#"+tab_id).addClass("on");
	});

	$(document).on("click",".slide_cate a",function(e){
		e.preventDefault();
		$(".slide_cate a").removeClass("on");
		$(this).addClass("on");
		var tab_id_href = $(this).attr("href");
		var tab_id = tab_id_href.substring(1);
		$(this).parent().siblings(".tab_cont").removeClass("on");
		$("#"+tab_id).addClass("on");

		$(".slide_2").slick("unslick");
		$(".slide_2").slick({
			infinite : true,
			arrows : false,
			slidesToShow : 1,
			SlidesToScroll : 1
		});
	});
	//메인 분양소식 슬라이더

	var slick_mov = $(".slide_2").slick({
		infinite : true,
		arrows : false,
		slidesToShow : 1,
		SlidesToScroll : 1
	});
	$(".btn_gs2_prev").on("click",function(e){
		e.preventDefault();
		$(".slide_2").slick("slickPrev");
	});
	$(".btn_gs2_next").on("click",function(e){
		e.preventDefault();
		$(".slide_2").slick("slickNext");
	});
});

$(function(){
    $(document).on("click",".ux_btn_wrt",function(e){
        e.preventDefault();
        $(".wrt_group_box").children(".btn_box").toggleClass("on");
    });
});


$(function(){
	$("#remote > button").on("click",function(e){
		e.preventDefault();
		$("#remote > button").removeClass("on");
		$(this).addClass("on");
		var a = $(this).attr("data-code");
		var b = $("body[class^='c_']");
		//$("body").removeClass();
		console.log(b);
		$("body").addClass(a);
	});
	
	$(document).on("click",".btn_decotation",function(e){
		e.preventDefault();
		$("#decorate").animate({right:0},300);
		$("body").append("<div class='dimm'></div>");
		$("body").css({
			overflow : "hidden"
		});
	});
	$(document).on("click",".btn_decorate_close",function(e){
		e.preventDefault();
		$("#decorate").animate({right:-600},300);
		$(".dimm").remove();
		$("body").css({
			overflow : "visible"
		});
	});
	$(document).on("click",".deco_dl > dt > button",function(e){
		e.preventDefault();
		$(this).parent().toggleClass("on");
		$(this).parent().next().slideToggle();
	});

	$(".side_menu_on > li > a").on("click",function(e){// 좌측메뉴 슬라이드
		e.preventDefault();
		$(this).parent().toggleClass("on");
		$(this).siblings().slideToggle();
	});

	//크기 변경
	$("input[type=radio][name=boxModel]").change(function(){
		var wrapSize = $(this).attr("data-tmp-code");
		$("#wrap").removeClass("wrapSize_full wrapSize_comp").addClass(wrapSize);
		if(wrapSize == "wrapSize_full"){
			$(".wrapSize_comp-box").hide();
		}else{
			$(".wrapSize_comp-box").show();
		}
	});

	//정렬 변경
	$("input[type=radio][name=boxAlign]").change(function(){
		var wrapAlign = $(this).attr("data-tmp-code");
		$("#wrap").removeClass("wrapAlign_center wrapAlign_left").addClass(wrapAlign);
	});

	//좌측메뉴 스킨 변경
	$("input[type=radio][name=skin]").change(function(){
		var skin_keyword = $(this).attr("data-skin-code");
		if(skin_keyword == "dsc_none"){
			$("#nav_gnb").removeClass("dsc_1 dsc_2 dsc_3 dsc_4 dsc_5").addClass("group_nav");
		}else{
			$("#nav_gnb").removeClass("dsc_1 dsc_2 dsc_3 dsc_4 dsc_5").addClass(skin_keyword);
		}
	});

	//전체 배경색상 변경
	var AllBg = ["bg_1","bg_2","bg_3","bg_4","bg_5","bg_6"];
	$("input[type=radio][name=bg]").change(function(){
		var body_bg = $(this).attr("data-color-bg");
		$("body").removeClass(AllBg).addClass(body_bg);
	});

	//상단 배경 변경
	var TopBg = ["bgTop_1","bgTop_2","bgTop_3","bgTop_4","bgTop_5","bgTop_6"];
	$("input[type=radio][name=bgT]").change(function(){
		var head_bg = $(this).attr("data-color-bgTop");
		$("#header").removeClass(TopBg).addClass(head_bg);
	});

	//좌측 색상 변경
	var LeftBg = ["bgL_1","bgL_2","bgL_3","bgL_4","bgL_5","bgL_6"];
	$("input[type=radio][name=bgL]").change(function(){
		var left_bg = $(this).attr("data-color-left");
		$("#nav_gnb").removeClass(LeftBg).addClass("group_nav").addClass(left_bg);
	});
});

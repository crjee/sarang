<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
	checkModifyAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>분양소식 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<!-- 달력 시작 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd' //달력 날짜 형태
		,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
		,changeYear: true //option값 년 선택 가능
		,changeMonth: true //option값  월 선택 가능                
		,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
		,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
		,buttonImageOnly: true //버튼 이미지만 깔끔하게 보이게함
		,buttonText: "선택" //버튼 호버 텍스트              
		,yearSuffix: "년" //달력의 년도 부분 뒤 텍스트
		,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
		,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
		,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 텍스트
		,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip
		,minDate: "-5Y" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		,maxDate: "+5y" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)  
	});

	$( function() {
		$("#rect_notice_date").datepicker();
		$("#frst_receipt_acpt_date").datepicker();
		$("#scnd_receipt_acpt_date").datepicker();
		$("#prize_anc_date").datepicker();
		$("#cnt_st_date").datepicker();
		$("#cnt_ed_date").datepicker();
		$("#resale_st_date").datepicker();
		$("#resale_ed_date").datepicker();
		$("#mvin_date").datepicker();
	} );
</script>
<!-- 달력 끝 -->
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	nsale_seq = Request("nsale_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_nsale "
	sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And session("user_id") <> rs("user_id") then
			Response.Write "<script>alert('수정 권한이없습니다');history.back();</script>"
			Response.End
		End If

		subject                = rs("subject")
		open_yn                = rs("open_yn")
		nsale_addr             = rs("nsale_addr")
		cmpl_se_cd             = rs("cmpl_se_cd")
		nsale_stts_cd          = rs("nsale_stts_cd")
		rect_notice_date       = rs("rect_notice_date")
		frst_receipt_acpt_date = rs("frst_receipt_acpt_date")
		scnd_receipt_acpt_date = rs("scnd_receipt_acpt_date")
		prize_anc_date         = rs("prize_anc_date")
		cnt_st_date            = rs("cnt_st_date")
		cnt_ed_date            = rs("cnt_ed_date")
		resale_st_date         = rs("resale_st_date")
		resale_ed_date         = rs("resale_ed_date")
		mvin_date              = rs("mvin_date")
		mdl_house_addr         = rs("mdl_house_addr")
		contents               = rs("contents")
		creid                  = rs("creid")
		credt                  = rs("credt")
		modid                  = rs("modid")
		moddt                  = rs("moddt")
		cafe_id                = rs("cafe_id")
		nsale_seq              = rs("nsale_seq")
		top_yn                 = rs("top_yn")
		view_cnt               = rs("view_cnt")
		parent_seq             = rs("parent_seq")
		parent_del_yn          = rs("parent_del_yn")
		restoreid              = rs("restoreid")
		restoredt              = rs("restoredt")
		comment_cnt            = rs("comment_cnt")
		step_num               = rs("step_num")
		group_num              = rs("group_num")
		menu_seq               = rs("menu_seq")
		user_id                = rs("user_id")
		level_num              = rs("level_num")
		nsale_num              = rs("nsale_num")
		section_seq            = rs("section_seq")
		link     = rs("link")
		subject  = Replace(subject, """", " & quot;")

		If link = "" Then
			link = "http://"
		End If
	End if
	rs.close

	If contents = "" Then
		sql = ""
		sql = sql & " select form "
		sql = sql & "   from cf_com_form "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		rs.Open Sql, conn, 3, 1
		If Not rs.eof Then
			contents = rs("form")
		End If
		rs.close
	End If
%>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 수정</h2>
				</div>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="pagesize" value="<%=pagesize%>">
					<input type="hidden" name="sch_type" value="<%=sch_type%>">
					<input type="hidden" name="sch_word" value="<%=sch_word%>">

					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="nsale_seq" value="<%=nsale_seq%>">
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">공개<em class="required">필수입력</em></th>
								<td colspan="3">
									<%=makeRadioCD("open_yn", open_yn, "")%>
								</td>
							</tr>
							<tr>
								<th scope="row">단지명/제목<em class="required">필수입력</em></th>
								<td colspan="3">
									<input type="text" id="subject" name="subject" value="<%=subject%>" class="inp" required>
								</td>
							</tr>
<%
	If tab_use_yn = "Y" Then
%>
							<tr>
								<th scope="row"><%=tab_nm%><em class="required">필수입력</em></th>
								<td>
									<%=makeSection("R", "section_seq", section_seq, "")%>
								</td>
							</tr>
<%
	End If
%>
							<tr>
								<th scope="row">분양주소</th>
								<td colspan="3">
									<input type="text" id="nsale_addr" name="nsale_addr" value="<%=nsale_addr%>" class="inp">
								</td>
							</tr>
							<tr>
								<th scope="row">단지종류<em class="required">필수입력</em></th>
								<td>
									<%=makeRadioCD("cmpl_se_cd", cmpl_se_cd, "")%>
								</td>
								<th scope="row">분양단계<em class="required">필수입력</em></th>
								<td>
									<%=makeRadioCD("nsale_stts_cd", nsale_stts_cd, "")%>
								</td>
							</tr>
							<tr>
								<th scope="row">모집공고일</th>
								<td>
									<span class="">
									<input type="text" id="rect_notice_date" name="rect_notice_date" value="<%=rect_notice_date%>" class="inp w120p" />
									</span>
								</td>
								<th scope="row">청약접수일</th>
								<td>
									<span class="">
										<em class="mr5">1순위</em>
										<input type="text" id="frst_receipt_acpt_date" name="frst_receipt_acpt_date" value="<%=frst_receipt_acpt_date%>" class="inp w120p" />
									</span>
									<span class="ml20">
										<em class="mr5">2순위</em>
										<input type="text" id="scnd_receipt_acpt_date" name="scnd_receipt_acpt_date" value="<%=scnd_receipt_acpt_date%>" class="inp w120p" />
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">당첨발표일</th>
								<td>
									<input type="text" id="prize_anc_date" name="prize_anc_date" value="<%=prize_anc_date%>" class="inp w120p" />
								</td>
								<th scope="row">계약기간</th>
								<td>
									<input type="text" id="cnt_st_date" name="cnt_st_date" value="<%=cnt_st_date%>" class="inp w120p" />  ~ 
									<input type="text" id="cnt_ed_date" name="cnt_ed_date" value="<%=cnt_ed_date%>" class="inp w120p" />
								</td>
							</tr>
							<tr>
								<th scope="row">전매기간</th>
								<td>
									<input type="text" id="resale_st_date" name="resale_st_date" value="<%=resale_st_date%>" class="inp w120p" />  ~ 
									<input type="text" id="resale_ed_date" name="resale_ed_date" value="<%=resale_ed_date%>" class="inp w120p" />
								</td>
								<th scope="row">입주일</th>
								<td>
									<input type="text" id="mvin_date" name="mvin_date" value="<%=mvin_date%>" class="inp w120p" />
								</td>
							</tr>
							<tr>
								<th scope="row">모델하우스 위치</th>
								<td colspan="3">
									<input type="text" id="mdl_house_addr" name="mdl_house_addr" value="<%=mdl_house_addr%>" class="inp">
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
<%
	If editor_yn = "Y" Then
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	Else
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	End If
%>
						<p class="txt_point mt10">새로고침시 에디터 내용은 유지되지 않습니다.</p>
					</div>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	menu_type = "nsale"
	com_seq = nsale_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>등록</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='nsale_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
<script>
	var oEditors = [];

	// 추가 글꼴 목록
	//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];

	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "ir1",
		sSkinURI: "/smart/SmartEditor2Skin.html",
		htParams : {
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
			fOnBeforeUnload : function() {
			}
		}, //boolean
		fOnAppLoad : function() {
			//예제 코드
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
		},
		fCreator: "createSEditor2"
	})

	function submitContents(elClickedObj) {
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
		try {
<%
	If tab_use_yn = "Y" Then
%>
			if ( ! $('input[name=section_seq]:checked').val()) {
				alert('<%=tab_nm%>을 선택해주세요.');
				return false;
			}
<%
	End If
%>
			elClickedObj.action = "nsale_modify_exec.asp";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()
		} catch(e) {alert(e)}
	}
</script>
</html>

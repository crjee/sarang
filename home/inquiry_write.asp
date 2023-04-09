<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>광고/제휴문의 등록</title>
	<link rel="stylesheet" type="text/css" href="/common/css/styles.css">
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
			<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" id="attachCnt" name="attachCnt" value="1">
			<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2">광고/제휴 문의하기</h2>
					<span class="posR"><em class="required">필수입력</em>는 필수 기재 항목입니다.</span>
				</div>
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
								<th scope="row">문의구분<em class="required">필수입력</em></th>
								<td colspan="3">
									<span class="">
										<input type="radio" id="s_group1" name="s_group" class="inp_radio" required>
										<label for="s_group1"><em>개인</em></label>
									</span>
									<span class="ml20">
										<input type="radio" id="s_group2" name="s_group" class="inp_radio" required>
										<label for="s_group2"><em>단체</em></label>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">회사명<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="" name="" class="inp">
								</td>
								<th scope="row">담당자 연락처<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">담당자 이메일 주소<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
								<th scope="row">담당자 이름<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th>
								<td colspan="3">
									<input type="text" id="" name="" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
								<td colspan="3">
									<input type="text" id="" name="" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">찾아보기</button>
									<p class="txt_point mt10">파일형식은 hwp, doc(docx), ppt, pdf 파일만 등록 가능합니다.</p>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
					</div>
					<div class="agree_box mt30">
						<h3 class="h3">개인정보 수집이용에 대한 동의</h3>
						<ul class="">
							<li>수집항목 : [필수] 담당자 연락처, 담당자 이메일 주소, 회사명, 담당자 이름</li>
							<li>수집항목 : [필수] 담당자 연락처, 담당자 이메일 주소, 회사명, 담당자 이름</li>
							<li>수집항목 : [필수] 담당자 연락처, 담당자 이메일 주소, 회사명, 담당자 이름</li>
						</ul>
					</div>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="reset" class="btn btn_c_n btn_n"><em>취소</em></button>
				</div>
			</form>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>
<script>
	var oEditors = [];

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
				var f = document.form;
				if (f.temp.value == "Y" && f.subject.value != "")
				{
					oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
					f.action = "board_temp_exec.asp";
					f.temp.value = "N";
					f.target = "hiddenfrm";
					f.submit();
					alert("작성중인 내용이 임시로 저장되었습니다.");
				}
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
			elClickedObj.action = "inquiry_exec.asp";
			elClickedObj.temp.value = "N";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()
		} catch(e) {alert(e)}
	}
</script>

<script>
	function fc_chk_byte(frm_nm, ari_max, cnt_view) { 
	//	var frm = document.regForm;
		var ls_str = frm_nm.value; // 이벤트가 일어난 컨트롤의 value 값 
		var li_str_len = ls_str.length; // 전체길이 

		// 변수초기화 
		var li_max = ari_max; // 제한할 글자수 크기 
		var i = 0; // for문에 사용 
		var li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
		var li_len = 0; // substring하기 위해서 사용 
		var ls_one_char = ""; // 한글자씩 검사한다 
		var ls_str2 = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다. 

		for (i=0; i< li_str_len; i++) { 
		// 한글자추출 
			ls_one_char = ls_str.charAt(i); 

			// 한글이면 2를 더한다. 
			if (escape(ls_one_char).length > 4) { 
				li_byte += 2; 
			} 
			// 그밗의 경우는 1을 더한다. 
			else { 
				li_byte++; 
			} 

			// 전체 크기가 li_max를 넘지않으면 
			if (li_byte <= li_max) { 
				li_len = i + 1; 
			} 
		} 

		// 전체길이를 초과하면 
		if (li_byte > li_max) { 
			alert( li_max + "byte 글자를 초과 입력할수 없습니다. \n 초과된 내용은 자동으로 삭제 됩니다. "); 
			ls_str2 = ls_str.substr(0, li_len);
			frm_nm.value = ls_str2; 

			li_str_len = ls_str2.length; // 전체길이 
			li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
			for (i=0; i< li_str_len; i++) { 
			// 한글자추출 
				ls_one_char = ls_str2.charAt(i); 

				// 한글이면 2를 더한다. 
				if (escape(ls_one_char).length > 4) { 
					li_byte += 2; 
				} 
				// 그밗의 경우는 1을 더한다. 
				else { 
					li_byte++; 
				} 
			} 
		} 
		if (cnt_view != "") {
			var inner_form = eval("document.all."+ cnt_view) 
			inner_form.innerHTML = li_byte ;		//frm.txta_Memo.value.length;
		}
	//	frm_nm.focus(); 

	} 
</script>

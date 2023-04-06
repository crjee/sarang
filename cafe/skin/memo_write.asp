<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkMemoSendAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
			<script>
				function goAll(obj) {
					if (obj.checked == true)
					{
						document.form.opt_value.value = "";
						document.form.opt_text.value = "전체회원";
					}
					else {
						document.form.opt_value.value = "";
						document.form.opt_text.value = "";
					}
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 등록</h2>
				</div>
				<form name="form" method="post" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="opt_value">
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">제목</th>
								<td>
									<input type="text" class="inp" id="subject" name="subject" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView');setCookie('subject',this.value,1)" required style="" />
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
							<tr>
								<th scope="row">받는 사람</th>
								<td>
									<span class="mr10">
										<button type="button" class="btn btn_c_n btn_s btn_long" onclick="goUser()">받는사람 선택</button>
									</span>
									<span class="mr10">
										<input type="checkbox" id="alluser" name="alluser" value="all" onclick="goAll(this)" class="inp_check"><label for="alluser"><em>전체회원</em></label>
									</span>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
						<div class="editor">
							<textarea name="opt_text" class="retextarea2" readonly required style="display:none"></textarea>
							<textarea name="ir1" id="ir1" style="width: 100%; height: 400px; display: none;"></textarea>
						</div>
					</div>
					<p class="txt_guide_1 mt10">새로고침시 에디터 내용은 유지되지 않습니다.</p>
				</div>
				<div class="btn_box">
					<!-- <button type="submit" class="btn btn_c_a btn_n btn_2txt_sel">확인</button> -->
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='job_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>

			<script type="text/javascript">
				function goUser() {
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}
			</script>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/cafe/skin/memo_user_edit_p.asp?cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="memo_user">
			<input type="hidden" name="open_specs" value="width=600, height=600, left=200, top=200">
			</form>
			<script type="text/javascript">
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
						//alert("완료!");
					}
				}, //boolean
				fOnAppLoad : function() {
					//예제 코드
					//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
				},
				fCreator: "createSEditor2"
			});

			function pasteHTML() {
				var sHTML = "<span style=color:#FF0000;>이미지도 같은 방식으로 삽입합니다.<\/span>";
				oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
			}

			function showHTML() {
				var sHTML = oEditors.getById["ir1"].getIR();
				alert(sHTML);
			}

			function submitContents(elClickedObj) {
				oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.

				// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("ir1").value를 이용해서 처리하면 됩니다.
				try {
					if (document.getElementById("ir1").value == "" || document.getElementById("ir1").value == "<p>&nbsp;</p>") {
						alert("내용을 입력하세요");
						return;
					}
					elClickedObj.action = "memo_write_exec.asp";
					elClickedObj.target = "hiddenfrm";
					elClickedObj.submit();
				} catch(e) {}
			}

			function setDefaultFont() {
				var sDefaultFont = "궁서";
				var nFontSize = 24;
				oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
			}
			</script>
	<!--Center-->

<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>
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

<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	menu_type = "notice"
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
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")

	link = "http://"
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_temp_notice "
	sql = sql & "  where user_id = '" & user_id  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		msgonly "임시 저장된 내용이 있습니다."
		top_yn   = rs("top_yn")
		pop_yn   = rs("pop_yn")
		link     = rs("link")
		cafe_id  = rs("cafe_id")
		subject  = rs("subject")
		contents = rs("contents")
	End If
	rs.close
%>
			<script>
				function goAll(obj) {
					if (obj.checked == true)
					{
						document.form.opt_value.value = "";
						document.form.opt_text.value = "전체사랑방";
					}
					else {
						document.form.opt_value.value = "";
						document.form.opt_text.value = "";
					}
				}
			</script>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
				<input type="hidden" name="opt_value">
				<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2">경인네트웍스 전체공지 등록</h2>
				</div>
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	If cafe_ad_level > 6 Then
%>
							<tr>
								<th scope="row">팝업/공지</th>
								<td>
									<input type="checkbox" class="inp_check" id="pop_yn" name="pop_yn" value="Y" <%=if3(pop_yn="Y","checked","")%> />
									<label for="pop_yn"><em>팝업으로 지정</em></label>
									<input type="checkbox" class="inp_check" id="top_yn" name="top_yn" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>공지로 지정</em></label>
								</td>
							</tr>
<%
	End If
%>
							<tr>
								<th scope="row">사랑방</th>
								<td>
									<button type="button" class="btn_long" onclick="goCafe()">사랑방 선택</button>
									<input type="checkbox" name="allcafe" value="all" onclick="goAll(this)" <%=if3(cafe_id="","checked","")%>> 전체사랑방
									<textarea name="opt_text" class="retextarea2" readonly required><%=cafe_name%></textarea>
								</td>
							</tr>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th></th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
<%
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_com_form "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		form = rs("form")
	End If
	rs.close

	If contents = "" Then
		contents = form
	End If

	If editor_yn = "Y" Then
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	Else
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	End if
%>
					</div>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">링크주소</th>
								<td>
									<input type="text" id="link" name="link" class="inp" value="<%=link%>">
								</td>
							</tr>
<%
	com_seq = notice_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='notice_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>
				<script type="text/javascript">
					function goCafe() {
						document.open_form.action = "/win_open_exec.asp"
						document.open_form.target = "hiddenfrm";
						document.open_form.submit();
					}
				</script>
				<form name="open_form" method="post">
				<input type="hidden" name="open_url" value="/cafe/skin/notice_cafe_edit_p.asp?cafe_id=<%=cafe_id%>">
				<input type="hidden" name="open_name" value="notice_cafe">
				<input type="hidden" name="open_specs" value="width=600, height=600, left=200, top=200">
				</form>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
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
					f.action = "notice_temp_exec.asp";
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
			elClickedObj.action = "notice_write_exec.asp";
			elClickedObj.temp.value = "N";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()

		} catch(e) {}
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

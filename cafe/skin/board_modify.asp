<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('수정 권한이없습니다');history.back()</script>"
		Response.End
	End If
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
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	menu_seq  = Request("menu_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	board_seq = Request("board_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_board "
	sql = sql & "  where board_seq = '" & board_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And UCase(session("user_id")) <> UCase(rs("user_id")) then
			Response.Write "<script>alert('수정 권한이없습니다');history.back();</script>"
			Response.End
		End If

		step_num = rs("step_num")
		top_yn   = rs("top_yn")
		user_id  = rs("user_id")
		subject  = rs("subject")
		contents = rs("contents")
		subject  = Replace(subject, """", " & quot;")

		If rs("link")="" Then
			link = "http://"
		Else
			link = rs("link")
		End If
	End if
	rs.close
%>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="board_seq" value="<%=board_seq%>">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 수정</h2>
				</div>
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	If cafe_mb_level > 6 Then
		If step_num = "0" Then
%>
							<tr>
								<th scope="row">공지</th>
								<td>
									<input type="checkbox" id="top_yn" name="top_yn" class="inp_check" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>공지로 지정</em></label>
								</td>
							</tr>
<%
		End If
	End If
%>
							<tr>
								<th scope="row">제목 *</th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
<%
	If edit = "edit" Then
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;" onkeyup="setCookie('ir1',this.value,1)"><%=contents%></textarea>
<%
	Else
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;" onkeyup="setCookie('ir1',this.value,1)"><%=contents%></textarea>
<%
	End if
%>
							<li class="orange">새로고침시 에디터 내용은 유지되지 않습니다.</li>
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
	com_seq = board_seq
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
							fOnBeforeUnload : function(){
								//alert("완료!")
							}
						}, //boolean
						fOnAppLoad : function(){
							//예제 코드
							//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
						},
						fCreator: "createSEditor2"
					})

					function submitContents(elClickedObj) {
						oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
						try {
							elClickedObj.action = "board_modify_exec.asp";
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

	for(i=0; i< li_str_len; i++) { 
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
		if(li_byte <= li_max) { 
			li_len = i + 1; 
		} 
	} 

	// 전체길이를 초과하면 
	if(li_byte > li_max) { 
		alert( li_max + "byte 글자를 초과 입력할수 없습니다. \n 초과된 내용은 자동으로 삭제 됩니다. "); 
		ls_str2 = ls_str.substr(0, li_len);
		frm_nm.value = ls_str2; 

		li_str_len = ls_str2.length; // 전체길이 
		li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
		for(i=0; i< li_str_len; i++) { 
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
	if (cnt_view != ""){
		var inner_form = eval("document.all."+ cnt_view) 
		inner_form.innerHTML = li_byte ;		//frm.txta_Memo.value.length;
	}
//	frm_nm.focus(); 

} 
</script>

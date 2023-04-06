<!--#include virtual="/ipin_inc.asp"-->
<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)

	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	Else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		cafe_id = rs("cafe_id")
	End If
	rs.close

	comment_seq = Request("comment_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & "_comment "
	sql = sql & "  where comment_seq = '" & comment_seq  & "' "
	rs.Open Sql, conn, 3, 1

	comment = rs("comment")

	If Not(user_id = rs("user_id") Or cafe_ad_level = 10) Then
		Response.Write "<script>alert('댓글 작성자가 아닙니다');window.close();</script>"
		Response.end
	End If
	rs.close
	Set rs = Nothing
%>
<!DOCTYPE html>
<html lang="ko">
<head>

<meta charset="euc-kr"/>
<title>경인네트웍스</title>
<meta content="IE=edge" http-equiv="X-UA-Compatible">
<meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0" />
</head>
<body>
<form name="form" method="post" action="com_comment_write_exec.asp">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<input type="hidden" name="comment_seq" value="<%=comment_seq%>">
<div style="text-align:center;padding:10px;padding-bottom:3px;">
	<textarea style="width:100%;height:100px;" name="comment" onKeyup="fc_chk_byte(this, 400, 'commentView')"><%=comment%></textarea>
	<span id="commentView" name="commentView">0</span>/400
</div>
<div style="text-align:center;padding-left:10px;padding-right:10px;">
	<input type="submit" value="댓글수정" style="width:100%;height:24px;" class="btn btn-default btn-xs">
</div>
</form>
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

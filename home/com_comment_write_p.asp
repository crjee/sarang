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
		msggo "�������� ����� �ƴմϴ�.",""
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
		Response.Write "<script>alert('��� �ۼ��ڰ� �ƴմϴ�');window.close();</script>"
		Response.end
	End If
	rs.close
	Set rs = Nothing
%>
<!DOCTYPE html>
<html lang="ko">
<head>

<meta charset="euc-kr"/>
<title>���γ�Ʈ����</title>
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
	<input type="submit" value="��ۼ���" style="width:100%;height:24px;" class="btn btn-default btn-xs">
</div>
</form>
</body>
</html>
<script>

function fc_chk_byte(frm_nm, ari_max, cnt_view) { 
//	var frm = document.regForm;
	var ls_str = frm_nm.value; // �̺�Ʈ�� �Ͼ ��Ʈ���� value �� 
	var li_str_len = ls_str.length; // ��ü���� 

	// �����ʱ�ȭ 
	var li_max = ari_max; // ������ ���ڼ� ũ�� 
	var i = 0; // for���� ��� 
	var li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
	var li_len = 0; // substring�ϱ� ���ؼ� ��� 
	var ls_one_char = ""; // �ѱ��ھ� �˻��Ѵ� 
	var ls_str2 = ""; // ���ڼ��� �ʰ��ϸ� �����Ҽ� ������������ �����ش�. 

	for (i=0; i< li_str_len; i++) { 
	// �ѱ������� 
		ls_one_char = ls_str.charAt(i); 

		// �ѱ��̸� 2�� ���Ѵ�. 
		if (escape(ls_one_char).length > 4) { 
			li_byte += 2; 
		} 
		// �׹��� ���� 1�� ���Ѵ�. 
		else { 
			li_byte++; 
		} 

		// ��ü ũ�Ⱑ li_max�� ���������� 
		if (li_byte <= li_max) { 
			li_len = i + 1; 
		} 
	} 

	// ��ü���̸� �ʰ��ϸ� 
	if (li_byte > li_max) { 
		alert( li_max + "byte ���ڸ� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. "); 
		ls_str2 = ls_str.substr(0, li_len);
		frm_nm.value = ls_str2; 

		li_str_len = ls_str2.length; // ��ü���� 
		li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
		for (i=0; i< li_str_len; i++) { 
		// �ѱ������� 
			ls_one_char = ls_str2.charAt(i); 

			// �ѱ��̸� 2�� ���Ѵ�. 
			if (escape(ls_one_char).length > 4) { 
				li_byte += 2; 
			} 
			// �׹��� ���� 1�� ���Ѵ�. 
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

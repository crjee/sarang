<!--#include virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request.Form("menu_seq")
	form = Request.form("ir1")

	sql = ""
	sql = sql & " update cf_com_form "
	sql = sql & "    set form = '" & form & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq='" & menu_seq & "'"
	Conn.Execute(sql)
%>
<script>
	alert('양식이 등록되었습니다');
	opener.location = 'form_edit_p.asp';
	window.close();
</script>

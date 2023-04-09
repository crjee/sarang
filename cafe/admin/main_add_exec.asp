<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()
	cafe_id = "home"

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set home_num = '0' "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	Conn.Execute(sql)

	For i = 1 To Request("menu_seq").count
		menu_seq = Request("menu_seq")(i)
		home_num = i

		sql = ""
		sql = sql & " update cf_menu "
		sql = sql & "    set home_num = '" & home_num & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		Conn.Execute(sql)
	Next
%>
<script>
parent.location = 'main_list.asp';
</script>

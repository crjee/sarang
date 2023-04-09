<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	menu_seq  = Request("menu_seq")
	home_num  = Request("home_num")
	list_type = Request("list_type")
	wide_yn   = Left(list_type, 1)
	list_type = Right(list_type, 2)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set wide_yn   = '" & wide_yn & "' "
	sql = sql & "       ,list_type = '" & list_type & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)
%>
<form name="form" action="../main_list.asp" method="post" target="_parent">
	<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
	<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
	<input type="hidden" name="home_num" value="<%=home_num%>">
</form>
<script>
	document.form.submit();
</script>

<!--#include virtual="/include/config_inc.asp"-->
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")

	menu_seq = Request("menu_seq")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
'	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
	End If
	rs.close

	comment_seq = Request("comment_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & "_comment "
	sql = sql & "  where comment_seq = '" & comment_seq  & "' "
	rs.Open Sql, conn, 3, 1

	If Not(user_id = rs("user_id") Or cafe_ad_level = 10) Then
		Response.Write "<script>alert('댓글 작성자가 아닙니다');window.close();</script>"
		Response.end
	End If
	rs.close
	Set rs = Nothing

	comment = Request.Form("comment")

	sql = ""
	sql = sql & " update cf_" & menu_type & "_comment "
	sql = sql & "    set comment = '" & comment & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where comment_seq = '" & comment_seq & "' "
	Conn.Execute(sql)
	Response.Write "<script>opener.parent.search_form.submit();window.close();</script>"
%>

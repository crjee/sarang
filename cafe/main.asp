<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	If Session("count") = "" then
		sql = ""
		sql = sql & " update cf_cafe "
		sql = sql & "    set visit_cnt = isnull(visit_cnt,0) + 1 "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		Conn.Execute(sql)
		Session("count") = "Y"
	End If

	Set rs = server.createobject("adodb.recordset")

	sql = ""
	sql = sql & " select skin_id                 "
	sql = sql & "   from cf_skin                 "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	rs.Open sql, Conn, 1
	If Not rs.eof Then
		session("skin_id") = rs("skin_id")
	Else
		session("skin_id") = "skin_01"
	End if
	rs.close
	Set rs = Nothing

	If session("user_id") = "crjee" Then
'		skin_id = "s01"
	End If

	Server.Execute("/cafe/skin/" & session("skin_id") & ".asp")
'	Response.write "/cafe/skin/" & session("skin_id") & ".asp"
%>

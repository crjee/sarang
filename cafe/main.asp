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

 ' crjee 임시
	session("skin_id") = "" ' crjee 임시
	If request("skin_id") <> "" Then ' crjee 임시
		If request("skin_id") = "noFrame" Then
			session("noFrame")  = "Y"
			session("skin_id")  = "skin_01"
			session("svTarget") = "_self"
			session("ctHref")   = ""
			session("ctTarget") = "_self"
			session("ctHref")   = ""
		ElseIf request("skin_id") = "skin_01" Then
			session("noFrame")  = ""
			session("skin_id")  = "skin_01"
			session("svTarget") = "cafe_main"
			session("ctHref")   = "cafe_main."
			session("ctTarget") = "_self"
			session("ctHref")   = ""
		ElseIf request("skin_id") = "skin_03" Then
			session("noFrame")  = ""
			session("skin_id")  = "skin_03"
			session("svTarget") = "cafe_main"
			session("ctHref")   = "cafe_main."
			session("ctTarget") = "cafe_main"
			session("ctHref")   = "cafe_main."
		Else
			session("noFrame")  = "Y"
			session("skin_id")  = "skin_01"
			session("svTarget") = "_self"
			session("ctHref")   = ""
			session("ctTarget") = "_self"
			session("ctHref")   = ""
		End If
	Else
			session("noFrame")  = "Y"
			session("skin_id")  = "skin_01"
			session("svTarget") = "_self"
			session("ctHref")   = ""
			session("ctTarget") = "_self"
			session("ctHref")   = ""
	End If
 ' crjee 임시

	If session("skin_id") = "" Then ' crjee 임시
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
	End If ' crjee 임시

	If session("user_id") = "crjee" Then
'		skin_id = "s01"
	End If

	Server.Execute("/cafe/skin/" & session("skin_id") & ".asp")
'	Response.write "/cafe/skin/" & session("skin_id") & ".asp"
%>

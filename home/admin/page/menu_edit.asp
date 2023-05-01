<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()
%>
<%
	menu_seq  = Request("menu_seq")
	menu_type = Request("menu_type")

	If bus <> "" Then
		sql = ""
		sql = sql & " update cf_menu                              "
		sql = sql & "    set page_type = '" & page_type & "'      "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate()                    "
		sql = sql & "  where menu_seq = '" & menu_seq & "'        "
		Conn.Execute(sql)
	End If

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                             "
	sql = sql & "   from cf_menu                       "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	rs.open Sql, conn, 3, 1

	If Not rs.eof then
		menu_name = menu_name
		menu_type = rs("menu_type")
	End If
	rs.close
	Set rs = Nothing

	If menu_name <> "-" Then
		If menu_type = "land" Then
			menu_type = "group"
		Elseif menu_type = "album" Or menu_type = "board" Or menu_type = "sale" Or menu_type = "job" Or menu_type = "nsale" Then
			menu_type = "board"
		Elseif menu_type = "memo" Or menu_type = "poll" Then
			menu_type = "page"
		ElseIf menu_type = "division" Then
			menu_type = ""
		Else
			menu_type = ""
		End If 
	End If

	If menu_type <> "" Then
		Server.Execute(menu_type & "_edit.asp")
	End If
%>

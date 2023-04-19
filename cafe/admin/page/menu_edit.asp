<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	menu_type = Request("menu_type")

	If bus <> "" Then
		sql = ""
		sql = sql & " update cf_menu                              "
		sql = sql & "    set page_type = '" & page_type & "'      "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate()                    "
		sql = sql & "  where menu_seq = '" & menu_seq & "'        "
		Conn.Execute(sql)
	End if

	sql = ""
	sql = sql & " select *                             "
	sql = sql & "   from cf_menu                       "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Set rs = Conn.Execute(sql)

	If Not rs.eof then
		menu_name = menu_name
		menu_type = rs("menu_type")
	End If

	If menu_name <> "-" Then
		If menu_type = "land" Then
			menu_type = "group"
		Elseif menu_type = "story" Or menu_type = "nsale" Then
			menu_type = "board"
		Elseif menu_type = "memo" Or menu_type = "poll" Then
			menu_type = "page"
		Else
			menu_type = menu_type
		End If
	End If

	Server.Execute(menu_type & "_edit.asp")
%>

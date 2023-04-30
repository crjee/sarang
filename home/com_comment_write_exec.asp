<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)

	comment_seq = Request("comment_seq")

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from gi_" & menu_type & "_comment "
	sql = sql & "  where comment_seq = '" & comment_seq  & "' "
	rs.Open Sql, conn, 3, 1

	If Not(user_id = rs("user_id") Or cafe_ad_level = 10) Then
		Response.Write "<script>alert('댓글 글쓴이가 아닙니다');window.close();</script>"
		Response.end
	End If
	rs.close
	Set rs = Nothing

	comment = Request.Form("comment")

	sql = ""
	sql = sql & " update gi_" & menu_type & "_comment "
	sql = sql & "    set comment = '" & comment & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where comment_seq = '" & comment_seq & "' "
	Conn.Execute(sql)
	Response.Write "<script>opener.parent.search_form.submit();window.close();</script>"
%>

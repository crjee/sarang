<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<!--#include virtual="/ipin_inc.asp"-->
<%
	cafe_id = "home"

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)

	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		cafe_id = rs("cafe_id")
	End If
	rs.close

	comment_seq = Request("comment_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from gi_" & menu_type & "_comment "
	sql = sql & "  where comment_seq = '" & comment_seq  & "' "
	rs.Open Sql, conn, 3, 1

	comment = rs("comment")

	If Not(user_id = rs("user_id") Or cafe_ad_level = 10) Then
		Response.Write "<script>alert('댓글 글쓴이가 아닙니다');window.close();</script>"
		Response.end
	End If
	rs.close
	Set rs = Nothing
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<title>경인네트웍스</title>
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
	<input type="submit" value="댓글수정" style="width:100%;height:24px;" class="btn btn-default btn-xs">
</div>
</form>
</body>
</html>

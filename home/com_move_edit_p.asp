<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<!--#include virtual="/ipin_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)

	com_seq = Request("com_seq")
%>
<html lang="ko">
<head>
<meta charset="utf-8"/>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<title>게시글이동</title>
</head>
<body>
	<table width="96%" align="center">
	<form name="form" method="post" action="com_move_exec.asp">
	<input type="hidden" name="com_seq" value="<%=com_seq%>">
	<input type="hidden" name="old_menu_seq" value="<%=menu_seq%>">
		<!--tr>
			<td style="font-size:12px;">
			<%'=rs("subject")%>
			<%' If cnt > 1 Then %>
			/ 답글 <%=cnt%>개가 있습니다
			<%' End If %>
			</td>
		</tr-->
		<tr>
			<td>
			<select name="menu_seq" class="sel w_auto" required>
				<option value="">게시판선택</option>
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq <> '" & menu_seq & "' "
	sql = sql & "    and menu_type = '" & menu_type & "' "
	sql = sql & "    and write_auth <= '" & toInt(cafe_mb_level) & "' "
	sql = sql & "  order by menu_name "
	rs.Open Sql, conn, 3, 1

	Do Until rs.eof
%>
				<option value="<%=rs("menu_seq")%>"><%=rs("menu_name")%></option>
<%
		rs.MoveNext
	Loop
	rs.close
	Set rs = nothing
%>
			</select>
			<input type="submit" value="이동">
			</td>
		</tr>
	</form>
	</table>
</body>
</html>

<!--#include virtual="/ipin_inc.asp"-->
<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)

	Set rs = Server.CreateObject ("ADODB.Recordset")

	com_seq = Request("com_seq")
%>
<html lang="ko">
<head>
<meta charset="euc-kr"/>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<title>�Խñ��̵�</title>
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
			/ ��� <%=cnt%>���� �ֽ��ϴ�
			<%' End If %>
			</td>
		</tr-->
		<tr>
			<td>
			<select name="menu_seq" required>
				<option value="">�Խ��Ǽ���</option>
<%
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
			<input type="submit" value="�̵�">
			</td>
		</tr>
	</form>
	</table>
</body>
</html>

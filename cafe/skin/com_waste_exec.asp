<!--#include virtual="/include/config_inc.asp"-->
<%
	page      = Request("page")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	If menu_seq <> "" then
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_menu "
		sql = sql & "  where menu_seq = '"& menu_seq &"' "
		sql = sql & "    and cafe_id = '"& cafe_id &"' "
		rs.Open Sql, conn, 3, 1

		If rs.EOF Then
			msggo "�������� ����� �ƴմϴ�.",""
		else
			menu_type = rs("menu_type")
			menu_name = rs("menu_name")
		End If
		rs.close
	Else
		menu_type = "notice"
	End If

	com_seq = Request(menu_type & "_seq")

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	cafe_mb_level = getUserLevel(cafe_id)
	If cafe_mb_level >= 6 Then ' ��������� �̸� ����
		Call waste_content(menu_type, com_seq)
	Else
		Set rs = Server.CreateObject ("ADODB.Recordset")

		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_" & menu_type & " "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		sql = sql & "    and user_id = '" & user_id & "' "
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then ' ���ۼ��� �̸� ����
			Call waste_content(menu_type, com_seq)
		Else ' ���ۼ��� �ƴϸ�
			Response.Write "<script>alert('�����̾����ϴ�');history.back();</script>"
			Response.End
		End If

		rs.close
		Set rs = Nothing
	End If

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("���� �Ǿ����ϴ�.");
	location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
/	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
/	location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	End if
%>

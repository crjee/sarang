<!--#include virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	com_seq = Request("com_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "�������� ����� �ƴմϴ�.",""
	else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
	End If
	rs.close

	on Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	cafe_mb_level = getUserLevel(cafe_id)

	If com_seq = "" Then
		Response.Write "<script>alert('���õ� �Խñ��� �����ϴ�');</script>"
		Response.end
	Else

		If cafe_mb_level > 5 Then

			for i=1 to Request("com_seq").count
				com_seq = Request("com_seq")(i)

				sql = ""
				sql = sql & " update cf_" & menu_type & " "
				sql = sql & "    set top_yn = case top_yn when 'Y' Then 'N' else 'Y' end "
				sql = sql & "       ,modid = '" & Session("user_id") & "' "
				sql = sql & "       ,moddt = getdate() "
				sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
				Conn.Execute(sql)

				sql = ""
				sql = sql & " update cf_menu "
				sql = sql & "    set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
				sql = sql & "       ,modid = '" & Session("user_id") & "' "
				sql = sql & "       ,moddt = getdate() "
				sql = sql & "  where menu_seq = '" & menu_seq & "' "
				Conn.Execute(sql)
			Next

		End if

	End if

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("ó�� �Ǿ����ϴ�.");
	parent.location.href='<%=menu_type%>_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&<%=menu_type%>_seq=<%=com_seq%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
	parent.location.href='<%=menu_type%>_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&<%=menu_type%>_seq=<%=com_seq%>';
</script>
<%
	End if
%>

<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<%
	old_menu_seq = Request.Form("menu_seq")
	menu_seq = Request.Form("menu_seq")
	com_seq = Request("com_seq")

	'on Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

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
		cafe_id   = rs("cafe_id")
	End If
	rs.close


	' �ڽű۰� ��� ��ȸ
	sql = ""
	sql = sql & " with tree_query  as (                                                                                                            "
	sql = sql & "   select                                                                                                                         "
	sql = sql & "          " & menu_type & "_seq                                                                                                                     "
	sql = sql & "        , parent_seq                                                                                                              "
	sql = sql & "        , subject                                                                                                                 "
	sql = sql & "        , convert(varchar(255), " & menu_type & "_seq) sort                                                                                         "
	sql = sql & "        , convert(varchar(2000), subject) depth_fullname                                                                          "
	sql = sql & "        , credt                                                                                                                 "
	sql = sql & "     from cf_" & menu_type & "                                                                                                        "
	sql = sql & "     where " & menu_type & "_seq = " & com_seq & "                                                                                                          "
	sql = sql & "     union all                                                                                                                    "
	sql = sql & "     select                                                                                                                       "
	sql = sql & "           b." & menu_type & "_seq                                                                                                                  "
	sql = sql & "         , b.parent_seq                                                                                                           "
	sql = sql & "         , b.subject                                                                                                              "
	sql = sql & "         , convert(varchar(255), convert(nvarchar,c.sort) + ' > ' +  convert(varchar(255), b." & menu_type & "_seq)) sort                           "
	sql = sql & "         , convert(varchar(2000), convert(nvarchar,c.depth_fullname) + ' > ' +  convert(varchar(2000), b.subject)) depth_fullname "
	sql = sql & "         , b.credt                                                                                                                 "
	sql = sql & "     from  cf_" & menu_type & " b, tree_query c                                                                                       "
	sql = sql & "     where b.parent_seq = c." & menu_type & "_seq                                                                                                   "
	sql = sql & " )                                                                                                                                "
	sql = sql & " select *                                                                                                                         "
	sql = sql & "   from cf_" & menu_type & "                                                                                                          "
	sql = sql & "  where " & menu_type & "_seq in (                                                                                                                  "
	sql = sql & " select " & menu_type & "_seq from tree_query)                                                                                                      "
	sql = sql & "  order by " & menu_type & "_seq "
	rs.Open Sql, conn, 1, 1

	If Not rs.eof Then
		' �޴�Ÿ�� ����
		Do Until rs.eof

			new_num = getNum(menu_type, cafe_id, menu_seq)
			old_num = rs(menu_type & "_num")
			group_num = rs("group_num")
			group_num = group_num + (new_num - old_num)
			credt = rs("credt")

			sql = ""
			sql = sql & " select isnull(max(group_num), 1) + 0.001 as group_max "
			sql = sql & "   from cf_" & menu_type & " "
			sql = sql & "  where menu_seq = '" & menu_seq  & "' "
			sql = sql & "    and credt < (select credt from cf_" & menu_type & " where " & menu_type & "_seq = " & com_seq & ") "
'			msgonly sql
			rs2.Open Sql, conn, 3, 1
			group_num = rs2("group_max")
			rs2.close
'			msgonly group_num

			sql = ""
			sql = sql & " select count(*) as group_cnt "
			sql = sql & "   from cf_" & menu_type & " "
			sql = sql & "  where menu_seq = '" & menu_seq  & "' "
			sql = sql & "    and group_num = '" & group_num  & "' "
'			msgonly sql
			rs2.Open Sql, conn, 3, 1
'			group_cnt = rs2("group_cnt")
			rs2.close
'			msgonly group_cnt
			If CInt(group_cnt) > 0 Then
				sql = ""
				sql = sql & " select isnull(min(group_num), " & CLng(group_num)  & ") - 0.001 as group_min "
				sql = sql & "   from cf_" & menu_type & " "
				sql = sql & "  where menu_seq = '" & menu_seq  & "' "
				sql = sql & "    and group_num < '" & group_num  & "' "
'				msgonly sql
				rs2.Open Sql, conn, 3, 1
'				group_num = clng(rs2("group_min"))
				rs2.close
			End if

			' �Խñ� ����
			sql = ""
			sql = sql & " update cf_" & menu_type & " "
			sql = sql & "    set menu_seq = " & menu_seq & " "
			sql = sql & "       ,group_num = " & group_num & " "
			sql = sql & "       ," & menu_type & "_num = " & new_num & " "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where " & menu_type & "_seq = " & com_seq & " "
			Conn.Execute(sql)

			sql = ""
			sql = sql & " update cf_menu "
			sql = sql & "    set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & old_menu_seq & "' and top_yn = 'Y') "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where menu_seq = '" & old_menu_seq & "' "
			Conn.Execute(sql)

			sql = ""
			sql = sql & " update cf_menu "
			sql = sql & "    set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where menu_seq = '" & menu_seq & "' "
			Conn.Execute(sql)

			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing
	Set fso = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("�̵� �Ǿ����ϴ�.");
	opener.parent.location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
	window.close()
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
	opener.parent.location.href='<%=pgm%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
	window.close()
</script>
<%
	End if
%>
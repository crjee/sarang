<!--#include virtual="/include/config_inc.asp"-->
<%
	menu_type = "notice"

	menu_type = "notice"
	notice_seq = Request("notice_seq")

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	cafe_mb_level = getUserLevel(cafe_id)

	If notice_seq = "" Then
		Response.Write "<script>alert('���õ� �Խñ��� �����ϴ�');</script>"
		Response.end
	Else
		If cafe_mb_level > 5 Then
			For i=1 To Request("notice_seq").count
				notice_seq = Request("notice_seq")(i)

				sql = ""
				sql = sql & " update cf_notice "
				sql = sql & "    set top_yn = case top_yn when 'Y' Then 'N' else 'Y' end "
				sql = sql & "       ,modid = '" & Session("user_id") & "' "
				sql = sql & "       ,moddt = getdate() "
				sql = sql & "  where notice_seq = '" & notice_seq & "' "
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
	parent.location.href='notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
	parent.location.href='notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
</script>
<%
	End if
%>

<!--#include virtual="/include/config_inc.asp"-->
<%
	notice_seq = Request("notice_seq")

	on Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	If notice_seq = "" Then
		Response.Write "<script>alert('���õ� �Խñ��� �����ϴ�');</script>"
		Response.end
	Else

		If cafe_ad_level > 5 Then

			for i=1 to Request("notice_seq").count
				notice_seq = Request("notice_seq")(i)

				sql = ""
				sql = sql & " update cf_notice"
				sql = sql & "    set pop_yn = case pop_yn when 'Y' Then 'N' else 'Y' end "
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
<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
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
		Response.Write "<script>alert('선택된 게시글이 없습니다');</script>"
		Response.end
	Else
		If cafe_mb_level > 5 Then
			For i = 1 To Request("notice_seq").count
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
	alert("처리 되었습니다.");
	parent.location.href='notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
	parent.location.href='notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
</script>
<%
	End if
%>

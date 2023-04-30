<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)

	notice_seq = Request("notice_seq")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	cafe_mb_level = GetUserLevel(cafe_id)

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
		End If
	End If

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("처리 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>') ;
<%
	End If
%>
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/notice_view.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>') ;
<%
	End If
%>
</script>
<%
	End If
%>

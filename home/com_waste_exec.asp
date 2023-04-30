<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckModifyAuth(cafe_id)

	page     = Request("page")
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	com_seq = Request(menu_type & "_seq")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	If cafe_ad_level = 10 Then ' 관리자 이면 삭제
		Call ExecWasteContent(menu_type, com_seq)
	Else
		Set rs = Server.CreateObject("ADODB.Recordset")

		sql = ""
		sql = sql & " select * "
		sql = sql & "   from gi_" & menu_type & " "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		sql = sql & "    and user_id = '" & session("user_id") & "' "
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then ' 글쓴이 이면 삭제
			Call ExecWasteContent(menu_type, com_seq)
		Else ' 글쓴이 아니면
			Response.Write "<script>alert('권한이없습니다');history.back();</script>"
			Response.End
		End If
		rs.Close
		Set rs = Nothing
	End If

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("삭제 되었습니다.");
	parent.location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
	parent.location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	End If
%>

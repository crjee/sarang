<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	page      = Request("page")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	If menu_seq <> "" then
		Set rs = Server.CreateObject("ADODB.Recordset")

		sql = ""
		sql = sql & " select *                             "
		sql = sql & "   from cf_menu                       "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		sql = sql & "    and cafe_id  = '" & cafe_id  & "' "
		rs.Open Sql, conn, 3, 1

		If Not rs.EOF Then
			menu_type = rs("menu_type")
			menu_name = rs("menu_name")
		End If
		rs.close
	Else
		menu_type = "notice"
	End If

	com_seq = Request(menu_type & "_seq")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	cafe_mb_level = GetUserLevel(cafe_id)
	If cafe_mb_level >= 6 Then ' 사랑방지기 이면 삭제
		Call ExecWasteContent(menu_type, com_seq)
	Else
		Set rs = Server.CreateObject("ADODB.Recordset")

		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_" & menu_type & " "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		sql = sql & "    and user_id = '" & Session("user_id") & "' "
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then ' 글쓴이 이면 삭제
			Call ExecWasteContent(menu_type, com_seq)
		Else ' 글쓴이 아니면
			Response.Write "<script>alert('권한이없습니다');history.back();</script>"
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
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("삭제 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>') ;
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
	parent.location.href='<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=1&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>') ;
<%
	End If
%>
</script>
<%
	End If
%>

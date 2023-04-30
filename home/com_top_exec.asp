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

	Call CheckAdmin()

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)

	menu_seq = Request("menu_seq")
	com_seq = Request("com_seq")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	For i = 1 To Request("com_seq").count
		com_seq = Request("com_seq")(i)

		sql = ""
		sql = sql & " update gi_" & menu_type & " "
		sql = sql & "    set top_yn = case top_yn when 'Y' Then 'N' else 'Y' end "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " update cf_menu "
		sql = sql & "    set top_cnt = (select count(*) from gi_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		Conn.Execute(sql)
	Next

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("처리 되었습니다.");
	parent.location.href='<%=menu_type%>_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&<%=menu_type%>_seq=<%=com_seq%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
	parent.location.href='<%=menu_type%>_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&<%=menu_type%>_seq=<%=com_seq%>';
</script>
<%
	End If
%>

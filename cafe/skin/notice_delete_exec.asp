<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkAdmin(cafe_id)

	menu_type = "notice"

	page      = request("page")
	sch_type  = request("sch_type")
	sch_word  = request("sch_word")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	notice_seq = Request("notice_seq")

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	sql = ""
	sql = sql & " select file_name "
	sql = sql & "   from cf_notice_attach "
	sql = sql & "  where notice_seq = '" & notice_seq  & "' "
	Rs.Open Sql, conn, 1

	i = 0
	If Not Rs.eof Then
		Do Until Rs.eof
			i = i + 1
			ReDim Preserve attach_file(i)
			attach_file(i) = Rs("file_name")
			Rs.MoveNext
		Loop
	End If
	Rs.close

	' 모든 첨부 삭제
	sql = "delete cf_notice_attach where notice_seq = '" & notice_seq  & "' "
	Conn.Execute(sql)

	' 모든 댓글 삭제
	sql = "delete cf_notice_comment where notice_seq = '" & notice_seq  & "' "
	Conn.Execute(sql)

	' 본글 삭제
	sql = "delete cf_notice where notice_seq = '" & notice_seq  & "' "
	Conn.Execute(sql)

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing

		Set fso = CreateObject("Scripting.FileSystemObject")
		If isarray(attach_file) Then
			For i = 1 To ubound(attach_file)
				uploadFolder = ConfigAttachedFileFolder & "notice\"
				strFileName = uploadFolder & attach_file(i)

				If (fso.FileExists(strFileName)) Then
					fso.DeleteFile(strFileName)
				End If
			Next
		End If
%>
<script>
	alert("삭제 되었습니다.");
	parent.location.href='notice_list.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End If
%>

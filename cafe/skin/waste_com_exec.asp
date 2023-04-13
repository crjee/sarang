<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	page      = request("page")
	sch_type  = request("sch_type")
	sch_word  = request("sch_word")
	task  = request("task")

	If menu_seq <> "" then
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_menu "
		sql = sql & "  where menu_seq = '"& menu_seq &"' "
		sql = sql & "    and cafe_id = '"& cafe_id &"' "
		rs.Open Sql, conn, 3, 1

		If rs.EOF Then
			msggo "정상적인 사용이 아닙니다.",""
		Else
			menu_type = rs("menu_type")
			menu_name = rs("menu_name")
		End If
		rs.close
	Else
		menu_type = "notice"
	End If

	com_seq = Request(menu_type & "_seq")

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	If task = "restore" Then ' 복원
		msg = "복원"
		call restore_content(menu_type, com_seq)
	ElseIf task = "delete" Then ' 삭제
		msg = "삭제"
		Call delete_content(menu_type, com_seq)

		If menu_type = "album" Then
			file_name = getonevalue("thumbnail","cf_waste_album","where " & menu_type & "_seq = " & com_seq)
		End If
	End If

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing

		If task = "delete" Then ' 삭제
			Set fso = CreateObject("Scripting.FileSystemObject")
			If isarray(attach_file) Then
				For i = 1 To ubound(attach_file)
					uploadFolder = ConfigAttachedFileFolder & "" & menu_type & "\"
					strFileName = uploadFolder & attach_file(i)

					If (fso.FileExists(strFileName)) Then
						fso.DeleteFile(strFileName)
					End If
				Next
			End If
			
			If menu_type = "album" Then
				uploadFolder = ConfigAttachedFileFolder & "thumbnail\"
				strFileName = uploadFolder & file_name

				If (fso.FileExists(strFileName)) Then
					fso.DeleteFile(strFileName)
				End If
			End If
			Set fso = Nothing
		End If
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("<%=msg%> 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='waste_<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/waste_<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>') ;
<%
	End if
%>
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

<!--#include virtual="/include/config_inc.asp"-->
<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "picture\"
	uploadform.DefaultPath = uploadFolder
	' �ϳ��� ���� ũ�⸦ 1MB���Ϸ� ����.
	uploadform.MaxFileLen = 10*1024*1024

	del = uploadform("del")
	memo_receive_yn = uploadform("memo_receive_yn")
	user_id = session("user_id")

	If uploadform("picture") <> "" Then
		IF uploadform("picture").FileLen > uploadform.MaxFileLen Then
			call msggo("������ ũ��� " & CInt(uploadform.MaxFileLen/1024/1014) & "MB�� �Ѿ�� �ȵ˴ϴ�","")
			Set uploadform = Nothing
			Response.End
		End If
	End If

	If UploadForm("picture") <> "" Then
		FilePath = UploadForm("picture").Save(,False)
		picture = uploadform("picture").LastSavedFileName
	End If

	Set UploadForm = Nothing

	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set memo_receive_yn = '" & memo_receive_yn & "' "
	If del = "Y" Then
	sql = sql & "       ,picture = null "
	ElseIf picture <> "" Then
	sql = sql & "       ,picture = '" & picture & "' "
	End If
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & user_id & "' "
	Conn.Execute(sql)
%>
<script>
alert("�����Ǿ����ϴ�.")
parent.location = 'my_info_edit.asp'
</script>

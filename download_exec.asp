<%
	menu_type = Request("menu_type")
	file_name = Request("file_name")
	file_path = Request("file_path")
	If file_path = "" then
	file_path = Server.MapPath("\") & "\" & "uploads\" & menu_type & "\" & file_name
	End if

	file_name2 = "/uploads/"& menu_type & "/" & file_name
	'response.write file_name2
	'response.end
	response.redirect file_name2


'    Response.Expires = 0
'     Response.Buffer = True
'     Response.Clear

'    Set fs = Server.CreateObject("Scripting.FileSystemObject")

	'response.write file_path & file_name
	'response.end

'    If fs.FileExists(file_path) Then
         '������ ������� ������ ��Ʈ�� ���·� ���� ������.
'         Response.ContentType = "application/octet-stream"
'         Response.CacheControl = "public"
'         Response.AddHeader "Content-Disposition","attachment;filename=" & file_name

'        Set Stream=Server.CreateObject("ADODB.Stream")
'         Stream.Open
'         Stream.Type=1
'         Stream.LoadFromFile file_path
'         Response.BinaryWrite Stream.Read
'         Stream.close
'         Set Stream = nothing
'     Else 
'         '������ ���� ���...
'         Response.Write "�ش� ������ ã�� �� �����ϴ�."
'     End If
     
'     Set fs = Nothing
%>

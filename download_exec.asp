<%@Language="VBScript" CODEPAGE="65001" %>
<%
	menu_type = Request("menu_type")
	file_name = Request("file_name")
	file_path = Request("file_path")
	If file_path = "" then
	file_path = Server.MapPath("\") & "\" & "uploads\" & menu_type & "\" & file_name
	End if

	file_name2 = "/uploads/" & menu_type & "/" & file_name
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
         '파일이 있을경우 파일을 스트림 형태로 열어 보낸다.
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
'         '파일이 없을 경우...
'         Response.Write "해당 파일을 찾을 수 없습니다."
'     End If
     
'     Set fs = Nothing
%>

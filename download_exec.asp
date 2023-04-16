<%
	Response.Buffer = False
	menu_type = Request("menu_type")
	file_name = Request("file_name")
	file_path = Request("file_path")

	If file_path = "" Then
		file_path = Server.MapPath("\") & "\" & "uploads\" & menu_type & "\" & file_name
	End if

	file_path = Replace(file_path, "sarang", "dev")

	Response.AddHeader "Content-Disposition","attachment;filename=" & file_name
	'Response.write file_path

	Set objFS =Server.CreateObject("scripting.FileSystemObject")
	Set objF = objFS.GetFile(file_path)
	Response.AddHeader "Content-Length", objF.Size
	Set objF = Nothing
	Set objFS = Nothing

	Response.ContentType = "application/unknown"
	Response.CacheControl = "public"

	Set objDownload = Server.CreateObject("DEXT.FileDownload")
	objDownload.Download file_path
	Set objDownload = Nothing
%>

<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Set rs = Server.CreateObject("ADODB.Recordset")
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	Set objImage = server.CreateObject("DEXT.ImageProc")

'	sql = ""
'	sql = sql & " select ca.* "
'	sql = sql & "   from cf_album_attach ca "
'	rs.Open Sql, conn, 3, 1
'
'	If Not rs.eof Then
'		Do Until rs2.eof
'
'
'	End If
			If True = objImage.SetSourceFile(Server.MapPath("\") & "\sys\" & "test.png") Then

				Response.Write objImage.ImageFormat
				Response.Write objImage.ImageWidth
				Response.Write objImage.ImageHeight
			End If
%>

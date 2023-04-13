<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<!--#include virtual="/ipin_inc.asp"-->
<%
	uploadUrl = ConfigAttachedFileURL & "album/"

	album_seq = Request("album_seq")

	arr_image = ""

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select file_name "
	sql = sql & "   from cf_album_attach "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then

		totalcnt = rs.recordcount
		strReturnJson = strReturnJson & "{""TotalCnt"":""" & totalcnt & """, ""ResultList"":["

		Do Until rs.eof
			If arr_image = "" Then
				arr_image = rs("file_name")
			Else
				arr_image =  arr_image & "::" & rs("file_name")
			End If

			rs.MoveNext
			
			If Not(rs.EOF) Then 
				strReturnJson = strReturnJson & ","
			End If
		Loop

		strReturnJson = strReturnJson & "{"
		strReturnJson = strReturnJson & """arr_image"":""" & arr_image & ""","
		strReturnJson = strReturnJson & """uploadUrl"":""" & uploadUrl & """"
		strReturnJson = strReturnJson & "}"
		strReturnJson = strReturnJson & "]}"
	Else
		strReturnJson = strReturnJson & "{""TotalCnt"":""0""}"
	End If
	rs.Close
	Set rs = Nothing
	Response.Write strReturnJson
%>

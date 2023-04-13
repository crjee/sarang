<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	uploadUrl = ConfigAttachedFileURL & "banner/"

	banner_seq = Request("banner_seq")
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_banner "
	sql = sql & "  where banner_seq = '" & banner_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		totalcnt = rs.recordcount

		strReturnJson = strReturnJson & "{""TotalCnt"":""" & totalcnt & """, ""ResultList"":["

		Do Until rs.EOF
			banner_seq = rs("banner_seq")
			file_type = rs("file_type")
			file_name = rs("file_name")
			banner_type = rs("banner_type")
			subject = rs("subject")
			open_yn = rs("open_yn")
			link = rs("link")
			banner_width = rs("banner_width")
			banner_height = rs("banner_height")

			Select Case banner_type
				Case "T"
					banner_type_txt = "상단"
				Case "C0"
					banner_type_txt = "대문전체"
					width  = 800
					height = 170
				Case "C1"
					banner_type_txt = "대문1"
					width  = 266
					height = 170
				Case "C2"
					banner_type_txt = "대문2"
					width  = 266
					height = 170
				Case "C3"
					banner_type_txt = "대문3"
					width  = 266
					height = 170
				Case "R"
					banner_type_txt = "오른쪽"
					width  = 150
			End Select

			strReturnJson = strReturnJson & "{"
			strReturnJson = strReturnJson & """banner_seq"":""" & banner_seq & ""","
			strReturnJson = strReturnJson & """file_type"":""" & file_type & ""","
			strReturnJson = strReturnJson & """file_name"":""" & file_name & ""","
			strReturnJson = strReturnJson & """banner_type"":""" & banner_type & ""","
			strReturnJson = strReturnJson & """subject"":""" & subject & ""","
			strReturnJson = strReturnJson & """open_yn"":""" & open_yn & ""","
			strReturnJson = strReturnJson & """link"":""" & link & ""","
			strReturnJson = strReturnJson & """banner_width"":""" & banner_width & ""","
			strReturnJson = strReturnJson & """banner_height"":""" & banner_height & """"
			strReturnJson = strReturnJson & "}"

			rs.MoveNext
			
			If Not(rs.EOF) Then 
				strReturnJson = strReturnJson & ","
			End If
		Loop

		strReturnJson = strReturnJson & "]}"
	Else
		strReturnJson = strReturnJson & "{""TotalCnt"":""0""}"
	End If
	rs.Close
	Set rs = Nothing
	Response.Write strReturnJson
%>

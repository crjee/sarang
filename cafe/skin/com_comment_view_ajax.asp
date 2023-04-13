<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	menu_type = Request("menu_type")
	comment_seq = Request("comment_seq")
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & "_comment "
	sql = sql & "  where comment_seq = '" & comment_seq &  "' "
	rs.Open Sql, conn, 3, 1

	If Not(user_id = rs("user_id") Or cafe_ad_level = 10) Then
		strReturnJson = strReturnJson & "{""TotalCnt"":""0""}"
	Else
		comment = rs("comment")

		totalcnt = rs.recordcount

		strReturnJson = strReturnJson & "{""TotalCnt"":""" & totalcnt & """, ""ResultList"":["

		Do Until rs.EOF
			strReturnJson = strReturnJson & "{"
			strReturnJson = strReturnJson & """comment_seq"":""" & comment_seq & ""","
			strReturnJson = strReturnJson & """comment"":""" & comment & """"
			strReturnJson = strReturnJson & "}"

			rs.MoveNext
			
			If Not(rs.EOF) Then 
				strReturnJson = strReturnJson & ","
			End If
		Loop

		strReturnJson = strReturnJson & "]}"
	End If
	rs.Close
	Set rs = Nothing
	Response.Write strReturnJson
%>

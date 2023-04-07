<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	poll_seq = Request("poll_seq")
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_poll "
	sql = sql & "  where poll_seq = '" & poll_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		totalcnt = rs.recordcount

		strReturnJson = strReturnJson & "{""TotalCnt"":""" & totalcnt & """, ""ResultList"":["

		Do Until rs.EOF
			subject = rs("subject")
			ques01  = rs("ques1")  : If ques01 <> "" Then ques_cnt = ques_cnt + 1
			ques02  = rs("ques2")  : If ques02 <> "" Then ques_cnt = ques_cnt + 1
			ques03  = rs("ques3")  : If ques03 <> "" Then ques_cnt = ques_cnt + 1
			ques04  = rs("ques4")  : If ques04 <> "" Then ques_cnt = ques_cnt + 1
			ques05  = rs("ques5")  : If ques05 <> "" Then ques_cnt = ques_cnt + 1
			ques06  = rs("ques6")  : If ques06 <> "" Then ques_cnt = ques_cnt + 1
			ques07  = rs("ques7")  : If ques07 <> "" Then ques_cnt = ques_cnt + 1
			ques08  = rs("ques8")  : If ques08 <> "" Then ques_cnt = ques_cnt + 1
			ques09  = rs("ques9")  : If ques09 <> "" Then ques_cnt = ques_cnt + 1
			ques10  = rs("ques10") : If ques10 <> "" Then ques_cnt = ques_cnt + 1
			count   = rs("count")  : If count < 1 Then count = ques_cnt
			sdate   = rs("sdate")
			edate   = rs("edate")
			rprsv_cert_use_yn = rs("rprsv_cert_use_yn")
			ddln_yn   = rs("ddln_yn")

			strReturnJson = strReturnJson & "{"
			strReturnJson = strReturnJson & """poll_seq"":""" & poll_seq & ""","
			strReturnJson = strReturnJson & """subject"":""" & subject & ""","
			strReturnJson = strReturnJson & """ques01"":"""  & ques01  & ""","
			strReturnJson = strReturnJson & """ques02"":"""  & ques02  & ""","
			strReturnJson = strReturnJson & """ques03"":"""  & ques03  & ""","
			strReturnJson = strReturnJson & """ques04"":"""  & ques04  & ""","
			strReturnJson = strReturnJson & """ques05"":"""  & ques05  & ""","
			strReturnJson = strReturnJson & """ques06"":"""  & ques06  & ""","
			strReturnJson = strReturnJson & """ques07"":"""  & ques07  & ""","
			strReturnJson = strReturnJson & """ques08"":"""  & ques08  & ""","
			strReturnJson = strReturnJson & """ques09"":"""  & ques09  & ""","
			strReturnJson = strReturnJson & """ques10"":"""  & ques10  & ""","
			strReturnJson = strReturnJson & """count"":"""   & count   & ""","
			strReturnJson = strReturnJson & """rprsv_cert_use_yn"":"""   & rprsv_cert_use_yn   & ""","
			strReturnJson = strReturnJson & """ddln_yn"":"""   & ddln_yn   & ""","
			strReturnJson = strReturnJson & """sdate"":""" & sdate & ""","
			strReturnJson = strReturnJson & """edate"":""" & edate & """"
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

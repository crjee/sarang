<%
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Application("db")
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cf.cafe_name   "
	sql = sql & "       ,cf.cafe_img    "
	sql = sql & "       ,cf.cafe_id     "
	sql = sql & "       ,cf.open_yn     "
	sql = sql & "       ,cf.reg_type    "
	sql = sql & "       ,cf.cate_id     "
	sql = sql & "       ,cf.visit_cnt   "
	sql = sql & "       ,cf.cafe_type   "
	sql = sql & "       ,cf.union_id    "
	sql = sql & "       ,cf.reg_level   "
	sql = sql & "       ,cf.activity_yn "
	sql = sql & "       ,cf.creid       "
	sql = sql & "       ,cf.credt       "
	sql = sql & "       ,cf.modid       "
	sql = sql & "       ,cf.moddt       "
	sql = sql & "   from cf_cafe cf     "
	sql = sql & "  where 1=1            "
	sql = sql & "  order by cafe_id     "

	rs.open Sql, conn, 3, 1

	conStr = ""
	If Not rs.EOF Then
		Do Until rs.EOF
			cafe_name = rs("cafe_name")
			cafe_img  = rs("cafe_img")
			cafe_id   = rs("cafe_id")
			open_yn = rs("open_yn")
			reg_type  = rs("reg_type")
			cate_id   = rs("cate_id")
			visit_cnt = rs("visit_cnt")
			cafe_type = rs("cafe_type")
			reg_level = rs("reg_level")
			activity_yn = rs("activity_yn")
			creid     = rs("creid")
			credt     = rs("credt")
			modid     = rs("modid")
			moddt     = rs("moddt")

			conStr = conStr & vbcrlf & "                <rule name=""" & cafe_id & """ stopProcessing=""true"">"
			conStr = conStr & vbcrlf & "                    <match url=""^" & cafe_id & """ />"
			conStr = conStr & vbcrlf & "                    <action type=""Rewrite"" url=""cafe/main.asp?cafe_id={R:0}"" />"
			conStr = conStr & vbcrlf & "                </rule>"

			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing

	auth_url = Server.MapPath("\")

	Set fso = CreateObject("scripting.filesystemobject")
Response.write auth_url & "\web_bak.config"
	Set config = fso.OpenTextFile(auth_url & "\web_bak.config", 1, False, 0)
	strText = config.readAll
	config.close

	wrText = Replace(strText, getGroup(strText, "<rules>", "</rules>"), conStr & vbcrlf & "            ")
	Response.write wrText

	Dim configFile
	Set configFile = CreateObject("ADODB.Stream")
	configFile.Mode=3
	configFile.Type=2
	configFile.Charset = "utf-8"
	configFile.Open
	configFile.WriteText(wrText), 1
	configFile.SaveToFile auth_url & "\web.config", 2
	configFile.Flush
	configFile.Close
	Set configFile = Nothing

	Function getGroup(ByVal tg_str, ByVal st_str, ByVal ed_str) ' 문자열 사이의 값
'		Response.write "re_str : " & tg_str & "  " & st_str & "  " & ed_str & "<br>"
		If InStr(tg_str, st_str) Then
			re_str = right(tg_str, Len(tg_str) - InStr(tg_str, st_str) - Len(st_str) + 1)
			re_str = Left(re_str, InStr(re_str, ed_str) - 1)
		Else
			re_str = tg_str
		End If

'		Response.write "re_str : " & re_str & "<br>"
		getGroup = re_str
	End Function

	Function getGroupA(ByVal tgStr, ByVal stStr, ByVal edStr)
		If InStr(tgStr, stStr) Then
			reStr = Right(tgStr, Len(tgStr) - InStr(tgStr, stStr) - Len(stStr) + 1)
			reStr = stStr & Left(reStr, InStr(reStr, edStr) - 1) & edStr
		Else
			reStr = ""
		End If
		getGroupA = reStr
	End Function
%>

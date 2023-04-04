<%
	user_id = request("userid")
	user_pw = request("userpw")

	remote_addr = request.ServerVariables("remote_addr")
	http_user_agent = request.ServerVariables("http_user_agent")
	http_referer = request.ServerVariables("http_referer")

	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Application("db")

	sql = ""
	sql = sql & " select mi.user_id                                        "
	sql = sql & "       ,mi.agency                                         "
	sql = sql & "       ,mi.kname                                          "
	sql = sql & "       ,mi.ename                                          "
	sql = sql & "       ,cm.cafe_id                                        "
	sql = sql & "       ,cf.union_id                                       "
	sql = sql & "       ,mi.stat                                           "
	sql = sql & "       ,ad.cafe_ad_level                                  "
	sql = sql & "       ,cm.cafe_mb_level                                  "
	sql = sql & "       ,cs.skin_id                                        "
	sql = sql & "   from cf_member mi                                      "
	sql = sql & "   left outer join cf_cafe_member cm on cm.user_id = mi.user_id "
	sql = sql & "   left outer join cf_admin ad on ad.user_id = mi.user_id "
	sql = sql & "   left outer join cf_cafe cf on cf.cafe_id = mi.cafe_id  "
	sql = sql & "   left outer join cf_skin cs on cs.cafe_id = cf.cafe_id  "
	sql = sql & "  where mi.user_id = '" & user_id & "'                        "

'http://gisarangbang.krei.co.kr/exdefault.asp?userid=DBB545&userpw=0xF667CC8E65823D5034D62AF6276741F8F890F36C8361FC4FED268DF84144CAA0
	Set mem = Conn.Execute(sql)
	if not mem.eof Then
	
		If Trim(mem("stat")) = "Y" Then
			stat = "Y"
			set_log()

			Session.timeout = 1440
			Session("user_id") = mem("user_id")
			Session("agency") = mem("agency")
			Session("kname") = mem("kname")
			Session("ename") = mem("ename")
			Session("mycafe") = mem("cafe_id")
			Session("cafe_ad_level") = mem("cafe_ad_level")
			Session("cafe_mb_level") = mem("cafe_mb_level")
			Session("skin_id") = mem("skin_id")

			If mem("union_id") = "jungdong" Then
				cafe_id = "jungdong"
			Else
				cafe_id = mem("cafe_id")
			End If

			Response.Write "<script>document.location.href = '/?cafe_id=" & cafe_id & "';</script>"
			Response.End
		Else
			stat = "N"
			set_log()

			session.Abandon
'			Response.Write "<script>alert('활동중지 회원이십니다.')</script>"
			Response.Write "<script>location.href='http://cafe.daum.net';</script>"
			Response.End
		End if
	Else
		stat = "x"
		set_log()

		session.Abandon
'		Response.Write "<script>alert('올바르지 않은 접근입니다.')</script>"
		Response.Write "<script>location.href='http://cafe.daum.net';</script>"
		Response.Write "<script>alert('올바르지 않은 접근입니다!!.');history.back();</script>"
		Response.end
	end If
	
	mem.Close()
	Conn.Close()
	Set Conn = Nothing

	Sub set_log()
		sql = ""
		sql = sql & " insert into cf_visit_log( "
		sql = sql & "        user_id "
		sql = sql & "       ,stat "
		sql = sql & "       ,user_ip "
		sql = sql & "       ,user_agent "
		sql = sql & "       ,refer_page "
		sql = sql & "       ,log_time "
		sql = sql & "       ,s_mon "
		sql = sql & "       ,s_day "
		sql = sql & "       ,s_hour "
		sql = sql & "       ,log_type "
		sql = sql & "      ) values( "
		sql = sql & "        '" & user_id & "' "
		sql = sql & "       ,'" & stat & "' "
		sql = sql & "       ,'" & remote_addr & "' "
		sql = sql & "       ,'" & http_user_agent & "' "
		sql = sql & "       ,'" & http_referer & "' "
		sql = sql & "       ,getdate() "
		sql = sql & "       ,'" & month(date) & "' " 
		sql = sql & "       ,'" & day(date) & "' "
		sql = sql & "       ,'" & hour(time) & "' "
		sql = sql & "       ,'CS')"
		Conn.execute sql 
	End Sub
%>

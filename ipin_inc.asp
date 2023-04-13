<%
	If session("user_id") = "" Then
		user_id = Request("user_id")
		ipin    = Request("ipin")

		Set Conn = Server.CreateObject("ADODB.Connection")
		Conn.open Application("db")

		sql = ""
		sql = sql & " select mi.user_id                                        "
		sql = sql & "       ,mi.agency                                         "
		sql = sql & "       ,mi.kname                                          "
		sql = sql & "       ,mi.ename                                          "
		sql = sql & "       ,mi.cafe_id                                        "
		sql = sql & "       ,cf.union_id                                       "
		sql = sql & "       ,upper(mi.stat) stat                               "
		sql = sql & "       ,ad.cafe_ad_level                                  "
		sql = sql & "       ,cs.skin_id                                        "
		sql = sql & "   from cf_member mi                                      "
		sql = sql & "   left outer join cf_admin ad on ad.user_id = mi.user_id "
		sql = sql & "   left outer join cf_cafe cf on cf.cafe_id = mi.cafe_id  "
		sql = sql & "   left outer join cf_skin cs on cs.cafe_id = cf.cafe_id  "
		sql = sql & "  where mi.user_id = '" & user_id & "'                    "
		sql = sql & "    and mi.ipin = '" & ipin & "'                          "

		Set rs = Conn.Execute(sql)
		If Not rs.eof Then
			If Trim(rs("stat")) = "Y" Then
				set_log()

				Session.timeout = 1440
				Session("user_id")       = rs("user_id")
				Session("agency")        = rs("agency")
				Session("kname")         = rs("kname")
				Session("ename")         = rs("ename")
				Session("mycafe")        = rs("cafe_id")
				Session("cafe_ad_level") = rs("cafe_ad_level")
				Session("skin_id")       = rs("skin_id")

				If rs("union_id") = "jungdong" Then
					cafe_id = "jungdong"
				Else
					cafe_id = rs("cafe_id")
				End If
			Else
				stat = "N"
				Response.Write "<script>alert('활동중지 회원입니다!');window.close();</script>"
				Response.End
			End if
		Else
			stat = "X"
			Response.Write "<script>alert('일치하는 회원정보를 찾지못했습니다!1');window.close();</script>"
			Response.end
		End If
		
		rs.Close()
		Conn.Close()
		Set Conn = Nothing

		Sub set_log()
			sql = ""
			sql = sql & " update cf_member "
			sql = sql & "    set ipin = null "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where user_id = '" & user_id & "' "
			Conn.execute sql 

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
			sql = sql & "       ,'C/S')"
			Conn.execute sql 
		End Sub
	End if
%>

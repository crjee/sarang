<%
	If com_seq = "" Then Response.End
%>
<%
	cafe_mb_level = GetUserLevel(cafe_id)
	If GetToInt(reply_auth) <= GetToInt(cafe_mb_level) Then
		set rs = server.createobject("adodb.recordset")
		sql = ""
		sql = sql & " select cc.* "
		sql = sql & "   from cf_waste_" & menu_type & "_comment cc "
		sql = sql & "   left outer join cf_member cm on cm.user_id = cc.user_id "
		sql = sql & "  where cc." & menu_type & "_seq = '" & com_seq & "' "
		sql = sql & "  order by cc.group_num desc, cc.step_num asc "
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
		comment_cnt = rs.recordcount
%>
				<div class="bbs_add_cont">
					<div class="bbs_add_cont_head">
						<h4>댓글</h4><span class="count"><%=comment_cnt%></span>
						<div class="posR">
						</div>
					</div>
					<div class="bbs_add_cont_body">
						<dl class="bac_box">
<%
			Do Until rs.eof
%>
							<dt>
								<strong title="<%=rs("tel_no")%>">
<%
			If rs("level_num") > 0 Then
%>
									<img src="/cafe/img/rb.png" height="0" width="<%=rs("level_num")*10%>">
									<img src="/cafe/img/re.png">
<%
			End If
%>
									<%=rs("agency")%>
								</strong>
								<span class=""><%=rs("credt")%><%If CStr(rs("reg_date")) = CStr(Date) then%>&nbsp;<img src="/cafe/img/btn/new.png" /><%End If%></span>
								<span class="posR">
<%
			comment = rs("comment")
			comment = Replace(comment, vbcrlf, "<br>")
%>
								</span>
							</dt>
							<dd>
								<%=comment%>
							</dd>
<%
			rs.MoveNext
		Loop
%>
						</dl>
					</div>
				</div>
<%
		End If
		rs.close
		Set rs = Nothing
	End If
%>

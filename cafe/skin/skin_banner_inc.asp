<%
	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select top 6 * "
	sql = sql & "       ,case when banner_type = 'C0' Then '800' "
	sql = sql & "             when banner_type = 'C1' Then '267' "
	sql = sql & "             when banner_type = 'C2' Then '266' "
	sql = sql & "             when banner_type = 'C3' Then '267' "
	sql = sql & "             end width "
	sql = sql & "       ,'170' as height "
	sql = sql & "   from cf_banner "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and open_yn = 'Y' "
	sql = sql & "    and banner_type like 'C%' "
	sql = sql & "  order by banner_type asc "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
%>
				<div class="visual_box">
<%
		Do Until rs.eof
			width       = rs("width")
			height      = rs("height")
			banner_type = rs("banner_type")

			If rs("link") <> "" Then
%>
							<a href="<%=rs("link")%>" target="_blank">
<%
			End If
%>
								<img src="<%=uploadUrl & rs("file_name")%>" style="width:<%=width%>px ;height:<%=height%>px;"/>
<%
			If rs("link") <> "" Then
%>
							</a>
<%
			End If
%>
						</li>
<%
			rs.MoveNext
		Loop
%>
					</ul>
				</div>
<%
	End If
	rs.close
%>

<%
	If cafe_id = "" Then Response.End

	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set bannerRs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select top 6 *                                 "
	sql = sql & "       ,case when banner_type = 'C0' Then '800' "
	sql = sql & "             when banner_type = 'C1' Then '267' "
	sql = sql & "             when banner_type = 'C2' Then '266' "
	sql = sql & "             when banner_type = 'C3' Then '267' "
	sql = sql & "             end width                          "
	sql = sql & "       ,'170' as height                         "
	sql = sql & "   from cf_banner                               "
	sql = sql & "  where cafe_id = '" & cafe_id & "'             "
	sql = sql & "    and open_yn = 'Y'                           "
	sql = sql & "    and banner_type like 'C%'                   "
	sql = sql & "  order by banner_type asc                      "
	sql = sql & "          ,banner_num asc                       "
	bannerRs.Open Sql, conn, 3, 1

	If Not bannerRs.eof Then
%>
				<div class="visual_box">
<%
		Do Until bannerRs.eof
			width       = bannerRs("width")
			height      = bannerRs("height")
			banner_type = bannerRs("banner_type")

			If bannerRs("link") <> "" Then
%>
							<a href="<%=bannerRs("link")%>" target="_blank">
<%
			End If
%>
								<img src="<%=uploadUrl & bannerRs("file_name")%>" style="width:<%=width%>px ;height:<%=height%>px;"/>
<%
			If bannerRs("link") <> "" Then
%>
							</a>
<%
			End If
%>
						</li>
<%
			bannerRs.MoveNext
		Loop
%>
					</ul>
				</div>
<%
	End If
	bannerRs.close
	Set bannerRs = Nothing
%>

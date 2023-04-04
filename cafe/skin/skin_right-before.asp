			<div id="LblockRight">
				<div id="Right">
					<ul>
<%
	uploadUrl = ConfigAttachedFileURL & "banner/"
	Set right_rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_banner "
	sql = sql & "  where cafe_id = '" & Session("cafe_id") & "' "
	sql = sql & "    and open_yn = 'Y' "
	sql = sql & "    and banner_type = 'R' "
	sql = sql & "  order by banner_num asc "
	right_rs.open Sql, conn, 3, 1

	If Not right_rs.eof then
		Do Until right_rs.eof
			banner_seq    =  right_rs("banner_seq")
			banner_num    =  right_rs("banner_num")
			banner_type   =  right_rs("banner_type")
			banner_subject =  right_rs("subject")
			file_name     =  right_rs("file_name")
			file_type     =  right_rs("file_type")
			banner_height =  right_rs("banner_height")
			banner_width  =  right_rs("banner_width")
			link          =  right_rs("link")
			open_yn       =  right_rs("open_yn")

			If banner_width = "" Then banner_width = "150"

			If file_type = "I" Then
%>
						<li>
<%
				If link <> "" Then
%>
							<a href="<%=link%>" target="_blank">
<%
				End If
%>
							<img src="<%=uploadUrl & file_name%>" style="width:150px;" />
<%
				If link <> "" Then
%>
							</a>
<%
				End If
%>
						</li>
<%
			elseIf file_type = "F" Then
%>
						<li>
							<div style="border:none;width:<%=banner_width%>px; height:<%=banner_height%>px;">
<%
				If link <> "" Then
%>
								<div style="border:none;position:absolute;left:0px;top:0px;z-index:1;background: rgba(255, 0, 0, 0); cursor: pointer; width:<%=banner_width%>px; height:<%=banner_height%>px" onclick="window.open('<%=link%>')"></div>
<%
				End If
%>
								<div style="border:none;position:absolute;left:0px;top:0px;z-index:-1; width:<%=banner_width%>px; height:<%=banner_height%>px">
									<embed src="<%=uploadUrl & file_name%>" style="width:<%=banner_width%>px; height:<%=banner_height%>px"/>
								</div>
							</div>
						</li>
<%
			End if

			right_rs.MoveNext
		Loop
	End If
	right_rs.close
	Set right_rs = nothing
%>
					</ul>
				</div>
			</div>

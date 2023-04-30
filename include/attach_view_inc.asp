<%
	uploadUrl = ConfigAttachedFileURL & menu_type & "/"
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set attcRs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                                          "
	sql = sql & "   from " & tb_prefix & "_" & menu_type & "_attach "
	sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "'  "
	sql = sql & "    and atch_file_se_cd = 'DATA'                   "
	sql = sql & "  order by attach_num                              "
	attcRs.Open Sql, conn, 3, 1

	attc_i = 0
	If Not attcRs.eof Then
		Do Until attcRs.eof

			file_name = attcRs("file_name")

			If (fso.FileExists(uploadFolder & file_name)) Then
				fileExt = LCase(Mid(file_name, InStrRev(file_name, ".") + 1))
				If fileExt = "pdf" Then
%>
						<%If attc_i > 0 Then%><br><%End If%>
						<a href="<%=uploadUrl & file_name%>" class="file"><img src="/cafe/img/inc/file.png" /> <%=attcRs("orgnl_file_nm")%></a>
<%
				Else
%>
						<%If attc_i > 0 Then%><br><%End If%>
						<a href="/download_exec.asp?menu_type=<%=menu_type%>&file_name=<%=file_name%>&orgnl_file_nm=<%=attcRs("orgnl_file_nm")%>" class="file"><img src="/cafe/img/inc/file.png" /> <%=attcRs("orgnl_file_nm")%></a>
<%
				End If
			Else
%>
						<%If attc_i > 0 Then%><br><%End If%>
						<a href="javascript:alert('파일이 존재하지 않습니다,')" class="file"><img src="/cafe/img/inc/file.png" /> <%=attcRs("orgnl_file_nm")%></a>
<%
			End If

			attc_i = attc_i + 1
			attcRs.MoveNext
		Loop
	End If
	attcRs.close
	Set attcRs = Nothing
	Set fso = Nothing
%>

<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<%
	menu_seq = Request("menu_seq")
	attach_seq = Request("attach_seq")
	ag = Request("ag")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	If menu_seq <> "" Then
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_menu "
		sql = sql & "  where menu_seq = '" & menu_seq  & "' "
		sql = sql & "    and cafe_id = '" & cafe_id  & "' "
		rs.Open Sql, conn, 3, 1

		If rs.EOF Then
			msggo "정상적인 사용이 아닙니다.",""
		Else
			menu_type = rs("menu_type")
			menu_name = rs("menu_name")
		End If
		rs.close
	Else
		menu_type = "notice"
	End If
	
	Set fso = CreateObject("Scripting.FileSystemObject")
	on Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	if menu_type = "album" Then

		sql = ""
		sql = sql & " select file_name, album_seq "
		sql = sql & "   from cf_album_attach "
		sql = sql & "  where attach_seq = '" & attach_seq  & "' "

		rs.Open Sql, conn, 3, 1
		If Not rs.EOF Then
			file_name = rs("file_name")
			album_seq = rs("album_seq")
		End If
		rs.close
	
		sql = ""
		sql = sql & " select top 1 * "
		sql = sql & "   from cf_album_attach "
		sql = sql & "  where album_seq = '" & album_seq  & "' "
		sql = sql & "  order by attach_seq "
		rs.Open Sql, conn, 3, 1

		If Not rs.EOF Then
			sub_seq = rs("attach_seq")
			sub_file_name = rs("file_name")
		End If
		rs.close

		sql = ""
		sql = sql & " delete "
		sql = sql & "   from cf_album_attach "
		sql = sql & "  where attach_seq = '" & attach_seq  & "' "
		Conn.Execute(sql)

		if CStr(album_seq) = CStr(sub_seq) Then

			sql = ""
			sql = sql & " select thumbnail "
			sql = sql & "   from cf_album "
			sql = sql & "  where album_seq = '" & album_seq  & "' "
			rs.Open Sql, conn, 3, 1

			If Not rs.EOF Then
				del_thumbnail = rs("thumbnail")
			End If
			rs.close

			sql = ""
			sql = sql & " select top 1 * "
			sql = sql & "   from cf_" & menu_type & "_attach "
			sql = sql & "  where album_seq = '" & album_seq  & "' "
			sql = sql & "  order by attach_seq "
			rs.Open Sql, conn, 3, 1

			If Not rs.EOF Then
				sub_seq2 = rs("attach_seq")
				sub_file_name = rs("file_name")
				filenameonly = Left(sub_file_name, instrRev(sub_file_name, ".") - 1)
				strext       = mid(sub_file_name, instrRev(sub_file_name, ".") + 1)

				set objImage = server.CreateObject("DEXT.ImageProc")

				if true = objImage.SetSourceFile(ConfigAttachedFileFolder & "album\" & sub_file_name) Then
					width  = objImage.ImageWidth
					height = objImage.ImageHeight

					if width > 140 Then
						wrate = width / 140
					End If
					if height > 140 Then
						hrate = height / 140
					End If

					if wrate > hrate Then
						rate = wrate
					Else
						rate = hrate
					End If

					'JPG 포맷으로 저장해야 함
					thumbnail = "thumbnail_" & com_seq & "_" & filenameonly & ".jpg"

					call objImage.SaveasThumbnail(ConfigAttachedFileFolder & "thumbnail\" & thumbnail, objImage.ImageWidth/rate, objImage.ImageHeight/rate, false, true)

					sql = ""
					sql = sql & " update cf_album "
					sql = sql & "    set thumbnail = '" & thumbnail & "' "
					sql = sql & "       ,modid = '" & Session("user_id") & "' "
					sql = sql & "       ,moddt = getdate() "
					sql = sql & "  where album_seq = '" & album_seq  & " '"
					Conn.Execute(sql)
				End If
			End If
			rs.close
		End If

	Else

		sql = ""
		sql = sql & " delete "
		sql = sql & "   from cf_" & menu_type & "_attach "
		sql = sql & "  where attach_seq = '" & attach_seq  & "' "
		Conn.Execute(sql)

	End If


	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing

		uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
		strFileName = uploadFolder & file_name
		If (fso.FileExists(strFileName)) Then
			fso.DeleteFile(strFileName)
		End If

		if del_thumbnail <> "" Then
			uploadFolder = ConfigAttachedFileFolder & "thumbnail\"
			strFileName = uploadFolder & del_thumbnail
			If (fso.FileExists(strFileName)) Then
				fso.DeleteFile(strFileName)
			End If
		End If

		Set fso = Nothing
%>
<script>
	alert("삭제 되었습니다.");
	str = '<input type="file" class="inp" name="file_name">';
	parent.document.all.attachDiv<%=ag%>.innerHTML = str;
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End If
%>

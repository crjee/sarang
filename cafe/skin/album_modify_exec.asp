<!--#include virtual="/include/config_inc.asp"-->
<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "album\"
	uploadform.DefaultPath = uploadFolder

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	group_num = uploadform("group_num")
	step_num = uploadform("step_num")
	level_num = uploadform("level_num")
	album_seq = uploadform("album_seq")
	kname = uploadform("kname")
	subject = uploadform("subject")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	For Each item In uploadform("file_name")
		If item <> "" Then
			If item.FileLen > UploadForm.MaxFileLen Then
				call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
				Set UploadForm = Nothing
				Response.End
			End If
		End If
	Next

	thumbnail = getonevalue("thumbnail","cf_album","where album_seq = '" & album_seq & "'")

	For Each item In uploadform("file_name")
		If item <> "" Then
			MimeType = item.MimeType

			'MimeType이 image/jpeg ,image/gIf이 아닌경우 업로드 중단
			If instr("image/jpeg/image/jpg,image/gIf,image/png,image/bmp", MimeType) Then
'				If thumbnail = "" And i = 1 Then
				If i = 1 Then
					Set objImage = server.CreateObject("DEXT.ImageProc")
					If true = objImage.SetSourceFile(uploadform.TempFilePath) Then
						width  = objImage.ImageWidth
						height = objImage.ImageHeight

						If width > 140 Then
							wrate = width / 140
						End If

						If height > 140 Then
							hrate = height / 140
						End If

						If wrate > hrate Then
							rate = wrate
						Else
							rate = hrate
						End If

						uploadFolder = ConfigAttachedFileFolder & "thumbnail\"
						uploadform.DefaultPath = uploadFolder
						'JPG 포맷으로 저장해야 함
						thumbnail = "thumbnail_" & album_seq & "_" & uploadform.FileNameWithoutExt & ".jpg"

						Call objImage.SaveasThumbnail(uploadFolder & thumbnail, objImage.ImageWidth/rate, objImage.ImageHeight/rate, false, true)
					End If
				End If

				uploadFolder = ConfigAttachedFileFolder & "album\"
				uploadform.DefaultPath = uploadFolder

				FilePath = item.Save(,False)
			Else
				msgonly uploadform.FileName & " 은 이미지파일이 아닙니다."
			End If
		End If
	Next

	sql = ""
	sql = sql & " update cf_album "
	sql = sql & "    set subject = '" & subject & "' "
	sql = sql & "       ,contents = '" & ir1 & "' "
	sql = sql & "       ,top_yn = '" & top_yn & "' "
	sql = sql & "       ,link = '" & link & "' "
	If thumbnail <> "" Then
	sql = sql & "       ,thumbnail = '" & thumbnail & "' "
	End If
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where album_seq = '" & album_seq & " '"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_album where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	For Each item In uploadform("file_name")
		If item <> "" Then
			new_seq = getSeq("cf_album_attach")

			sql = ""
			sql = sql & " insert into cf_album_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,album_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & album_seq & "' "
			sql = sql & "       ,'" & item.LastSavedFileName & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing
%>
<script>
	alert("수정 되었습니다.");
	parent.location.href='album_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&album_seq=<%=album_seq%>';
</script>

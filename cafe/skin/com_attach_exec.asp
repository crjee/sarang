<!--#include virtual="/include/config_inc.asp"-->
<%
	attach_seq = Request("attach_seq")
	ag = Request("ag")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	If menu_seq <> "" Then
		checkCafePage(cafe_id)
	Else
		menu_type = "notice"
	End If
	
	Set fso = CreateObject("Scripting.FileSystemObject")
	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	If menu_type = "album" Then
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

		If CStr(album_seq) = CStr(sub_seq) Then
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

				Set objImage = server.CreateObject("DEXT.ImageProc")

				If True = objImage.SetSourceFile(ConfigAttachedFileFolder & "album\" & sub_file_name) Then
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

					'JPG �������� �����ؾ� ��
					thumbnail = "thumbnail_" & com_seq & "_" & filenameonly & ".jpg"

					Call objImage.SaveasThumbnail(ConfigAttachedFileFolder & "thumbnail\" & thumbnail, objImage.ImageWidth/rate, objImage.ImageHeight/rate, false, true)

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

		If del_thumbnail <> "" Then
			uploadFolder = ConfigAttachedFileFolder & "thumbnail\"
			strFileName = uploadFolder & del_thumbnail
			If (fso.FileExists(strFileName)) Then
				fso.DeleteFile(strFileName)
			End If
		End If

		Set fso = Nothing
%>
<script>
	alert("���� �Ǿ����ϴ�.");
	str = '<input type="file" class="input" name="file_name" style="width:70%;">';
<%
	if ag = "1" Then
%>
	str = str + '<button class="btn_plus" type="button" onclick="addAttach()">&nbsp;</button>';
	str = str + '<button class="btn_minus" type="button" onclick="delAttach()">&nbsp;</button>';
<%
	End If
%>
	parent.document.all.attachDiv<%=ag%>.innerHTML = str;
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End If
%>

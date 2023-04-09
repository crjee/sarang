<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "banner\"
	uploadform.DefaultPath = uploadFolder
	banner_seq = uploadform("banner_seq")
	task = uploadform("task")
	banner_type = uploadform("banner_type")
	file_type = uploadform("file_type")
	subject = uploadform("subject")
	open_yn = uploadform("open_yn")
	link = uploadform("link")
	banner_width = uploadform("banner_width")
	banner_height = uploadform("banner_height")

	If UploadForm("file_name") <> "" Then
		Set fso = CreateObject("Scripting.FileSystemObject")
		FileName = uploadform("file_name").FileName
		strFileName = uploadFolder & FileName

		If uploadform("file_name").FileLen > uploadform.MaxFileLen Then
			call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
			Set uploadform = Nothing
			Response.End
		End If

		If UploadForm("file_name") <> "" Then
			FilePath = UploadForm("file_name").Save(,False)
		End If

		file_name = uploadform("file_name").LastSavedFileName
	End If

	Set UploadForm = Nothing

	If banner_type = "" Then
		banner_type = "R"
	End If

	If task = "ins" Then
		msg = "등록"

		Set rs = Conn.Execute("select top 1 banner_num from cf_banner where cafe_id='" & cafe_id & "' and banner_type='R' order by banner_num desc")

		If rs.eof Then
			banner_num = 1
		Else
			banner_num = rs("banner_num")+1
		End If

		new_seq = getSeq("cf_banner")
		sql = ""
		sql = sql & " insert into cf_banner( "
		sql = sql & "        banner_seq "
		sql = sql & "       ,cafe_id "
		sql = sql & "       ,banner_type "
		sql = sql & "       ,open_yn "
		sql = sql & "       ,subject "
		sql = sql & "       ,file_type "
		sql = sql & "       ,file_name "
		sql = sql & "       ,banner_num "
		sql = sql & "       ,banner_width "
		sql = sql & "       ,banner_height "
		sql = sql & "       ,link "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & new_seq & "' "
		sql = sql & "       ,'" & cafe_id & "' "
		sql = sql & "       ,'" & banner_type & "' "
		sql = sql & "       ,'" & open_yn & "' "
		sql = sql & "       ,'" & subject & "' "
		sql = sql & "       ,'" & file_type & "' "
		sql = sql & "       ,'" & file_name & "' "
		sql = sql & "       ,'" & banner_num & "' "
		sql = sql & "       ,'" & banner_width & "' "
		sql = sql & "       ,'" & banner_height & "' "
		sql = sql & "       ,'" & link & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)

		Response.write "<script>alert('" & msg & " 되었습니다.');parent.location = 'banner_list.asp';</script>"
	ElseIf task = "del" Then
		msg = "삭제"

		sql = "delete from cf_banner where banner_seq='" & banner_seq & "'"
		Conn.Execute(sql)

		Response.write "<script>alert('" & msg & " 되었습니다.');parent.location = 'banner_list.asp';</script>"
	ElseIf task = "upd" Then
		msg = "수정"

		sql = ""
		sql = sql & " update cf_banner "
		sql = sql & "    set open_yn = '" & open_yn & "' "
		sql = sql & "       ,subject = '" & subject & "' "
		sql = sql & "       ,file_type = '" & file_type & "' "
		If file_name <> "" Then
		sql = sql & "       ,file_name = '" & file_name & "'"
		End If
		sql = sql & "       ,banner_width = '" & banner_width & "' "
		sql = sql & "       ,banner_height = '" & banner_height & "' "
		sql = sql & "       ,link = '" & link & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where banner_seq = '" & banner_seq & "'"
		Conn.Execute(sql)

		Response.write "<script>alert('" & msg & " 되었습니다.');parent.location = 'banner_list.asp';</script>"
		'Response.write "<script>alert('" & msg & " 되었습니다.');parent.opener.location = 'banner_list.asp';parent.close();</script>"
	End If
%>

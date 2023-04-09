<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "cafeimg\"
	uploadform.DefaultPath = uploadFolder
	' 하나의 파일 크기를 1MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024

	cafe_id   = uploadform("cafe_id")
	cafe_name = uploadform("cafe_name")
	open_yn   = uploadform("open_yn")
	open_type = uploadform("open_type")

	If open_type = "" Then open_type = "C"

	old_name = getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe_id & "'")

	cafe_img = UploadForm("cafe_img")

	If uploadform("cafe_img") <> "" Then
		IF uploadform("cafe_img").FileLen > uploadform.MaxFileLen Then
			Call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
			Set uploadform = Nothing
			Response.End
		End If
	End If

	If UploadForm("cafe_img") <> "" Then
		FilePath = UploadForm("cafe_img").Save(,False)
		file_name = uploadform("cafe_img").LastSavedFileName
	End If

	Set UploadForm = Nothing

	sql = ""
	sql = sql & " update cf_cafe set "
	sql = sql & "    set cafe_name = '" & cafe_name & "' "
	If file_name <> "" Then
	sql = sql & "       ,cafe_img  = '" & file_name & "' "
	end if
	sql = sql & "       ,open_yn   = '" & open_yn & "' "
	sql = sql & "       ,open_type = '" & open_type & "' "
	sql = sql & "       ,cate_id   = '" & cate_id & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	Conn.Execute(sql)

	If old_name <> cafe_name Then
		sql = ""
		sql = sql & " update cf_menu "
		sql = sql & "    set menu_name = replace(menu_name, '" & old_name & "', '" & cafe_name & "') "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		Conn.Execute(sql)
	End if
%>
<script>
alert("수정되었습니다.")
parent.location = 'cafe_info_edit.asp'
</script>

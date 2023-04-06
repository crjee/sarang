<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	menu_type = "notice"

	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "notice\"
	uploadform.DefaultPath = uploadFolder

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	notice_seq = uploadform("notice_seq")
	kname = uploadform("kname")
	subject = uploadform("subject")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")
	pop_yn = uploadform("pop_yn")

	allcafe = uploadform("allcafe")
	opt_value = uploadform("opt_value")

	For Each item In uploadform("file_name")
		If item <> "" Then
			IF item.FileLen > UploadForm.MaxFileLen Then
				call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
				Set UploadForm = Nothing
				Response.End
			End If
		End If
	Next

	For Each item In uploadform("file_name")
		If item <> "" Then
			FilePath = item.Save(,False)
		End If
	Next

	If allcafe = "all" Then
		cafe_id = ""
	Else
		cafe_id = opt_value
	End If

	sql = ""
	sql = sql & " update cf_notice "
	sql = sql & "    set subject  = '" & subject & "' "
	sql = sql & "       ,contents = '" & ir1 & "' "
	sql = sql & "       ,top_yn   = '" & top_yn & "' "
	sql = sql & "       ,pop_yn   = '" & pop_yn & "' "
	sql = sql & "       ,cafe_id  = '" & cafe_id & "' "
	sql = sql & "       ,link     = '" & link & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & " where notice_seq = '" & notice_seq & "' "
	Conn.Execute(sql)

	For Each item In uploadform("file_name")
		If item <> "" Then
			new_seq = getSeq("cf_notice_attach")

			sql = ""
			sql = sql & " insert into cf_notice_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,notice_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & notice_seq & "' "
			sql = sql & "       ,'" & item.LastSavedFileName & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing
%>
<form name="form" action="notice_view.asp" method="post">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="sch_type" value="<%=sch_type%>">
<input type="hidden" name="sch_word" value="<%=sch_word%>">
<input type="hidden" name="notice_seq" value="<%=notice_seq%>">
</form>
<script>
	alert("수정 되었습니다.");
	parent.location.href='notice_view.asp?page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
</script>


<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	checkCafePageUpload(cafe_id)

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	board_seq = uploadform("board_seq")
	kname = uploadform("kname")
	subject = uploadform("subject")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

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

	sql = ""
	sql = sql & " update cf_board "
	sql = sql & "    set subject = '" & subject & "' "
	sql = sql & "       ,contents = '" & ir1 & "' "
	sql = sql & "       ,top_yn = '" & top_yn & "' "
	sql = sql & "       ,link = '" & link & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & " where board_seq = '" & board_seq & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_board where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	For Each item In uploadform("file_name")
		If item <> "" Then
			new_seq = getSeq("cf_board_attach")

			sql = ""
			sql = sql & " insert into cf_board_attach(attach_seq "
			sql = sql & "       ,board_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & board_seq & "' "
			sql = sql & "       ,'" & item.LastSavedFileName & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing
%>
<form name="form" action="board_view.asp" method="post">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="sch_type" value="<%=sch_type%>">
<input type="hidden" name="sch_word" value="<%=sch_word%>">
<input type="hidden" name="board_seq" value="<%=board_seq%>">
</form>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='board_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&board_seq=<%=board_seq%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/board_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&board_seq=<%=board_seq%>') ;
<%
	End if
%>
</script>

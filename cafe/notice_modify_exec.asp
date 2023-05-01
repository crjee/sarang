<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	Call CheckMultipart()

	Call CheckAdmin()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "notice\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = uploadform(menu_type & "_seq")
	Call CheckDataExist(com_seq)

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	notice_seq  = uploadform("notice_seq")

	top_yn      = uploadform("top_yn")
	pop_yn      = uploadform("pop_yn")
	section_seq = uploadform("section_seq")
	subject     = Replace(uploadform("subject"),"'","&#39;")
	contents    = Replace(uploadform("contents"),"'","&#39;")
	link        = uploadform("link")
	If link     = "http://" Then link = ""

	allcafe     = uploadform("allcafe")
	opt_value   = uploadform("opt_value")

	If allcafe = "all" Then
		cafe_id = ""
	Else
		cafe_id = opt_value
	End If

	sql = ""
	sql = sql & " update cf_notice                                  "
	sql = sql & "    set subject     = '" & subject            & "' "
	sql = sql & "       ,contents    = '" & contents           & "' "
	sql = sql & "       ,top_yn      = '" & top_yn             & "' "
	sql = sql & "       ,section_seq = '" & section_seq        & "' "
	sql = sql & "       ,pop_yn      = '" & pop_yn             & "' "
	sql = sql & "       ,cafe_id     = '" & cafe_id            & "' "
	sql = sql & "       ,link        = '" & link               & "' "
	sql = sql & "       ,modid       = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt       = getdate()                    "
	sql = sql & " where notice_seq = '" & notice_seq & "'           "
	Conn.Execute(sql)

	com_seq = notice_seq

%>
<!--#include  virtual="/include/attach_exec_inc.asp"-->
<%

	Set rs = Nothing
	Set fso = Nothing
	Set uploadform = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<form name="form" action="notice_view.asp" method="post">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="sch_type" value="<%=sch_type%>">
<input type="hidden" name="sch_word" value="<%=sch_word%>">
<input type="hidden" name="notice_seq" value="<%=notice_seq%>">
</form>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
<%
		If session("noFrame") = "Y" Then
%>
	parent.location.href='notice_view.asp?page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>';
<%
		Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/notice_view.asp?page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&notice_seq=<%=notice_seq%>') ;
<%
		End If
%>
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
		Set fso = CreateObject("Scripting.FileSystemObject")

		uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
		dsplyFolder  = ConfigAttachedFileFolder & "display\" & menu_type & "\"
		thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\" & menu_type & "\"

		For j = 1 To img_i
			If img_file_name(j) <> "" Then
				If (fso.FileExists(uploadFolder & img_file_name(j))) Then
					fso.DeleteFile(uploadFolder & img_file_name(j))
				End If
				If (fso.FileExists(dsplyFolder & dsply_file_nm(j))) Then
					fso.DeleteFile(dsplyFolder & dsply_file_nm(j))
				End If
				If (fso.FileExists(thmbnlFolder & thmbnl_file_nm(j))) Then
					fso.DeleteFile(thmbnlFolder & thmbnl_file_nm(j))
				End If
			End If
		Next

		For j = 1 To data_i
			If data_file_name(j) <> "" Then
				If (fso.FileExists(uploadFolder & data_file_name(j))) Then
					fso.DeleteFile(uploadFolder & data_file_name(j))
				End If
			End If
		Next

		Set fso = Nothing
	End If
%>

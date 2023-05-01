<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "job\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = uploadform(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckModifyAuth(cafe_id)

	dsplyFolder  = ConfigAttachedFileFolder & "display\job\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\job\"


	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject("ADODB.Recordset")

	menu_seq    = uploadform("menu_seq")
	page        = uploadform("page")
	pagesize    = uploadform("pagesize")
	sch_type    = uploadform("sch_type")
	sch_word    = uploadform("sch_word")
	self_yn     = uploadform("self_yn")
	all_yn      = uploadform("all_yn")

	job_seq     = uploadform("job_seq")

	top_yn      = uploadform("top_yn")
	subject     = uploadform("subject")
	work        = uploadform("work")
	age1        = uploadform("age1")
	age2        = uploadform("age2")
	sex         = uploadform("sex")
	work_year   = uploadform("work_year")
	certify     = uploadform("certify")
	work_place  = uploadform("work_place")
	agency      = uploadform("agency")
	person      = uploadform("person")
	tel_no      = uploadform("tel_no")
	mbl_telno   = uploadform("mbl_telno")
	fax_no      = uploadform("fax_no")
	email       = uploadform("email")
	homepage    = uploadform("homepage")
	method      = uploadform("method")
	end_date    = uploadform("end_date")
	contents    = uploadform("contents")
	section_seq = uploadform("section_seq")

	If age1 <> "" Or age2 <> "" Then
		age  = age1 & "~" & age2
	End If

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " update cf_job                                     "
	sql = sql & "    set subject     = '" & subject            & "' "
	sql = sql & "       ,work        = '" & work               & "' "
	sql = sql & "       ,age         = '" & age                & "' "
	sql = sql & "       ,sex         = '" & sex                & "' "
	sql = sql & "       ,work_year   = '" & work_year          & "' "
	sql = sql & "       ,certify     = '" & certify            & "' "
	sql = sql & "       ,work_place  = '" & work_place         & "' "
	sql = sql & "       ,agency      = '" & agency             & "' "
	sql = sql & "       ,person      = '" & person             & "' "
	sql = sql & "       ,tel_no      = '" & tel_no             & "' "
	sql = sql & "       ,mbl_telno   = '" & mbl_telno          & "' "
	sql = sql & "       ,fax_no      = '" & fax_no             & "' "
	sql = sql & "       ,email       = '" & email              & "' "
	sql = sql & "       ,homepage    = '" & homepage           & "' "
	sql = sql & "       ,method      = '" & method             & "' "
	sql = sql & "       ,end_date    = '" & end_date           & "' "
	sql = sql & "       ,contents    = '" & contents           & "' "
	sql = sql & "       ,top_yn      = '" & top_yn             & "' "
	sql = sql & "       ,section_seq = '" & section_seq        & "' "
	sql = sql & "       ,modid       = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt       = getdate()                    "
	sql = sql & "  where job_seq = '" & job_seq & "'                "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_job where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	com_seq = job_seq

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
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
<%
		If session("noFrame") = "Y" Then
%>
	parent.location.href='job_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&job_seq=<%=job_seq%>&self_yn=<%=self_yn%>&all_yn=<%=all_yn%>';
<%
		Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/job_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&job_seq=<%=job_seq%>&self_yn=<%=self_yn%>&all_yn=<%=all_yn%>') ;
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
<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckMultipart()

	cafe_id = "home"

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

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	job_seq   = uploadform("job_seq")

	top_yn      = uploadform("top_yn")
	pop_yn      = uploadform("pop_yn")
	section_seq = uploadform("section_seq")
	subject     = Replace(uploadform("subject"),"'","&#39;")
	contents    = Replace(uploadform("contents"),"'","&#39;")
	link        = uploadform("link")
	If link     = "http://" Then link = ""

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	work       = uploadform("work")
	age        = uploadform("age")
	sex        = uploadform("sex")
	work_year  = uploadform("work_year")
	certify    = uploadform("certify")
	work_place = uploadform("work_place")
	person     = uploadform("person")
	tel_no     = uploadform("tel_no")
	mbl_telno  = uploadform("mbl_telno")
	fax_no     = uploadform("fax_no")
	email      = uploadform("email")
	homepage   = uploadform("homepage")
	method     = uploadform("method")
	end_date   = uploadform("end_date")

	sql = ""
	sql = sql & " update gi_job "
	sql = sql & "    set top_yn            = '" & top_yn             & "' "
	sql = sql & "       ,pop_yn            = '" & pop_yn             & "' "
	sql = sql & "       ,section_seq       = '" & section_seq        & "' "
	sql = sql & "       ,subject           = '" & subject            & "' "
	sql = sql & "       ,contents          = '" & contents           & "' "
	sql = sql & "       ,link              = '" & link               & "' "

	sql = sql & "       ,work              = '" & work               & "' "
	sql = sql & "       ,age               = '" & age                & "' "
	sql = sql & "       ,sex               = '" & sex                & "' "
	sql = sql & "       ,work_year         = '" & work_year          & "' "
	sql = sql & "       ,certify           = '" & certify            & "' "
	sql = sql & "       ,work_place        = '" & work_place         & "' "
	sql = sql & "       ,person            = '" & person             & "' "
	sql = sql & "       ,tel_no            = '" & tel_no             & "' "
	sql = sql & "       ,mbl_telno         = '" & mbl_telno          & "' "
	sql = sql & "       ,fax_no            = '" & fax_no             & "' "
	sql = sql & "       ,email             = '" & email              & "' "
	sql = sql & "       ,homepage          = '" & homepage           & "' "
	sql = sql & "       ,method            = '" & method             & "' "
	sql = sql & "       ,end_date          = '" & end_date           & "' "

	sql = sql & "       ,modid             = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt             = getdate()                    "
	sql = sql & "  where job_seq         = '" & job_seq            & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu                                                                                         "
	sql = sql & "    set top_cnt   = (select count(*) from gi_sale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate()                                                                           "
	sql = sql & "       ,modid     = '" & Session("user_id") & "'                                                        "
	sql = sql & "       ,moddt     = getdate()                                                                           "
	sql = sql & "  where menu_seq  = '" & menu_seq & "'                                                                  "
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
<form name="form" action="job_view.asp" method="post">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="sch_type" value="<%=sch_type%>">
<input type="hidden" name="sch_word" value="<%=sch_word%>">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<input type="hidden" name="job_seq" value="<%=job_seq%>">
</form>
<script>
	alert("수정 되었습니다.");
	parent.location.href='job_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&job_seq=<%=job_seq%>';
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

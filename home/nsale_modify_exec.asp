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
	uploadFolder = ConfigAttachedFileFolder & "nsale\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = uploadform(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckModifyAuth(cafe_id)

	dsplyFolder  = ConfigAttachedFileFolder & "display\nsale\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\nsale\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject("ADODB.Recordset")

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	nsale_seq = uploadform("nsale_seq")

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

	open_yn                = uploadform("open_yn")
	nsale_addr             = uploadform("nsale_addr")
	cmpl_se_cd             = uploadform("cmpl_se_cd")
	nsale_stts_cd          = uploadform("nsale_stts_cd")
	rect_notice_date       = uploadform("rect_notice_date")
	frst_receipt_acpt_date = uploadform("frst_receipt_acpt_date")
	scnd_receipt_acpt_date = uploadform("scnd_receipt_acpt_date")
	prize_anc_date         = uploadform("prize_anc_date")
	cnt_st_date            = uploadform("cnt_st_date")
	cnt_ed_date            = uploadform("cnt_ed_date")
	resale_st_date         = uploadform("resale_st_date")
	resale_ed_date         = uploadform("resale_ed_date")
	mvin_date              = uploadform("mvin_date")
	mdl_house_addr         = uploadform("mdl_house_addr")

	sql = ""
	sql = sql & " update gi_nsale "
	sql = sql & "    set top_yn                 = '" & top_yn                 & "' "
	sql = sql & "       ,pop_yn                 = '" & pop_yn                 & "' "
	sql = sql & "       ,section_seq            = '" & section_seq            & "' "
	sql = sql & "       ,subject                = '" & subject                & "' "
	sql = sql & "       ,contents               = '" & contents               & "' "
	sql = sql & "       ,link                   = '" & link                   & "' "

	sql = sql & "       ,open_yn                = '" & open_yn                & "' "
	sql = sql & "       ,nsale_addr             = '" & nsale_addr             & "' "
	sql = sql & "       ,cmpl_se_cd             = '" & cmpl_se_cd             & "' "
	sql = sql & "       ,nsale_stts_cd          = '" & nsale_stts_cd          & "' "
	sql = sql & "       ,rect_notice_date       = '" & rect_notice_date       & "' "
	sql = sql & "       ,frst_receipt_acpt_date = '" & frst_receipt_acpt_date & "' "
	sql = sql & "       ,scnd_receipt_acpt_date = '" & scnd_receipt_acpt_date & "' "
	sql = sql & "       ,prize_anc_date         = '" & prize_anc_date         & "' "
	sql = sql & "       ,cnt_st_date            = '" & cnt_st_date            & "' "
	sql = sql & "       ,cnt_ed_date            = '" & cnt_ed_date            & "' "
	sql = sql & "       ,resale_st_date         = '" & resale_st_date         & "' "
	sql = sql & "       ,resale_ed_date         = '" & resale_ed_date         & "' "
	sql = sql & "       ,mvin_date              = '" & mvin_date              & "' "
	sql = sql & "       ,mdl_house_addr         = '" & mdl_house_addr         & "' "

	sql = sql & "       ,modid                  = '" & Session("user_id")     & "' "
	sql = sql & "       ,moddt                  = getdate()                        "
	sql = sql & " where nsale_seq               = '" & nsale_seq              & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu                                                                                         "
	sql = sql & "    set top_cnt   = (select count(*) from gi_sale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate()                                                                           "
	sql = sql & "       ,modid     = '" & Session("user_id") & "'                                                        "
	sql = sql & "       ,moddt     = getdate()                                                                           "
	sql = sql & "  where menu_seq  = '" & menu_seq & "'                                                                  "
	Conn.Execute(sql)

	com_seq = nsale_seq

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
<form name="form" method="post" action="nsale_view.asp">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="sch_type" value="<%=sch_type%>">
<input type="hidden" name="sch_word" value="<%=sch_word%>">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<input type="hidden" name="nsale_seq" value="<%=nsale_seq%>">
</form>
<script>
	alert("수정 되었습니다.");
	parent.location.href='nsale_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&nsale_seq=<%=nsale_seq%>';
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

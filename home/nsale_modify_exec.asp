<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	checkCafePageUpload(cafe_id)
	checkModifyAuth(cafe_id)

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	nsale_seq = uploadform("nsale_seq")
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

	open_yn                = uploadform("open_yn")
	nsale_rgn_cd           = uploadform("nsale_rgn_cd")
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
	sql = sql & " update cf_nsale "
	sql = sql & "    set subject                = '" & subject                & "' "
	sql = sql & "       ,open_yn                = '" & open_yn                & "' "
	sql = sql & "       ,nsale_rgn_cd           = '" & nsale_rgn_cd           & "' "
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
	sql = sql & "       ,contents               = '" & ir1                    & "' "
	sql = sql & "       ,modid                  = '" & Session("user_id")     & "' "
	sql = sql & "       ,moddt                  = getdate()                        "
	sql = sql & " where nsale_seq = '" & nsale_seq & "' "
	Conn.Execute(sql)
	
	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_nsale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	For Each item In uploadform("file_name")
		If item <> "" Then
			new_seq = getSeq("cf_nsale_attach")

			sql = ""
			sql = sql & " insert into cf_nsale_attach(attach_seq "
			sql = sql & "       ,nsale_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & nsale_seq & "' "
			sql = sql & "       ,'" & item.LastSavedFileName & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing
%>
<form name="form" method="post" action="nsale_view.asp">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<input type="hidden" name="page" value="<%=page%>">
<input type="hidden" name="pagesize" value="<%=pagesize%>">
<input type="hidden" name="sch_type" value="<%=sch_type%>">
<input type="hidden" name="sch_word" value="<%=sch_word%>">
<input type="hidden" name="nsale_seq" value="<%=nsale_seq%>">
</form>
<script>
	alert("수정 되었습니다.");
	parent.location.href='nsale_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&nsale_seq=<%=nsale_seq%>';
</script>

<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<%
	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder
	' 하나의 파일 크기를 10MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024
	' 전체 파일의 크기를 50MB 이하로 제한.
	uploadform.TotalLen = 50*1024*1024

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select menu_type "
	sql = sql & "       ,isnull(daily_cnt,9999) as daily_cnt "
	sql = sql & "       ,inc_del_yn "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	Else
		daily_cnt = rs("daily_cnt")
		inc_del_yn = rs("inc_del_yn")
		menu_type = rs("menu_type")
	End If
	rs.close
	Set rs = Nothing

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	Set fso = CreateObject("Scripting.FileSystemObject")

	If Not (fso.FolderExists(uploadFolder)) Then
		fso.CreateFolder(uploadFolder)
	End If

	Set fso = Nothing
	uploadform.DefaultPath = uploadFolder

	nsale_seq = uploadform("nsale_seq")
	group_num = uploadform("group_num")
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")
	pst_rgn_se_cd = uploadform("pst_rgn_se_cd")

	For Each item In uploadform("file_name")
		If item <> "" Then
			IF item.FileLen > uploadform.MaxFileLen Then
				call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
				Set uploadform = Nothing
				Response.End
			End If
		End If
	Next

	For Each item In uploadform("file_name")
		If item <> "" Then
			FilePath = item.Save(,False)
		End If
	Next

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	new_seq = getSeq("cf_nsale")

	If group_num = "" Then ' 새글
		parent_seq = ""
		nsale_num = getNum(menu_type, cafe_id, menu_seq)
		group_num = nsale_num
		level_num = 0
		step_num = 0
	Else ' 답글
		parent_seq = nsale_seq
		nsale_num = ""
		group_num = group_num
		level_num = level_num + 1

		sql = ""
		sql = sql & " update cf_nsale "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "

		Conn.execute sql

		step_num = step_num + 1
	End If

	open_yn                = uploadform("open_yn")
	nsale_rgn_se_cd        = uploadform("nsale_rgn_se_cd")
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
	sql = sql & " insert into cf_nsale( "
	sql = sql & "        subject                "
	sql = sql & "       ,open_yn                "
	sql = sql & "       ,nsale_rgn_se_cd        "
	sql = sql & "       ,nsale_addr             "
	sql = sql & "       ,cmpl_se_cd             "
	sql = sql & "       ,nsale_stts_cd          "
	sql = sql & "       ,rect_notice_date       "
	sql = sql & "       ,frst_receipt_acpt_date "
	sql = sql & "       ,scnd_receipt_acpt_date "
	sql = sql & "       ,prize_anc_date         "
	sql = sql & "       ,cnt_st_date            "
	sql = sql & "       ,cnt_ed_date            "
	sql = sql & "       ,resale_st_date         "
	sql = sql & "       ,resale_ed_date         "
	sql = sql & "       ,mvin_date              "
	sql = sql & "       ,mdl_house_addr         "
	sql = sql & "       ,contents               "
	sql = sql & "       ,cafe_id                "
	sql = sql & "       ,nsale_seq              "
	sql = sql & "       ,top_yn                 "
	sql = sql & "       ,view_cnt               "
	sql = sql & "       ,parent_seq             "
	sql = sql & "       ,parent_del_yn          "
	sql = sql & "       ,restoreid              "
	sql = sql & "       ,restoredt              "
	sql = sql & "       ,comment_cnt            "
	sql = sql & "       ,step_num               "
	sql = sql & "       ,group_num              "
	sql = sql & "       ,menu_seq               "
	sql = sql & "       ,user_id                "
	sql = sql & "       ,level_num              "
	sql = sql & "       ,nsale_num              "
	sql = sql & "       ,creid                  "
	sql = sql & "       ,credt                  "
	sql = sql & "      ) values( "
	sql = sql & "        '" & subject                & "' "
	sql = sql & "       ,'" & open_yn                & "' "
	sql = sql & "       ,'" & nsale_rgn_se_cd        & "' "
	sql = sql & "       ,'" & nsale_addr             & "' "
	sql = sql & "       ,'" & cmpl_se_cd             & "' "
	sql = sql & "       ,'" & nsale_stts_cd          & "' "
	sql = sql & "       ,'" & rect_notice_date       & "' "
	sql = sql & "       ,'" & frst_receipt_acpt_date & "' "
	sql = sql & "       ,'" & scnd_receipt_acpt_date & "' "
	sql = sql & "       ,'" & prize_anc_date         & "' "
	sql = sql & "       ,'" & cnt_st_date            & "' "
	sql = sql & "       ,'" & cnt_ed_date            & "' "
	sql = sql & "       ,'" & resale_st_date         & "' "
	sql = sql & "       ,'" & resale_ed_date         & "' "
	sql = sql & "       ,'" & mvin_date              & "' "
	sql = sql & "       ,'" & mdl_house_addr         & "' "
	sql = sql & "       ,'" & ir1                    & "' "
	sql = sql & "       ,'" & cafe_id                & "' "
	sql = sql & "       ,'" & new_seq                & "' "
	sql = sql & "       ,'" & top_yn                 & "' "
	sql = sql & "       ,'" & view_cnt               & "' "
	sql = sql & "       ,'" & parent_seq             & "' "
	sql = sql & "       ,'" & parent_del_yn          & "' "
	sql = sql & "       ,'" & restoreid              & "' "
	sql = sql & "       ,'" & restoredt              & "' "
	sql = sql & "       ,'" & comment_cnt            & "' "
	sql = sql & "       ,'" & step_num               & "' "
	sql = sql & "       ,'" & group_num              & "' "
	sql = sql & "       ,'" & menu_seq               & "' "
	sql = sql & "       ,'" & user_id                & "' "
	sql = sql & "       ,'" & level_num              & "' "
	sql = sql & "       ,'" & nsale_num              & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_nsale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	nsale_seq = new_seq

	j = 1
	For Each item In uploadform("file_name")
		If item <> "" Then
			file_name = item.LastSavedFileName

			new_seq = getSeq("cf_nsale_attach")

			sql = ""
			sql = sql & " insert into cf_nsale_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,nsale_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values("
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & nsale_seq & "' "
			sql = sql & "       ,'" & file_name & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set uploadform = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	var cValue = "";
	var cDay = 1;
	var cName = "subject";
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
	if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

	alert("입력 되었습니다.");
	parent.location.href='nsale_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
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
	End if
%>

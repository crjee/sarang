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
	uploadFolder = ConfigAttachedFileFolder & "notice\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)

	dsplyFolder  = ConfigAttachedFileFolder & "display\notice\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\notice\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject("ADODB.Recordset")

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	notice_seq = uploadform("notice_seq")
	group_num = uploadform("group_num")
	level_num = uploadform("level_num")
	step_num  = uploadform("step_num")

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

	new_seq = GetComSeq("gi_notice")

	If group_num = "" Then ' 새글
		parent_seq = ""
		notice_num = GetComNum("notice", cafe_id, menu_seq)
		group_num = notice_num
		level_num = 0
		step_num = 0
	Else ' 답글
		parent_seq = notice_seq
		notice_num = ""
		group_num = group_num
		level_num = level_num + 1

		sql = ""
		sql = sql & " update gi_notice "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where menu_seq = " & menu_seq  & " "
		sql = sql & "    and group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "
		Conn.execute sql

		step_num = step_num + 1
	End If

	sql = ""
	sql = sql & " insert into gi_notice(               "
	sql = sql & "        notice_seq                    "
	sql = sql & "       ,notice_num                    "
	sql = sql & "       ,group_num                    "
	sql = sql & "       ,step_num                     "
	sql = sql & "       ,level_num                    "
	sql = sql & "       ,menu_seq                     "
	sql = sql & "       ,cafe_id                      "
	sql = sql & "       ,agency                       "
	sql = sql & "       ,top_yn                       "
	sql = sql & "       ,pop_yn                       "
	sql = sql & "       ,section_seq                  "
	sql = sql & "       ,subject                      "
	sql = sql & "       ,contents                     "
	sql = sql & "       ,link                         "

	sql = sql & "       ,user_id                      "
	sql = sql & "       ,reg_date                     "
	sql = sql & "       ,view_cnt                     "
	sql = sql & "       ,comment_cnt                  "
	sql = sql & "       ,suggest_cnt                  "
	sql = sql & "       ,parent_seq                   "
	sql = sql & "       ,creid                        "
	sql = sql & "       ,credt                        "
	sql = sql & "      ) values(                      "
	sql = sql & "        '" & new_seq            & "' "
	sql = sql & "       ,'" & notice_num         & "' "
	sql = sql & "       ,'" & group_num          & "' "
	sql = sql & "       ,'" & step_num           & "' "
	sql = sql & "       ,'" & level_num          & "' "
	sql = sql & "       ,'" & menu_seq           & "' "
	sql = sql & "       ,'" & cafe_id            & "' "
	sql = sql & "       ,'" & Session("agency")  & "' "
	sql = sql & "       ,'" & top_yn             & "' "
	sql = sql & "       ,'" & pop_yn             & "' "
	sql = sql & "       ,'" & section_seq        & "' "
	sql = sql & "       ,'" & subject            & "' "
	sql = sql & "       ,'" & contents           & "' "
	sql = sql & "       ,'" & link               & "' "

	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Date()             & "' "
	sql = sql & "       ,0 "
	sql = sql & "       ,0 "
	sql = sql & "       ,0 "
	sql = sql & "       ,'" & parent_seq         & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())                   "
	Conn.Execute(sql)

	If daily_cnt < 9999 Then
		sql = ""
		sql = sql & " insert into cf_write_log(           "
		sql = sql & "        write_seq                    "
		sql = sql & "       ,cafe_id                      "
		sql = sql & "       ,menu_seq                     "
		sql = sql & "       ,user_id                      "
		sql = sql & "       ,creid                        "
		sql = sql & "       ,credt                        "
		sql = sql & "      ) values(                      "
		sql = sql & "        '" & new_seq            & "' "
		sql = sql & "       ,'" & cafe_id            & "' "
		sql = sql & "       ,'" & menu_seq           & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)
	End If

	sql = ""
	sql = sql & " update cf_menu                                                                                         "
	sql = sql & "    set top_cnt   = (select count(*) from gi_sale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate()                                                                           "
	sql = sql & "       ,modid     = '" & Session("user_id") & "'                                                        "
	sql = sql & "       ,moddt     = getdate()                                                                           "
	sql = sql & "  where menu_seq  = '" & menu_seq & "'                                                                  "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from gi_temp_notice "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	sql = sql & "    and cafe_id  = '" & cafe_id  & "' "
	sql = sql & "    and user_id  = '" & Session("user_id")  & "' "
	Conn.Execute(sql)

	notice_seq = new_seq
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
<script>
	var cValue = "";
	var cDay = 1;
	var cName = "subject";
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
	if (typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

	alert("입력 되었습니다.");
	parent.location.href='notice_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
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
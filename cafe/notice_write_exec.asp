<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	Call CheckMultipart()

	Call CheckAdmin()

	menu_type = "notice"

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "notice\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)

	dsplyFolder  = ConfigAttachedFileFolder & "display\notice\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\notice\"


	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject("ADODB.Recordset")

	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	notice_seq = uploadform("notice_seq")
	group_num  = uploadform("group_num") ' 답글에 대한 원본 글
	level_num  = uploadform("level_num")
	step_num   = uploadform("step_num")
	subject    = Replace(uploadform("subject"),"'","&#39;")
	contents   = Replace(uploadform("contents"),"'","&#39;")
	link       = uploadform("link")
	top_yn     = uploadform("top_yn")
	pop_yn     = uploadform("pop_yn")
	allcafe    = uploadform("allcafe")
	opt_value  = uploadform("opt_value")
	If link    = "http://" Then link = ""

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	new_seq = GetComSeq("cf_notice")

	If group_num = "" Then ' 새글
		parent_seq = ""
		notice_num = GetOneValue("isnull(max(notice_num)+1,1)","cf_notice","")
		group_num = notice_num
		level_num = 0
		step_num = 0
	Else ' 답글
		parent_seq = notice_seq
		level_num = level_num + 1

		sql = ""
		sql = sql & " update cf_notice "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "

		Conn.execute sql

		step_num = step_num + 1
	End If

	If allcafe = "all" Then
		cafe_id = ""
	Else
		cafe_id = opt_value
	End If
	
	sql = ""
	sql = sql & " insert into cf_notice( "
	sql = sql & "        notice_seq "
	sql = sql & "       ,parent_seq "
	sql = sql & "       ,group_num "
	sql = sql & "       ,level_num "
	sql = sql & "       ,step_num "
	sql = sql & "       ,notice_num "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,agency "
	sql = sql & "       ,subject "
	sql = sql & "       ,contents "
	sql = sql & "       ,view_cnt "
	sql = sql & "       ,suggest_cnt "
	sql = sql & "       ,link "
	sql = sql & "       ,top_yn "
	sql = sql & "       ,pop_yn "
	sql = sql & "       ,user_id "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values( "
	sql = sql & "        '" & new_seq & "' "
	sql = sql & "       ,'" & parent_seq & "' "
	sql = sql & "       ,'" & group_num & "' "
	sql = sql & "       ,'" & level_num & "' "
	sql = sql & "       ,'" & step_num & "' "
	sql = sql & "       ,'" & notice_num & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & Session("agency") & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & contents & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & pop_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " delete                                         "
	sql = sql & "   from cf_temp_notice                          "
	sql = sql & "  where user_id = '" & Session("user_id")  & "' "
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
<script src="//code.jquery.com/jquery.min.js"></script>
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
<%
		If session("noFrame") = "Y" Then
%>
	parent.location.href='notice_list.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
<%
		Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/notice_list.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>') ;
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

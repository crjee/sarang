<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckMultipart()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "job\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)
	Call CheckDailyCount(cafe_id)

	dsplyFolder  = ConfigAttachedFileFolder & "display\job\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\job\"


	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject("ADODB.Recordset")

	top_yn    = uploadform("top_yn")
	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")
	menu_seq  = uploadform("menu_seq")

	job_seq   = uploadform("job_seq")
	group_num = uploadform("group_num") ' 답글에 대한 원본 글
	level_num = uploadform("level_num")
	step_num  = uploadform("step_num")

	subject     = Replace(uploadform("subject"),"'","&#39;")
	section_seq = uploadform("section_seq")
	work        = uploadform("work")
	age1        = uploadform("age1")
	age2        = uploadform("age2")

	sex        = uploadform("sex")
	work_year  = uploadform("work_year")
	certify    = uploadform("certify")
	work_place = uploadform("work_place")
	agency     = uploadform("agency")
	person     = uploadform("person")
	tel_no     = uploadform("tel_no")
	mbl_telno  = uploadform("mbl_telno")
	fax_no     = uploadform("fax_no")
	email      = uploadform("email")
	homepage   = uploadform("homepage")
	method     = uploadform("method")
	end_date   = uploadform("end_date")
	contents   = uploadform("contents")

	If age1 <> "" Or age2 <> "" Then
	age  = age1 & "~" & age2
	End If

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	new_seq = GetComSeq("cf_job")

	If group_num = "" Then ' 새글
		parent_seq = ""
		job_num = GetComNum("job", cafe_id, menu_seq)
		group_num = job_num
		level_num = 0
		step_num = 0
	Else ' 답글
		parent_seq = job_seq

		level_num = level_num + 1

		sql = ""
		sql = sql & " update cf_job "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where menu_seq = " & menu_seq  & " "
		sql = sql & "    and group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "
		Conn.execute sql

		step_num = step_num + 1
	End If

	sql = ""
	sql = sql & " insert into cf_job(job_seq "
	sql = sql & "       ,subject "
	sql = sql & "       ,section_seq                      "
	sql = sql & "       ,work "
	sql = sql & "       ,age "
	sql = sql & "       ,sex "
	sql = sql & "       ,work_year "
	sql = sql & "       ,certify "
	sql = sql & "       ,work_place "
	sql = sql & "       ,agency "
	sql = sql & "       ,person "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,fax_no "
	sql = sql & "       ,email "
	sql = sql & "       ,homepage "
	sql = sql & "       ,method "
	sql = sql & "       ,end_date "
	sql = sql & "       ,contents "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,user_id "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values("
	sql = sql & "       ,'" & new_seq & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & section_seq            & "' "
	sql = sql & "       ,'" & work & "' "
	sql = sql & "       ,'" & age & "' "
	sql = sql & "       ,'" & sex & "' "
	sql = sql & "       ,'" & work_year & "' "
	sql = sql & "       ,'" & certify & "' "
	sql = sql & "       ,'" & work_place & "' "
	sql = sql & "       ,'" & agency & "' "
	sql = sql & "       ,'" & person & "' "
	sql = sql & "       ,'" & tel_no & "' "
	sql = sql & "       ,'" & fax_no & "' "
	sql = sql & "       ,'" & email & "' "
	sql = sql & "       ,'" & homepage & "' "
	sql = sql & "       ,'" & method & "' "
	sql = sql & "       ,'" & end_date & "' "
	sql = sql & "       ,'" & contents & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_job where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_job "
	sql = sql & "  where cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & Session("user_id")  & "' "
	Conn.Execute(sql)

	job_seq = new_seq
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
	alert("입력 되었습니다.");
<%
		If session("noFrame") = "Y" Then
%>
	parent.location.href='job_list.asp?menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>';
<%
		Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/job_list.asp?menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>') ;
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

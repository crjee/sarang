<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder "notice\"
	uploadform.DefaultPath = uploadFolder
	' �ϳ��� ���� ũ�⸦ 10MB���Ϸ� ����.
	uploadform.MaxFileLen = 10*1024*1024
	' ��ü ������ ũ�⸦ 50MB ���Ϸ� ����.
	uploadform.TotalLen = 50*1024*1024

	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	notice_seq = uploadform("notice_seq")
	group_num = uploadform("group_num")
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_notice "
	sql = sql & "  where user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	new_seq = getSeq("cf_temp_notice")

	parent_seq = ""
	notice_num = getonevalue("isnull(max(notice_num)+1,1)","cf_notice","")
	group_num = notice_num
	level_num = 0
	step_num = 0

	sql = ""
	sql = sql & " insert into cf_temp_notice( "
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
	sql = sql & "       ,'" & ir1 & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	notice_seq = new_seq

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
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // �ѱ� ������ �������� escape(cValue)�� �մϴ�.
	if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

//	alert("�Է� �Ǿ����ϴ�.");
//	parent.location.href='notice_list.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
//	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End if
%>

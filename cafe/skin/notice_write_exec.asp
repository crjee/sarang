<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "notice\"
	uploadform.DefaultPath = uploadFolder
	' �ϳ��� ���� ũ�⸦ 10MB���Ϸ� ����.
	uploadform.MaxFileLen = 10*1024*1024
	' ��ü ������ ũ�⸦ 50MB ���Ϸ� ����.
	uploadform.TotalLen = 50*1024*1024

	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	notice_seq = uploadform("notice_seq")
	group_num = uploadform("group_num")
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")
	pop_yn = uploadform("pop_yn")

	allcafe = uploadform("allcafe")
	opt_value = uploadform("opt_value")

	For Each item In uploadform("file_name")
		If item <> "" Then
			IF item.FileLen > uploadform.MaxFileLen Then
				call msggo("������ ũ��� " & CInt(uploadform.MaxFileLen/1024/1014) & "MB�� �Ѿ�� �ȵ˴ϴ�","")
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

	new_seq = getSeq("cf_notice")

	If group_num = "" Then ' ����
		parent_seq = ""
		notice_num = getonevalue("isnull(max(notice_num)+1,1)","cf_notice","")
		group_num = notice_num
		level_num = 0
		step_num = 0
	Else ' ���
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
	sql = sql & "       ,'" & ir1 & "' "
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
	sql = sql & " delete "
	sql = sql & "   from cf_temp_notice "
	sql = sql & "  where user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	notice_seq = new_seq

	j = 1
	For Each item In uploadform("file_name")
		If item <> "" Then
			file_name = item.LastSavedFileName

			new_seq = getSeq("cf_notice_attach")

			sql = ""
			sql = sql & " insert into cf_notice_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,notice_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & notice_seq & "' "
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
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // �ѱ� ������ �������� escape(cValue)�� �մϴ�.
	if(typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

	alert("�Է� �Ǿ����ϴ�.");
	parent.location.href='notice_list.asp?page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("������ �u���߽��ϴ�.\n\n�������� : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End if
%>

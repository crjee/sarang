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
	' 하나의 파일 크기를 10MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024
	' 전체 파일의 크기를 50MB 이하로 제한.
	uploadform.TotalLen = 50*1024*1024

	checkCafePageUpload(cafe_id)
	checkWriteAuth(cafe_id)

	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	Set fso = CreateObject("Scripting.FileSystemObject")

	If Not (fso.FolderExists(uploadFolder)) Then
		fso.CreateFolder(uploadFolder)
	End If

	Set fso = Nothing
	uploadform.DefaultPath = uploadFolder

	story_seq = uploadform("story_seq")
	group_num = uploadform("group_num")
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")
	section_seq = uploadform("section_seq")

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

	new_seq = getSeq("cf_story")

	If group_num = "" Then ' 새글
		parent_seq = ""
		story_num = getNum(menu_type, cafe_id, menu_seq)
		group_num = story_num
		level_num = 0
		step_num = 0
	Else ' 답글
		parent_seq = story_seq
		story_num = ""
		group_num = group_num
		level_num = level_num + 1

		sql = ""
		sql = sql & " update cf_story "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "
		Conn.execute sql

		step_num = step_num + 1
	End If

	sql = ""
	sql = sql & " insert into cf_story( "
	sql = sql & "        story_seq "
	sql = sql & "       ,parent_seq "
	sql = sql & "       ,group_num "
	sql = sql & "       ,level_num "
	sql = sql & "       ,step_num "
	sql = sql & "       ,story_num "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,menu_seq "
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
	sql = sql & "       ,section_seq "
	sql = sql & "      ) values( "
	sql = sql & "        '" & new_seq & "' "
	sql = sql & "       ,'" & parent_seq & "' "
	sql = sql & "       ,'" & group_num & "' "
	sql = sql & "       ,'" & level_num & "' "
	sql = sql & "       ,'" & step_num & "' "
	sql = sql & "       ,'" & story_num & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & menu_seq & "' "
	sql = sql & "       ,'" & Session("agency") & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & ir1 & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate() "
	sql = sql & "       ,'" & section_seq & "')"
	Conn.Execute(sql)

	If daily_cnt < 9999 Then
		sql = ""
		sql = sql & " insert into cf_write_log( "
		sql = sql & "        write_seq "
		sql = sql & "       ,cafe_id "
		sql = sql & "       ,menu_seq "
		sql = sql & "       ,user_id "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & new_seq & "' "
		sql = sql & "       ,'" & cafe_id & "' "
		sql = sql & "       ,'" & menu_seq & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)
	End If
	
	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_story where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)
	
	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_story "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	story_seq = new_seq

	j = 1
	For Each item In uploadform("file_name")
		If item <> "" Then
			file_name = item.LastSavedFileName

			new_seq = getSeq("cf_story_attach")

			sql = ""
			sql = sql & " insert into cf_story_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,story_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values("
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & story_seq & "' "
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
	if (typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

	alert("입력 되었습니다.");
	parent.location.href='story_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
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

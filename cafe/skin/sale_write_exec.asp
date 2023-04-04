<!--#include virtual="/include/config_inc.asp"-->
<%
	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "sale\"
	uploadform.DefaultPath = uploadFolder
	' �ϳ��� ���� ũ�⸦ 10MB���Ϸ� ����.
	uploadform.MaxFileLen = 10*1024*1024
	' ��ü ������ ũ�⸦ 50MB ���Ϸ� ����.
	uploadform.TotalLen = 50*1024*1024

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	Set rs = server.createobject("adodb.recordset")

	sql = ""
	sql = sql & " select isnull(daily_cnt,9999) as daily_cnt "
	sql = sql & "       ,inc_del_yn "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "�������� ����� �ƴմϴ�.",""
	Else
		daily_cnt = rs("daily_cnt")
		inc_del_yn = rs("inc_del_yn")
	End If
	rs.close

	If daily_cnt < "9999" Then
		If inc_del_yn = "N" Then
			sql = ""
			sql = sql & " select count(menu_seq) as write_cnt "
			sql = sql & "   from cf_sale "
			sql = sql & "  where menu_seq = '" & menu_seq  & "' "
			sql = sql & "    and cafe_id = '" & cafe_id  & "' "
			sql = sql & "    and agency = '" & session("agency")  & "' "
			sql = sql & "    and convert(varchar(10),credt,120) = '" & date & "' "
			rs.Open Sql, conn, 3, 1
			write_cnt = rs("write_cnt")
			rs.close
		Else
			sql = ""
			sql = sql & " select count(wl.menu_seq) as write_cnt "
			sql = sql & "   from cf_write_log wl "
			sql = sql & "   left join cf_member cm on cm.user_id = wl.user_id "
			sql = sql & "  where wl.menu_seq = '" & menu_seq  & "' "
			sql = sql & "    and wl.cafe_id = '" & cafe_id  & "' "
			sql = sql & "    and cm.agency = '" & session("agency")  & "' "
			sql = sql & "    and convert(varchar(10),wl.credt,120) = '" & date & "' "
			rs.Open Sql, conn, 3, 1
			write_cnt = rs("write_cnt")
			rs.close
		End If

		If cint(write_cnt) >= cint(daily_cnt) Then
			Response.Write "<script>alert('1�� ��� ���� " & daily_cnt & "���� �ʰ� �Ͽ����ϴ�');history.back()</script>"
			Response.End
		End If
	End If

	sale_seq = uploadform("sale_seq")
	group_num = uploadform("group_num")
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	location = uploadform("location")
	bargain = uploadform("bargain")
	area = uploadform("area")
	floor = uploadform("floor")
	compose = uploadform("compose")
	price = uploadform("price")
	live_in = uploadform("live_in")
	parking = uploadform("parking")
	traffic = uploadform("traffic")
	purpose = uploadform("purpose")
	tel_no = uploadform("tel_no")
	fax_no = uploadform("fax_no")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	For Each item In uploadform("file_name")
		If item <> "" Then
			IF item.FileLen > UploadForm.MaxFileLen Then
				call msggo("������ ũ��� " & CInt(uploadform.MaxFileLen/1024/1014) & "MB�� �Ѿ�� �ȵ˴ϴ�","")
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

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	new_seq = getSeq("cf_sale")

	If group_num = "" Then ' ����

		parent_seq = ""
		sale_num = getNum("sale", cafe_id, menu_seq)
		group_num = sale_num
		level_num = 0
		step_num = 0

	Else ' ���

		parent_seq = sale_seq
		level_num = level_num + 1

		sql = ""
		sql = sql & " update cf_sale "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "

		Conn.execute sql

		step_num = step_num + 1
	End If

	sql = ""
	sql = sql & " insert into cf_sale( "
	sql = sql & "        sale_seq "
	sql = sql & "       ,parent_seq "
	sql = sql & "       ,group_num "
	sql = sql & "       ,step_num "
	sql = sql & "       ,level_num "
	sql = sql & "       ,sale_num "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,menu_seq "
	sql = sql & "       ,agency "
	sql = sql & "       ,location "
	sql = sql & "       ,bargain "
	sql = sql & "       ,area "
	sql = sql & "       ,floor "
	sql = sql & "       ,compose "
	sql = sql & "       ,price "
	sql = sql & "       ,live_in "
	sql = sql & "       ,parking "
	sql = sql & "       ,traffic "
	sql = sql & "       ,purpose "
	sql = sql & "       ,subject "
	sql = sql & "       ,contents "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,fax_no "
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
	sql = sql & "       ,'" & sale_num & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & menu_seq & "' "
	sql = sql & "       ,'" & Session("agency") & "' "
	sql = sql & "       ,'" & location & "' "
	sql = sql & "       ,'" & bargain & "' "
	sql = sql & "       ,'" & area & "' "
	sql = sql & "       ,'" & floor & "' "
	sql = sql & "       ,'" & compose & "' "
	sql = sql & "       ,'" & price & "' "
	sql = sql & "       ,'" & live_in & "' "
	sql = sql & "       ,'" & parking & "' "
	sql = sql & "       ,'" & traffic & "' "
	sql = sql & "       ,'" & purpose & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & ir1 & "' "
	sql = sql & "       ,'" & tel_no & "' "
	sql = sql & "       ,'" & fax_no & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
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
	sql = sql & "    set top_cnt = (select count(*) from cf_sale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_sale "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	sale_seq = new_seq

	j = 1
	For Each item In uploadform("file_name")
		If item <> "" Then
			file_name = item.LastSavedFileName

			new_seq = getSeq("cf_sale_attach")

			sql = ""
			sql = sql & " insert into cf_sale_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,sale_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & sale_seq & "' "
			sql = sql & "       ,'" & file_name & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("�Է� �Ǿ����ϴ�.");
	parent.location.href='sale_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
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
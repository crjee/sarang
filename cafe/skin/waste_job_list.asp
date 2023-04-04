<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>��Ų-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	menu_seq = Request("menu_seq")
	self_yn  = Request("self_yn")
	all_yn   = Request("all_yn")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "�������� ����� �ƴմϴ�.",""
	else
		menu_type  = rs("menu_type")
		menu_name  = rs("menu_name")
		editor_yn  = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth  = rs("read_auth")
	End If
	rs.close

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	sql = ""
	sql = sql & " select count(job_seq) cnt "
	sql = sql & "   from cf_waste_job       "
	sql = sql & "  where 1 = 1              "
	If all_yn <> "Y" then
	sql = sql & "    and end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "    and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & kword

	rs.Open sql, conn, 3, 1
	RecordCount = 0 ' �ڷᰡ ������
	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "       ,convert(varchar(10), end_date, 120) as end_date_txt "
	sql = sql & "  from (select row_number() over( order by job_seq desc) as rownum "
	sql = sql & "              ,* "
	sql = sql & "          from cf_waste_job cb "
	sql = sql & "         where 1 = 1 "
	If all_yn <> "Y" then
	sql = sql & "           and end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "           and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & "           and isnull(top_yn,'') <> 'Y' "
	sql = sql & kword
	sql = sql & "       ) a "
	sql = sql & " where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & " "
	sql = sql & "  order by job_seq desc "

	rs.Open Sql, conn, 3, 1

	' ��ü ������ �� ���
	If RecordCount/pagesize = Int(RecordCount/pagesize) then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
	End If
%>
			<script>
				function MovePage(page){
					var f = document.search_form;
					f.page.value = page;
					f.action = "job_list.asp"
					f.submit();
				}

				function goView(job_seq){
					var f = document.search_form;
					f.job_seq.value = job_seq;
					f.action = "job_view.asp"
					f.submit()
				}

				function goSearch(){
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><font color="red"><%=menu_name%></font>&nbsp;�� <%=FormatNumber(RecordCount,0)%>���� �Խù��� �ֽ��ϴ�.</h2>
				</div>
				<div class="">
					<div class="search_box algR">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="job_seq">
						<select id="sch_type" name="sch_type" class="sel w100p">
							<option value="all">��ü</option>
							<option value="cb.subject" <%=if3(sch_type="cb.subject","selected","")%>>����</option>
							<option value="cb.agency" <%=if3(sch_type="cb.agency","selected","")%>>�۾���</option>
							<option value="cb.contents" <%=if3(sch_type="cb.contents","selected","")%>>����</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w300p">
						<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">�˻�</button>
						<select id="pagesize" name="pagesize" class="sel w100p" onchange="goSearch()">
							<option value=""></option>
							<option value="20" <%=if3(pagesize="20","selected","")%>>20</option>
							<option value="30" <%=if3(pagesize="30","selected","")%>>30</option>
							<option value="40" <%=if3(pagesize="40","selected","")%>>40</option>
							<option value="50" <%=if3(pagesize="50","selected","")%>>50</option>
							<option value="100" <%=if3(pagesize="100","selected","")%>>100</option>
						</select>
						</form>
					</div>
				</div>

				<div class="mt10">
					<div class="tb">
						<form name="list_form" method="post">
						<input type="hidden" name="menu_type" value="<%=menu_type%>">
						<input type="hidden" name="smode">
						<table>
							<colgroup>
								<col class="w_auto" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">ä������</th>
									<th scope="col">�ٹ�����</th>
									<th scope="col">�߰�����</th>
									<th scope="col">�����</th>
									<th scope="col">������</th>
								</tr>
							</thead>
							<tbody>
<%
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql =       ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "       ,convert(varchar(10), end_date, 120) as end_date_txt "
	sql = sql & "   from cf_waste_job cb "
	sql = sql & "  where top_yn = 'Y' "
	sql = sql & " order by job_seq desc "

	rs2.Open Sql, conn, 3, 1

	If Not rs2.eof Then
		i = 1
		Do Until rs2.eof
			subject = rs2("subject")
			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "�������"
			End If
			subject_s = rmid(subject, 35, "..")
%>
								<tr>
									<td><a href="javascript: goView('<%=rs2("job_seq")%>')" title="<%=subject_s%>"><%=subject%></a></td>
									<td class="algC"><%=rs2("work_place")%></td>
									<td class="algC"><%=rs2("agency")%></td>
									<td class="algC"><%=rs2("credt_txt")%></td>
									<td class="algC"><%=rs2("end_date_txt")%></td>
								</tr>
<%
			rs2.MoveNext
		Loop
	End If

	rs2.close
	Set rs2 = nothing

	If Not rs.EOF Then
		Do Until rs.EOF Or i > rs.pagesize
			subject = rs("subject")

			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "�������"
			End If

			parent_del_yn = rs("parent_del_yn")

			If parent_del_yn = "Y" Then
				subject = "*������ ������ ���* " & subject
			End If

			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td><a href="javascript: goView('<%=rs("job_seq")%>')" title="<%=subject_s%>"><%=subject%></a>
<%
			If CDate(DateAdd("d",2,rs("credt_txt"))) >= Date Then
%>
										<img src="/cafe/skin/img/btn/new.png" />
<%
			End If
%>
									</td>
									<td class="algC"><%=rs("work_place")%></td>
									<td class="algC"><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></td>
									<td class="algC"><%=rs("credt_txt")%></td>
									<td class="algC"><%=rs("end_date_txt")%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="100">��ϵ� ���� �����ϴ�.</td>
								</tr>
<%
	End If

	rs.close
	Set rs = Nothing
%>
							</tbody>
						</table>
						</form>
					</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
<%
	If write_auth <= cafe_mb_level Then ' �۾��� ����
%>
					<div class="btn_box algR">
						<button class="btn btn_c_a btn_n" type="button" onclick="location.href='/cafe/skin/job_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
					</div>
<%
	End If
%>
				</div>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>

<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)
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
	self_yn  = Request("self_yn")
	all_yn   = Request("all_yn")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (cb.subject like '%" & sch_word & "%' or cb.creid like '%" & sch_word & "%' or cb.agency like '%" & sch_word & "%' or cb.contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(job_seq) cnt "
	sql = sql & "   from cf_job cb          "
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
	sql = sql & " select subject "
	sql = sql & "       ,job_seq "
	sql = sql & "       ,work_place "
	sql = sql & "       ,agency "
	sql = sql & "       ,parent_del_yn "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "       ,convert(varchar(10), end_date, 120) as end_date_txt "
	sql = sql & "   from (select row_number() over( order by job_seq desc) as rownum "
	sql = sql & "               ,cb.subject "
	sql = sql & "               ,cb.job_seq "
	sql = sql & "               ,cb.work_place "
	sql = sql & "               ,cb.agency "
	sql = sql & "               ,cb.credt "
	sql = sql & "               ,cb.end_date "
	sql = sql & "               ,cb.parent_del_yn "
	sql = sql & "               ,cm.phone as tel_no "
	sql = sql & "           from cf_job cb "
	sql = sql & "           left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "         where 1 = 1 "
	If all_yn <> "Y" then
	sql = sql & "           and cb.end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "           and cb.user_id = '" & session("user_id") & "' "
	End If
	sql = sql & "           and isnull(cb.top_yn,'') <> 'Y' "
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
%>
			<script>
				function MovePage(page) {
					var f = document.search_form;
					f.page.value = page;
					f.action = "job_list.asp"
					f.submit();
				}

				function goView(job_seq) {
					var f = document.search_form;
					f.job_seq.value = job_seq;
					f.action = "job_view.asp"
					f.submit()
				}

				function goSearch() {
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						�� <strong><%=FormatNumber(RecordCount,0)%></strong>���� �Խù��� �ֽ��ϴ�.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="job_seq">
<%
	cafe_mb_level = getUserLevel(cafe_id)
	If user_id <> "" Then
%>
<!--
						<button class="btn_basic4txt" type="button" id="btn-check-all" data-toggle="checkboxes" data-action="check">��ü����</button>
 -->
<%
		If cafe_mb_level > 6 Then
%>
<!--
						<button class="btn_basic2txt" type="button" onclick="list_action('del')">����</button>
						<button class="btn_basic2txt" type="button" onclick="list_action('move')">�̵�</button>
						<button class="btn_basic2txt" type="button" onclick="list_action('notice')">����</button>
 -->
<%
		End If
	End If

	If cafe_ad_level = 10 Then
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/waste_job_list.asp?menu_seq=<%=menu_seq%>'">������</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' �۾��� ����
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/job_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
<%
	End If
%>
						<select id="sch_type" name="sch_type" class="sel w100p">
							<option value="all">��ü</option>
							<option value="cb.subject" <%=if3(sch_type="cb.subject","selected","")%>>����</option>
							<option value="cb.agency" <%=if3(sch_type="cb.agency","selected","")%>>�۾���</option>
							<option value="cb.contents" <%=if3(sch_type="cb.contents","selected","")%>>����</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w200p">
						<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">�˻�</button>
<%
	If write_auth <= cafe_mb_level Then ' �۾��� ����
%>
						<span class="ml20">
							<input type="checkbox" id="self_yn" name="self_yn" class="inp_check" value="Y" <%=if3(self_yn="Y","checked","")%> onclick="goAll()" />
							<label for="self_yn"><em>���ε��</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="all_yn" name="all_yn" class="inp_check" value="Y" <%=if3(all_yn="Y","checked","")%> onclick="goAll()" />
							<label for="all_yn"><em>��ü����</em></label>
						</span>
						<script>
							function goAll() {
								var f = document.search_form;
								f.action = "job_list.asp"
								f.page.value = 1;
								f.submit()
							}
						</script>
<%
	End If
%>
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
						<table class="tb_fixed">
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
	sql = sql & " select cb.subject "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "       ,cb.job_seq "
	sql = sql & "       ,cb.work_place "
	sql = sql & "       ,cb.agency "
	sql = sql & "       ,convert(varchar(10), cb.credt, 120) as credt_txt "
	sql = sql & "       ,convert(varchar(10), cb.end_date, 120) as end_date_txt "
	sql = sql & "   from cf_job cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
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
									<td class="algC"><a title="<%=rs2("tel_no")%>"><%=rs2("agency")%></a></td>
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
									<td colspan="5">��ϵ� ���� �����ϴ�.</td>
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


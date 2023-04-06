<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
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
	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '" & ipin & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & session("user_id") & "' "
	Conn.Execute(sql)

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	self_yn   = Request("self_yn")
	all_yn    = Request("all_yn")

	job_seq = Request("job_seq")

	Call setViewCnt(menu_type, job_seq)

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cj.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_waste_job cj "
	sql = sql & "   left join cf_member cm on cm.user_id = cj.user_id "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	rs.Open Sql, conn, 3, 1

	top_yn  = rs("top_yn")
	job_seq = rs("job_seq")
	subject = rs("subject")
	work    = rs("work")
	age     = rs("age")

	If age = "" Or age = "0" Then
		age = "����"
	End If

	sex    = rs("sex")

	If sex = "" Then
		sex = "����"
	ElseIf sex = "M" Then
		sex = "����"
	ElseIf sex = "W" Then
		sex = "����"
	End If

	work_year  = rs("work_year")

	If work_year = "" Then
		work_year = "����"
	Else
		work_year = work_year
	End If

	certify    = rs("certify")

	If certify = "Y" Then
		certify = "�ʼ�"
	Else
		certify = "����"
	End If

	work_place = rs("work_place")
	agency     = rs("agency")
	person     = rs("person")
	tel_no     = rs("tel_no")
	fax_no     = rs("fax_no")
	email      = rs("email")
	homepage   = rs("homepage")
	method     = rs("method")
	end_date   = rs("end_date")
	contents   = rs("contents")
	credt      = rs("credt")
	user_id    = rs("user_id")
%>
			<script type="text/javascript">
				function goList() {
					document.search_form.action = "/cafe/skin/waste_job_list.asp"
					document.search_form.submit();
				}
				function goRestore() {
					document.search_form.action = "/cafe/skin/waste_com_exec.asp"
					document.search_form.task.value = "restore";
					document.search_form.submit();
				}
				function goDelete() {
					document.search_form.action = "/cafe/skin/waste_com_exec.asp"
					document.search_form.task.value = "delete";
					document.search_form.submit();
				}
			</script>
			<form name="search_form" method="post">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="self_yn" value="<%=self_yn%>">
			<input type="hidden" name="all_yn" value="<%=all_yn%>">
			<input type="hidden" name="task">
			<input type="hidden" name="job_seq" value="<%=job_seq%>">
			<input type="hidden" name="com_seq" value="<%=job_seq%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">������ <%=menu_name%> ���뺸��</font></h2>
				</div>
				<div class="btn_box view_btn">
					<button class="btn btn_c_n btn_n" type="button" onclick="goRestore()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goList()">���</button>
				</div>
				<div class="view_head">
					<h3 class="h3" id="subject"><%=subject%></h3>
					<div class="wrt_info_box">
						<ul>
							<li><span>�ۼ���</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
							<li><span>��ȸ</span><strong><%=rs("view_cnt")%></strong></li>
							<li><span>����Ͻ�</span><strong><%=rs("credt")%></strong></li>
						</ul>
					</div>
				</div>



				<div class="view_cont">
					<h4 class="f_awesome h4">�ڰ�����</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">������</th>
									<td><%=work%></td>
									<th scope="row">����</th>
									<td><%=age%></td>
								</tr>
								<tr>
									<th scope="row">����</th>
									<td><%=sex%></td>
									<th scope="row">���</th>
									<td><%=work_year%></td>
								</tr>
								<tr>
									<th scope="row">�����ڰ���</th>
									<td><%=certify%></td>
									<th scope="row">�ٹ�����</th>
									<td><%=work_place%></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>

				<div class="view_cont">
					<h4 class="f_awesome h4">���ǹ� �������</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">�߰����Ҹ�</th>
									<td><%=agency%></td>
									<th scope="row">����ڸ�</th>
									<td><%=person%></td>
								</tr>
								<tr>
									<th scope="row">����ó</th>
									<td><%=tel_no%></td>
									<th scope="row">�ѽ�</th>
									<td><%=fax_no%></td>
								</tr>
								<tr>
									<th scope="row">�̸���</th>
									<td><%=email%></td>
									<th scope="row">Ȩ������</th>
									<td><%=homepage%></td>
								</tr>
								<tr>
									<th scope="row">�������</th>
									<td><%=method%></td>
									<th scope="row">������</th>
									<td><%=end_date%></td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">�����䰭</h4>
				</div>
				<div class="bbs_cont">
					<%=rs("contents")%>
				</div>
<%
	com_seq = job_seq
%>
<!--#include virtual="/cafe/skin/waste_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


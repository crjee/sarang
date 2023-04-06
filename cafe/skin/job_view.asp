<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&job_seq=" & Request("job_seq")
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
	sql = sql & "   from cf_job cj "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	rs.Open Sql, conn, 3, 1

	top_yn  = rs("top_yn")
	job_seq = rs("job_seq")
	subject = rs("subject")
	work    = rs("work")
	age     = rs("age")
	If age = "" Or age = "0" Then
		age = "����"
	End if
	sex    = rs("sex")
	If sex = "" Then
		sex = "����"
	elseIf sex = "M" Then
		sex = "����"
	elseIf sex = "W" Then
		sex = "����"
	End if
	work_year  = rs("work_year")
	If work_year = "" Then
		work_year = "����"
	else
		work_year = work_year
	End if
	certify    = rs("certify")
	If certify = "Y" Then
		certify = "�ʼ�"
	else
		certify = "����"
	End if
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
				function goPrint() {
					var initBody;
					window.onbeforeprint = function() {
						initBody = document.body.innerHTML;
						document.body.innerHTML =  document.getElementById('CenterContents').innerHTML;
					};
						window.onafterprint = function() {
						document.body.innerHTML = initBody;
					};
					window.print();
				}

				function goList() {
					document.search_form.action = "/cafe/skin/job_list.asp"
					document.search_form.submit();
				}
				function goReply() {
					document.search_form.action = "/cafe/skin/job_reply.asp"
					document.search_form.submit();
				}
				function goModify() {
					document.search_form.action = "/cafe/skin/job_modify.asp"
					document.search_form.submit();
				}
				function goDelete() {
					document.search_form.action = "/cafe/skin/com_waste_exec.asp"
					document.search_form.submit();
				}
				function goNotice() {
					document.search_form.action = "/cafe/skin/com_top_exec.asp"
					document.search_form.submit();
				}
				function goSuggest() {
					document.search_form.action = "/cafe/skin/com_suggest_exec.asp"
					document.search_form.submit();
				}
				function goMove() {
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}
				function copyUrl() {
					try{
						if (window.clipboardData) {
								window.clipboardData.setData("Text", "<%=pageUrl%>")
								alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
						}
						else if (window.navigator.clipboard) {
								window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
									alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
								});
						}
						else {
							temp = prompt("�ش� ���ּҸ� �����Ͻʽÿ�.", "<%=pageUrl%>");
						}
					} catch(e) {
						alert(e)
					}
				}
			</script>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/cafe/skin/com_move_edit_p.asp?com_seq=<%=job_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="com_move">
			<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
			</form>
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
					<h2 class="h2"><%=menu_name%> ���뺸��</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If group_num = "" And reply_auth <= cafe_mb_level Then
%>
					<!-- <button class="btn btn_c_n btn_n" type="button" onclick="goReply()">���</button> -->
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goModify()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goMove()">�̵�</button>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goNotice()"><%=if3(rs("top_yn")="Y","��������","��������")%></button>
<%
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goSuggest()">��õ</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goPrint()">�μ�</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="location.href='/cafe/skin/job_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
<%
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="copyUrl()">���ּҺ���</button>
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
<!--#include virtual="/cafe/skin/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


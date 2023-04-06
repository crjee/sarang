<!--#include virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�޴� ���� : ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
<%
	menu_seq = Request("menu_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "

	Set rs = Conn.Execute(sql)
	If Not rs.eof Then
		menu_name  = rs("menu_name")
		page_type  = rs("page_type")
		menu_type  = rs("menu_type")
		list_type  = rs("list_type")
		wide_yn    = rs("wide_yn")
		home_num   = rs("home_num")
		home_cnt   = rs("home_cnt")
		hidden_yn  = rs("hidden_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth  = rs("read_auth")
		editor_yn  = rs("editor_yn")
		daily_cnt  = rs("daily_cnt")
		inc_del_yn = rs("inc_del_yn")
		list_info  = rs("list_info")
	End If
	rs.close
%>
					<div class="adm_cont_tit">
						<h4 class="h3 mt20 mb10"><%=menu_name%> ����</h4>
					</div>
					<form name="form" method="post" action="main_exec.asp">
					<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="home_num" value="<%=home_num%>">
					<div class="adm_cont">
						<div id="board" class="tb tb_form_1">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w120p" />
									<col class="w_remainder" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" rowspan="2">�ؽ�Ʈ��</th>
										<td>
											<span class="">
												<input type="radio" id="NT1" name="list_type" value="NT1" <%=if3(wide_yn&list_type="NT1","checked","")%> class="inp_radio" />
												<label for="NT1"><em>�⺻��</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="">
												<input type="radio" id="YT1" name="list_type" value="YT1" <%=if3(wide_yn&list_type="YT1","checked","")%> class="inp_radio" />
												<label for="YT1"><em>���̵���</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="2">�ٹ���</th>
										<td>
											<span class="">
												<input type="radio" id="NA1" name="list_type" value="NA1" <%=if3(wide_yn&list_type="NA1","checked","")%> class="inp_radio" />
												<label for="NA1"><em>�⺻ ������</em></label>&nbsp;&nbsp;&nbsp;&nbsp;
											</span>
											<span class="ml20">
												<input type="radio" id="NA2" name="list_type" value="NA2" <%=if3(wide_yn&list_type="NA2","checked","")%> class="inp_radio" />
												<label for="NA2"><em> ������</em></label>
											</span>
											<span class="ml20">
												<input type="radio" id="NA3" name="list_type" value="NA3" <%=if3(wide_yn&list_type="NA3","checked","")%> class="inp_radio" />
												<label for="NA3"><em> �����̵���</em></label>
											</span>
											<span class="ml20">
												<input type="radio" id="NA4" name="list_type" value="NA4" <%=if3(wide_yn&list_type="NA4","checked","")%> class="inp_radio" />
												<label for="NA4"><em> �ǽ����̵���</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="">
												<input type="radio" id="YA1" name="list_type" value="YA1" <%=if3(wide_yn&list_type="YA1","checked","")%> class="inp_radio" />
												<label for="YA1"><em>���̵� ������</em></label>
											</span>
											<span class="ml20">
												<input type="radio" id="YA2" name="list_type" value="YA2" <%=if3(wide_yn&list_type="YA2","checked","")%> class="inp_radio" />
												<label for="YA2"><em> ������</em></label>
											</span>
											<span class="ml20">
												<input type="radio" id="YA3" name="list_type" value="YA3" <%=if3(wide_yn&list_type="YA3","checked","")%> class="inp_radio" />
												<label for="YA3"><em> �����̵���</em></label>
											</span>
											<span class="ml20">
												<input type="radio" id="YA4" name="list_type" value="YA4" <%=if3(wide_yn&list_type="YA4","checked","")%> class="inp_radio" />
												<label for="YA4"><em> �ǽ����̵���</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="2">ī����</th>
										<td>
											<span class="">
												<input type="radio" id="NC1" name="list_type" value="NC1" <%=if3(wide_yn&list_type="NC1","checked","")%> class="inp_radio" />
												<label for="NC1"><em>�⺻��</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<td>
											<span class="">
												<input type="radio" id="YC1" name="list_type" value="YC1" <%=if3(wide_yn&list_type="YC1","checked","")%> class="inp_radio" />
												<label for="YC1"><em>���̵���</em></label>
											</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_box algR">
							<button type="submit" class="btn btn_c_a btn_n">����</button>
							<button type="reset" class="btn btn_c_n btn_n">���</button>
							<button type="button" class="btn btn_c_n btn_n" id="del">����</button>
						</div>
						</form>
						<script>
						</script>
					</div>
</body>
</html>
<script LANGUAGE="JavaScript">
<!--
	$('#del').click(function() {
		msg="�����Ͻðڽ��ϱ�?"
		if (confirm(msg)) {
			document.location.href='../main_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
//-->
</script>

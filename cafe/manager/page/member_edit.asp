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
					<form name="form" method="post" action="com_exec.asp">
					<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="menu_type" value="<%=menu_type%>">
					<div class="adm_cont">
						<div id="board" class="tb tb_form_1">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w120p" />
									<col class="w_remainder" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">�̸�</th>
										<td>
											<input type="text" id="menu_name" name="menu_name" value="<%=menu_name%>" class="inp">
										</td>
									</tr>
									<tr>
										<th scope="row">�׸��̱�</th>
										<td>
											<span class="">
												<input type="checkbox" id="list_info" name="list_info" value="agency" <%=if3(InStr(list_info, "agency")>0,"checked","")%> />
												<label for=""><em>��ȣ</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="kname" <%=if3(InStr(list_info, "kname")>0,"checked","")%> />
												<label for=""><em>��ǥ�ڸ�</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="picture" <%=if3(InStr(list_info, "picture")>0,"checked","")%> />
												<label for=""><em>��ǥ�ڻ���</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="license" <%=if3(InStr(list_info, "license")>0,"checked","")%> />
												<label for=""><em>�㰡��ȣ</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="phone" <%=if3(InStr(list_info, "phone")>0,"checked","")%> />
												<label for=""><em>��ȭ��ȣ</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="mobile" <%=if3(InStr(list_info, "mobile")>0,"checked","")%> />
												<label for=""><em>�ڵ�����ȣ</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="fax" <%=if3(InStr(list_info, "fax")>0,"checked","")%> />
												<label for=""><em>�ѽ�</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="interphone" <%=if3(InStr(list_info, "interphone")>0,"checked","")%> />
												<label for=""><em>������ȣ</em></label>
											</span>
											<span class="ml10">
												<input type="checkbox" id="list_info" name="list_info" value="addr" <%=if3(InStr(list_info, "addr")>0,"checked","")%> />
												<label for=""><em>�ּ�</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<th scope="row">�޴����߱�</th>
										<td>
											<input type="checkbox" id="hidden_yn" name="hidden_yn" value="Y" <%=if3(hidden_yn = "Y","checked","") %> class="" />
											<label for=""><em>���߱�</em></label>
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
			document.location.href='../menu_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
//-->
</script>

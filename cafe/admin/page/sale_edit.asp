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
										<th scope="row">����</th>
										<td>
											<ul class="list_option">
												<li class="">
													<span class="head">����</span>
													<select id="write_auth" name="write_auth" class="sel w_auto">
														<option value="1" <%=if3(write_auth = "1","selected","") %>>��ȸ��</option>
														<option value="2" <%=if3(write_auth = "2","selected","") %>>��ȸ��</option>
														<option value="10" <%=if3(write_auth = "10","selected","") %>>���������</option>
													</select>
												</li>
												<li class="">
													<span class="head">��۾���</span>
													<select id="reply_auth" name="reply_auth" class="sel w_auto">
														<option value="1" <%=if3(reply_auth = 1,"selected","") %>>��ȸ��</option>
														<option value="2" <%=if3(reply_auth = 2,"selected","") %>>��ȸ��</option>
														<option value="10" <%=if3(reply_auth = 10,"selected","") %>>���������</option>
													</select>
												</li>
												<li class="">
													<span class="head">�б�</span>
													<select id="read_auth" name="read_auth" class="sel w_auto">
														<option value="1" <%=if3(read_auth = 1,"selected","") %>>��ȸ��</option>
														<option value="2" <%=if3(read_auth = 2,"selected","") %>>��ȸ��</option>
														<option value="10" <%=if3(read_auth = 10,"selected","") %>>���������</option>
													</select>
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th scope="row">��ļ���</th>
										<td>
<%
	Set form = Conn.Execute("select * from cf_com_form where menu_seq='"&menu_seq&"'")
	If Not form.eof then
%>
											<label><input type="checkbox">������Ļ��</label>
											<button class="btn_4txt_sel" type="submit" onclick="window.open('form_edit_p.asp?menu_seq=<%=Request("menu_seq")%>','form','width=700,height=700,scrollbars=yes');">��ļ���</button>
<%
	Else
%>
											<button class="btn_4txt_sel" type="submit" onclick="window.open('form_edit_p.asp?menu_seq=<%=Request("menu_seq")%>','form','width=700,height=700,scrollbars=yes');">��ĵ��</button>
<%
	End If
%>
										</td>
									</tr>
									<tr>
										<th scope="row">�޴����߱�</th>
										<td>
											<input type="checkbox" id="hidden_yn" name="hidden_yn" value="Y" <%=if3(hidden_yn = "Y","checked","") %> class="" />
											<label for=""><em>���߱�</em></label>
										</td>
									</tr>
									<tr>
										<th scope="row">��������</th>
										<td>
											<select id="editor_yn" name="editor_yn" class="sel w_auto">
												<option value="Y" <%=if3(editor_yn = "Y","selected","") %>>������</option>
												<option value="N" <%=if3(editor_yn <> "Y","selected","") %>>�ؽ�Ʈ</option>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">���γ��ⰹ��</th>
										<td>
											<select id="home_cnt" name="home_cnt" class="sel w_auto">
<%
	For i = 2 To 10
%>
												<option value="<%= i %>" <%=if3(home_cnt = i,"selected","") %>><%= i %>��</option>
<%
	Next
%>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">1�� ��ϼ�</th>
										<td>
											<select id="daily_cnt" name="daily_cnt" class="sel w_auto">
												<option value="9999">��������</option>
												<option value='1' <%=If3(daily_cnt="1","selected","") %>>1</option>
												<option value='2' <%=If3(daily_cnt="2","selected","") %>>2</option>
												<option value='3' <%=If3(daily_cnt="3","selected","") %>>3</option>
											</select>
											<span class="ml20">
												<input type="radio" id="inc_del_yn" name="inc_del_yn" value="Y" <%=if3(inc_del_yn="Y","checked","") %> class="" />
												<label for=""><em>������ ����</em></label>
											</span>
											<span class="ml10">
												<input type="radio" id="inc_del_yn" name="inc_del_yn" value="N" <%=if3(inc_del_yn="N","checked","") %> class="" />
												<label for=""><em>������ ������</em></label>
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
			document.location.href='../menu_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
//-->
</script>

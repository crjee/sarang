<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	menu_seq = Request("menu_seq")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�˾����� ���� : ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS ����<sub>����� ����</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">�˾����� ����</h2>
			</div>
			<div class="adm_guide_message">
				<ul>
					<li>�˾������� �Խù��� �� ���������� �����ϰ��� �ϴ� ���� �˾����·� ����ִ� ����� ���մϴ�.</li>
					<li>���� �Խ����� �������� �������ּ���.</li>
					<li>�ش� �Խ����� �Խñ��� ��ȣ�� �Է��ϼ���.</li>
					<li>�� 4���� �˾������� �����ϸ�, �ϳ��� �Խ��ǿ��� �ִ� 4���� �Խñ��� ��� �� �ֽ��ϴ�.</li>
				</ul>
			</div>
			<div class="adm_cont">
				<div class="tb tb_form_1">
				<form name="form" method="post" action="popup_exec.asp" target="hiddenfrm">
					<table class="tb_input">
						<colgroup>
							<col class="w10" />
							<col class="w40" />
							<col class="w10" />
							<col class="w40" />
						</colgroup>
						<tbody>
<%
	For i = 1 To 4
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_popup"
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		sql = sql & "    and popup_order = '" & i & "' "

		Set rs = Conn.Execute(sql)
		If Not rs.eof Then
			menu_seq = rs("menu_seq")
			popup_num = rs("popup_num")
		else
			menu_seq = ""
			popup_num = ""
		End if
%>
							<tr>
								<th scope="row"><%=i%> ��°</th>
								<td>
									<select id="menu_seq<%=i%>" name="menu_seq<%=i%>" class="sel">
										<option value="">�˾������� �����ϼ���</option>
<%
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_menu "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		sql = sql & "   and menu_type in ('board') "
'		sql = sql & "   and menu_type in ('board','sale','job') "

		Set row = Conn.Execute(sql)

		Do Until row.eof
%>
										<option value="<%=row("menu_seq")%>" <%=if3(row("menu_seq") = menu_seq,"selected","") %>><%=row("menu_name")%></option>
<%
			row.MoveNext
		loop
%>
									</select>
								</td>
								<th scope="row">�Խñ� ��ȣ</th>
								<td>
									<input type="text" id="popup_num<%=i%>" name="popup_num<%=i%>" value="<%=popup_num%>" placeholder="�Խñ� ��ȣ �Է�" class="inp">
								</td>
							</tr>
<%
	Next
%>
						</tbody>
					</table>
				</div>
				<div class="btn_box algR">
					<button class="btn btn_c_a btn_n" type="submit">Ȯ��</button>
				</div>
				</form>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
</html>

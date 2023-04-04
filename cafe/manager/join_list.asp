<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	If Request("user")<>"" Then
		sql = ""
		sql = sql & " update cf_cafe_member "
		sql = sql & "    set stat = 'Y' "
		sql = sql & "       ,cafe_mb_level = '1' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		sql = sql & "    and user_id = '" & Request("user") & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " update cf_cafe_member "
		sql = sql & "    set stat = 'Y' "
		sql = sql & "       ,cafe_mb_level = '1' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where user_id = '" & Request("user") & "' "
		Conn.Execute(sql)

		Response.Write "<script>parent.location = 'join_list.asp'</script>"
		Response.end
	End If

	Reg_level = Request.Form("reg_level")

	If reg_level<>"" Then
		sql = ""
		sql = sql & " update cf_cafe "
		sql = sql & "    set reg_level = '" & reg_level & "' "
		sql = sql & "       ,modid = '" & user_id & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "'"
		Conn.Execute(sql)

		msgonly "���� �Ǿ����ϴ�."
	End If

	Set conf = Conn.Execute("select * from cf_cafe where cafe_id = '" & cafe_id & "'")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�⺻���� ���� : ����� ����</title>
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
				<h2 class="h2">��������/����</h2>
			</div>
			<div class="adm_cont">
				<form method="post">
				<div class="status_box clearBoth">
					<span class="floatL">
						<span class="f_weight_b mr10">���Ե�޼��� :</span>
						����� ȸ������ ��
						<select id="reg_level" name="reg_level" class="sel w100p">
							<option value="1" <%=if3(reg_level="1","selected","")%>>��ȸ��</option>
							<option value="2" <%=if3(reg_level="2","selected","")%>>��ȸ��</option>
						</select>
						���� �ڵ� ��� �����մϴ�.
						<button type="submit" class="btn btn_c_s btn_s">Ȯ��</button>
					</span>
					<span class="floatR">
					</span>
				</div>
				</form>
				
				<div class="tb tb_form_1">
					<table>
						<colgroup>
							<col class="w20" span="5" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">��ȣ</th>
								<th scope="col">�̸�(��ȣ)</th>
								<th scope="col">��ȭ��ȣ</th>
								<th scope="col">������</th>
								<th scope="col">����</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_cafe_member cm "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.stat = 'Y' "
	sql = sql & "  where cm.cafe_id = '" & cafe_id & "' "
	sql = sql & "    and cm.stat = 'Y' "
	sql = sql & "    and cm.cafe_mb_level = '1' "
	Set row = Conn.Execute(sql)

	If Not row.eof Then
		Do Until row.eof
%>
							<tr>
								<td class="algC"><%=i%></td>
								<td class="algC"><%=row("kname") & " (" & row("agency") & ")" %></td>
								<td class="algC"><%=row("mobile")%></td>
								<td class="algC"><%=row("addr1")%> <%=row("addr2")%></td>
								<td class="algC"><input type="button" value="���Խ���" onclick="ifrm.location.href='join_exec.asp?user_id=<%=row("user_id")%>'"></td>
							</tr>
<%
			i = i + 1
			row.MoveNext
		Loop
	Else
%>
							<tr>
								<td class="algC" colspan="5">���Խ�û�� ȸ���� �����ϴ�.</td>
							</tr>
<%
	End If
%>
						</tbody>
					</table>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
</body>
</html>

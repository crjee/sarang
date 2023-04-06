<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>ȸ�� ���� > ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS ����<sub>��ü����</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/supervisor/supervisor_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">�Խñ� �ߴ� ��û</h2>
			</div>
			<div class="adm_cont">
				<div class="search_box">
					<select id="" name="" class="sel w100p">
						<option value="">�Ⱓ����</option>
					</select>
					<select id="" name="" class="sel w100p">
						<option value="">����</option>
					</select>
					<input type="text" id="" name="" class="inp w300p" />
					<button type="button" class="btn btn_c_a btn_s">�˻�</button>
				</div>
				<div class="tb tb_form_1">
					<table>
						<colgroup>
							<col class="w5" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="w_auto" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
						</colgroup>
						<thead>
<%
	i = 1
	If Not rs.EOF Then
		Do Until rs.EOF OR i > rs.pagesize
			user_id   = rs("user_id")
			kname     = rs("kname")
			agency    = rs("agency")
			phone     = rs("phone")
			email     = rs("email")
			mstat     = rs("mstat")
			cstat     = rs("cstat")
			cafe_id   = rs("cafe_id")
			cafe_name = rs("cafe_name")
			cafe_mb_level = rs("cafe_mb_level")
			post_cnt  = rs("post_cnt")
			picture   = rs("picture")
			union_id  = rs("union_id")
			union_name  = rs("union_name")
			union_mb_level = rs("union_mb_level")
%>
							<tr>
								<th scope="col">��ȣ</th>
								<th scope="col">��û����</th>
								<th scope="col">�̸�/�ҼӴ�ü��</th>
								<th scope="col">�޴���</th>
								<th scope="col">�̸����ּ�</th>
								<th scope="col">����</th>
								<th scope="col">÷������</th>
								<th scope="col">��û��</th>
								<th scope="col">ó��</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="algC">10</td>
								<td class="algC">����</td>
								<td class="algC">�ֽ�ȸ�� Ȱ���</td>
								<td class="algC">010-0000-0000</td>
								<td class="algC">hong123@gmail.com</td>
								<td><a href="#n">�Խñ� �ߴ� ��û�մϴ�.</a></td>
								<td class="algC"><button type="button" class="btn f_awesome btn_file"><em>÷������</em></button></td>
								<td class="algC">2022-04-13</td>
								<td class="algC">
									<select id="" name="" class="sel w100">
										<option value="">����</option>
										<option value="">�Ϸ�</option>
										<option value="">����</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
</body>
</html>
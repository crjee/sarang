<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�α��� : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap" class="login_zone">
		<div class="login_box">
			<div class="login_box_head">
				<h1 class="h1">ȸ�� �α���</h1>
			</div>
			<form name="login_form" method="post" action="login_exec.asp">
			<div class="login_box_body">
				<div class="login_cont">
					<div class="login_cont_obj"	>
						<label for="" class="hide">���̵�</label>
						<input type="text" id="user_id" name="user_id" placeholder="���̵� �Է��ϼ���" required class="inp" />
					</div>
					<div class="login_cont_obj"	>
						<label for="" class="hide">��й�ȣ</label>
						<input type="password" id="user_pw" name="user_pw" placeholder="��й�ȣ�� �Է��ϼ���" required class="inp" />
					</div>
					<button type="submit" class="btn"><em>�α���</em></button>
				</div>
				<div class="login_cont">
					<input type="checkbox" id="user_id_check" name="" class="inp_check" />
					<label for="user_id_check"><em>���̵� ����</em></label>
					<p class="txt">�� <strong>��ҹ���</strong>�� �����Ͽ� �Է��� �ּ���.</p>
				</div>
			</div>
			</form>
		</div>
	</div>
</body>
</html>

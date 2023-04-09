<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Session.abandon
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-3 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div class="flex_box">
		<div class="section_box">
			<p><em class="f_red">세션이 만료</em>되었습니다.</p>
			<p>다시 접속해 주세요.</p>
			<a href="/" class="btn btn_n">다시 접속하기</a>
		</div>
	</div>
</body>
</html>

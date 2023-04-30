<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include virtual="/ipin_inc.asp"-->
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = Request("cafe_id")
	poll_seq = Request("poll_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_poll pq "
	sql = sql & "   left outer join cf_poll_ans pa on pa.poll_seq = pq.poll_seq "
	sql = sql & "  where pq.cafe_id = '"&cafe_id&"' "
	sql = sql & "    and pq.poll_seq = '"&poll_seq&"' "
	sql = sql & "  order by pq.reg_date desc "
	Set row = Conn.Execute(sql)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
		<main id="main" class="sub">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2">설문 결과</h2>
				</div>
				<div>
					<h3><%=row("subject")%><h3>
				</div>
				<div>
					<ul>
<%
	total = 0
	If Not row.eof Then
		For i = 1 To 10
			If row("ques"&i) <> "" Then
				total = total + row("ans"&i)
			End If
		Next

		For i = 1 To 10
			If row("ques"&i) <> "" Then
				If row("ans"&i) <> 0 Then
					ans = row("ans"&i) / total * 100
%>
		<li><%=row("ans"&i)%>명 참여 [ <%=FormatNumber(ans,0)%>% ]&nbsp;&nbsp;<%=row("ques"&i)%></li>
<%
				Else
%>
		<li>0명 참여 [ 0% ]&nbsp;&nbsp;<%=row("ques"&i)%></li>
<%
				End If
			End If
		Next
	End If
%>
						<li>총 <%=total%>명 참여 </li>
					</ul>
				</div>
			</div>
		</main>
	</div>
</body>
</html>
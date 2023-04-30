<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckReadAuth(cafe_id)
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
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
	<div id="wrap" class="group">
<!--#include virtual="/cafe/cafe_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/cafe_left_inc.asp"-->
<%
	End IF
%>
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select land_seq        "
	sql = sql & "       ,land_url        "
	sql = sql & "       ,reg_date        "
	sql = sql & "       ,subject         "
	sql = sql & "       ,contents        "
	sql = sql & "   from cf_land         "
	sql = sql & "  order by land_seq asc "
	rs.Open Sql, conn, 3, 1
%>
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2">부동산뉴스</h2>
				</div>
				<div class="">
					<div class="tb">
						<table class="tb_fixed">
							<colgroup>
								<col class="w7" />
								<col class="w_auto" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">등록일</th>
								</tr>
							</thead>
							<tbody>
<%
	If Not rs.EOF Then
		i = 0
		Do Until rs.EOF
			i = i + 1
			land_seq = rs("land_seq")
			land_url = rs("land_url")
			reg_date = rs("reg_date")
			subject  = rs("subject")
			contents = rs("contents")

			land_list = "<a href=http://land.naver.com/" & land_url & " target=_blank title='" & subject & "'>" & subject & "</a>"
%>
								<tr>
									<td class="algC"><%=i%></td>
									<td><%=land_list%></td>
									<td class="algC"><%=Left(reg_date, 10)%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
<%
	End If
	rs.close
	Set rs = Nothing
%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<%
	End IF
%>
</body>
</html>


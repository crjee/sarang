<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	If sch_word <> "" Then
		If sch_type = "l" Then
			kword = " and (cb.subject like '%" & sch_word & "%' or cb.agency like '%" & sch_word & "%' or cb.contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select land_seq        "
	sql = sql & "       ,land_url        "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "       ,subject         "
	sql = sql & "       ,contents        "
	sql = sql & "   from cf_land         "
	sql = sql & "  order by land_seq asc "
	rs.Open Sql, conn, 3, 1
%>
		<main id="main" class="main">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="">
					<div class="search_box algR">
					</div>
					<div class="tb">
						<table>
							<colgroup>
								<col class="w5" />
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
			credt_txt = rs("credt_txt")
			subject  = rs("subject")
			contents = rs("contents")

			land_list = "<a href=http://land.naver.com/" & land_url & " target=_blank title='" & subject & "'>" & subject & "</a>"
%>
								<tr>
									<td class="algC"><%=i%></td>
									<td><%=land_list%></td>
									<td class="algC"><%=credt_txt%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="3" class="td_nodata">등록된 글이 없습니다.</td>
								</tr>
<%
	End If
	rs.close
	Set rs = nothing
%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>

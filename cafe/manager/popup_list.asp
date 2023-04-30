<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)

	menu_seq = Request("menu_seq")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>팝업공지 관리 : 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>사랑방 관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">팝업공지 관리</h2>
			</div>
			<div class="adm_guide_message">
				<ul>
					<li>팝업공지란 게시물들 중 여러사람들과 공유하고자 하는 글을 팝업형태로 띄워주는 기능을 말합니다.</li>
					<li>먼저 게시판을 좌측에서 선택해주세요.</li>
					<li>해당 게시판의 게시글의 번호를 입력하세요.</li>
					<li>총 4개의 팝업공지를 지원하며, 하나의 게시판에서 최대 4개의 게시글을 띄울 수 있습니다.</li>
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
	Set rs = Server.CreateObject("ADODB.Recordset")

	For i = 1 To 4
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_popup"
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		sql = sql & "    and popup_order = '" & i & "' "
		rs.open Sql, conn, 3, 1

		If Not rs.eof Then
			menu_seq = rs("menu_seq")
			popup_num = rs("popup_num")
		Else
			menu_seq = ""
			popup_num = ""
		End If
		rs.close
%>
							<tr>
								<th scope="row"><%=i%> 번째</th>
								<td>
									<select id="menu_seq<%=i%>" name="menu_seq<%=i%>" class="sel">
										<option value="">팝업공지를 선택하세요</option>
<%
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_menu "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		sql = sql & "   and menu_type in ('board') "
'		sql = sql & "   and menu_type in ('board','sale','job') "
		rs.open Sql, conn, 3, 1

		Do Until rs.eof
%>
										<option value="<%=rs("menu_seq")%>" <%=if3(rs("menu_seq") = menu_seq,"selected","") %>><%=rs("menu_name")%></option>
<%
			rs.MoveNext
		Loop
		rs.close
%>
									</select>
								</td>
								<th scope="row">게시글 번호</th>
								<td>
									<input type="text" id="popup_num<%=i%>" name="popup_num<%=i%>" value="<%=popup_num%>" placeholder="게시글 번호 입력" class="inp">
								</td>
							</tr>
<%
	Next
	Set rs = Nothing
%>
						</tbody>
					</table>
				</div>
				<div class="btn_box algR">
					<button type="submit" class="btn btn_c_a btn_n">확인</button>
				</div>
				</form>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>메뉴 관리 : 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
<%
	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	rs.open Sql, conn, 3, 1

	If Not rs.eof Then
		menu_name = rs("menu_name")
		page_type = rs("page_type")
		menu_type = rs("menu_type")
		home_cnt  = rs("home_cnt")
		hidden_yn = rs("hidden_yn")
		doc       = rs("doc")
	End If
	rs.close
	Set rs = Nothing
%>
					<div class="adm_cont_tit">
						<h4 class="h3 mt20 mb10"><%=menu_name%> 설정</h4>
					</div>
					<form name="form" method="post" action="com_exec.asp">
					<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="menu_type" value="<%=menu_type%>">
					<input type="hidden" name="page_type" value="<%=page_type%>">
					<div class="adm_cont">
						<div id="board" class="tb tb_form_1">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w120p" />
									<col class="w_remainder" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">이름</th>
										<td>
											<input type="text" id="menu_name" name="menu_name" value="<%=menu_name%>" class="inp">
										</td>
									</tr>
									<tr>
										<th scope="row">소개</th>
										<td>
											<input type="text" id="doc" name="doc" value="<%=doc%>" class="inp">
										</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_box algR">
							<button type="submit" class="btn btn_c_a btn_n">저장</button>
							<button type="reset" class="btn btn_c_n btn_n">취소</button>
							<button type="button" class="btn btn_c_n btn_n" id="del">삭제</button>
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
		msg="삭제하시겠습니까?"
		if (confirm(msg)) {
			document.location.href='../menu_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
//-->
</script>

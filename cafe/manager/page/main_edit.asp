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
		menu_name  = rs("menu_name")
		page_type  = rs("page_type")
		menu_type  = rs("menu_type")
		list_type  = rs("list_type")
		wide_yn    = rs("wide_yn")
		home_num   = rs("home_num")
		home_cnt   = rs("home_cnt")
		hidden_yn  = rs("hidden_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth  = rs("read_auth")
		editor_yn  = rs("editor_yn")
		daily_cnt  = rs("daily_cnt")
		inc_del_yn = rs("inc_del_yn")
		list_info  = rs("list_info")
	End If
	rs.close
	Set rs = Nothing
%>
					<div class="adm_cont_tit">
						<h4 class="h3 mt20 mb10"><%=menu_name%> 설정</h4>
					</div>
					<form name="form" method="post" action="main_exec.asp">
					<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="home_num" value="<%=home_num%>">
					<div class="adm_cont">
						<div id="board" class="tb tb_form_1">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w120p" />
									<col class="w120p" />
									<col class="w_remainder" />
									<col class="w_remainder" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row" rowspan="2">텍스트</th>
										<th scope="row">2열</th>
										<td>
											<span class="">
												<input type="radio" id="NT1" name="list_type" value="NT1" <%=if3(wide_yn&list_type="NT1","checked","")%> class="inp_radio" />
												<label for="NT1"><em>리스트형</em></label>
											</span>
										</td>
										<td rowspan="6"></th>
									</tr>
									<tr>
										<th scope="row">와이드</th>
										<td>
											<span class="">
												<input type="radio" id="YT1" name="list_type" value="YT1" <%=if3(wide_yn&list_type="YT1","checked","")%> class="inp_radio" />
												<label for="YT1"><em>리스트형</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="2">앨범</th>
										<th>2열</th>
										<td>
											<span class="">
												<input type="radio" id="NA1" name="list_type" value="NA1" <%=if3(wide_yn&list_type="NA1","checked","")%> class="inp_radio" />
												<label for="NA1"><em>슬라이드형</em></label>
											</span>
<!-- 
											<span class="">
												<input type="radio" id="NA2" name="list_type" value="NA2" <%=if3(wide_yn&list_type="NA2","checked","")%> class="inp_radio" />
												<label for="NA2"><em>탭 슬라이드형</em></label>
											</span>
 -->
										</td>
									</tr>
									<tr>
										<th scope="row">와이드</th>
										<td>
											<span class="">
												<input type="radio" id="YA1" name="list_type" value="YA1" <%=if3(wide_yn&list_type="YA1","checked","")%> class="inp_radio" />
												<label for="YA1"><em>슬라이드형</em></label>
											</span>
<!-- 
											<span class="">
												<input type="radio" id="YA2" name="list_type" value="YA2" <%=if3(wide_yn&list_type="YA2","checked","")%> class="inp_radio" />
												<label for="YA2"><em>탭 슬라이드형</em></label>
											</span>
 -->
										</td>
									</tr>
									<tr>
										<th scope="row" rowspan="2">카드</th>
										<th scope="row">2열</th>
										<td>
											<span class="">
												<input type="radio" id="NC1" name="list_type" value="NC1" <%=if3(wide_yn&list_type="NC1","checked","")%> class="inp_radio" />
												<label for="NC1"><em>좌측 이미지형</em></label>
											</span>
											<span class="">
												<input type="radio" id="NC2" name="list_type" value="NC2" <%=if3(wide_yn&list_type="NC2","checked","")%> class="inp_radio" />
												<label for="NC2"><em>우측 이미지형</em></label>
											</span>
										</td>
									</tr>
									<tr>
										<th scope="row">와이드</th>
										<td>
											<span class="">
												<input type="radio" id="YC1" name="list_type" value="YC1" <%=if3(wide_yn&list_type="YC1","checked","")%> class="inp_radio" />
												<label for="YC1"><em>좌측 이미지형</em></label>
											</span>
											<span class="">
												<input type="radio" id="YC2" name="list_type" value="YC2" <%=if3(wide_yn&list_type="YC2","checked","")%> class="inp_radio" />
												<label for="YC2"><em>우측 이미지형</em></label>
											</span>
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
			document.location.href='../main_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
//-->
</script>

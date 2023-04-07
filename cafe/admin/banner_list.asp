<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(*) cnt "
	sql = sql & "   from cf_banner "
	sql = sql & "  where cafe_id = 'root' "
	sql = sql & "    and banner_type = 'T' "
	rs.open Sql, conn, 3, 1

	If rs("cnt") = 0 Then
		new_seq = getSeq("cf_banner")

		sql = ""
		sql = sql & " insert into cf_banner( "
		sql = sql & "        banner_seq "
		sql = sql & "       ,cafe_id "
		sql = sql & "       ,banner_type "
		sql = sql & "       ,open_yn "
		sql = sql & "       ,subject "
		sql = sql & "       ,file_name "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values "
		sql = sql & "      ('" & new_seq & "'  ,'root', 'top', 'Y', '', '','" & Session("user_id") & "', getdate()),"
		sql = sql & "      ('" & new_seq+1 & "','root', 'top', 'Y', '', '','" & Session("user_id") & "', getdate()),"
		sql = sql & "      ('" & new_seq+2 & "','root', 'top', 'Y', '', '','" & Session("user_id") & "', getdate()),"
		sql = sql & "      ('" & new_seq+3 & "','root', 'top', 'Y', '', '','" & Session("user_id") & "', getdate()),"
		sql = sql & "      ('" & new_seq+4 & "','root', 'top', 'Y', '', '','" & Session("user_id") & "', getdate()),"
		sql = sql & "      ('" & new_seq+5 & "','root', 'top', 'Y', '', '','" & Session("user_id") & "', getdate());"
		Conn.Execute(sql)
	End If
	rs.close
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>전체관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/admin/admin_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">배너관리</h2>
			</div>
			<div class="adm_cont">
				<div class="adm_menu_manage">
					<div class="tb tb_form_1">
						<table class="tb_fixed">
							<colgroup>
								<col class="w5" />
								<col class="w10" />
								<col class="w_remainder" />
								<col class="w_remainder" />
								<col class="w8" />
								<col class="w7" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">구분</th>
									<th scope="col">배너이미지</th>
									<th scope="col">제목/링크</th>
									<th scope="col">등록일</th>
									<th scope="col">공개여부</th>
									<th scope="col">설정</th>
								</tr>
							</thead>
							<tbody>
<%
	postion = Request("postion")

	If postion <> "" Then
		were = "    and banner_type = '" & postion & "' "
	else
		were = ""
	End if

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_banner "
	sql = sql & "  where cafe_id = 'root' "
	sql = sql & were
	sql = sql & "  order by banner_seq asc "
	rs.open Sql, conn, 3, 1

	i = 1

	Do Until rs.eof
		open_yn = rs("open_yn")
		If open_yn = "Y" then
			open_yn = "공개"
		Else
			open_yn = "비공개"
		End If

		If rs("banner_type") = "T" then
			banner_type = "상단"
		Else
			banner_type = "오른쪽"
		End if
%>
								<tr>
									<td class="algC"><%=i%></td>
									<td class="algC"><%=banner_type%></td>
									<td class="algC">
<%
		If rs("file_name") <> "" Then
			uploadUrl = ConfigAttachedFileURL & "banner/"

			If rs("file_type") = "I" Then
%>
										<img src="<%=uploadUrl & rs("file_name")%>" style="border:1px solid black;width:160px;height:80px;">
<%
			ElseIf rs("file_type") = "F" Then
%>
										<embed src="<%=uploadUrl & rs("file_name")%>" style="width:160px ;height:80px;">
<%
			End if
		Else
%>
										<div style="width:160px;height:80px;padding-top:30%;text-align:center;">160px X 80px
<%
		End If
%>
									</td>
									<td class="algC"><%=rs("subject")%>
<%
		If rs("link") <> "" Then
%>
										<br><br><a href="<%=rs("link")%>" target="_blank"><%=rs("link")%></a>
<%
		End If
%>
									</td>
									<td class="algC"><%=rs("credt")%></td>
									<td class="algC"><%=open_yn%></td>
									<td class="algC">
										<button type="button" class="btn btn_c_a btn_s" onclick="lyp('lypp_adm_banner')">수정</button>
									</td>
								</tr>
<%
		i = i + 1
		rs.MoveNext
	Loop
	rs.close
	Set rs = nothing
%>
							</tbody>
						</table>
					</div>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<!-- 배너 등록 : s -->
	<aside class="lypp lypp_adm_default lypp_adm_banner">
		<header class="lypp_head">
			<h2 class="h2">배너 등록</h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>닫기</em></button></span>
		</header>
		<div class="adm_cont">
			<form method="post" action="banner_exec.asp" enctype="multipart/form-data" target="hiddenfrm">
			<input type="hidden" name="task" value="upd">
			<input type="hidden" name="banner_seq" value="<%=banner_seq%>">
			<div class="tb tb_form_1">
				<table class="tb_input">
					<colgroup>
						<col class="w15" />
						<col class="w35" />
						<col class="w15" />
						<col class="w35" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">제목</th>
							<td colspan="3">
								<input type="text" id="subject" name="subject" maxlength="100" required class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">파일종류</th>
							<td>
								<select id="file_type" name="file_type" required class="sel w_auto">
									<option value="I" <%=if3(file_type="I","selected","")%>>이미지</option>
								</select>
							</td>
							<th scope="row">배너선택</th>
							<td>
								<input type="file" id="file_name" name="file_name" class="inp" required />
							</td>
						</tr>
						<tr>
							<th scope="row">배너이미지</th>
							<td>
<%
	If file_type = "I" Then
%>
								<img src="<%=uploadUrl & file_name%>" style="width:160px ;height:80px;">
<%
	elseIf file_type = "F" Then
%>
								<embed src="<%=uploadUrl & file_name%>" style="width:160px ;height:80px;">
<%
	End if
%>
							</td>
							<th scope="row">배너링크</th>
							<td>
								<input type="text" id="link" name="link" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">배너크기</th>
							<td>
								<span class="">
									<label for="">가로</label>
									<input type="text" id="banner_width" name="banner_width" class="inp w100p" />
								</span>
								<span class="ml10">
									<label for="">세로</label>
									<input type="text" id="banner_height" name="banner_height" class="inp w100p" />
								</span>
							</td>
							<th scope="row">공개여부</th>
							<td>
								<span class="">
									<input type="radio" id="open_yn" name="open_yn" value="Y" <%=if3(open_yn="Y","checked","")%> required class="inp_radio" />
									<label for=""><em>공개</em></label>
								</span>
								<span class="ml10">
									<input type="radio" id="open_yn" name="open_yn" value="N" <%=if3(open_yn="N","checked","")%> required class="inp_radio" />
									<label for=""><em>비공개</em></label>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button type="submit" class="btn btn_n">확인</button>
				<button type="reset" class="btn btn_n">취소</button>
			</div>
			</form>
		</div>
	</aside>
	<!-- //배너 등록 : e -->
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	</body>
</html>

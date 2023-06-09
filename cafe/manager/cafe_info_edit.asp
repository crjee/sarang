<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>가입정보 관리 : 사랑방 관리</title>
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
				<h2 class="h2">기본정보 관리</h2>
			</div>
			<div class="adm_cont">
				<form name="nomarForm" method="post" action="cafe_info_exec.asp" enctype="multipart/form-data">
				<input type="hidden" name="tb_prefix" value="cf">
				<div class="adm_menu_manage">
					<div class="tb tb_form_1">
						<table class="tb_input">
							<colgroup>
								<col class="w150p" />
								<col class="w_remainder" />
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">사랑방 로고</th>
									<td>
										<div class="logo">
<%
	uploadUrl = ConfigAttachedFileURL & "cafeimg/"

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                           "
	sql = sql & "   from cf_cafe                     "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	rs.open Sql, conn, 3, 1

	If Not rs.eof Then
		cafe_img  = rs("cafe_img")
		cafe_name = rs("cafe_name")
		open_yn   = rs("open_yn")
		open_type = rs("open_type")
		union_id  = rs("union_id")
	End If
	rs.close
	Set rs = Nothing

	If cafe_img <> "" Then
%>
											<img src="<%=uploadUrl & cafe_img%>" id="profile" name="profile" style="width:168px;height:54px">
<%
	Else
%>
											<img id="profile" name="profile" style="width:168px;height:54px">
<%
	End If
%>
										</div>
										<button type="button" id="deleteBtn" class="btn" onclick="cafe_img_del()">이미지 삭제</button>
										<button type="button" id="enrollBtn" class="btn">이미지 등록</button>
										<input type="file" name="cafe_img" id="cafe_img" style="display:none">
										<ul class="list_txt">
											<li>우리 사랑방을 표현할 수 있는 대표 이미지를 골라주세요.</li>
											<li>사랑방정보 영역, 프로필 페이지 및 우리사랑방 앱 등에 활용됩니다.</li>
											<li>크기는 168×54 픽셀 입니다.</li>
										</ul>
										<p class=""></p>
									</td>
								</tr>
								<tr>
									<th scope="row">사랑방 이름</th>
									<td>
										<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
										<input type="text" id="cafe_name" name="cafe_name" size="50" class="inp" required value="<%=cafe_name%>">
									</td>
								</tr>
								<tr>
									<th scope="row">공개 여부</th>
									<td>
										<%=GetMakeCDRadio("open_yn", open_yn, "")%>
									</td>
								</tr>
								<tr>
									<th scope="row">바로가기 설정</th>
									<td>
										<span class="">
											<input type="radio" class="inp_radio" id="open_type" name="open_type" value="C" <%=if3(open_type="C","checked","")%> />
											<label for=""><em>사랑방</em></label>
<%
	If union_id <> "" Then
%>
											<input type="radio" class="inp_radio" id="open_type" name="open_type" value="U" <%=if3(open_type="U","checked","")%> />
											<label for=""><em>연합회</em></label>
<%
	End If
%>
										</span>
										<span class="ml20">
											
										</span>
									</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="btn_box algR">
						<button type="submit" class="btn btn_c_a btn_n">확인</button>
					</div>
				</div>
				</form>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$('#enrollBtn').bind('click', function(e) {
		$('#cafe_img').click()
	})

	$(window).load(function() {
		function readURL(input,obj) {
			if (input.files && input.files[0]) {
				var reader = new FileReader()

				reader.onload = function (e) {
					$(obj).attr('src', e.target.result)
				}

				reader.readAsDataURL(input.files[0])
			}
		}

		$("#cafe_img").change(function() {
			readURL(this,'#profile')
		})
	})

	function cafe_img_del() {
		document.all.profile.src='';
		document.all.cafe_img.value = '';
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

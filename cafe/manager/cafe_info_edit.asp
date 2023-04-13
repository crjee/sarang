<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	Set row = Conn.Execute("select * from cf_cafe where cafe_id='" & cafe_id & "'")
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
	If row("cafe_img") <> "" Then
%>
											<img src="<%=uploadUrl & row("cafe_img")%>" id="profile" name="profile" style="width:168px;height:54px">
<%
	Else
%>
											<img id="profile" name="profile" style="width:168px;height:54px">
<%
	End If
%>
										</div>
										<button type="button" id="deleteBtn" class="btn" onclick="javascript:cafe_img_del()">이미지 삭제</button>
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
										<input type="text" id="cafe_name" name="cafe_name" size="50" class="inp" required value="<%=row("cafe_name")%>">
									</td>
								</tr>
								<tr>
									<th scope="row">공개 여부</th>
									<td>
										<%=makeRadioCD("open_yn", open_yn, "required")%>
									</td>
								</tr>
								<tr>
									<th scope="row">바로가기 설정</th>
									<td>
										<span class="">
											<input type="radio" class="inp_radio" id="open_type" name="open_type" value="C" <%=if3(row("open_type")="C","checked","")%> />
											<label for=""><em>사랑방</em></label>
<%
	If row("union_id") <> "" Then
%>
											<input type="radio" class="inp_radio" id="open_type" name="open_type" value="U" <%=if3(row("open_type")="U","checked","")%> />
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
</html>
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

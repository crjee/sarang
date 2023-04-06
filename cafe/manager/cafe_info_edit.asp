<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	Set row = Conn.Execute("select * from cf_cafe where cafe_id='" & cafe_id & "'")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�������� ���� : ����� ����</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS ����<sub>����� ����</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">�⺻���� ����</h2>
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
									<th scope="row">����� �ΰ�</th>
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
										<button type="button" id="deleteBtn" class="btn" onclick="javascript:cafe_img_del()">�̹��� ����</button>
										<button type="button" id="enrollBtn" class="btn">�̹��� ���</button>
										<input type="file" name="cafe_img" id="cafe_img" style="display:none">
										<ul class="list_txt">
											<li>�츮 ������� ǥ���� �� �ִ� ��ǥ �̹����� ����ּ���.</li>
											<li>��������� ����, ������ ������ �� �츮����� �� � Ȱ��˴ϴ�.</li>
											<li>ũ��� 168��54 �ȼ� �Դϴ�.</li>
										</ul>
										<p class=""></p>
									</td>
								</tr>
								<tr>
									<th scope="row">����� �̸�</th>
									<td>
										<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
										<input type="text" id="cafe_name" name="cafe_name" size="50" class="inp" required value="<%=row("cafe_name")%>">
									</td>
								</tr>
								<tr>
									<th scope="row">���� ����</th>
									<td>
										<span class="">
											<input type="radio" id="open_yn" name="open_yn" value="Y" <%=if3(row("open_yn")="Y","checked","")%> />
											<label for=""><em>����</em></label>
										</span>
										<span class="ml20">
											<input type="radio" id="open_yn" name="open_yn" value="N" <%=if3(row("open_yn")="N","checked","")%> />
											<label for=""><em>�����</em></label>
										</span>
									</td>
								</tr>
								<tr>
									<th scope="row">�ٷΰ��� ����</th>
									<td>
										<span class="">
											<input type="radio" id="open_type" name="open_type" value="C" <%=if3(row("open_type")="C","checked","")%> />
											<label for=""><em>�����</em></label>
<%
	If row("union_id") <> "" Then
%>
											<input type="radio" id="open_type" name="open_type" value="U" <%=if3(row("open_type")="U","checked","")%> />
											<label for=""><em>����ȸ</em></label>
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
						<button type="submit" class="btn btn_c_a btn_n">Ȯ��</button>
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

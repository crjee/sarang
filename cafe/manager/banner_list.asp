<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>��� ���� > ������</title>
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
				<h2 class="h2">��ʰ���</h2>
			</div>
			<div class="adm_cont">
				<div class="adm_menu_manage">
				<form name="nform" method="post" action="banner_num_exec.asp" target="hiddenfrm">
					<div class="btn_box algL mb10">
						<button type="submit" class="btn btn_c_a btn_s">������� ����</button>
					</div>
					<div class="tb tb_form_1">
						<table class="tb_fixed">
							<colgroup>
								<col class="w5" />
								<col class="w5" />
								<col class="w10" />
								<col class="w_remainder" />
								<col class="w_remainder" />
								<col class="w8" />
								<col class="w7" />
								<col class="w7" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">�������</th>
									<th scope="col">�����ȣ</th>
									<th scope="col">�̹���</th>
									<th scope="col">����</th>
									<th scope="col">��ũ</th>
									<th scope="col">�����</th>
									<th scope="col">����</th>
									<th scope="col">��������</th>
									<th scope="col">����</th>
								</tr>
							</thead>
							<tbody>
<%
	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_banner "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and banner_type <> 'T' "
	sql = sql & "  order by banner_type, banner_num asc "
	rs.Open Sql, conn, 3, 1

	i = 1
	Do Until rs.eof
		open_yn = rs("open_yn")
		If open_yn = "Y" Then
			open_yn = "����"
		Else
			open_yn = "�����"
		End If

		banner_seq = rs("banner_seq")
		banner_num = rs("banner_num")
		file_type = rs("file_type")
		file_name = rs("file_name")
		banner_type = rs("banner_type")
		subject = rs("subject")
		open_yn = rs("open_yn")
		link = rs("link")
		banner_width = rs("banner_width")
		banner_height = rs("banner_height")

		Select Case banner_type
			Case "T"
				banner_type_txt = "���"
			Case "C0"
				banner_type_txt = "�빮��ü"
				width  = 800
				height = 170
			Case "C1"
				banner_type_txt = "�빮1"
				width  = 266
				height = 170
			Case "C2"
				banner_type_txt = "�빮2"
				width  = 266
				height = 170
			Case "C3"
				banner_type_txt = "�빮3"
				width  = 266
				height = 170
			Case "R"
				banner_type_txt = "������"
				width  = 150
		End Select
%>
								<tr>
									<td class="algC">
										<input type="hidden" name="banner_seq" value="<%=rs("banner_seq")%>">
<%
		If rs("banner_type") = "R" Then
%>
										<input type="text" name="banner_num" class="inp w40p algC" value="<%=banner_num%>" align="right">
<%
		Else
%>
										<input type="hidden" name="banner_num" value="<%=banner_num%>">
<%
		End If
%>
									</td>
									<td class="algC"><%=banner_num%></td>
									<td class="algC">
<%
		If rs("file_type") = "I" Then
%>
										<%If rs("link") <> "" then%><a href="<%=rs("link")%>" target="_blank"><%End if%><img src="<%=uploadUrl & rs("file_name")%>" style="border:1px solid #dddddd;width:150px;"><%If rs("link") <> "" then%></a><%End if%></li>
<%
		ElseIf rs("file_type") = "F" Then
%>
										<%If rs("link") <> "" then%><a href="<%=rs("link")%>" target="_blank"><%End if%><embed src="<%=uploadUrl & rs("file_name")%>" style="border:1px solid #dddddd;width:<%=banner_width%>px ;height:<%=banner_height%>px;"><%If rs("link") <> "" then%></a><%End if%></li>
<%
		End if
%>
									</td>
									<td class="algC"><%=rs("subject")%></td>
									<td class="algC"><%=rs("link")%></td>
									<td class="algC"><%=Left(rs("credt"),10)%></td>
									<td class="algC"><%=banner_type_txt%></td>
									<td class="algC"><%=open_yn%></td>
									<td class="algC">
										<button type="button" class="btn btn_c_a btn_s btn_modi" onclick="onEdit('<%=rs("banner_seq")%>')">����</button>
										<button type="button" class="btn btn_c_a btn_s" onclick="hiddenfrm.location.href='banner_del_exec.asp?task=del&banner_seq=<%=rs("banner_seq")%>'">����</button>
									</td>
								</tr>
<%
		i = i + 1
		rs.MoveNext
	Loop
	rs.close
%>
							</tbody>
						</table>
					</div>
					<div class="btn_box algR">
						<a href="#n" class="btn btn_c_a btn_n" onclick="onRegi()">��ʵ��</a>
					</div>
				</div>
			</form>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	<!-- Banner ��� : s -->
	<aside class="lypp lypp_adm_default lypp_adm_banner">
		<header class="lypp_head">
			<h2 class="h2">��� <span id="regTitle"></span></h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>�ݱ�</em></button></span>
		</header>
		<div class="adm_cont">
			<form method="post" id="regi_form" name="regi_form" action="banner_exec.asp" enctype="multipart/form-data" target="hiddenfrm">
			<input type="hidden" id="task" name="task" value="ins">
			<input type="hidden" id="banner_seq" name="banner_seq">
			<div class="tb">
				<table class="tb_input">
					<colgroup>
						<col class="w100p" />
						<col class="w_auto" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">��ġ</th>
							<td>
								<select id="banner_type" name="banner_type" required class="sel w_auto">
									<option></option>
									<%If banner_type_C0 <> "Y" then%><option value="C0">�빮��ü</option><%End if%>
									<%If banner_type_C1 <> "Y" then%><option value="C1">�빮1</option><%End if%>
									<%If banner_type_C2 <> "Y" then%><option value="C2">�빮2</option><%End if%>
									<%If banner_type_C3 <> "Y" then%><option value="C3">�빮3</option><%End if%>
									<option value="R">������</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">��������</th>
							<td>
								<select id="file_type" name="file_type" required class="sel w_auto">
									<option value="I">�̹���</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">����</th>
							<td>
								<input type="text" id="subject" name="subject" maxlength="100" required class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">��ʼ���</th>
							<td>
								<img id="file_img" name="file_img" style="width:150px">
								<input type="file" id="file_name" name="file_name" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">���ũ��</th>
							<td>
								<label for="">����</label>
								<input type="text" id="banner_width" name="banner_width" required class="inp w100p" />

								<label for="">����</label>
								<input type="text" id="banner_height" name="banner_height" required class="inp w100p" />
							</td>
						</tr>
						<tr>
							<th scope="row">��ʸ�ũ</th>
							<td>
								<input type="text" id="link" name="link" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">��������</th>
							<td>
								<input type="radio" id="open_y" name="open_yn" value="Y" required />
								<label for="open_y"><em>����</em></label>

								<input type="radio" id="open_n" name="open_yn" value="N" required />
								<label for="open_n"><em>�����</em></label>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button id="submitBtn" type="submit" class="btn btn_n">Ȯ��</button>
				<button id="resetBtn" type="reset" class="btn btn_n">���</button>
			</div>
			</form>
		</div>
	</aside>
	<!-- //Banner ��� : e -->
</body>
</html>
<!--Center-->
<script type="text/javascript">
	function readURL(input,obj) {
		if (input.files && input.files[0]) {
			var reader = new FileReader()

			reader.onload = function (e) {
				$(obj).attr('src', e.target.result)
			}

			reader.readAsDataURL(input.files[0])
		}
	}

	$("#file_name").change(function(){
		readURL(this,'#file_img')
	})

	$('#resetBtn').bind('click', function(e) {
		$("#file_img").attr('src', "")
	})

	function onRegi(){
		$("#regi_form")[0].reset();
		$("#task").val("ins");
		$("#file_img").attr('src', "")
		$("#file_name").attr("required" , true);
		document.getElementById("regTitle").innerText = "���";
		lyp('lypp_adm_banner');
	}

	function onEdit(banner_seq){
		$("#regi_form")[0].reset();
		$("#task").val("upd")
		$("#file_img").attr('src', "")
		$("#file_name").attr("required" , false);
		document.getElementById("regTitle").innerText = "����";
		lyp('lypp_adm_banner');

		try {
			var strHtml = [];

			$.ajax({
				type: "POST",
				dataType: "json",
				url: "/cafe/manager/banner_ajax_view.asp",
				data: {"banner_seq":banner_seq},
				success: function(xmlData) {
					if (xmlData.TotalCnt > 0) {
						for (i=0; i<xmlData.TotalCnt; i++) {
							//alert(xmlData.ResultList[i].banner_seq);
							$("#banner_seq").val(xmlData.ResultList[i].banner_seq);
							//alert(xmlData.ResultList[i].file_type);
							$("#file_type").val(xmlData.ResultList[i].file_type);
							//alert(xmlData.ResultList[i].file_name);
							$("#file_img").attr('src', "<%=uploadUrl%>"+xmlData.ResultList[i].file_name)
//										$("#file_name").val(xmlData.ResultList[i].file_name);
							//alert(xmlData.ResultList[i].banner_type);
							$("#banner_type").val(xmlData.ResultList[i].banner_type);
							//alert(xmlData.ResultList[i].subject);
							$("#subject").val(xmlData.ResultList[i].subject);
							//alert(xmlData.ResultList[i].open_yn);
							if(xmlData.ResultList[i].open_yn == "Y")
							$("#open_y").prop('checked',true);
							if(xmlData.ResultList[i].open_yn == "N")
							$("#open_n").prop('checked',true);
							//alert(xmlData.ResultList[i].link);
							$("#link").val(xmlData.ResultList[i].link);
							//alert(xmlData.ResultList[i].banner_width);
							$("#banner_width").val(xmlData.ResultList[i].banner_width);
							//alert(xmlData.ResultList[i].banner_height);
							$("#banner_height").val(xmlData.ResultList[i].banner_height);
						}
					}
					else {
						alert("�ش� ��ʰ� �����ϴ�");
					}
				},
				complete : function(){
				},
				error : function(xmlData) {
					alert("ERROR");
				}
			});
		}
		catch (e){
			alert(e);
		}
	}

</script>

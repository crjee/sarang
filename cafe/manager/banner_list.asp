<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>배너 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
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
				<h2 class="h2">배너관리</h2>
			</div>
			<div class="adm_cont">
				<div class="adm_menu_manage">
				<form name="nform" method="post" action="banner_num_exec.asp" target="hiddenfrm">
					<div class="btn_box algL mb10">
						<button type="submit" class="btn btn_c_a btn_s">노출순서 저장</button>
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
									<th scope="col">노출순서</th>
									<th scope="col">노출번호</th>
									<th scope="col">이미지</th>
									<th scope="col">제목</th>
									<th scope="col">링크</th>
									<th scope="col">등록일</th>
									<th scope="col">구분</th>
									<th scope="col">공개여부</th>
									<th scope="col">설정</th>
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
			open_yn = "공개"
		Else
			open_yn = "비공개"
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
				banner_type_txt = "상단"
			Case "C0"
				banner_type_txt = "대문전체"
				width  = 800
				height = 170
			Case "C1"
				banner_type_txt = "대문1"
				width  = 266
				height = 170
			Case "C2"
				banner_type_txt = "대문2"
				width  = 266
				height = 170
			Case "C3"
				banner_type_txt = "대문3"
				width  = 266
				height = 170
			Case "R"
				banner_type_txt = "오른쪽"
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
										<button type="button" class="btn btn_c_a btn_s btn_modi" onclick="onEdit('<%=rs("banner_seq")%>')">수정</button>
										<button type="button" class="btn btn_c_a btn_s" onclick="hiddenfrm.location.href='banner_del_exec.asp?task=del&banner_seq=<%=rs("banner_seq")%>'">삭제</button>
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
						<a href="#n" class="btn btn_c_a btn_n" onclick="onRegi()">배너등록</a>
					</div>
				</div>
			</form>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	<!-- Banner 등록 : s -->
	<aside class="lypp lypp_adm_default lypp_adm_banner">
		<header class="lypp_head">
			<h2 class="h2">배너 <span id="regTitle"></span></h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>닫기</em></button></span>
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
							<th scope="row">위치</th>
							<td>
								<select id="banner_type" name="banner_type" required class="sel w_auto">
									<option></option>
									<%If banner_type_C0 <> "Y" then%><option value="C0">대문전체</option><%End if%>
									<%If banner_type_C1 <> "Y" then%><option value="C1">대문1</option><%End if%>
									<%If banner_type_C2 <> "Y" then%><option value="C2">대문2</option><%End if%>
									<%If banner_type_C3 <> "Y" then%><option value="C3">대문3</option><%End if%>
									<option value="R">오른쪽</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">파일종류</th>
							<td>
								<select id="file_type" name="file_type" required class="sel w_auto">
									<option value="I">이미지</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td>
								<input type="text" id="subject" name="subject" maxlength="100" required class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">배너선택</th>
							<td>
								<img id="file_img" name="file_img" style="width:150px">
								<input type="file" id="file_name" name="file_name" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">배너크기</th>
							<td>
								<label for="">가로</label>
								<input type="text" id="banner_width" name="banner_width" required class="inp w100p" />

								<label for="">세로</label>
								<input type="text" id="banner_height" name="banner_height" required class="inp w100p" />
							</td>
						</tr>
						<tr>
							<th scope="row">배너링크</th>
							<td>
								<input type="text" id="link" name="link" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">공개여부</th>
							<td>
								<input type="radio" id="open_y" name="open_yn" value="Y" required />
								<label for="open_y"><em>공개</em></label>

								<input type="radio" id="open_n" name="open_yn" value="N" required />
								<label for="open_n"><em>비공개</em></label>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button id="submitBtn" type="submit" class="btn btn_n">확인</button>
				<button id="resetBtn" type="reset" class="btn btn_n">취소</button>
			</div>
			</form>
		</div>
	</aside>
	<!-- //Banner 등록 : e -->
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

	$("#file_name").change(function() {
		readURL(this,'#file_img')
	})

	$('#resetBtn').bind('click', function(e) {
		$("#file_img").attr('src', "")
	})

	function onRegi() {
		$("#regi_form")[0].reset();
		$("#task").val("ins");
		$("#file_img").attr('src', "")
		$("#file_name").attr("required" , true);
		document.getElementById("regTitle").innerText = "등록";
		lyp('lypp_adm_banner');
	}

	function onEdit(banner_seq) {
		$("#regi_form")[0].reset();
		$("#task").val("upd")
		$("#file_img").attr('src', "")
		$("#file_name").attr("required" , false);
		document.getElementById("regTitle").innerText = "수정";
		lyp('lypp_adm_banner');

		try {
			var strHtml = [];

			$.ajax({
				type: "POST",
				dataType: "json",
				url: "/cafe/manager/banner_view_ajax.asp",
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
							if (xmlData.ResultList[i].open_yn == "Y")
							$("#open_y").prop('checked',true);
							if (xmlData.ResultList[i].open_yn == "N")
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
						alert("해당 배너가 없습니다");
					}
				},
				complete : function() {
				},
				error : function(xmlData) {
					alert("ERROR");
				}
			});
		}
		catch (e) {
			alert(e);
		}
	}

</script>

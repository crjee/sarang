<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="skin_type_1">
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
	<div id="wrap" class="group">
<!--#include virtual="/cafe/cafe_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/cafe_left_inc.asp"-->
<%
	End IF
%>
			<div class="container">
<%
	Set rs = Server.CreateObject("ADODB.Recordset")
	sql = ""
	sql = sql & " select "
	sql = sql & "        mb.* "
	sql = sql & "       ,cm.cafe_id "
	sql = sql & "       ,cm.cafe_mb_level "
	sql = sql & "       ,um.union_mb_level"
	sql = sql & "       ,cm.stat cstat "
	sql = sql & "       ,cc.cafe_name "
	sql = sql & "       ,cc.union_id "
	sql = sql & "       ,cu.cafe_name as union_name "
	sql = sql & "   from cf_member mb "
	sql = sql & "   left outer join cf_cafe_member cm on cm.user_id = mb.user_id "
	sql = sql & "   left outer join cf_cafe cc on cc.cafe_id = cm.cafe_id "
	sql = sql & "   left outer join cf_cafe cu on cu.cafe_id = cc.union_id "
	sql = sql & "   left outer join cf_union_manager um on um.user_id = mb.user_id and um.union_id = cu.cafe_id "
	sql = sql & "  where mb.user_id = '" & session("user_id")  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		user_id         = rs("user_id")
		user_pw         = rs("user_pw")
		kname           = rs("kname")
		ename           = rs("ename")
		agency          = rs("agency")
		license         = rs("license")
		birth           = rs("birth")
		sex             = rs("sex")
		email           = rs("email")
		mobile          = rs("mobile")
		phone           = rs("phone")
		interphone      = rs("interphone")
		fax             = rs("fax")
		erec            = rs("erec")
		mrec            = rs("mrec")
		zipcode         = rs("zipcode")
		addr1           = rs("addr1")
		addr2           = rs("addr2")
		stat            = rs("stat")
		cafe_id         = rs("cafe_id")
		mlevel          = rs("mlevel")
		creid           = rs("creid")
		credt           = rs("credt")
		modid           = rs("modid")
		moddt           = rs("moddt")
		ipin            = rs("ipin")
		memo_receive_yn = rs("memo_receive_yn")
		picture         = rs("picture")

		cafe_id         = rs("cafe_id")
		cafe_mb_level   = rs("cafe_mb_level")
		union_mb_level  = rs("union_mb_level")
		cstat           = rs("cstat")
		cafe_name       = rs("cafe_name")
		union_id        = rs("union_id")
		union_name      = rs("union_name")

		If isnull(cafe_id       ) Then cafe_id         = ""
		If isnull(cafe_mb_level ) Then cafe_mb_level   = ""
		If isnull(union_mb_level) Then union_mb_level  = ""
		If isnull(cstat         ) Then cstat           = ""
		If isnull(cafe_name     ) Then cafe_name       = ""
		If isnull(union_id      ) Then union_id        = ""
		If isnull(union_name    ) Then union_name      = ""
	End If
	rs.close

	Select Case cafe_mb_level
		Case "1" cafe_mb_level_txt = "준회원"
		Case "2" cafe_mb_level_txt = "정회원"
		Case "10" cafe_mb_level_txt = "사랑방지기"
	End Select
	
	If isnull(union_mb_level) Then union_mb_level = ""
		Select Case union_mb_level
			Case "" union_mb_level_txt = "정회원"
			Case "10" union_mb_level_txt = "연합회지기"
		End Select
%>
				<form name="form" method="post" action="my_info_exec.asp" enctype="multipart/form-data">
				<input type="hidden" name="tb_prefix" value="cf">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2">나의 정보</h2>
				</div>
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">성명</th>
								<td colspan="3">
									<%=kname%>
								</td>
							</tr>
							<tr>
								<th scope="row">중개업소명</th>
								<td>
									<%=agency%>
								</td>
								<th scope="row">허가번호</th>
								<td>
									<%=license%>
								</td>
							</tr>
							<tr>
								<th scope="row">쪽지수신</th>
								<td>
									<input type="radio" class="inp_radio" name="memo_receive_yn" value="Y" <%=if3(memo_receive_yn="Y","checked","")%>>허용 &nbsp; &nbsp;
									<input type="radio" class="inp_radio" name="memo_receive_yn" value="N" <%=if3(memo_receive_yn="N","checked","")%>>차단
								</td>
								<th scope="row">휴대폰</th>
								<td>
									<%=mobile%>
								</td>
							</tr>
							<tr>
								<th scope="row">연락처</th>
								<td>
									<%=phone%><%=if3(interphone="","","(" & interphone & ")")%>
								</td>
								<th scope="row">팩스</th>
								<td>
									<%=fax%>
								</td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td colspan="3">
									<%=addr1%> <%=addr2%>
								</td>
							</tr>
							<tr>
								<th scope="row">사랑방</th>
								<td>
									<a href="/cafe/main.asp?cafe_id=<%=cafe_id%>"><%=cafe_name%><%=if3(cafe_id="","","(" & cafe_mb_level_txt & ")")%></a>
								</td>
								<th scope="row">연합회</th>
								<td>
									<a href="/cafe/main.asp?cafe_id=<%=union_id%>"><%=union_name%><%=if3(union_id="","","(" & union_mb_level_txt & ")")%></a>
								</td>
							</tr>
							<tr>
								<th scope="row">중개업소사진</th>
								<td colspan="3">
									<div class="photo">
<%
	uploadUrl = ConfigAttachedFileURL & "picture/"
	If picture <> "" Then
%>
										<img src="<%=uploadUrl & picture%>" id="profile" name="profile" title="중개업소사진">
<%
	Else
%>
										<img id="profile" name="profile" style="width:132px;height:132px">
<%
	End If
%>
									</div>
									<button type="button" id="deleteBtn" class="btn_long" onclick="picture_del()">사진 삭제</button>
									<button type="button" id="enrollBtn" class="btn_long">사진 등록</button>
									<input type="file" name="picture" id="picture" style="display:none">
									<input type="hidden" name="del" id="del">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goCafe()">취소</button>
				</div>
				</form>
				<form name="search_form" id="search_form" method="post">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				</form>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<%
	End IF
%>
</body>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$('#enrollBtn').bind('click', function(e) {
		$('#picture').click()
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

		$("#picture").change(function() {
			readURL(this,'#profile')
		})
	})

	function picture_del() {
		document.all.profile.src='';
		document.all.picture.value = '';
		document.all.del.value = 'Y';
	}

	function goCafe() {
		var f = document.search_form;
		f.action = "/<%=session("cafe_id")%>";
		f.target = "_top";
		f.submit();
	}
</script>
</html>

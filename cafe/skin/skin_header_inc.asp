<script language="JavaScript">
<!--
	// 쿠키 생성
	function setCookie(name, value, d) {
		document.cookie = name+'='+escape(value)+'; path=/'+(d?'; expires='+(function(t) {t.setDate(t.getDate()+d);return t})(new Date).toGMTString():'');
	}

	// 쿠키 가져오기
	function getCookie(name) {
		name = new RegExp(name + '=([^;]*)');
		return name.test(document.cookie) ? unescape(RegExp.$1) : '';
	}
//-->
</script>
<script>
	var scale = 1;
	var scale2 = getCookie("scale");

	if (scale2 != "") {
		scale = scale2;
		document.body.style.zoom = scale;
	}

	function zoomIn() {
		scale = parseFloat(scale) + 0.1;
		zoom();
	}

	function zoomOut() {
		scale = parseFloat(scale) - 0.1;
		zoom();
	}

	function zoomDefault() {
		scale = 1;
		zoom();
	}

	function zoom() {
		scale = scale * 10
		scale = Math.round(scale)
		scale = scale / 10
		setCookie("scale", scale, 100);

		document.location.href = document.location;
	}
</script>
<%
	cafe_mb_level = getUserLevel(cafe_id)
	Select case cafe_mb_level
		Case "0"
			Response.Write "<script>alert('관리자에 의해 사랑방 접근이 제한 되었습니다.');top.location.href='/';</script>"
			Response.end
		Case "1"
			user_level_str = "준회원"
		Case "2"
			user_level_str = "정회원"
		Case "10"
			user_level_str = "운영자"
	End Select

	Set header_rs = Server.CreateObject ("ADODB.Recordset")

	' 회원수
	sql = ""
	sql = sql & " select count(cafe_id) as cnt "
	sql = sql & "   from cf_cafe_member "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and stat = 'Y' "
	header_rs.Open sql, conn, 3, 1

	If Not header_rs.EOF Then
		member_cnt = header_rs("cnt")
	End If
	header_rs.close

	' 방문자수, 카페이미지
	sql = ""
	sql = sql & " select visit_cnt "
	sql = sql & "       ,cafe_img "
	sql = sql & "   from cf_cafe "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	header_rs.Open sql, conn, 3, 1

	If Not header_rs.EOF Then
		visit_cnt = header_rs("visit_cnt")
		cafe_img = header_rs("cafe_img")
	End If
	header_rs.close

	' 쪽지수
	sql = ""
	sql = sql & " select count(to_user) as cnt "
	sql = sql & "   from cf_memo "
	sql = sql & "  where to_user = '" & user_id & "' "
	sql = sql & "    and to_stat <> 'Y' "
	header_rs.Open sql, conn, 3, 1

	If Not header_rs.EOF Then
		memo_cnt = header_rs("cnt")
	End If
	header_rs.close
	Set header_rs = Nothing
%>
		<header id="header">
			<div class="header_inner">
				<div class="header_cont">
					<h1><a href="/"><img src="/common/img/common/logo.svg" alt="" /></a></h1>
					<ul class="top_btn_box">
						<li class="button_zone">
							<span id="zoom"></span>
							<script>
								var target = document.getElementById('zoom');
								target.innerText = scale;
							</script>
							<button type="button" class="btn_enlar" onclick="zoomOut()"><em>축소</em></button>
							<button type="button" class="btn_nor" onclick="zoomDefault()"><em>기본</em></button>
							<button type="button" class="btn_reduc" onclick="zoomIn()"><em>확대</em></button>
						</li>
<%
	If Session("cafe_ad_level") = "10" Then
%>
						<li><a href="/cafe/admin/member_list.asp">관리자</a></li>
						<li><a href="/cafe/main.asp?cafe_id=<%=session("mycafe")%>">처음으로</a></li>
						<li><a href="/cafe/skin/my_info_edit.asp">내정보</a></li>
<%
		If user_id <> "" Then
%>
						<li><a href="/logout_exec.asp">로그아웃</a></li>
<%
		Else
%>
						<li><a href="/">로그인</a></li>
<%
		End If
		If skin_yn = "Y" Then
%>
						<li><a href="#n" class="btn_decotation">꾸미기</a></li>
<%
		End If

	ElseIf Session("cafe_mb_level") = "10" Then
%>
						<li><a href="/cafe/skin/my_info_edit.asp">내정보</a></li>
						<li><a href="/cafe/main.asp?cafe_id=<%=session("mycafe")%>">처음으로</a></li>
						<li><a href="/end_message_view.asp">로그아웃</a></li>
<%
		If skin_yn = "Y" Then
%>
						<li><a href="#n" class="btn_decotation">꾸미기</a></li>
<%
		End If
	Else
%>
						<li><a href="/cafe/skin/my_info_edit.asp">내정보</a></li>
						<li><a href="/cafe/main.asp?cafe_id=<%=session("mycafe")%>">처음으로</a></li>
						<li><a href="/end_message_view.asp">로그아웃</a></li>
<%
	End If
%>
						<li><a href="/home/main.asp">경인홈</a></li>
					</ul>
				</div>
				<div class="header_banner">
<%
	uploadUrl = ConfigAttachedFileURL & "banner/"
	Set head_rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select top 6 *           "
	sql = sql & "   from cf_banner         "
	sql = sql & "  where cafe_id='root'    "
	sql = sql & "    and banner_type = 'T' "
	sql = sql & "    and open_yn = 'Y'     "
	sql = sql & "  order by banner_seq asc "
	head_rs.open Sql, conn, 3, 1
	i = 1
	Do Until head_rs.eof
		i = i + 1
		banner_seq     = head_rs("banner_seq")
		banner_num     = head_rs("banner_num")
		banner_type    = head_rs("banner_type")
		banner_subject = head_rs("subject")
		file_name      = head_rs("file_name")
		file_type      = head_rs("file_type")
		banner_height  = head_rs("banner_height")
		banner_width   = head_rs("banner_width")
		link           = head_rs("link")
		open_yn        = head_rs("open_yn")

		banner_width  =  160
		banner_height =  80

		If file_name <> "" then
%>
					<div class="banners">
<%
			If link <> "" Then
%>
						<a href="<%=link%>" target="_blank">
<%
			End If
%>
						<img src="<%=uploadUrl & file_name%>"/>
<%
			If link <> "" Then
%>
						</a>
<%
			End If
%>
					</div>
<%
		End If

		head_rs.MoveNext
	Loop

	head_rs.close
	Set head_rs = nothing
%>
<%
	For j = i To 7
%>
					<div class="banners"></div>
<%
	Next
%>
				</div>
			</div>
		</header>

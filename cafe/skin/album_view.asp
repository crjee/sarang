<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	read_auth = getonevalue("read_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(read_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('읽기 권한이없습니다');history.back()</script>"
		Response.End
	End If

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&album_seq=" & Request("album_seq")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<%
	menu_seq  = Request("menu_seq")
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	album_seq = Request("album_seq")

	Call setViewCnt(menu_type, album_seq)

	sql = ""
	sql = sql & " select ca.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_album ca "
	sql = sql & "   left join cf_member cm on cm.user_id = ca.user_id "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
	End If

'	rs.close
%>
			<script type="text/javascript">
				function Rsize(img, ww, hh, aL) {
					var tt = imgRsize(img, ww, hh);
					if (img.width > ww || img.height > hh) {

						// 가로나 세로크기가 제한크기보다 크면
						img.width = tt[0];
						// 크기조정
						img.height = tt[1];
						img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

						if(aL){
							// 자동링크 on
							img.onclick = function() {
								wT = Math.ceil((screen.width - tt[2])/2.6);
								// 클라이언트 중앙에 이미지위치.
								wL = Math.ceil((screen.height - tt[3])/2.6);
								var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
								var doc = mm.document;
								try{
									doc.body.style.margin = 0;
									// 마진제거
									doc.body.style.cursor = "hand";
									doc.title = "원본이미지";
								}
								catch(err) {
								}
								finally {
								}

							}
							img.style.cursor = "hand";
						}
					}
					else {
							img.onclick = function(){
								alert("현재이미지가 원본 이미지입니다.");
							}
					}
				}

				function imgRsize(img, rW, rH){
					var iW = img.width;
					var iH = img.height;
					var g = new Array;
					if(iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
						g[0] = iW;
						g[1] = iH;
					}
					else {
						if(img.width > img.height) { // 원크기 가로가 세로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						else if(img.width < img.height) { //원크기의 세로가 가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
						else {
							g[0] = rW;
							g[1] = rH;
						}
						if(g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						if(g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
					}

					g[2] = img.width; // 원사이즈 가로
					g[3] = img.height; // 원사이즈 세로

					return g;
				}

				function goPrint(){
					var initBody;
					window.onbeforeprint = function(){
						initBody = document.body.innerHTML;
						document.body.innerHTML =  document.getElementById('CenterContents').innerHTML;
					};
					window.onafterprint = function(){
						document.body.innerHTML = initBody;
					};
					window.print();
				}

				function goList(){
					document.search_form.action = "/cafe/skin/album_list.asp"
					document.search_form.submit();
				}

				function goReply(){
					document.search_form.action = "/cafe/skin/album_reply.asp"
					document.search_form.submit();
				}

				function goModify(){
					document.search_form.action = "/cafe/skin/album_modify.asp"
					document.search_form.submit();
				}

				function goDelete(){
					document.search_form.action = "/cafe/skin/com_waste_exec.asp"
					document.search_form.submit();
				}

				function goSuggest(){
					document.search_form.action = "/cafe/skin/com_suggest_exec.asp"
					document.search_form.submit();
				}

				function goSlide(){
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}

				function copyUrl(){
					try{
						if (window.clipboardData){
								window.clipboardData.setData("Text", "<%=pageUrl%>")
								alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
						}
						else if (window.navigator.clipboard){
								window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
									alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
								});
						}
						else{
							temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
						}
					}catch(e){
						alert(e)
					}
				}
			</script>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/cafe/skin/album_slide_view_p.asp?album_seq=<%=album_seq%>">
			<input type="hidden" name="open_name" value="album_slide">
			<input type="hidden" name="open_specs" value="width=660, height=530, left=150, top=20">
			</form>
			<form name="search_form" method="post">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="album_seq" value="<%=album_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goModify()">수정</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">삭제</button>
<%
		End If
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goSuggest()">추천</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goPrint()">프린터</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goSlide()">슬라이드</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="copyUrl()">글주소복사</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goList()">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
				<div class="view_head">
					<h3 class="h3" id="subject"><%=rs("subject")%></h3>
					<div class="wrt_info_box">
						<ul>
							<li><span>작성자</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
							<li><span>조회</span><strong><%=rs("view_cnt")%></strong></li>
							<li><span>추천</span><strong><%=rs("suggest_cnt")%></strong></li>
							<li><span>등록일시</span><strong><%=rs("credt")%></strong></li>
						</ul>
					</div>
				</div>
				<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<%
	link = rs("link")
	link_txt = rmid(link, 40, "..")
	
	If link_txt <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/skin/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<script>
	document.getElementById("linkBtn").onclick = function(){
		try{
			if (window.clipboardData){
					window.clipboardData.setData("Text", "<%=link%>")
					alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
			}
			else if (window.navigator.clipboard){
					window.navigator.clipboard.writeText("<%=link%>").then(() => {
						alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
					});
			}
			else{
				temp = prompt("해당 URL을 복사하십시오.", "<%=link%>");
			}
		}catch(e){
			alert(e)
		}
	};
</script>
<%
	End If
%>
<%
	uploadUrl = ConfigAttachedFileURL & "album/"

	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_album_attach "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	sql = sql & "  order by attach_num "
	rs2.Open Sql, conn, 3, 1

	Do Until rs2.eof
%>
					<img src="<%=uploadUrl & rs2("file_name")%>" border="0" onLoad="Rsize(this, 600, 450, 1)" style="cursor:hand" /><br /><br />
<%
		rs2.MoveNext
	loop
	rs2.close
	Set rs2 = Nothing
%>
				</div>
				<div class="bbs_cont">
					<%=rs("contents")%>
				</div>
				</div>
<%
	rs.close
	Set rs = Nothing
%>
<%
	com_seq = album_seq
%>
<!--#include virtual="/cafe/skin/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


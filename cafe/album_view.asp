<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckReadAuth(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL")
%>
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
			<div class="container" id="album">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	cafe_sch  = Request("cafe_sch")

	self_yn   = Request("self_yn")

	album_seq = Request("album_seq")

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select ca.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_album ca "
	sql = sql & "   left join cf_member cm on cm.user_id = ca.user_id "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
	End If
%>
				<form name="search_form" method="post">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
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
	write_auth = GetOneValue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If GetToInt(write_auth) <= GetToInt(cafe_mb_level) Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
		If rs("step_num") = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goModify('<%=session("ctTarget")%>')">수정</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goDelete()">삭제</button>
<%
		End If
	End If
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goSuggest()">추천</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goPrint()">프린터</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="onSlide()">슬라이드</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="onCopyUrl()">글주소복사</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goList('<%=cafe_sch%>', '<%=session("ctTarget")%>')">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3" id="subject"><%=rs("subject")%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>글쓴이</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
								<li><span>조회</span><strong><%=rs("view_cnt")%></strong></li>
								<li><span>추천</span><strong><%=rs("suggest_cnt")%></strong></li>
								<li><span>등록일시</span><strong><%=rs("credt")%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<!--#include virtual="/include/attach_view_inc.asp"-->
<%
	link = rs("link")
	link_txt = rmid(link, 40, "..")
	
	If link_txt <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
						<script>
							document.getElementById("linkBtn").onclick = function() {
								try{
									if (window.clipjobData) {
											window.clipjobData.setData("text", "<%=link%>")
											alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
									}
									else if (window.navigator.clipjob) {
											window.navigator.clipjob.writeText("<%=link%>").then(() => {
												alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
											});
									}
									else {
										temp = prompt("해당 URL을 복사하십시오.", "<%=link%>");
									}
								} catch(e) {
									alert(e)
								}
							};
						</script>
<%
	End If
%>
<%
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                               "
	sql = sql & "   from cf_album_attach                 "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	sql = sql & "  order by attach_num                   "
	rs2.Open Sql, conn, 3, 1

	displayUrl = ConfigAttachedFileURL & "display/album/"

	Do Until rs2.eof
		dsply_file_nm = rs2("dsply_file_nm")

		fileUrl = displayUrl & dsply_file_nm
		filePath = displayUrl & dsply_file_nm

		If arr_image = "" Then
			arr_image = dsply_file_nm
		Else
			arr_image =  arr_image & ":" & dsply_file_nm
		End If
%>
						<img src="<%=fileUrl%>" border="0" style="cursor:hand" /><br /><br />
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
<!--#include virtual="/cafe/com_comment_list_inc.asp"-->
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
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
<%
	uploadUrl = ConfigAttachedFileURL & "album/"
%>
	<!-- 레이어 팝업 -->
	<div class="lypp lypp_sarang lypp_slide">
		<header class="lypp_head">
			<h2 class="h2">슬라이드 뷰</h2>
			<span class="posR">
				<button type="button" class="btn btn_close"><em>닫기</em></button>
			</span>
		</header>
		<div class="adm_cont">
				<div class="">
					<img name="_Ath_Slide" onload="OnImgLoad(); Rsize(this, 600, 450,1)" style="cursor:hand">
				</div>
				<div class="btn_box algC">
					<img src="/cafe/img/btn/pic_bu11.gif" width="42" height="26" border="0" alt="이전 사진" onClick="Prev()" style="cursor:hand" name="btnPrev">
					<img src="/cafe/img/btn/pic_bu12.gif" width="42" height="26" border="0" alt="자동슬라이드" onClick="Play()" style="cursor:hand" name="btnPlay">
					<img src="/cafe/img/btn/pic_bu13.gif" width="42" height="26" alt="중지" border="0" onClick="Stop()" style="cursor:hand" name="btnStop">
					<img src="/cafe/img/btn/pic_bu14.gif" width="42" height="26" border="0" alt="다음사진" onClick="Next()" style="cursor:hand" name="btnNext">
				</div>
		</div>
	</div>
<script>
	function Rsize(img, ww, hh, aL) {
		var tt = imgRsize(img, ww, hh);
		if (img.width > ww || img.height > hh) {

			// 가로나 세로크기가 제한크기보다 크면
			img.width = tt[0];
			// 크기조정
			img.height = tt[1];
			img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

			if (aL) {
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
				img.onclick = function() {
					alert("현재이미지가 원본 이미지입니다.");
				}
		}
	}

	function goPrint() {
		var initBody;
		window.onbeforeprint = function() {
			initBody = document.body.innerHTML;
			document.body.innerHTML =  document.getElementById('print_area').innerHTML;
		};
		window.onafterprint = function() {
			document.body.innerHTML = initBody;
		};
		window.print();
	}

	function goList(sch, gvTarget) {
		if (sch == 'Y') {
			document.search_form.action = "/cafe/cafe_search_list.asp";
		}
		else {
			document.search_form.action = "/cafe/album_list.asp";
		}
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}

	function goReply(gvTarget) {
		document.search_form.action = "/cafe/album_reply.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}

	function goWrite(gvTarget) {
		document.search_form.action = "/cafe/album_write.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}

	function goModify(gvTarget) {
		try{
			document.search_form.action = "/cafe/album_modify.asp";
			document.search_form.target = gvTarget;
			document.search_form.submit();
		} catch(e) {
			alert(e)
		}
	}

	function goDelete() {
		document.search_form.action = "/cafe/com_waste_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}

	function goSuggest() {
		document.search_form.action = "/cafe/com_suggest_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}

	function onCopyUrl() {
		try{
			if (window.clipjobData) {
					window.clipjobData.setData("text", "<%=pageUrl%>")
					alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
			}
			else if (window.navigator.clipjob) {
					window.navigator.clipjob.writeText("<%=pageUrl%>").then(() => {
						alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
					});
			}
			else {
				temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
			}
		} catch(e) {
			alert(e)
		}
	}

	g_fPlayMode = 0;
	g_iimg = 0;
	g_imax = 0;
	g_mimg = 1;
	g_ImageTable = new Array();

	function ChangeImage(fFwd) {
		if (fFwd) {
			if (++g_iimg == g_imax)
				g_iimg = 1;
		}
		else {
			if (g_iimg > 1)
				g_iimg--;
		}//if
		Update();
	}//function ChangeImage

	function Update() {
		document.all._Ath_Slide.src = g_ImageTable[g_iimg][0];
		if (g_iimg == g_mimg)
		{
			g_fPlayMode = !g_fPlayMode;
			btnPrev.disabled = btnPlay.disabled = btnNext.disabled = false;
		}//if
		//document.all._Ath_FileName.innerHTML = g_ImageTable[g_iimg][1];
		//document.all._Ath_Img_X.innerHTML = g_iimg + 1;
		//document.all._Ath_Img_N.innerHTML = g_imax;
	}//function Update

	function Play() {
		if (!g_fPlayMode) g_fPlayMode = !g_fPlayMode;
		if (g_fPlayMode)
		{
			btnPrev.disabled = btnPlay.disabled = btnNext.disabled = true;
			Next();
		}//if
	}//function Play

	function Stop() {
		if (g_fPlayMode) g_fPlayMode = !g_fPlayMode;
		btnPrev.disabled = btnPlay.disabled = btnNext.disabled = false;
	}//function Stop

	function OnImgLoad() {
		if (g_fPlayMode)
		{
			if (g_iimg != g_mimg)
				window.setTimeout("Tick()", g_dwTimeOutSec * 1000);
		}//if
	}//function OnImgLoad

	function Tick() {
		if (g_fPlayMode)
			Next();
	}//function Tick

	function Prev() {
		ChangeImage(false);
	}//function Prev

	function Next() {
		ChangeImage(true);
	}//function Next

	function main() {
		Update();
	}//function main

	sl_list = "<%=arr_image%>";
	sl_arr = sl_list.split(":");
	for (var i = 0; i < sl_arr.length; i++) {
		g_ImageTable[g_mimg++] = new Array("<%=displayUrl%>" + sl_arr[i], "");
	}//for
	g_imax = g_mimg--;

	g_dwTimeOutSec = 3;

	function Rsize(img, ww, hh, aL) {
		var tt = imgRsize(img, ww, hh);
		if (img.width > ww || img.height > hh) {

			// 가로나 세로크기가 제한크기보다 크면
			img.width = tt[0];
			// 크기조정
			img.height = tt[1];
			img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

			if (aL) {
				// 자동링크 on
				img.onclick = function() {
					wT = Math.ceil((screen.width - tt[2])/2.6);
					// 클라이언트 중앙에 이미지위치.
					wL = Math.ceil((screen.height - tt[3])/2.6);
					var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
					var mm = window.open(img.src, "mm");
					var doc = mm.document;
					doc.body.style.margin = 0;
					// 마진제거
					doc.body.style.cursor = "hand";
					doc.title = "원본이미지";
				}
				img.style.cursor = "hand";
			}
		}
		else {
				img.onclick = function() {
					alert("현재이미지가 원본 이미지입니다.");
				}
		}
	}

	function imgRsize(img, rW, rH) {
		var iW = img.width;
		var iH = img.height;
		var g = new Array;
		if (iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
			g[0] = iW;
			g[1] = iH;
		}
		else {
			if (img.width > img.height) { // 원크기 가로가 세로보다 크면
				g[0] = rW;
				g[1] = Math.ceil(img.height * rW / img.width);
			}
			else if (img.width < img.height) { //원크기의 세로가 가로보다 크면
				g[0] = Math.ceil(img.width * rH / img.height);
				g[1] = rH;
			}
			else {
				g[0] = rW;
				g[1] = rH;
			}
			if (g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
				g[0] = rW;
				g[1] = Math.ceil(img.height * rW / img.width);
			}
			if (g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
				g[0] = Math.ceil(img.width * rH / img.height);
				g[1] = rH;
			}
		}

		g[2] = img.width; // 원사이즈 가로
		g[3] = img.height; // 원사이즈 세로

		return g;
	}

	function onSlide() {
		Play();
		lyp('lypp_slide');
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

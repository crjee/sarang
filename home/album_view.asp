<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

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
	<title>경인 홈</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	home_sch  = Request("home_sch")

	self_yn   = Request("self_yn")

	album_seq = Request("album_seq")

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	page_move = Request("page_move")

	If page_move = "prev" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
		sql = sql & "       ,album_seq as prev_seq                                               "
		sql = sql & "   from gi_album                                                            "
		sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
		sql = sql & "    and album_seq > '" & album_seq & "'                                     "
		sql = sql & "  order by group_num asc, step_num desc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			prev_seq = rs("prev_seq")
		End If
		rs.close
		album_seq = prev_seq
	ElseIf page_move = "next" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
		sql = sql & "       ,album_seq as next_seq                                               "
		sql = sql & "   from gi_album                                                            "
		sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
		sql = sql & "    and album_seq < '" & album_seq & "'                                     "
		sql = sql & "  order by group_num desc, step_num asc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			next_seq = rs("next_seq")
		End If
		rs.close
		album_seq = next_seq
	End If
	' Response.write "page_move : " & page_move & "<br>"
	' Response.write "album_seq : " & album_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	prev_seq = ""
	next_seq = ""
	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
	sql = sql & "       ,album_seq as prev_seq                                               "
	sql = sql & "   from gi_album                                                            "
	sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
	sql = sql & "    and album_seq > '" & album_seq & "'                                     "
	sql = sql & "  order by group_num asc, step_num desc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		prev_seq = rs("prev_seq")
	End If
	rs.close

	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "       ,album_seq as next_seq                                               "
	sql = sql & "   from gi_album                                                            "
	sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
	sql = sql & "    and album_seq < '" & album_seq & "'                                     "
	sql = sql & "  order by group_num desc, step_num asc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		next_seq = rs("next_seq")
	End If
	rs.close
	' Response.write "album_seq : " & album_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	sql = ""
	sql = sql & " select ca.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from gi_album ca "
	sql = sql & "   left join cf_member cm on cm.user_id = ca.user_id "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		group_num      = rs("group_num")
		step_num       = rs("step_num")
		level_num      = rs("level_num")
		album_num      = rs("album_num")
		cafe_id        = rs("cafe_id")
		menu_seq       = rs("menu_seq")
		agency         = rs("agency")
		subject        = rs("subject")
		contents       = rs("contents")
		view_cnt       = rs("view_cnt")
		suggest_cnt    = rs("suggest_cnt")
		link           = rs("link")
		top_yn         = rs("top_yn")
		reg_date       = rs("reg_date")
		creid          = rs("creid")
		credt          = rs("credt")
		modid          = rs("modid")
		moddt          = rs("moddt")
		album_seq      = rs("album_seq")
		suggest_info   = rs("suggest_info")
		user_id        = rs("user_id")
		parent_seq     = rs("parent_seq")
		move_album_num = rs("move_album_num")
		parent_del_yn  = rs("parent_del_yn")
		move_menu_seq  = rs("move_menu_seq")
		move_user_id   = rs("move_user_id")
		move_date      = rs("move_date")
		restoreid      = rs("restoreid")
		restoredt      = rs("restoredt")
		comment_cnt    = rs("comment_cnt")
		section_seq    = rs("section_seq")
		pop_yn         = rs("pop_yn")

		tel_no         = rs("tel_no")
	End If
	rs.close
%>
			<div class="container">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="page_move" value="<%=page_move%>">
				<input type="hidden" name="task">

				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="album_seq" value="<%=album_seq%>">
				<input type="hidden" name="com_seq" value="<%=album_seq%>">

				<input type="hidden" name="group_num" value="<%=group_num%>">
				<input type="hidden" name="level_num" value="<%=level_num%>">
				<input type="hidden" name="step_num" value="<%=step_num%>">
				</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<!--#include virtual="/home/home_up_view_btn_inc.asp"-->
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3" id="subject"><%=subject%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>글쓴이</span><strong><a title="<%=tel_no%>"><%=agency%></a></strong></li>
								<li><span>조회</span><strong><%=view_cnt%></strong></li>
								<li><span>추천</span><strong><%=suggest_cnt%></strong></li>
								<li><span>등록일시</span><strong><%=credt%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<!--#include virtual="/include/attach_view_inc.asp"-->
<%
	If link <> "" Then
		link_txt = rmid(link, 40, "..")
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
						<script>
							document.getElementById("linkBtn").onclick = function() {
								try{
									if (window.clipalbumData) {
											window.clipalbumData.setData("text", "<%=link%>")
											alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
									}
									else if (window.navigator.clipalbum) {
											window.navigator.clipalbum.writeText("<%=link%>").then(() => {
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
	displayUrl = ConfigAttachedFileURL & "display/album/"

	sql = ""
	sql = sql & " select *                               "
	sql = sql & "   from gi_album_attach                 "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	sql = sql & "    and atch_file_se_cd = 'IMG'         "
	sql = sql & "  order by attach_num                   "
	rs.Open Sql, conn, 3, 1

	Do Until rs.eof
		dsply_file_nm = rs("dsply_file_nm")

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
		rs.MoveNext
	Loop
	rs.close
	Set rs = Nothing
%>
					</div>
					<div class="bbs_cont">
						<%=contents%>
					</div>
				</div>
<%
	com_seq = album_seq
%>
<!--#include virtual="/home/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
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
	<!-- 레이어 팝업 -->
	<div class="lypp lypp_sarang lypp_move">
		<header class="lypp_head">
			<h2 class="h2">게시물 이동</h2>
			<span class="posR">
				<button type="button" class="btn btn_close"><em>닫기</em></button>
			</span>
		</header>
		<div class="adm_cont">
			<form name="form" method="post"  action="com_move_exec.asp" target="hiddenfrm">
				<input type="hidden" name="com_seq" value="<%=album_seq%>">
				<input type="hidden" name="old_menu_seq" value="<%=menu_seq%>">
				<div class="tb tb_form_1">
					<table class="tb_input">
						<colgroup>
							<col class="w15">
							<col class="auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">게시판 선택</th>
								<td colspan="3">
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                                     "
	sql = sql & "   from cf_menu                               "
	sql = sql & "  where cafe_id = '" & cafe_id & "'           "
	sql = sql & "    and menu_seq <> '" & menu_seq & "'        "
	sql = sql & "    and menu_type = '" & menu_type & "'       "
	sql = sql & "    and write_auth <= '" & cafe_mb_level & "' "
	sql = sql & "  order by menu_name                          "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		okSubmit = "Y"
%>
									<select id="menu_seq" name="menu_seq" class="sel w_auto" required >
<%

		Do Until rs.eof
			menu_seq = rs("menu_seq")
			menu_name = rs("menu_name")
%>
										<option value="<%=menu_seq%>"><%=menu_name%></option>
<%
			rs.MoveNext
		Loop
%>
									</select>
<%
	Else
		okSubmit = "N"
%>
									이동 가능한 곳이 없습니다.
<%
	End If
	rs.close
	Set rs = Nothing
%>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box algC">
<%
	If okSubmit = "Y" Then
%>
					<button type="submit" class="btn btn_c_a btn_n">이동</button>
<%
	End If
%>
					<button type="reset" class="btn btn_c_n btn_n">취소</button>
				</div>
			</form>
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

//	function goWrite() {
//		document.search_form.action = "album_write.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goReply() {
//		document.search_form.action = "album_reply.asp";
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goModify() {
//		document.search_form.action = "album_modify.asp";
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goDelete() {
//		document.search_form.action = "com_waste_exec.asp";
//		//document.search_form.target = "hiddenfrm";
//		document.search_form.submit();
//	}

//	function goMove() {
//		lyp('lypp_move');
//	}

//	function goTopMove() {
//		document.search_form.action = "com_top_exec.asp"
//		//document.search_form.target = "hiddenfrm";
//		document.search_form.submit();
//	}

//	function goSuggest() {
//		document.search_form.action = "com_suggest_exec.asp";
//		//document.search_form.target = "hiddenfrm";
//		document.search_form.submit();
//	}

//	function goPrint() {
//		var initBody;
//		window.onbeforeprint = function() {
//			initBody = document.body.innerHTML;
//			document.body.innerHTML =  document.getElementById('print_area').innerHTML;
//		};
//		window.onafterprint = function() {
//			document.body.innerHTML = initBody;
//		};
//		window.print();
//	}

//	function onCopyUrl() {
//		try{
//			if (window.clipalbumData) {
//					window.clipalbumData.setData("text", "<%=pageUrl%>")
//					alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//			}
//			else if (window.navigator.clipalbum) {
//					window.navigator.clipalbum.writeText("<%=pageUrl%>").then(() => {
//						alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//					});
//			}
//			else {
//				temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
//			}
//		} catch(e) {
//			alert(e)
//		}
//	}

//	function onCopySubject() {
//		try{
//			str = document.getElementById("subject").innerText;
//			if (window.clipalbumData) {
//					window.clipalbumData.setData("text", str)
//					alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//			}
//			else if (window.navigator.clipalbum) {
//					window.navigator.clipalbum.writeText(str).then(() => {
//						alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//					});
//			}
//			else {
//				temp = prompt("해당 제목을 복사하십시오.", str);
//			}
//		} catch(e) {
//			alert(e)
//		}
//	}

//	function goPrev() {
//		document.search_form.page_move.value = "prev"
//		document.search_form.action = "album_view.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goNext() {
//		document.search_form.page_move.value = "next"
//		document.search_form.action = "album_view.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goList(sch) {
//		if (sch == 'Y') {
//			document.search_form.action = "cafe_search_list.asp";
//		}
//		else {
//			document.search_form.action = "album_list.asp";
//		}
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}


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

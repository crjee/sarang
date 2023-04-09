<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<!--#include virtual="/ipin_inc.asp"-->
<%
	uploadUrl = ConfigAttachedFileURL & "album/"

	album_seq = Request("album_seq")

	arr_image = ""

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_album_attach "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	rs.Open Sql, conn, 3, 1

	Do Until rs.eof
		If arr_image = "" Then
			arr_image = rs("file_name")
		Else
			arr_image =  arr_image & ":" & rs("file_name")
		End If

		rs.MoveNext
	Loop
	rs.close
	Set rs = Nothing
%>
<html>
<head>
<title>이미지 슬라이드 뷰어</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body bgcolor="#FFFFFF" text="#000000" topmargin="0" leftmargin="0">
<Script Language="JavaScript1.2">
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
			alert("슬라이드 마지막 이미지 입니다.");
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
		g_ImageTable[g_mimg++] = new Array("<%=uploadUrl%>" + sl_arr[i], "");
	}//for
	g_imax = g_mimg--;

	g_dwTimeOutSec = 3;

	window.onload = Play;

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

</Script>
<table width="640" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td align="center" height="480"><img name="_Ath_Slide" onload="OnImgLoad(); Rsize(this, 600, 450,1)" style="cursor:hand"></td>
	</tr>
	<tr>
		<td bgcolor="BCB7AE" height="5"></td>
	</tr>
	<tr>
		<td style="padding:5pt" align="center">
			<img src="/cafe/skin/img/btn/pic_bu11.gif" width="42" height="26" border="0" alt="이전 사진" onClick="Prev()" style="cursor:hand" name="btnPrev">
			<img src="/cafe/skin/img/btn/pic_bu12.gif" width="42" height="26" border="0" alt="자동슬라이드" onClick="Play()" style="cursor:hand" name="btnPlay">
			<img src="/cafe/skin/img/btn/pic_bu13.gif" width="42" height="26" alt="중지" border="0" onClick="Stop()" style="cursor:hand" name="btnStop">
			<img src="/cafe/skin/img/btn/pic_bu14.gif" width="42" height="26" border="0" alt="다음사진" onClick="Next()" style="cursor:hand" name="btnNext">
			&nbsp;
			<img src="/cafe/skin/img/btn/pic_bu15.gif" width="42" height="26" border="0" alt="창닫기" onClick="window.close()" style="cursor:hand">
		</td>
	</tr>
</table>
</body>
</html>

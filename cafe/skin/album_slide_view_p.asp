<!--#include virtual="/ipin_inc.asp"-->
<!--#include virtual="/include/config_inc.asp"-->
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
<title>�̹��� �����̵� ���</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
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
			alert("�����̵� ������ �̹��� �Դϴ�.");
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

			// ���γ� ����ũ�Ⱑ ����ũ�⺸�� ũ��
			img.width = tt[0];
			// ũ������
			img.height = tt[1];
			img.alt = "Ŭ���Ͻø� �����̹����� ���Ǽ��ֽ��ϴ�.";

			if (aL) {
				// �ڵ���ũ on
				img.onclick = function() {
					wT = Math.ceil((screen.width - tt[2])/2.6);
					// Ŭ���̾�Ʈ �߾ӿ� �̹�����ġ.
					wL = Math.ceil((screen.height - tt[3])/2.6);
					var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
					var mm = window.open(img.src, "mm");
					var doc = mm.document;
					doc.body.style.margin = 0;
					// ��������
					doc.body.style.cursor = "hand";
					doc.title = "�����̹���";
				}
				img.style.cursor = "hand";
			}
		}
		else {
				img.onclick = function() {
					alert("�����̹����� ���� �̹����Դϴ�.");
				}
		}
	}

	function imgRsize(img, rW, rH) {
		var iW = img.width;
		var iH = img.height;
		var g = new Array;
		if (iW < rW && iH < rH) { // ���μ��ΰ� ����� ������ ���� ���
			g[0] = iW;
			g[1] = iH;
		}
		else {
			if (img.width > img.height) { // ��ũ�� ���ΰ� ���κ��� ũ��
				g[0] = rW;
				g[1] = Math.ceil(img.height * rW / img.width);
			}
			else if (img.width < img.height) { //��ũ���� ���ΰ� ���κ��� ũ��
				g[0] = Math.ceil(img.width * rH / img.height);
				g[1] = rH;
			}
			else {
				g[0] = rW;
				g[1] = rH;
			}
			if (g[0] > rW) { // ������ ���ΰ��� ��� ���κ��� ũ��
				g[0] = rW;
				g[1] = Math.ceil(img.height * rW / img.width);
			}
			if (g[1] > rH) { // ������ ���ΰ��� ��� ���ΰ����κ��� ũ��
				g[0] = Math.ceil(img.width * rH / img.height);
				g[1] = rH;
			}
		}

		g[2] = img.width; // �������� ����
		g[3] = img.height; // �������� ����

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
			<img src="/cafe/skin/img/btn/pic_bu11.gif" width="42" height="26" border="0" alt="���� ����" onClick="Prev()" style="cursor:hand" name="btnPrev">
			<img src="/cafe/skin/img/btn/pic_bu12.gif" width="42" height="26" border="0" alt="�ڵ������̵�" onClick="Play()" style="cursor:hand" name="btnPlay">
			<img src="/cafe/skin/img/btn/pic_bu13.gif" width="42" height="26" alt="����" border="0" onClick="Stop()" style="cursor:hand" name="btnStop">
			<img src="/cafe/skin/img/btn/pic_bu14.gif" width="42" height="26" border="0" alt="��������" onClick="Next()" style="cursor:hand" name="btnNext">
			&nbsp;
			<img src="/cafe/skin/img/btn/pic_bu15.gif" width="42" height="26" border="0" alt="â�ݱ�" onClick="window.close()" style="cursor:hand">
		</td>
	</tr>
</table>
</body>
</html>

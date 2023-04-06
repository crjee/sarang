<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&album_seq=" & Request("album_seq")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>��Ų-1 : GI</title>
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
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	Set rs = Server.CreateObject ("ADODB.Recordset")

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
								var doc = mm.document;
								try{
									doc.body.style.margin = 0;
									// ��������
									doc.body.style.cursor = "hand";
									doc.title = "�����̹���";
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

				function goPrint() {
					var initBody;
					window.onbeforeprint = function() {
						initBody = document.body.innerHTML;
						document.body.innerHTML =  document.getElementById('CenterContents').innerHTML;
					};
					window.onafterprint = function() {
						document.body.innerHTML = initBody;
					};
					window.print();
				}

				function goList() {
					document.search_form.action = "/cafe/skin/album_list.asp"
					document.search_form.submit();
				}

				function goReply() {
					document.search_form.action = "/cafe/skin/album_reply.asp"
					document.search_form.submit();
				}

				function goModify() {
					document.search_form.action = "/cafe/skin/album_modify.asp"
					document.search_form.submit();
				}

				function goDelete() {
					document.search_form.action = "/cafe/skin/com_waste_exec.asp"
					document.search_form.submit();
				}

				function goSuggest() {
					document.search_form.action = "/cafe/skin/com_suggest_exec.asp"
					document.search_form.submit();
				}

				function goSlide() {
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}

				function copyUrl() {
					try{
						if (window.clipboardData) {
								window.clipboardData.setData("Text", "<%=pageUrl%>")
								alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
						}
						else if (window.navigator.clipboard) {
								window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
									alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
								});
						}
						else {
							temp = prompt("�ش� ���ּҸ� �����Ͻʽÿ�.", "<%=pageUrl%>");
						}
					} catch(e) {
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
					<h2 class="h2"><%=menu_name%> ���뺸��</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goModify()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">����</button>
<%
		End If
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goSuggest()">��õ</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goPrint()">������</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goSlide()">�����̵�</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
<%
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="copyUrl()">���ּҺ���</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goList()">���</button>
				</div>
				<div id="print_area"><!-- ����Ʈ���� �߰� crjee -->
				<div class="view_head">
					<h3 class="h3" id="subject"><%=rs("subject")%></h3>
					<div class="wrt_info_box">
						<ul>
							<li><span>�ۼ���</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
							<li><span>��ȸ</span><strong><%=rs("view_cnt")%></strong></li>
							<li><span>��õ</span><strong><%=rs("suggest_cnt")%></strong></li>
							<li><span>����Ͻ�</span><strong><%=rs("credt")%></strong></li>
						</ul>
					</div>
				</div>
				<div class="wrt_file_box"><!-- ÷�����Ͽ��� �߰� crjee -->
<%
	link = rs("link")
	link_txt = rmid(link, 40, "..")
	
	If link_txt <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/skin/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<script>
	document.getElementById("linkBtn").onclick = function() {
		try{
			if (window.clipboardData) {
					window.clipboardData.setData("Text", "<%=link%>")
					alert("�ش� URL�� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
			}
			else if (window.navigator.clipboard) {
					window.navigator.clipboard.writeText("<%=link%>").then(() => {
						alert("�ش� URL�� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
					});
			}
			else {
				temp = prompt("�ش� URL�� �����Ͻʽÿ�.", "<%=link%>");
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


<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&board_seq=" & Request("board_seq")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="sub">
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	all_yn    = Request("all_yn")

	board_seq = Request("board_seq")

	Call setViewCnt(menu_type, board_seq)

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cb.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_board cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where board_seq = '" & board_seq & "' "
	rs.Open Sql, conn, 3, 1
%>
			<script type="text/javascript">
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

				function goList() {
					document.search_form.action = "/home/board_list.asp"
					document.search_form.submit();
				}
				function goReply() {
					document.search_form.action = "/home/board_reply.asp"
					document.search_form.submit();
				}
				function goModify() {
					document.search_form.action = "/home/board_modify.asp"
					document.search_form.submit();
				}
				function goDelete() {
					document.search_form.action = "/home/com_waste_exec.asp"
					document.search_form.submit();
				}
				function goNotice() {
					document.search_form.action = "/home/com_top_exec.asp"
					document.search_form.submit();
				}
				function goSuggest() {
					document.search_form.action = "/home/com_suggest_exec.asp"
					document.search_form.submit();
				}
				function goMove() {
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}
				function copySubject() {
					try{
						str = document.getElementById("subject").innerText;
						if (window.clipboardData) {
								window.clipboardData.setData("Text", str)
								alert("�ش� ������ ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
						}
						else if (window.navigator.clipboard) {
								window.navigator.clipboard.writeText(str).Then(() => {
									alert("�ش� ������ ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
								});
						}
						else {
							temp = prompt("�ش� ������ �����Ͻʽÿ�.", str);
						}
					} catch(e) {
						alert(e)
					}
				}
				function copyUrl() {
					try{
						if (window.clipboardData) {
								window.clipboardData.setData("Text", "<%=pageUrl%>")
								alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
						}
						else if (window.navigator.clipboard) {
								window.navigator.clipboard.writeText("<%=pageUrl%>").Then(() => {
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
			<input type="hidden" name="open_url" value="/home/com_move_edit_p.asp?com_seq=<%=board_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="com_move">
			<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
			</form>
			<form name="search_form" method="post">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="all_yn" value="<%=all_yn%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="task">
			<input type="hidden" name="board_seq" value="<%=board_seq%>">
			<input type="hidden" name="com_seq" value="<%=board_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> ���뺸��</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If group_num = "" And reply_auth <= cafe_mb_level Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goReply()">���</button>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goModify()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">����</button>
<%
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goMove()">�̵�</button>
<%
		End If
	End If
%>
<%
	If cafe_mb_level > 6 Then
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goNotice()"><%=if3(rs("top_yn")="Y","��������","��������")%></button>
<%
		End If
	End If
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goSuggest()">��õ</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goPrint()">�μ�</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="copyUrl()">���ּҺ���</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="copySubject()">���񺹻�</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="location.href='/home/board_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
<%
	End If
%>
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
	uploadUrl = ConfigAttachedFileURL & menu_type & "/"
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_board_attach "
	sql = sql & "  where board_seq = '" & board_seq & "' "
	rs2.Open Sql, conn, 3, 1
	i = 0
	If Not rs2.eof Then
		Do Until rs2.eof
			If (fso.FileExists(uploadFolder & rs2("file_name"))) Then
				fileExt = LCase(Mid(rs2("file_name"), InStrRev(rs2("file_name"), ".") + 1))
				If fileExt = "pdf" Then
%>
					<%If i > 0 Then%><br><%End If%>
					<a href="<%=uploadUrl & rs2("file_name")%>" class="file"><img src="/home/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
				Else
%>
					<%If i > 0 Then%><br><%End If%>
					<a href="/download_exec.asp?menu_type=<%=menu_type%>&file_name=<%=rs2("file_name")%>" class="file"><img src="/home/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
				End If
			Else
%>
					<%If i > 0 Then%><br><%End If%>
					<a href="javascript:alert('������ �������� �ʽ��ϴ�,')" class="file"><img src="/home/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
			End If

			i = i + 1
			rs2.MoveNext
		Loop
	End If
	rs2.close
	Set rs2 = Nothing
	Set fso = Nothing
%>
<%
	link = rs("link")
	link_txt = rmid(link, 40, "..")

	If link <> "" Then
%>
					<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/home/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<script>
	document.getElementById("linkBtn").onclick = function() {
		try{
			if (window.clipboardData) {
					window.clipboardData.setData("Text", "<%=link%>")
					alert("�ش� URL�� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
			}
			else if (window.navigator.clipboard) {
					window.navigator.clipboard.writeText("<%=link%>").Then(() => {
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
				</div>
				<div class="bbs_cont">
					<%=rs("contents")%>
				</div>
				</div>
<%
	rs.close
	Set rs = nothing
%>
<%
	com_seq = board_seq
%>
<!--#include virtual="/home/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>

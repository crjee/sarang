<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)
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
		msggo "�������� ����� �ƴմϴ�.",""
	Else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	sale_seq = Request("sale_seq")

	Call setViewCnt(menu_type, sale_seq)

	sql = ""
	sql = sql & " select cs.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_waste_sale cs "
	sql = sql & "   left join cf_member cm on cm.user_id = cs.user_id "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs.Open Sql, conn, 3, 1

	top_yn   = rs("top_yn")
	subject  = rs("subject")
	link     = rs("link")
	location = rs("location")
	bargain  = rs("bargain")
	area     = rs("area")
	floor    = rs("floor")
	compose  = rs("compose")
	price    = rs("price")
	live_in  = rs("live_in")
	parking  = rs("parking")
	traffic  = rs("traffic")
	purpose  = rs("purpose")
	contents = rs("contents")
	tel_no   = rs("tel_no")
	fax_no   = rs("fax_no")
	view_cnt = rs("view_cnt")
	credt = rs("credt")
	agency   = rs("agency")
%>
			<script type="text/javascript">
				function goList(){
					document.search_form.action = "/cafe/skin/waste_sale_list.asp"
					document.search_form.submit();
				}
				function goRestore(){
					document.search_form.action = "/cafe/skin/waste_com_exec.asp"
					document.search_form.task.value = "restore";
					document.search_form.submit();
				}
				function goDelete(){
					document.search_form.action = "/cafe/skin/waste_com_exec.asp"
					document.search_form.task.value = "delete";
					document.search_form.submit();
				}
			</script>
			<form name="search_form" method="post">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="task">
			<input type="hidden" name="sale_seq" value="<%=sale_seq%>">
			<input type="hidden" name="com_seq" value="<%=sale_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">������ <%=menu_name%> ���뺸��</font></h2>
				</div>
				<div class="btn_box view_btn">
					<button class="btn btn_c_n btn_n" type="button" onclick="goRestore()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goList()">���</button>
				</div>
				<div class="view_head">
					<h3 class="h3" id="subject"><%=subject%></h3>
					<div class="wrt_info_box">
						<ul>
							<li><span>�ۼ���</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
							<li><span>��ȸ</span><strong><%=rs("view_cnt")%></strong></li>
							<li><span>����Ͻ�</span><strong><%=rs("credt")%></strong></li>
						</ul>
					</div>
				</div>
				<div class="wrt_file_box"><!-- ÷�����Ͽ��� �߰� crjee -->
<%
	link_txt = rmid(link, 40, "..")
	
	If link_txt <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/skin/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<script>
	document.getElementById("linkBtn").onclick = function(){
		try{
			if (window.clipboardData){
					window.clipboardData.setData("Text", "<%=link%>")
					alert("�ش� URL�� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
			}
			Else if (window.navigator.clipboard){
					window.navigator.clipboard.writeText("<%=link%>").Then(() => {
						alert("�ش� URL�� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
					});
			}
			Else{
				temp = prompt("�ش� URL�� �����Ͻʽÿ�.", "<%=link%>");
			}
		}catch(e){
			alert(e)
		}
	};
</script>
<%
	End If
%>
				</div>
				<div class="view_cont">
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">������</th>
									<td><%=location%></td>
									<th scope="row">������</th>
									<td><%=bargain%></td>
								</tr>
								<tr>
									<th scope="row">����</th>
									<td><%=area%></td>
									<th scope="row">�ش���/����</th>
									<td><%=floor%></td>
								</tr>
								<tr>
									<th scope="row">�氳��/��Ǽ�</th>
									<td><%=compose%></td>
									<th scope="row">�ݾ�</th>
									<td><%=price%></td>
								</tr>
								<tr>
									<th scope="row">���ְ�����</th>
									<td><%=live_in%></td>
									<th scope="row">��������</th>
									<td><%=parking%></td>
								</tr>
								<tr>
									<th scope="row">���߱���</th>
									<td><%=traffic%></td>
									<th scope="row">�뵵</th>
									<td><%=purpose%></td>
								</tr>
								<tr>
									<th scope="row">����ó</th>
									<td><%=tel_no%></td>
									<th scope="row">�ѽ�</th>
									<td><%=fax_no%></td>
								</tr>
<%
	uploadUrl = ConfigAttachedFileURL & menu_type & "/"
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_waste_sale_attach "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs2.Open Sql, conn, 3, 1

	i = 0
	If Not rs2.eof Then
%>
								<tr>
									<th scope="row">÷������</th>
									<td colspan="3" style="text-align:left">
<%
		Do Until rs2.eof
			If (fso.FileExists(uploadFolder & rs2("file_name"))) Then
				fileExt = LCase(Mid(rs2("file_name"), InStrRev(rs2("file_name"), ".") + 1))
				If fileExt = "pdf" Then
%>
										<%If i > 0 Then%><br><%End If%>
										<a href="<%=uploadUrl & rs2("file_name")%>" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
				Else
%>
										<%If i > 0 Then%><br><%End If%>
										<a href="/download_exec.asp?menu_type=<%=menu_type%>&file_name=<%=rs2("file_name")%>" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
				End If
			Else
%>
										<%If i > 0 Then%><br><%End If%>
										<a href="javascript:alert('������ �������� �ʽ��ϴ�,')" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
			End If

			i = i + 1
			rs2.MoveNext
		Loop
%>
									</td>
								</tr>
<%
	End If
	rs2.close
	Set rs2 = Nothing
	Set fso = Nothing
%>
						</tbody>
						</table>
					</div>
				</div>
				<div class="bbs_cont">
					<%=rs("contents")%>
				</div>
<%
	com_seq = sale_seq
%>
<!--#include virtual="/cafe/skin/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>
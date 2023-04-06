<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	menu_type = "notice"
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
	all_yn    = Request("all_yn")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	notice_seq = Request("notice_seq")

	Call setViewCnt(menu_type, notice_seq)

	sql = ""
	sql = sql & " select cb.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_waste_notice cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where notice_seq = '" & notice_seq & "' "
	rs.Open Sql, conn, 3, 1
%>
			<script type="text/javascript">
				function goList() {
					document.search_form.action = "/cafe/skin/waste_notice_list.asp"
					document.search_form.submit();
				}
				function goRestore() {
					document.search_form.action = "/cafe/skin/waste_com_exec.asp"
					document.search_form.task.value = "restore";
					document.search_form.submit();
				}
				function goDelete() {
					document.search_form.action = "/cafe/skin/waste_com_exec.asp"
					document.search_form.task.value = "delete";
					document.search_form.submit();
				}
			</script>
			<form name="search_form" method="post">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="all_yn" value="<%=all_yn%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="task">
			<input type="hidden" name="notice_seq" value="<%=notice_seq%>">
			<input type="hidden" name="com_seq" value="<%=notice_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">������ ���γ�Ʈ���� ��ü���� ���뺸��</font></h2>
				</div>
				<div class="btn_box view_btn">
					<button class="btn btn_c_n btn_n" type="button" onclick="goRestore()">����</button>
					<button class="btn btn_c_n btn_n" type="button" onclick="goDelete()">����</button>
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
	sql = sql & "   from cf_notice_attach "
	sql = sql & "  where notice_seq = '" & notice_seq & "' "
	rs2.Open Sql, conn, 3, 1
	i = 0
	If Not rs2.eof Then
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
					<p class="file"><a href="<%=link%>" target="_blink"><%=link_txt%></a>&nbsp;<img src="/cafe/skin/img/inc/copy.png" style="cursor:hand" onclick="window.clipnoticeData.setData('Text','<%=link%>');alert('�ش� �� �ּҰ� ����Ǿ����ϴ�.\n\n Ű���忡 Ctrl + V ������ �̿��Ͻʽÿ�. ')"/></p>
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
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


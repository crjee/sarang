<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)
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
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) credt_txt "
	sql = sql & "   from cf_album ca "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
	sql = sql & "    and level_num = 0 "
	sql = sql & kword
	sql = sql & "  order by group_num desc,step_num asc "
	rs.Open sql, conn, 3, 1

	rs.PageSize = PageSize
	RecordCount = 0 ' �ڷᰡ ������
	If Not rs.EOF Then
		RecordCount = rs.recordcount
	End If

	' ��ü ������ �� ���
	If RecordCount/PageSize = Int(RecordCount/PageSize) then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
		rs.AbsolutePage = page
		PageNum = rs.PageCount
	End If
%>
			<script>
				function MovePage(page) {
					var f = document.search_form;
					f.page.value = page;
					f.action = "album_list.asp"
					f.submit();
				}

				function goView(album_seq) {
					var f = document.search_form;
					f.album_seq.value = album_seq;
					f.action = "album_view.asp"
					f.submit();
				}

				function goSearch() {
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}
				function Rsize(img, ww, hh, aL) {
					var tt = imgRsize(img, ww, hh);
					if (img.width > ww || img.height > hh) {

						// ���γ� ����ũ�Ⱑ ����ũ�⺸�� ũ��
						img.width = tt[0];
						// ũ������
						img.height = tt[1];

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
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="">
					<div class="search_box clearBoth">
						<div class="floatL">
							�� <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>���� �Խù��� �ֽ��ϴ�.
						</div>
						<div class="floatR">
							<form name="search_form" id="search_form" method="post">
							<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
							<input type="hidden" name="page" value="<%=page%>">
							<input type="hidden" name="album_seq">
<%
	If cafe_ad_level = 10 Then
%>
							<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/waste_album_list.asp?menu_seq=<%=menu_seq%>'">������</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' �۾��� ����
%>
							<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
<%
	End If
%>
							<select id="sch_type" name="sch_type" class="sel w100p">
								<option value="all">��ü</option>
								<option value="cb.subject" <%=if3(sch_type="cb.subject","selected","")%>>����</option>
								<option value="cb.agency" <%=if3(sch_type="cb.agency","selected","")%>>�۾���</option>
								<option value="cb.contents" <%=if3(sch_type="cb.contents","selected","")%>>����</option>
							</select>
							<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w300p">
							<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">�˻�</button>
							<select id="pagesize" name="pagesize" class="sel w100p" onchange="goSearch()">
								<option value=""></option>
								<option value="20" <%=if3(pagesize="20","selected","")%>>20</option>
								<option value="30" <%=if3(pagesize="30","selected","")%>>30</option>
								<option value="40" <%=if3(pagesize="40","selected","")%>>40</option>
								<option value="50" <%=if3(pagesize="50","selected","")%>>50</option>
								<option value="100" <%=if3(pagesize="100","selected","")%>>100</option>
							</select>
							</form>
						</div>
					</div>
					<div class="tb">
						<div class="gallery gallery_t_1">
							<div class="gallery_inner_box">
<%
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	i = 1
	j = 0
	line_item = 4
	If Not rs.EOF Then
		Do Until rs.EOF Or i > rs.PageSize
			album_seq = rs("album_seq")
			subject   = rs("subject")
			album_num = rs("album_num")
			view_cnt  = rs("view_cnt")
			credt     = rs("credt")
			agency    = rs("agency")
			thumbnail   = rs("thumbnail")
			comment_cnt = rs("comment_cnt")
%>
								<div class="c_wrap">
<%
			uploadUrl = ConfigAttachedFileURL & "album/"

			sql = ""
			sql = sql & " select top 1 * "
			sql = sql & "   from cf_album_attach "
			sql = sql & "  where album_seq = '" & album_seq & "' "
			sql = sql & "  order by album_seq "
			rs2.Open Sql, conn, 3, 1

			If Not rs2.EOF Then
%>
									<span class="photos"><a href="javascript: goView('<%=album_seq%>')"><img src="<%=uploadUrl & rs2("file_name")%>" border="0" /></a></span>
<%
			Else
%>
									<span class="photos"></span>
<%
			End If
			rs2.close
%>
									<a href="javascript: goView('<%=album_seq%>')"><span class="text"><%=subject%>(<%=comment_cnt%>)</span></a>
<%
			If CDate(DateAdd("d", 2, credt_txt)) >= Date Then
%>
						<img src="/cafe/skin/img/btn/new.png" />
<%
			End if
%>
									<span class="posr">��ȸ <%=view_cnt%> �� <%=credt_txt%></span>
									<span class="posr"><%=agency%></span>
								</div>
<%
			i = i + 1
			rs.MoveNext
		Loop
	End if
	rs.close
	Set rs = nothing

	Set fso = nothing
%>
							</div>
						</div>
					</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
<%
	If write_auth <= cafe_mb_level Then ' �۾��� ����
%>
					<div class="btn_box algR">
						<button class="btn btn_c_a btn_n" type="button" onclick="location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">�۾���</button>
					</div>
<%
	End If
%>
				</div>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


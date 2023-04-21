<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkManager(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
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
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
<%
	End IF
%>
			<div class="container">
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "" Then
			kword = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) credt_txt "
	sql = sql & "       ,(select count(comment_seq) from cf_waste_album_comment where album_seq = ca.album_seq) comment_cnt"
	sql = sql & "   from cf_waste_album ca "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
	sql = sql & "    and level_num = 0 "
	sql = sql & kword
	sql = sql & "  order by group_num desc,step_num asc "
	rs.Open Sql, conn, 3, 1
	rs.PageSize = PageSize
	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs.recordcount
	End If

	' 전체 페이지 수 얻기
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
				function MovePage(page, gvTarget) {
					var f = document.search_form;
					f.page.value = page;
					f.action = "waste_album_list.asp";
					f.target = gvTarget;
					f.submit();
				}

				function goView(album_seq, gvTarget) {
					var f = document.search_form;
					f.album_seq.value = album_seq;
					f.action = "waste_album_view.asp";
					f.target = gvTarget;
					f.submit();
				}

				function goSearch(gvTarget) {
					var f = document.search_form;
					f.page.value = 1;
					f.target = gvTarget;
					f.submit();

				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">휴지통 <%=menu_name%></font></h2>
				</div>
				<div class="">
					<div class="search_box clearBoth">
						<div class="floatL">
							총 <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>건의 게시물이 있습니다.
						</div>
						<div class="floatR">
							<form name="search_form" id="search_form" method="post">
							<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
							<input type="hidden" name="page" value="<%=page%>">
							<input type="hidden" name="album_seq">
							<select id="sch_type" name="sch_type" class="sel w_auto">
								<option value="">전체</option>
								<option value="cb.subject" <%=if3(sch_type="cb.subject","selected","")%>>제목</option>
								<option value="cb.agency" <%=if3(sch_type="cb.agency","selected","")%>>글쓴이</option>
								<option value="cb.contents" <%=if3(sch_type="cb.contents","selected","")%>>내용</option>
							</select>
							<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w150p">
							<button type="button" class="btn btn_c_a btn_s" onclick="goSearch('<%=session("ctTarget")%>')">검색</button>
							<select id="pagesize" name="pagesize" class="sel w50p" onchange="goSearch('<%=session("ctTarget")%>')">
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
			comment_cnt = rs("comment_cnt")
%>
								<div class="c_wrap">
<%
			uploadUrl = ConfigAttachedFileURL & "album/"

			sql = ""
			sql = sql & " select top 1 * "
			sql = sql & "   from cf_waste_album_attach "
			sql = sql & "  where album_seq = '" & album_seq & "' "
			sql = sql & "  order by album_seq "
			rs2.Open Sql, conn, 3, 1

			If Not rs2.EOF Then
%>
									<span class="photos"><a href="javascript: goView('<%=album_seq%>', '<%=session("ctTarget")%>')"><img src="<%=uploadUrl & rs2("file_name")%>" border="0" /></a></span>
<%
			Else
%>
									<span class="photos"></span>
<%
			End If
			rs2.close
%>
									<a href="javascript: goView('<%=album_seq%>', '<%=session("ctTarget")%>')"><span class="text"><%=subject%>(<%=comment_cnt%>)</span></a>
<%
			If CDate(DateAdd("d", 2, credt_txt)) >= Date Then
%>
						<img src="/cafe/skin/img/btn/new.png" />
<%
			End if
%>
									<span class="posr">조회 <%=view_cnt%> ㅣ <%=credt_txt%></span>
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
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
					<div class="btn_box algR">
						<button type="button" class="btn btn_c_a btn_n" onclick="<%=session("ctHref")%>location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
					</div>
<%
	End If
%>
				</div>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
<%
	End IF
%>
</body>
</html>


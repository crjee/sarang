<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	read_auth = getonevalue("read_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")

	If toInt(read_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('읽기 권한이없습니다');history.back();</script>"
		Response.end
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
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
	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	else
		menu_type  = rs("menu_type")
		menu_name  = rs("menu_name")
		editor_yn  = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth  = rs("read_auth")
	End If
	rs.close

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

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) credt_txt "
	sql = sql & "   from cf_album ca "
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
				function MovePage(page){
					var f = document.search_form;
					f.page.value = page;
					f.action = "album_list.asp"
					f.submit();
				}

				function goView(album_seq){
					var f = document.search_form;
					f.album_seq.value = album_seq;
					f.action = "album_view.asp"
					f.submit();
				}

				function goSearch(){
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}
				function Rsize(img, ww, hh, aL) {
					var tt = imgRsize(img, ww, hh);
					if (img.width > ww || img.height > hh) {

						// 가로나 세로크기가 제한크기보다 크면
						img.width = tt[0];
						// 크기조정
						img.height = tt[1];

					}
				}

				function imgRsize(img, rW, rH){
					var iW = img.width;
					var iH = img.height;
					var g = new Array;
					if(iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
						g[0] = iW;
						g[1] = iH;
					}
					else {
						if(img.width > img.height) { // 원크기 가로가 세로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						else if(img.width < img.height) { //원크기의 세로가 가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
						else {
							g[0] = rW;
							g[1] = rH;
						}
						if(g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						if(g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
					}

					g[2] = img.width; // 원사이즈 가로
					g[3] = img.height; // 원사이즈 세로

					return g;
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
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
<%
	If cafe_ad_level = 10 Then
%>
							<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/waste_album_list.asp?menu_seq=<%=menu_seq%>'">휴지통</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
							<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
							<select id="sch_type" name="sch_type" class="sel w100p">
								<option value="all">전체</option>
								<option value="cb.subject" <%=if3(sch_type="cb.subject","selected","")%>>제목</option>
								<option value="cb.agency" <%=if3(sch_type="cb.agency","selected","")%>>글쓴이</option>
								<option value="cb.contents" <%=if3(sch_type="cb.contents","selected","")%>>내용</option>
							</select>
							<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w300p">
							<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">검색</button>
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
						<button class="btn btn_c_a btn_n" type="button" onclick="location.href='/cafe/skin/album_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
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


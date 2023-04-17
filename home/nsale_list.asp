<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
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
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "" Then
			kword = " and (subject like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(nsale_seq) cnt          "
	sql = sql & "   from cf_nsale                      "
	sql = sql & "  where cafe_id = '" & cafe_id & "'   "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
	sql = sql & kword
	rs.Open sql, conn, 3, 1
	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select convert(varchar(10), credt, 120) as credt_txt                               "
	sql = sql & "       ,*                                                                           "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "               ,*                                                                   "
	sql = sql & "           from cf_nsale                                                            "
	sql = sql & "          where cafe_id = '" & cafe_id & "'                                         "
	sql = sql & "            and menu_seq = '" & menu_seq & "'                                       "
	sql = sql & kword
	sql = sql & "        ) a                                                                         "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & "          "
	sql = sql & "  order by group_num desc, step_num asc                                             "
	rs.Open sql, conn, 3, 1

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) Then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
	End If
%>
		<main id="main" class="main">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="">
					<div class="search_box algR">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="nsale_seq">
<%
	If cafe_ad_level = 10 Then
%>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/home/nsale_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
						<select id="sch_type" name="sch_type" class="sel w_auto">
							<option value="">전체</option>
							<option value="cb.subject" <%=if3(sch_type="subject","selected","")%>>제목</option>
							<option value="cb.contents" <%=if3(sch_type="contents","selected","")%>>내용</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w150p">
						<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">검색</button>
						</form>
					</div>
					<div class="tb">
						<div class="gallery gallery_t_1">
							<div class="gallery_inner_box">
<%
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	i = 1
	If Not rs.EOF Then
		Do Until rs.EOF Or i > rs.PageSize
			nsale_seq   = rs("nsale_seq")
			subject     = rs("subject")
			view_cnt    = rs("view_cnt")
			agency      = rs("agency")
			comment_cnt = rs("comment_cnt")
			credt_txt   = rs("credt_txt")

			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End if
%>
								<div class="c_wrap">
<%
			uploadUrl = ConfigAttachedFileURL & "nsale/"

			sql = ""
			sql = sql & " select top 1 * "
			sql = sql & "   from cf_nsale_attach "
			sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
			sql = sql & "  order by nsale_seq "
			rs2.Open Sql, conn, 3, 1

			If Not rs2.EOF Then
%>
									<span class="photos"><a href="javascript: goView('<%=nsale_seq%>')"><img src="<%=uploadUrl & rs2("file_name")%>" border="0" /></a></span>
<%
			Else
%>
									<span class="photos"></span>
<%
			End If
			rs2.close
%>
									<a href="javascript: goView('<%=nsale_seq%>')"><span class="text"><%=subject%>(<%=comment_cnt%>)
<%
			If CDate(DateAdd("d", 2, credt_txt)) >= Date Then
%>
										<img src="/cafe/skin/img/btn/new.png" />
<%
			End if
%>
									</span></a>
									<span class="posr"><span class="text">조회 <%=view_cnt%> ㅣ <%=credt_txt%></span></span>
									<span class="posr"><span class="text"><%=agency%></span></span>
								</div>
<%
			i = i + 1
			rs.MoveNext
		Loop
	Else
%>
								<div class="c_wrap">
									등록된 글이 없습니다.
								</div>
<%
	End If
	rs.close
	Set rs = nothing

	Set fso = nothing
%>
							</div>
						</div>
					</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
				</div>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>
<script>
	function MovePage(page) {
		var f = document.search_form;
		f.page.value = page;
		f.action = "nsale_list.asp"
		f.submit();
	}

	function goView(nsale_seq, no) {
		try{
			var f = document.search_form;
			f.nsale_seq.value = nsale_seq;
			if (no == 0) {
			f.notice_seq.value = nsale_seq;
			f.action = "notice_view.asp"
			}
			else {
			f.action = "nsale_view.asp"
			}
			f.submit()
		} catch(e) {
			alert(e)
		}
	}

	function goSearch() {
		var f = document.search_form;
		f.page.value = 1;
		f.submit();
	}
</script>

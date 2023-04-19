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
	section_seq = Request("section_seq")
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	If sch_word <> "" Then
		If sch_type = "" Then
			kword = " and (subject like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(story_seq) cnt "
	sql = sql & "   from cf_story cb "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
	If section_seq <> "" Then
	sql = sql & "    and section_seq = '" & section_seq & "' "
	End If
	sql = sql & kword
	rs.Open sql, conn, 3, 1

	RecordCount = 0 ' 자료가 없을때
	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select convert(varchar(10), credt, 120) as credt_txt"
	sql = sql & "       ,comment_cnt   "
	sql = sql & "       ,subject       "
	sql = sql & "       ,parent_del_yn "
	sql = sql & "       ,level_num     "
	sql = sql & "       ,story_num     "
	sql = sql & "       ,story_seq     "
	sql = sql & "       ,agency        "
	sql = sql & "       ,view_cnt      "
	sql = sql & "       ,suggest_cnt   "
	sql = sql & "       ,credt         "
	sql = sql & "       ,group_num     "
	sql = sql & "       ,step_num      "
	sql = sql & "       ,user_id       "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "               ,comment_cnt   "
	sql = sql & "               ,subject       "
	sql = sql & "               ,parent_del_yn "
	sql = sql & "               ,level_num     "
	sql = sql & "               ,story_num     "
	sql = sql & "               ,story_seq     "
	sql = sql & "               ,agency        "
	sql = sql & "               ,view_cnt      "
	sql = sql & "               ,suggest_cnt   "
	sql = sql & "               ,credt      "
	sql = sql & "               ,group_num     "
	sql = sql & "               ,step_num      "
	sql = sql & "               ,user_id       "
	sql = sql & "           from cf_story cb"
	sql = sql & "          where cafe_id = '" & cafe_id & "' "
	sql = sql & "            and menu_seq = '" & menu_seq & "' "
	If section_seq <> "" Then
	sql = sql & "            and section_seq = '" & section_seq & "' "
	End If
	sql = sql & kword
	sql = sql & "        ) a "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & " "
	sql = sql & "  order by group_num desc, step_num asc "
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
						<input type="hidden" name="section_seq" value="<%=section_seq%>">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="story_seq">
						<input type="hidden" name="notice_seq">
<%
	If cafe_ad_level = 10 Then
%>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="location.href='story_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
						<select id="sch_type" name="sch_type" class="sel w_auto">
							<option value="">전체</option>
							<option value="subject" <%=if3(sch_type="subject","selected","")%>>제목</option>
							<option value="agency" <%=if3(sch_type="agency","selected","")%>>글쓴이</option>
							<option value="contents" <%=if3(sch_type="contents","selected","")%>>내용</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w150p">
						<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">검색</button>
						</form>
					</div>
<!--#include virtual="/home/home_tab_inc.asp"-->
					<div class="tb">
						<table>
							<colgroup>
								<col class="w7" />
								<col class="w_auto" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">작성자</th>
									<th scope="col">작성일</th>
									<th scope="col">조회</th>
								</tr>
							</thead>
							<tbody>
<%
	If Not rs.EOF Then
		Do Until rs.EOF
			comment_cnt = rs("comment_cnt")
			subject = rs("subject")
			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End if

			parent_del_yn = rs("parent_del_yn")

			If parent_del_yn = "Y" Then
				subject = "*원글이 삭제된 답글* " & subject
			End if
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><%=if3(rs("level_num")="0",rs("story_num"),"")%></td>
									<td>
<%
			If rs("level_num") > "0" Then
%>
										<img src="/cafe/skin/img/btn/re.gif" width="<%=rs("level_num")*10%>" height="0">
										<img src="/cafe/skin/img/btn/re.png" />
<%
			End If
%>
										<a href="javascript: goView('<%=rs("story_seq")%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
<%
			If comment_cnt > "0" Then
%>
										(<%=comment_cnt%>)
<%
			End If
%>
<%
			If CDate(DateAdd("d",2,rs("credt_txt"))) >= Date Then
%>
										<img src="/cafe/skin/img/btn/new.png" />
<%
			End if
%>
									</td>
									<td class="algC">운영자</td>
									<td class="algC"><%=rs("credt_txt")%></td>
									<td class="algC"><%=rs("view_cnt")%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="5" class="td_nodata">등록된 글이 없습니다.</td>
								</tr>
<%
	End If
	rs.close
	Set rs = nothing
%>
							</tbody>
						</table>
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
		f.action = "story_list.asp"
		f.submit();
	}

	function goView(story_seq, no) {
		try{
			var f = document.search_form;
			f.story_seq.value = story_seq;
			if (no == 0) {
			f.notice_seq.value = story_seq;
			f.action = "notice_view.asp"
			}
			else {
			f.action = "story_view.asp"
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

	function goTab(section_seq) {
		var f = document.search_form;
		f.section_seq.value = section_seq;
		f.page.value = 1;
		f.submit();
	}
</script>

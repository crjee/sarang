<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
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
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (cb.subject like '%" & sch_word & "%' or cb.creid like '%" & sch_word & "%' or cb.agency like '%" & sch_word & "%' or cb.contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(job_seq) cnt "
	sql = sql & "   from cf_job cb          "
	sql = sql & "  where 1 = 1              "
	If all_yn <> "Y" then
	sql = sql & "    and end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "    and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & kword

	rs.Open sql, conn, 3, 1
	RecordCount = 0 ' 자료가 없을때
	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select subject "
	sql = sql & "       ,job_seq "
	sql = sql & "       ,work_place "
	sql = sql & "       ,agency "
	sql = sql & "       ,parent_del_yn "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "       ,convert(varchar(10), end_date, 120) as end_date_txt "
	sql = sql & "   from (select row_number() over( order by job_seq desc) as rownum "
	sql = sql & "               ,cb.subject "
	sql = sql & "               ,cb.job_seq "
	sql = sql & "               ,cb.work_place "
	sql = sql & "               ,cb.agency "
	sql = sql & "               ,cb.credt "
	sql = sql & "               ,cb.end_date "
	sql = sql & "               ,cb.parent_del_yn "
	sql = sql & "               ,cm.phone as tel_no "
	sql = sql & "           from cf_job cb "
	sql = sql & "           left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "         where 1 = 1 "
	If all_yn <> "Y" then
	sql = sql & "           and cb.end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "           and cb.user_id = '" & session("user_id") & "' "
	End If
	sql = sql & "           and isnull(cb.top_yn,'') <> 'Y' "
	sql = sql & kword
	sql = sql & "       ) a "
	sql = sql & " where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & " "
	sql = sql & "  order by job_seq desc "
	rs.Open Sql, conn, 3, 1

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) then
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
						<input type="hidden" name="job_seq">
<%
	If cafe_ad_level = 10 Then
%>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/board_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
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
						</form>
					</div>
					<div class="tb">
						<table class="tb_fixed">
							<colgroup>
								<col class="w_auto" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">채용제목</th>
									<th scope="col">근무지역</th>
									<th scope="col">중개업소</th>
									<th scope="col">등록일</th>
									<th scope="col">마감일</th>
								</tr>
							</thead>
							<tbody>
<%
	If Not rs.EOF Then
		Do Until rs.EOF Or i > rs.pagesize
			subject = rs("subject")
			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End if
			subject_s = rmid(subject, 40, "..")

			parent_del_yn = rs("parent_del_yn")

			If parent_del_yn = "Y" Then
				subject = "*원글이 삭제된 답글* " & subject
			End if
%>
								<tr>
									<td><a href="javascript: goView('<%=rs("job_seq")%>')" title="<%=subject_s%>"><%=subject%></a>
<%
			If CDate(DateAdd("d",2,rs("credt_txt"))) >= Date Then
%>
										<img src="/cafe/skin/img/btn/new.png" />
<%
			End if
%>
									</td>
									<td class="algC"><%=rs("work_place")%></td>
									<td class="algC"><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></td>
									<td class="algC"><%=rs("credt_txt")%></td>
									<td class="algC"><%=rs("end_date_txt")%></td>
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

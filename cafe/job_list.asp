<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckReadAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방</title>
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
<!--#include virtual="/cafe/cafe_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/cafe_left_inc.asp"-->
<%
	End If
%>
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	self_yn  = Request("self_yn")
	all_yn   = Request("all_yn")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "" Then
			schStr = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			schStr = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		schStr = ""
	End If

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(job_seq) cnt "
	sql = sql & "   from cf_job cj          "
	sql = sql & "  where 1 = 1              "
	If all_yn <> "Y" then
	sql = sql & "    and end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "    and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & schStr
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
	sql = sql & "       ,mbl_telno "
	sql = sql & "       ,reg_date "
	sql = sql & "       ,end_date "
	sql = sql & "   from (select row_number() over( order by job_seq desc) as rownum "
	sql = sql & "               ,subject "
	sql = sql & "               ,job_seq "
	sql = sql & "               ,work_place "
	sql = sql & "               ,agency "
	sql = sql & "               ,credt "
	sql = sql & "               ,end_date "
	sql = sql & "               ,parent_del_yn "
	sql = sql & "               ,tel_no "
	sql = sql & "               ,mbl_telno "
	sql = sql & "           from cf_job  "
	sql = sql & "          where 1 = 1 "
	If all_yn <> "Y" then
	sql = sql & "           and end_date >= '" & date & "' "
	End If
	If self_yn = "Y" then
	sql = sql & "           and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & "           and isnull(top_yn,'') <> 'Y' "
	sql = sql & schStr
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
%>
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						총 <strong><%=FormatNumber(RecordCount,0)%></strong>건의 게시물이 있습니다.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1, '<%=session("ctTarget")%>')">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="job_seq">
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<span class="ml20">
							<input type="checkbox" id="self_yn" name="self_yn" class="inp_check" value="Y" <%=if3(self_yn="Y","checked","")%> onclick="goAll()" />
							<label for="self_yn"><em>본인등록</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="all_yn" name="all_yn" class="inp_check" value="Y" <%=if3(all_yn="Y","checked","")%> onclick="goAll()" />
							<label for="all_yn"><em>전체보기</em></label>
						</span>
						<script>
							function goAll() {
								var f = document.search_form;
								f.action = "job_list.asp"
								f.page.value = 1;
								f.submit()
							}
						</script>
<%
	End If
%>
<%
	If cafe_ad_level = 10 Then
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWaste('<%=session("ctTarget")%>')">휴지통</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
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
				<div class="mt10">
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
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	sql =       ""
	sql = sql & " select subject "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,job_seq "
	sql = sql & "       ,work_place "
	sql = sql & "       ,agency "
	sql = sql & "       ,reg_date "
	sql = sql & "       ,end_date "
	sql = sql & "   from cf_job cj "
	sql = sql & "  where top_yn = 'Y' "
	sql = sql & " order by job_seq desc "
	rs2.Open Sql, conn, 3, 1

	If Not rs2.eof Then
		i = 1
		Do Until rs2.eof
			subject = rs2("subject")
			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End If
			subject_s = rmid(subject, 35, "..")
%>
								<tr>
									<td><a href="javascript: goView('<%=rs2("job_seq")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%></a></td>
									<td class="algC"><%=rs2("work_place")%></td>
									<td class="algC"><a title="<%=rs2("tel_no")%>"><%=rs2("agency")%></a></td>
									<td class="algC"><%=rs2("reg_date")%></td>
									<td class="algC"><%=rs2("end_date")%></td>
								</tr>
<%
			rs2.MoveNext
		Loop
	End If
	rs2.close
	Set rs2 = Nothing

	If Not rs.EOF Then
		Do Until rs.EOF Or i > PageSize
			subject = rs("subject")

			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End If

			parent_del_yn = rs("parent_del_yn")

			If parent_del_yn = "Y" Then
				subject = "*원글이 삭제된 답글* " & subject
			End If

			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td><a href="javascript: goView('<%=rs("job_seq")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%></a>
<%
			If CDate(DateAdd("d",2,rs("reg_date"))) >= Date Then
%>
										<img src="/cafe/img/btn/new.png" />
<%
			End If
%>
									</td>
									<td class="algC"><%=rs("work_place")%></td>
									<td class="algC"><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></td>
									<td class="algC"><%=rs("reg_date")%></td>
									<td class="algC"><%=rs("end_date")%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="5">등록된 글이 없습니다.</td>
								</tr>
<%
	End If
	rs.close
	Set rs = Nothing
%>
							</tbody>
						</table>
					</div>
<!--#include virtual="/cafe/cafe_page_inc.asp"-->
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
					<div class="btn_box algR">
						<button type="button" class="btn btn_c_a btn_n" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
					</div>
<%
	End If
%>
				</div>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<%
	End If
%>
</body>
<script>
	function MovePage(page, gvTarget) {
		var f = document.search_form;
		f.page.value = page;
		f.target = gvTarget;
		f.action = "/cafe/job_list.asp";
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "/cafe/job_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goView(job_seq, gvTarget) {
		var f = document.search_form;
		f.job_seq.value = job_seq;
		f.target = gvTarget;
		f.action = "/cafe/job_view.asp";
		f.submit()
	}

	function goWaste(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/waste_job_list.asp";
		f.submit();
	}

	function goSearch(gvTarget) {
		var f = document.search_form;
		f.page.value = 1;
		f.target = gvTarget;
		f.submit();
	}

	function goTab(section_seq, gvTarget) {
		var f = document.search_form;
		f.section_seq.value = section_seq;
		f.page.value = 1;
		f.target = gvTarget;
		f.submit();
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>


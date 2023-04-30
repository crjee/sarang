<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

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
	<title>경인 홈</title>
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
	sch_type    = Request("sch_type")
	sch_word    = Request("sch_word")

	all_yn      = Request("all_yn")
	self_yn     = Request("self_yn")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If section_seq = "0" Then
	ElseIf section_seq = "999999" Then
		secStr = "    and (section_seq = null or section_seq = '') "
	ElseIf section_seq <> "" Then
		secStr = "    and section_seq = '" & section_seq & "' "
	End If

	If sch_word <> "" then
		If sch_type = "" Then
			schStr = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			schStr = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		schStr = ""
	End IF

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(job_seq) cnt "
	sql = sql & "   from gi_job cj          "
	sql = sql & "  where 1 = 1              "
	If all_yn <> "Y" Then
	sql = sql & "    and end_date >= '" & date & "' "
	End If
	If self_yn = "Y" Then
	sql = sql & "    and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & secStr
	sql = sql & schStr
	rs.Open sql, conn, 3, 1

	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If

	sql = ""
	sql = sql & " select *                                                                           "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "               ,*                                                                   "
	sql = sql & "           from gi_job                                              "
	sql = sql & "          where 1 = 1                                               "
	If all_yn <> "Y" Then
	sql = sql & "            and end_date >= '" & Date                          & "' "
	End If
	If self_yn = "Y" Then
	sql = sql & "            and user_id = '" & session("user_id")              & "' "
	End If
	sql = sql & secStr
	sql = sql & schStr
	sql = sql & "        ) a                                                                         "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & "          "
	sql = sql & "  order by group_num desc, step_num asc                                             "
	rs.Open Sql, conn, 3, 1
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
						<input type="hidden" name="job_seq">
<%
	If cafe_ad_level = 10 Then
%>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWrite()">글쓰기</button>
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
		Do Until rs.EOF
			job_seq       = rs("job_seq")
			job_num       = rs("job_num")
			group_num     = rs("group_num")
			step_num      = rs("step_num")
			level_num     = rs("level_num")
			menu_seq      = rs("menu_seq")
			cafe_id       = rs("cafe_id")
			agency        = rs("agency")
			top_yn        = rs("top_yn")
			pop_yn        = rs("pop_yn")
			section_seq   = rs("section_seq")
			subject       = rs("subject")
			contents      = rs("contents")
			link          = rs("link")
			work          = rs("work")
			age           = rs("age")
			sex           = rs("sex")
			work_year     = rs("work_year")
			certify       = rs("certify")
			work_place    = rs("work_place")
			person        = rs("person")
			tel_no        = rs("tel_no")
			mbl_telno     = rs("mbl_telno")
			fax_no        = rs("fax_no")
			email         = rs("email")
			homepage      = rs("homepage")
			method        = rs("method")
			end_date      = rs("end_date")
			user_id       = rs("user_id")
			reg_date      = rs("reg_date")
			view_cnt      = rs("view_cnt")
			comment_cnt   = rs("comment_cnt")
			suggest_cnt   = rs("suggest_cnt")
			suggest_info  = rs("suggest_info")
			parent_seq    = rs("parent_seq")
			parent_del_yn = rs("parent_del_yn")
			move_job_num  = rs("move_job_num")
			move_menu_seq = rs("move_menu_seq")
			move_user_id  = rs("move_user_id")
			move_date     = rs("move_date")
			restoreid     = rs("restoreid")
			restoredt     = rs("restoredt")
			creid         = rs("creid")
			credt         = rs("credt")
			modid         = rs("modid")
			moddt         = rs("moddt")

			If isnull(subject) Or isempty(subject) Or Trim(Len(subject)) = 0 Then
				subject = "제목없음"
			End If

			If parent_del_yn = "Y" Then
				subject = "*원글이 삭제된 답글* " & subject
			End If

			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td><a href="javascript: goView('<%=job_seq%>')" title="<%=subject_s%>"><%=subject%></a>
<%
			If CDate(DateAdd("d",2,reg_date)) >= Date Then
%>
										<img src="/cafe/img/btn/new.png" />
<%
			End If
%>
									</td>
									<td class="algC"><%=work_place%></td>
									<td class="algC"><a title="<%=tel_no%>"><%=agency%></a></td>
									<td class="algC"><%=Left(reg_date, 10)%></td>
									<td class="algC"><%=end_date%></td>
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
	Set rs = Nothing
%>
							</tbody>
						</table>
					</div>
<!--#include virtual="/home/home_page_inc.asp"-->
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
					<div class="btn_box algR">
						<button type="button" class="btn btn_c_a btn_n" onclick="goWrite()">글쓰기</button>
					</div>
<%
	End If
%>
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
		f.target = "_self";
		f.action = "job_list.asp";
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "job_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goView(job_seq) {
		var f = document.search_form;
		f.job_seq.value = job_seq;
		f.target = "_self";
		f.action = "job_view.asp";
		f.submit()
	}

	function goSearch() {
		var f = document.search_form;
		f.page.value = 1;
		f.target = "_self";
		f.submit();
	}

	function goTab(section_seq) {
		var f = document.search_form;
		f.section_seq.value = section_seq;
		f.page.value = 1;
		f.submit();
	}
</script>

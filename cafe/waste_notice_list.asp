<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	menu_type = "notice"
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

	Set rs = Server.CreateObject("ADODB.Recordset")

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

	sql = ""
	sql = sql & " select count(notice_seq) cnt "
	sql = sql & "   from cf_waste_notice "
	sql = sql & schStr
	rs.Open sql, conn, 3, 1

	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select *                                                                           "
	sql = sql & "       ,reg_date                               "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "               ,*                                                                   "
	sql = sql & "           from cf_waste_notice                                                     "
	sql = sql & schStr
	sql = sql & "        ) a                                                                         "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & "          "
	sql = sql & "  order by group_num desc, step_num asc                                             "
	rs.Open sql, conn, 3, 1

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If
%>
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><font color="red">휴지통 경인네트웍스 전체공지</font>&nbsp;총 <%=FormatNumber(RecordCount,0)%>건의 글이 있습니다.</h2>
				</div>
				<div class="">
					<div class="search_box algR">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1, '<%=session("ctTarget")%>')">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="notice_seq">
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
					<div class="tb">
						<table class="tb_fixed">
							<colgroup>
								<col class="w7" />
								<col class="w_auto" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">글쓴이</th>
									<th scope="col">조회</th>
									<th scope="col">추천</th>
									<th scope="col">등록일</th>
								</tr>
							</thead>
							<tbody>
<%
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,reg_date "
	sql = sql & "   from cf_waste_notice cb "
	sql = sql & "  where top_yn = 'Y' "
	sql = sql & " order by notice_seq desc "
	rs2.Open Sql, conn, 3, 1

	If Not rs2.eof Then
		i = 1
		Do Until rs2.eof
			subject = rs2("subject")
			If isnull(subject) Or isempty(subject) Or Len(Trim(subject)) = 0 Then
				subject = "제목없음"
			End If
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><img src="/cafe/img/btn/btn_notice.png" /></td>
									<td><a href="javascript: goView('<%=rs2("notice_seq")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%></a></td>
									<td class="algC"><%=rs2("agency")%></td>
									<td class="algC"><%=rs2("view_cnt")%></td>
									<td class="algC"><%=rs2("suggest_cnt")%></td>
									<td class="algC"><%=rs2("reg_date")%></td>
								</tr>
<%
			rs2.MoveNext
		Loop
	End If
	rs2.close
	Set rs2 = Nothing

	If Not rs.EOF Then
		Do Until rs.EOF 
			comment_cnt = rs("comment_cnt")
			subject = rs("subject")
			subject = Replace(subject, """", "&quot;")
			If subject = "" Then
				subject = "제목없음"
			End If

			parent_del_yn = rs("parent_del_yn")

			If parent_del_yn = "Y" Then
				subject = "*원글이 삭제된 답글* " & subject
			End If
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><%=if3(rs("level_num")="0",rs("notice_num"),"")%></td>
									<td>
<%
			If rs("level_num") > "0" Then
%>
										<img src="/cafe/img/btn/re.gif" width="<%=rs("level_num")*10%>" height="0">
										<img src="/cafe/img/btn/re.png" />
<%
			End If
%>
										<a href="javascript: goView('<%=rs("notice_seq")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
<%
			If comment_cnt > "0" Then
%>
										(<%=comment_cnt%>)
<%
			End If
%>
<%
			If CDate(DateAdd("d",2,rs("reg_date"))) >= Date Then
%>
										<img src="/cafe/img/btn/new.png" />
<%
			End If
%>
									</td>
									<td class="algC"><%=rs("agency")%></td>
									<td class="algC"><%=rs("view_cnt")%></td>
									<td class="algC"><%=rs("suggest_cnt")%></td>
									<td class="algC"><%=rs("reg_date")%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="6">등록된 글이 없습니다.</td>
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
		f.action = "/cafe/waste_notice_list.asp";
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "/cafe/notice_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goView(notice_seq, gvTarget) {
		var f = document.search_form;
		f.notice_seq.value = notice_seq;
		f.target = gvTarget;
		f.action = "/cafe/waste_notice_view.asp";
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

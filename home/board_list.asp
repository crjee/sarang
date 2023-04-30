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

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	If section_seq = "0" Then
	ElseIf section_seq = "999999" Then
		secStr = "    and (section_seq = null or section_seq = '') "
	ElseIf section_seq <> "" Then
		secStr = "    and section_seq = '" & section_seq & "' "
	End If

	If sch_word <> "" Then
		If sch_type = "" Then
			schStr = " and (subject like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			schStr = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		schStr = ""
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
						<input type="hidden" name="board_seq">
						<input type="hidden" name="notice_seq">
<!--#include virtual="/home/home_up_list_btn_inc.asp"-->
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
								<col class="w6" />
								<col class="w6" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">글쓴이</th>
									<th scope="col">조회</th>
									<th scope="col">추천</th>
									<th scope="col">작성일</th>
								</tr>
							</thead>
							<tbody>
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	If page_type = "notice" Then
	sql = sql & " select cb.subject "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "       ,cb.agency "
	sql = sql & "       ,cb.view_cnt "
	sql = sql & "       ,cb.suggest_cnt "
	sql = sql & "       ,cb.notice_seq as board_seq "
	sql = sql & "       ,0 as no "
	sql = sql & "       ,cb.user_id "
	sql = sql & "       ,cb.reg_date "
	sql = sql & "       ,convert(varchar(10), cb.reg_date, 120) as reg_date_txt "
	sql = sql & "   from gi_notice cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where cb.top_yn = 'Y' "
	sql = sql & "    and (cb.cafe_id = null or cb.cafe_id = '' or ', ' + cb.cafe_id + ', ' like '%, " & cafe_id & ", %') "
	sql = sql & "  union all"
	End if
	sql = sql & " select cb.subject "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "       ,cb.agency "
	sql = sql & "       ,cb.view_cnt "
	sql = sql & "       ,cb.suggest_cnt "
	sql = sql & "       ,cb.board_seq "
	sql = sql & "       ,1 as no  "
	sql = sql & "       ,cb.user_id "
	sql = sql & "       ,cb.reg_date "
	sql = sql & "       ,convert(varchar(10), cb.reg_date, 120) as reg_date_txt "
	sql = sql & "   from gi_board cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where cb.cafe_id = '"& cafe_id &"' "
	sql = sql & "    and cb.menu_seq = '"& menu_seq &"' "
	sql = sql & "    and cb.top_yn = 'Y' "
	sql = sql & " order by no, board_seq desc "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
			no          = rs("no")
			board_seq   = rs("board_seq")
			subject     = rs("subject")
			tel_no      = rs("tel_no")
			agency      = rs("agency")
			view_cnt    = rs("view_cnt")
			suggest_cnt = rs("suggest_cnt")
			reg_date    = rs("reg_date")

			If isnull(subject) Or isempty(subject) Or Len(Trim(subject)) = 0 Then
				subject = "제목없음"
			End if
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><img src="/cafe/img/btn/btn_notice.png" /></td>
									<td><a href="#n" onclick="goView('<%=board_seq%>','<%=no%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a></td>
									<td class="algC"><a title="<%=tel_no%>"><%=agency%></a></td>
									<td class="algC"><%=view_cnt%></td>
									<td class="algC"><%=suggest_cnt%></td>
									<td class="algC"><%=Left(reg_date, 10)%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	End If
	rs.close

	sql = ""
	sql = sql & " select count(board_seq) cnt          "
	sql = sql & "   from gi_board cb                   "
	sql = sql & "  where cafe_id  = '" & cafe_id  & "' "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
	sql = sql & secStr
	sql = sql & schStr
	rs.Open sql, conn, 3, 1

	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) Then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If

	sql = ""
	sql = sql & " select a.*                                                                         "
	sql = sql & "       ,cm.phone as tel_no                                                          "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "               ,*                                                                   "
	sql = sql & "           from gi_board                                                            "
	sql = sql & "          where cafe_id  = '" & cafe_id                                        & "' "
	sql = sql & "            and menu_seq = '" & menu_seq                                       & "' "
	sql = sql & secStr
	sql = sql & schStr
	sql = sql & "        ) a                                                                         "
	sql = sql & "   left join cf_member cm on cm.user_id = a.user_id                                 "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & "          "
	sql = sql & "  order by group_num desc, step_num asc                                             "
	rs.Open sql, conn, 3, 1

	If Not rs.EOF Then
		Do Until rs.EOF
			board_seq      = rs("board_seq")
			board_num      = rs("board_num")
			group_num      = rs("group_num")
			step_num       = rs("step_num")
			level_num      = rs("level_num")
			menu_seq       = rs("menu_seq")
			cafe_id        = rs("cafe_id")
			agency         = rs("agency")
			top_yn         = rs("top_yn")
			pop_yn         = rs("pop_yn")
			section_seq    = rs("section_seq")
			subject        = rs("subject")
			contents       = rs("contents")
			link           = rs("link")
			user_id        = rs("user_id")
			reg_date       = rs("reg_date")
			view_cnt       = rs("view_cnt")
			comment_cnt    = rs("comment_cnt")
			suggest_cnt    = rs("suggest_cnt")
			suggest_info   = rs("suggest_info")
			parent_seq     = rs("parent_seq")
			parent_del_yn  = rs("parent_del_yn")
			move_board_num = rs("move_board_num")
			move_menu_seq  = rs("move_menu_seq")
			move_user_id   = rs("move_user_id")
			move_date      = rs("move_date")
			restoreid      = rs("restoreid")
			restoredt      = rs("restoredt")
			creid          = rs("creid")
			credt          = rs("credt")
			modid          = rs("modid")
			moddt          = rs("moddt")

			tel_no         = rs("tel_no")

			subject = Replace(subject, """", "&quot;")

			If isnull(subject) Or isempty(subject) Or Len(Trim(subject)) = 0 Then
				subject = "제목없음"
			End If

			If parent_del_yn = "Y" Then
				subject = "*원글이 삭제된 답글* " & subject
			End If

			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><%=if3(level_num="0",board_num,"")%></td>
									<td>
<%
			If level_num > "0" Then
%>
										<img src="/cafe/img/btn/re.gif" width="<%=level_num*10%>" height="0">
										<img src="/cafe/img/btn/re.png" />
<%
			End If
%>
										<a href="#n" onclick="goView('<%=board_seq%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
<%
			If comment_cnt > "0" Then
%>
										(<%=comment_cnt%>)
<%
			End If
%>
<%
			If CDate(DateAdd("d",2,reg_date)) >= Date Then
%>
										<img src="/cafe/img/btn/new.png" />
<%
			End If
%>
									</td>
									<td class="algC"><a title="<%=tel_no%>"><%=agency%></a></td>
									<td class="algC"><%=view_cnt%></td>
									<td class="algC"><%=suggest_cnt%></td>
									<td class="algC"><%=Left(reg_date, 10)%></td>
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
<script>
	function MovePage(page) {
		var f = document.search_form;
		f.page.value = page;
		f.action = "board_list.asp"
		f.submit();
	}

	function goWrite() {
		var f = document.search_form;
		f.action = "board_write.asp"
		f.submit();
	}

	function goView(board_seq) {
			var f = document.search_form;
			f.board_seq.value = board_seq;
			f.action = "board_view.asp"
			f.submit()
	}

	function goWaste() {
		var f = document.search_form;
		f.action = "waste_board_list.asp";
		f.submit();
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
</html>

<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
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
	section_seq = Request("section_seq")
	sch_type    = Request("sch_type")
	sch_word    = Request("sch_word")

	self_yn  = Request("self_yn")

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

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(board_seq) cnt          "
	sql = sql & "   from cf_board cb                   "
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
%>
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						총 <strong><%=FormatNumber(RecordCount,0)%></strong>건의 글이 있습니다.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1, '<%=session("ctTarget")%>')">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="board_seq">
						<input type="hidden" name="notice_seq">
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<span class="ml20">
							<input type="checkbox" id="self_yn" name="self_yn" class="inp_check" value="Y" <%=if3(self_yn="Y","checked","")%> onclick="goAll()" />
							<label for="self_yn"><em>본인등록</em></label>
						</span>
						<script>
							function goAll() {
								var f = document.search_form;
								f.action = "board_list.asp"
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
						<button type="button" class="btn btn_c_a btn_s" onclick="goNotice('<%=session("ctTarget")%>')">전체공지</button>
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
						<form name="list_form" method="post">
						<input type="hidden" name="menu_type" value="<%=menu_type%>">
						<input type="hidden" name="smode">
						<table class="tb_fixed">
							<colgroup>
								<col class="w7" />
								<col class="w_auto" />
								<col class="w15" />
								<col class="w7" />
								<col class="w7" />
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
	sql = sql & "   from cf_notice cb "
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
	sql = sql & "   from cf_board cb "
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
	sql = sql & " select a.*                                                                         "
	sql = sql & "       ,cm.phone as tel_no                                                          "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "       ,comment_cnt   "
	sql = sql & "       ,subject       "
	sql = sql & "       ,parent_del_yn "
	sql = sql & "       ,level_num     "
	sql = sql & "       ,board_num     "
	sql = sql & "       ,board_seq     "
	sql = sql & "       ,agency        "
	sql = sql & "       ,view_cnt      "
	sql = sql & "       ,suggest_cnt   "
	sql = sql & "       ,reg_date      "
	sql = sql & "       ,group_num     "
	sql = sql & "       ,step_num      "
	sql = sql & "       ,user_id       "
	sql = sql & "           from cf_board                                                            "
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
			comment_cnt   = rs("comment_cnt")
			subject       = rs("subject")
			parent_del_yn = rs("parent_del_yn")
			level_num     = rs("level_num")
			board_num     = rs("board_num")
			board_seq     = rs("board_seq")
			agency        = rs("agency")
			view_cnt      = rs("view_cnt")
			suggest_cnt   = rs("suggest_cnt")
			group_num     = rs("group_num")
			step_num      = rs("step_num")
			user_id       = rs("user_id")
			reg_date      = rs("reg_date")

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
						</form>
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
		f.action = "/cafe/board_list.asp";
		f.target = gvTarget;
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "/cafe/board_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goView(board_seq, no, gvTarget) {
		var f = document.search_form;
		f.board_seq.value = board_seq;
		if (no == 0) {
			f.notice_seq.value = board_seq;
			f.action = "/cafe/notice_view.asp"
			f.target = gvTarget;
		}
		else {
			f.action = "/cafe/board_view.asp";
			f.target = gvTarget;
		}
		f.submit()
	}

	function goWaste(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/waste_board_list.asp";
		f.submit();
	}

	function goNotice(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/notice_list.asp";
		f.submit();
	}

	function goSearch(gvTarget) {
		var f = document.search_form;
		f.page.value = 1;
		f.target = gvTarget;
		f.submit();
	}
</script>
</html>
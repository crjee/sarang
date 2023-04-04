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
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	Else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		page_type = rs("page_type")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (cb.subject like '%" & sch_word & "%' or cb.agency like '%" & sch_word & "%' or cb.contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	sql = ""
	sql = sql & " select count(board_seq) cnt "
	sql = sql & "   from cf_board cb "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
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
	sql = sql & "       ,board_num     "
	sql = sql & "       ,board_seq     "
	sql = sql & "       ,agency        "
	sql = sql & "       ,view_cnt      "
	sql = sql & "       ,suggest_cnt   "
	sql = sql & "       ,group_num     "
	sql = sql & "       ,step_num      "
	sql = sql & "       ,user_id    "
	sql = sql & "       ,tel_no        "
	sql = sql & "   from (select row_number() over( order by cb.group_num desc, cb.step_num asc) as rownum "
	sql = sql & "               ,cb.comment_cnt   "
	sql = sql & "               ,cb.subject       "
	sql = sql & "               ,cb.parent_del_yn "
	sql = sql & "               ,cb.level_num     "
	sql = sql & "               ,cb.board_num     "
	sql = sql & "               ,cb.board_seq     "
	sql = sql & "               ,cb.agency        "
	sql = sql & "               ,cb.view_cnt      "
	sql = sql & "               ,cb.suggest_cnt   "
	sql = sql & "               ,cb.credt      "
	sql = sql & "               ,cb.group_num     "
	sql = sql & "               ,cb.step_num      "
	sql = sql & "               ,cb.user_id       "
	sql = sql & "               ,cm.phone as tel_no "
	sql = sql & "           from cf_board cb"
	sql = sql & "           left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "          where cb.cafe_id = '" & cafe_id & "' "
	sql = sql & "            and cb.menu_seq = '" & menu_seq & "' "
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
%>
			<script>
				function MovePage(page){
					var f = document.search_form;
					f.page.value = page;
					f.action = "board_list.asp"
					f.submit();
				}

				function goView(board_seq, no){
					var f = document.search_form;
					f.board_seq.value = board_seq;
					if (no == 0){
					f.notice_seq.value = board_seq;
					f.action = "notice_view.asp"
					}
					else{
					f.action = "board_view.asp"
					}
					f.submit()
				}

				function goSearch(){
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						총 <strong><%=FormatNumber(RecordCount,0)%></strong>건의 글이 있습니다.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="board_seq">
						<input type="hidden" name="notice_seq">
<%
	If cafe_ad_level = 10 Then
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/notice_list.asp'">전체공지</button>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/waste_board_list.asp?menu_seq=<%=menu_seq%>'">휴지통</button>
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
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w250p">
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

				<div class="mt10">
					<div class="tb">
						<form name="list_form" method="post">
						<input type="hidden" name="menu_type" value="<%=menu_type%>">
						<input type="hidden" name="smode">
						<table>
							<colgroup>
								<col class="w5" />
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
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

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
		sql = sql & "       ,cb.credt "
		sql = sql & "       ,convert(varchar(10), cb.credt, 120) as credt_txt "
		sql = sql & "   from cf_notice cb "
		sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
		sql = sql & "  where cb.top_yn = 'Y' "
		sql = sql & "    and (cb.cafe_id = null or cb.cafe_id = '' or ', ' + cb.cafe_id + ', ' like '%, " & cafe_id & ", %') "
		sql = sql & "  union all"
	End If

	sql = sql & " select cb.subject "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "       ,cb.agency "
	sql = sql & "       ,cb.view_cnt "
	sql = sql & "       ,cb.suggest_cnt "
	sql = sql & "       ,cb.board_seq "
	sql = sql & "       ,1 as no  "
	sql = sql & "       ,cb.user_id "
	sql = sql & "       ,cb.credt "
	sql = sql & "       ,convert(varchar(10), cb.credt, 120) as credt_txt "
	sql = sql & "   from cf_board cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where cb.cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and cb.menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cb.top_yn = 'Y' "
	sql = sql & " order by no, board_seq desc "
	rs2.Open Sql, conn, 3, 1

	If Not rs2.eof Then
		i = 1
		Do Until rs2.eof
			subject = rs2("subject")
			no = rs2("no")
			If isnull(subject) Or isempty(subject) Or Len(Trim(subject)) = 0 Then
				subject = "제목없음"
			End if
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><img src="/cafe/skin/img/btn/btn_notice.png" /></td>
									<td><a href="javascript: goView('<%=rs2("board_seq")%>','<%=no%>')" title="<%=subject_s%>"><%=subject%></a></td>
									<td class="algC"><a title="<%=rs2("tel_no")%>"><%=rs2("agency")%></a></td>
									<td class="algC"><%=rs2("view_cnt")%></td>
									<td class="algC"><%=rs2("suggest_cnt")%></td>
									<td class="algC"><%=rs2("credt_txt")%></td>
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
									<td class="algC"><%=if3(rs("level_num")="0",rs("board_num"),"")%></td>
									<td>
<%
			If rs("level_num") > "0" Then
%>
										<img src="/cafe/skin/img/btn/re.gif" width="<%=rs("level_num")*10%>" height="0">
										<img src="/cafe/skin/img/btn/re.png" />
<%
			End If
%>
										<a href="javascript: goView('<%=rs("board_seq")%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
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
									<td class="algC"><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></td>
									<td class="algC"><%=rs("view_cnt")%></td>
									<td class="algC"><%=rs("suggest_cnt")%></td>
									<td class="algC"><%=rs("credt_txt")%></td>
								</tr>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="100" class="td_nodata">등록된 글이 없습니다.</td>
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
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
					<div class="btn_box algR">
						<button class="btn btn_c_a btn_n" type="button" onclick="location.href='/cafe/skin/board_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
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

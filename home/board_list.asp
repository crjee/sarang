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
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	menu_seq = Request("menu_seq")

'If session("user_id") = "crjee" Then extime("cf_menu ?ㅽ뻾?쒓컙")
	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1
'If session("user_id") = "crjee" Then extime("cf_menu ?ㅽ뻾?쒓컙")

	If rs.EOF Then
		msggo "?뺤긽?곸씤 ?ъ슜???꾨떃?덈떎.",""
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
	If page = "" Then page = 1

	If sch_word <> "" Then
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

	RecordCount = 0 ' ?먮즺媛 ?놁쓣??
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
	sql = sql & "       ,credt      "
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

	' ?꾩껜 ?섏씠吏 ???산린
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
						<input type="hidden" name="board_seq">
						<input type="hidden" name="notice_seq">
<%
	If cafe_ad_level = 10 Then
%>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 湲?곌린 沅뚰븳
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/home/board_write.asp?menu_seq=<%=menu_seq%>'">湲?곌린</button>
<%
	End If
%>
						<select id="sch_type" name="sch_type" class="sel w100p">
							<option value="all">?꾩껜</option>
							<option value="cb.subject" <%=if3(sch_type="cb.subject","selected","")%>>?쒕ぉ</option>
							<option value="cb.agency" <%=if3(sch_type="cb.agency","selected","")%>>湲?댁씠</option>
							<option value="cb.contents" <%=if3(sch_type="cb.contents","selected","")%>>?댁슜</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w300p">
						<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">寃??/button>
						</form>
					</div>
					<div class="tb">
						<table>
							<colgroup>
								<col class="w5" />
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
				subject = "?쒕ぉ?놁쓬"
			End if

			parent_del_yn = rs("parent_del_yn")

			If parent_del_yn = "Y" Then
				subject = "*?먭?????젣???듦?* " & subject
			End if
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><%=if3(rs("level_num")="0",rs("board_num"),"")%></td>
									<td>
<%
			If rs("level_num") > "0" Then
%>
										<img src="/home/img/btn/re.gif" width="<%=rs("level_num")*10%>" height="0">
										<img src="/home/img/btn/re.png" />
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
										<img src="/home/img/btn/new.png" />
<%
			End if
%>
									</td>
									<td class="algC"></td>
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
		f.action = "board_list.asp"
		f.submit();
	}

	function goView(board_seq, no) {
		try{
			var f = document.search_form;
			f.board_seq.value = board_seq;
			if (no == 0) {
			f.notice_seq.value = board_seq;
			f.action = "notice_view.asp"
			}
			else {
			f.action = "board_view.asp"
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

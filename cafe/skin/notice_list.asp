<!--#include virtual="/include/config_inc.asp"-->
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

	Set rs = Server.CreateObject ("ADODB.Recordset")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	sql = ""
	sql = sql & " select count(notice_seq) cnt "
	sql = sql & "   from cf_notice "
	sql = sql & kword

	rs.Open sql, conn, 3, 1
	RecordCount = 0 ' 자료가 없을때
	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "   from (select row_number() over( order by group_num desc,step_num asc) as rownum "
	sql = sql & "               ,cn.* "
	sql = sql & "           from cf_notice cn "
	If cafe_ad_level <> "10" Then ' 글쓰기 권한
	sql = sql & "          where (cafe_id = null or cafe_id = '' or ', ' + cafe_id + ', ' like '%, " & cafe_id & ", %') "
	End If
	sql = sql & kword
	sql = sql & "        ) a "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & " "
	sql = sql & "  order by group_num desc, step_num asc "
	rs.Open sql, conn, 3, 1

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
	End If
%>
			<script>
				function MovePage(page){
					var f = document.search_form;
					f.page.value = page;
					f.action = "notice_list.asp"
					f.submit();
				}

				function goView(notice_seq){
					var f = document.search_form;
					f.notice_seq.value = notice_seq;
					f.action = "notice_view.asp"
					f.submit()
				}

				function goSearch(){
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2">경인네트웍스 전체공지&nbsp;총 <%=FormatNumber(RecordCount,0)%>건의 글이 있습니다.</h2>
				</div>
				<div class="">
					<div class="search_box algR">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="notice_seq">
<%
	If cafe_ad_level = 10 Then
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/waste_notice_list.asp?menu_seq=<%=menu_seq%>'">휴지통</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/notice_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
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
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">제목</th>
									<th scope="col">글쓴이</th>
									<th scope="col">사랑방</th>
									<th scope="col">조회</th>
									<th scope="col">추천</th>
									<th scope="col">등록일</th>
								</tr>
							</thead>
							<tbody>
<%
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cn.* "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "   from cf_notice cn "
	sql = sql & "  where top_yn = 'Y' "
	If cafe_ad_level <> "10" Then ' 글쓰기 권한
	sql = sql & "    and (cafe_id = null or cafe_id = '' or ', ' + cafe_id + ', ' like '%" & ", " & cafe_id & ", " & "%') "
	End If
	sql = sql & " order by notice_seq desc "

	rs2.Open Sql, conn, 3, 1

	If Not rs2.eof Then
		i = 1
		Do Until rs2.eof
			cafe_id = rs2("cafe_id")
			If cafe_id = "" Then
				cafe_name = "전체사랑방"
			Else

				arrCafe = Split(cafe_id, ",")

				For i = 0 To ubound(arrCafe)
					cafe = Trim(arrCafe(i))
					If i = 0 then
						cafe_name = getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
					Else
						cafe_name = cafe_name & ", " & getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
					End If
				Next
			End If
			cafe_name = rmid(cafe_name, 10, "..")
			subject = rs2("subject")
			If isnull(subject) Or isempty(subject) Or Len(Trim(subject)) = 0 Then
				subject = "제목없음"
			End if
			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><img src="/cafe/skin/img/btn/btn_notice.png" /></td>
									<td><a href="javascript: goView('<%=rs2("notice_seq")%>')" title="<%=subject_s%>"><%=subject%></a></td>
									<td class="algC"><%=rs2("agency")%></td>
									<td class="algC"><%=cafe_name%></td>
									<td class="algC"><%=rs2("view_cnt")%></td>
									<td class="algC"><%=rs2("suggest_cnt")%></td>
									<td class="algC"><%=rs2("credt_txt")%></td>
								</tr>
<%
			rs2.MoveNext
		Loop
	End If

	rs2.close
	Set rs2 = nothing

	If Not rs.EOF Then
		Do Until rs.EOF 
			comment_cnt = rs("comment_cnt")
			cafe_id = rs("cafe_id")
			If cafe_id = "" Then
				cafe_name = "전체사랑방"
			Else

				arrCafe = Split(cafe_id, ",")

				For i = 0 To ubound(arrCafe)
					cafe = Trim(arrCafe(i))
					If i = 0 then
						cafe_name = getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
					Else
						cafe_name = cafe_name & ", " & getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
					End If
				Next
			End If
			cafe_name = rmid(cafe_name, 10, "..")
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
									<td class="algC"><%=if3(rs("level_num")="0",rs("notice_num"),"")%></td>
									<td>
<%
			If rs("level_num") > "0" Then
%>
										<img src="/cafe/skin/img/btn/re.gif" width="<%=rs("level_num")*10%>" height="0">
										<img src="/cafe/skin/img/btn/re.png" />
<%
			End If
%>
										<a href="javascript: goView('<%=rs("notice_seq")%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
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
									<td class="algC"><%=rs("agency")%></td>
									<td class="algC"><%=cafe_name%></td>
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
									<td colspan="100">등록된 글이 없습니다.</td>
								</tr>
<%
	End If

	rs.close
	Set rs = nothing
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
						<button class="btn btn_c_a btn_n" type="button" onclick="location.href='/cafe/skin/notice_write.asp'">글쓰기</button>
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


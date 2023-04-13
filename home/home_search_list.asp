<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
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
<!-- 달력 시작 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd',
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		showMonthAfterYear: true,
		yearSuffix: '년'
	});

	$( function() {
		$("#sch_st_date").datepicker();
		$("#sch_ed_date").datepicker();
	} );
</script>
<!-- 달력 끝 -->
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
<%
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "" Then
			kword = "   and (subject like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = "   and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	sch_term    = Request("sch_term")
	sch_st_date = Request("sch_st_date")
	sch_ed_date = Request("sch_ed_date")
	sch_board   = Request("sch_board")

	Select Case sch_term
		Case "DAY"
			kword = kword & "   and credt between DATEADD(DAY, -1, GETDATE()) and getdate() "
		Case "WEK"
			kword = kword & "   and credt between DATEADD(DAY, -7, GETDATE()) and getdate() "
		Case "MNT"
			kword = kword & "   and credt between DATEADD(MM, -1, GETDATE()) and getdate() "
		Case "HYR"
			kword = kword & "   and credt between DATEADD(MM, -6, GETDATE()) and getdate() "
		Case "YER"
			kword = kword & "   and credt between DATEADD(YY, -1, GETDATE()) and getdate() "
		Case "DIN"
			sch_st_date = Request("sch_st_date")
			sch_ed_date = Request("sch_ed_date")
			kword = kword & "   and credt between '" & sch_st_date & "' and '" & sch_ed_date & "' "
	End Select

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select menu_type                                            "
	sql = sql & "       ,menu_name                                            "
	sql = sql & "       ,menu_seq                                             "
	sql = sql & "       ,hidden_yn                                            "
	sql = sql & "   from cf_menu                                              "
	sql = sql & "  where cafe_id = 'home'                          "
	sql = sql & "    and hidden_yn = 'N'                                      "
	sql = sql & "    and read_auth is not null                                "
	sql = sql & "    and read_auth <= '" & cafe_mb_level & "'                 "
	sql = sql & "    and menu_type in ('album','board','job','sale','notice','nsale','story') "
	If sch_board <> "" Then
	sql = sql & "    and menu_seq = '" & sch_board & "'                       "
	End If
	Rs.Open sql, conn, 3, 1

	sqlSub = ""
	sqlSub = sqlSub & "         select 'notice' as menu_type "
	sqlSub = sqlSub & "               ,0 as no               "
	sqlSub = sqlSub & "               ,notice_seq as com_seq "
	sqlSub = sqlSub & "               ,notice_num as com_num "
	sqlSub = sqlSub & "               ,subject               "
	sqlSub = sqlSub & "               ,agency                "
	sqlSub = sqlSub & "               ,view_cnt              "
	sqlSub = sqlSub & "               ,comment_cnt           "
	sqlSub = sqlSub & "               ,suggest_cnt           "
	sqlSub = sqlSub & "               ,credt                 "
	sqlSub = sqlSub & "               ,menu_seq              "
	sqlSub = sqlSub & "           from cf_notice             "
	If cafe_ad_level = "10" Then ' 글쓰기 권한
	sqlSub = sqlSub & "          where 1 = 1                 "
	Else
	sqlSub = sqlSub & "          where (cafe_id = null or cafe_id = '' or ', ' + cafe_id + ', ' like '%, " & cafe_id & ", %') "
	End If
	sqlSub = sqlSub & kword

	Do Until Rs.eof
		menu_type = Rs("menu_type")
		menu_name = Rs("menu_name")
		menu_seq  = Rs("menu_seq")
		hidden_yn = Rs("hidden_yn")

		sqlSub = sqlSub & "          union all                                                "
		sqlSub = sqlSub & "         select '" & menu_type & "' as menu_type                   "
		sqlSub = sqlSub & "               ,1 as no                                            "
		sqlSub = sqlSub & "               ,b" & menu_seq & "." & menu_type & "_seq as com_seq "
		sqlSub = sqlSub & "               ,b" & menu_seq & "." & menu_type & "_num as com_num "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".subject                          "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".agency                           "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".view_cnt                         "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".comment_cnt                      "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".suggest_cnt                      "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".credt                            "
		sqlSub = sqlSub & "               ,b" & menu_seq & ".menu_seq                         "
		sqlSub = sqlSub & "           from cf_" & menu_type & " b" & menu_seq & "             "
		sqlSub = sqlSub & "          where cafe_id = '" & cafe_id & "'                        "
		sqlSub = sqlSub & "            and menu_seq = '" & menu_seq & "'                      "
		sqlSub = sqlSub & kword

		Rs.MoveNext
	Loop
	Rs.close

	sql = ""
	sql = sql & " select count(com_seq) cnt        "
	sql = sql & "           from ( "
	sql = sql & sqlSub
	sql = sql & "                ) aa "
	rs.Open sql, conn, 3, 1
	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	sql = ""
	sql = sql & " select convert(varchar(10), bb.credt, 120) as credt_txt "
	sql = sql & "       ,bb.*                              "
	sql = sql & "   from (select row_number() over( order by credt desc, menu_seq asc, com_seq asc) as rownum "
	sql = sql & "               ,aa.*                              "
	sql = sql & "           from ( "
	sql = sql & sqlSub
	sql = sql & "                ) aa "
	sql = sql & "        ) bb "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & " "
	sql = sql & "  order by credt desc, menu_seq asc, com_seq asc "
	rs.Open sql, conn, 3, 1

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) Then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If
%>
			<script>
				function MovePage(page, gvTarget) {
					var f = document.search_form;
					f.page.value = page;
					f.action = "home_search_list.asp";
					f.target = gvTarget;
					f.submit();
				}
				function goView(com_type, com_seq, no, gvTarget) {
					var f = document.search_form;
					f.album_seq.value  = com_seq;
					f.board_seq.value  = com_seq;
					f.job_seq.value    = com_seq;
					f.sale_seq.value   = com_seq;
					f.notice_seq.value = com_seq;

					if (no == 0) {
						f.action = "notice_view.asp"
						f.target = gvTarget;
					}
					else {
						f.action = com_type + "_view.asp";
						f.target = gvTarget;
					}
					f.submit()
				}

				function goSearch(gvTarget) {
					var f = document.search_form;
					f.page.value = 1;
					f.action = "home_search_list.asp";
					f.target = gvTarget;
					f.submit();
				}

				function setTerm(obj) {
					if (obj.value == "DIN")
					{
						$('#sch_st_date').css("display","block");
						$('#sch_ed_date').css("display","block");
					}
					else {
						$('#sch_st_date').attr("value","");
						$('#sch_ed_date').attr("value","");
						$('#sch_st_date').css("display","none");
						$('#sch_ed_date').css("display","none");
					}
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2">통합검색 결과</h2>
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						총 <strong><%=FormatNumber(RecordCount,0)%></strong>건의 글이 있습니다.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1, '<%=session("ctTarget")%>')">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="album_seq" value="<%=com_seq%>">
						<input type="hidden" name="board_seq" value="<%=com_seq%>">
						<input type="hidden" name="job_seq" value="<%=com_seq%>">
						<input type="hidden" name="sale_seq" value="<%=com_seq%>">
						<input type="hidden" name="notice_seq" value="<%=com_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="com_seq">
						<select id="sch_term" name="sch_term" class="sel w_auto" onChange="setTerm(this)">
							<option value="">전체기간</option>
							<%=makeComboCD("sch_term", sch_term)%>
						</select>
						<input type="text" id="sch_st_date" name="sch_st_date" value="<%=sch_st_date%>" class="inp w100p" readonly />
						<input type="text" id="sch_ed_date" name="sch_ed_date" value="<%=sch_ed_date%>" class="inp w100p" readonly />
						<select id="sch_board" name="sch_board" class="sel w_auto">
							<option value="">전체게시판</option>
<%
	Set leftRs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select menu_type                                            "
	sql = sql & "       ,menu_name                                            "
	sql = sql & "       ,menu_seq                                             "
	sql = sql & "       ,hidden_yn                                            "
	sql = sql & "   from cf_menu                                              "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                          "
	sql = sql & "    and hidden_yn = 'N'                                      "
	sql = sql & "    and write_auth is not null                               "
	sql = sql & "    and write_auth <= '" & cafe_mb_level & "'                "
	sql = sql & "    and menu_type in ('album','board','job','sale','notice') "
	leftRs.Open sql, conn, 3, 1

	Do Until leftRs.eof
		left_menu_type = leftRs("menu_type")
		left_menu_name = leftRs("menu_name")
		left_menu_seq  = leftRs("menu_seq")
		left_hidden_yn = leftRs("hidden_yn")
		left_menu_name = Replace(left_menu_name, " & amp;"," & ")
%>
							<option value="<%=left_menu_seq%>" <%=if3(CStr(left_menu_seq)=CStr(sch_board),"selected","")%>><%=left_menu_name%></option>
<%
		leftRs.MoveNext
	Loop
	leftRs.close
%>
						</select>
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
	If Not rs.EOF Then
		Do Until rs.EOF
			comment_cnt = rs("comment_cnt")
			subject = rs("subject")
			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End if

			subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><%=rs("com_num")%></td>
									<td>
										<a href="javascript: goView('<%=rs("menu_type")%>', '<%=rs("com_seq")%>', '<%=rs("no")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
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
									<td colspan="6" class="td_nodata">검색된 글이 없습니다.</td>
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
				</div>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>

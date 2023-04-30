<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckCafeMember(cafe_id)
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
<!-- 달력 시작 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd' //달력 날짜 형태
		,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
		,changeYear: true //option값 년 선택 가능
		,changeMonth: true //option값  월 선택 가능                
		,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
		,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
		,buttonImageOnly: true //버튼 이미지만 깔끔하게 보이게함
		,buttonText: "선택" //버튼 호버 텍스트              
		,yearSuffix: "년" //달력의 년도 부분 뒤 텍스트
		,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
		,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
		,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 텍스트
		,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip
		,minDate: "-5Y" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		,maxDate: "+5y" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)  
	});

	$( function() {
		$("#sch_st_date").datepicker();
		$("#sch_ed_date").datepicker();
	} );
</script>
<!-- 달력 끝 -->
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

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	If sch_word <> "" then
		If sch_type = "" Then
			schStr = "   and (subject like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			schStr = "   and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		schStr = ""
	End If

	sch_term    = Request("sch_term")
	sch_st_date = Request("sch_st_date")
	sch_ed_date = Request("sch_ed_date")
	sch_board   = Request("sch_board")

	Select Case sch_term
		Case "DAY"
			schDate = "       ,convert(varchar(10), DATEADD(DAY, -1, GETDATE()), 120) as sch_st_date, convert(varchar(10), GETDATE(), 120) as sch_ed_date "
			schStr = schStr & "   and credt between DATEADD(DAY, -1, GETDATE()) and getdate() "
		Case "WEK"
			schDate = "       ,convert(varchar(10), between DATEADD(DAY, -7, GETDATE()), 120) as sch_st_date, convert(varchar(10), GETDATE(), 120) as sch_ed_date "
			schStr = schStr & "   and credt between DATEADD(DAY, -7, GETDATE()) and getdate() "
		Case "MNT"
			schDate = "       ,convert(varchar(10), DATEADD(MM, -1, GETDATE()), 120) as sch_st_date, convert(varchar(10), GETDATE(), 120) as sch_ed_date "
			schStr = schStr & "   and credt between DATEADD(MM, -1, GETDATE()) and getdate() "
		Case "HYR"
			schDate = "       ,convert(varchar(10), DATEADD(MM, -6, GETDATE()), 120) as sch_st_date, convert(varchar(10), GETDATE(), 120) as sch_ed_date "
			schStr = schStr & "   and credt between DATEADD(MM, -6, GETDATE()) and getdate() "
		Case "YER"
			schDate = "       ,convert(varchar(10), DATEADD(YY, -1, GETDATE()), 120) as sch_st_date, convert(varchar(10), GETDATE(), 120) as sch_ed_date "
			schStr = schStr & "   and credt between DATEADD(YY, -1, GETDATE()) and getdate() "
		Case "DIN"
			sch_st_date = Request("sch_st_date")
			sch_ed_date = Request("sch_ed_date")
			schDate = "       ,'" & sch_st_date & "' as sch_st_date, '" & sch_ed_date & "' as sch_ed_date "
			schStr = schStr & "   and credt between '" & sch_st_date & "' and '" & sch_ed_date & "' "
		Case Else
			schDate = "       ,null as sch_st_date, null as sch_ed_date "
	End Select

	RecordCount = 0 ' 자료가 없을때
	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	If schStr <> "" Then
		sql = ""
		sql = sql & " select menu_type                                            "
		sql = sql & "       ,menu_name                                            "
		sql = sql & "       ,menu_seq                                             "
		sql = sql & "       ,hidden_yn                                            "
		sql = sql & schDate
		sql = sql & "   from cf_menu                                              "
		sql = sql & "  where cafe_id = '" & cafe_id & "'                          "
		sql = sql & "    and hidden_yn = 'N'                                      "
		sql = sql & "    and read_auth is not null                                "
		sql = sql & "    and read_auth <= '" & cafe_mb_level & "'                 "
		sql = sql & "    and menu_type in ('album','board','job','sale','notice') "
		If sch_board <> "" Then
		sql = sql & "    and menu_seq = '" & sch_board & "'                       "
		End If
		Rs.Open sql, conn, 3, 1

		subSql = ""
	'	subSql = subSql & "         select 'notice' as menu_type "
	'	subSql = subSql & "               ,0 as no               "
	'	subSql = subSql & "               ,notice_seq as com_seq "
	'	subSql = subSql & "               ,notice_num as com_num "
	'	subSql = subSql & "               ,subject               "
	'	subSql = subSql & "               ,agency                "
	'	subSql = subSql & "               ,view_cnt              "
	'	subSql = subSql & "               ,comment_cnt           "
	'	subSql = subSql & "               ,suggest_cnt           "
	'	subSql = subSql & "               ,credt                 "
	'	subSql = subSql & "               ,menu_seq              "
	'	subSql = subSql & "           from cf_notice             "
	'	If cafe_ad_level = "10" Then ' 글쓰기 권한
	'	subSql = subSql & "          where 1 = 1                 "
	'	Else
	'	subSql = subSql & "          where (cafe_id = null or cafe_id = '' or ', ' + cafe_id + ', ' like '%, " & cafe_id & ", %') "
	'	End If
	'	subSql = subSql & schStr

		If Not rs.eof Then
			i = 1
			Do Until Rs.eof
				menu_type   = Rs("menu_type")
				menu_name   = Rs("menu_name")
				menu_seq    = Rs("menu_seq")
				hidden_yn   = Rs("hidden_yn")
				sch_st_date = Rs("sch_st_date")
				sch_ed_date = Rs("sch_ed_date")

				If i > 1 Then
				subSql = subSql & "          union all                                                "
				End If
				subSql = subSql & "         select '" & menu_type & "' as menu_type                   "
				subSql = subSql & "               ,1 as no                                            "
				subSql = subSql & "               ,b" & menu_seq & "." & menu_type & "_seq as com_seq "
				subSql = subSql & "               ,b" & menu_seq & "." & menu_type & "_num as com_num "
				subSql = subSql & "               ,b" & menu_seq & ".subject                          "
				subSql = subSql & "               ,b" & menu_seq & ".agency                           "
				subSql = subSql & "               ,b" & menu_seq & ".view_cnt                         "
				subSql = subSql & "               ,b" & menu_seq & ".comment_cnt                      "
				subSql = subSql & "               ,b" & menu_seq & ".suggest_cnt                      "
				subSql = subSql & "               ,b" & menu_seq & ".credt                            "
				subSql = subSql & "               ,b" & menu_seq & ".menu_seq                         "
				subSql = subSql & "           from cf_" & menu_type & " b" & menu_seq & "             "
				subSql = subSql & "          where cafe_id = '" & cafe_id & "'                        "
				subSql = subSql & "            and menu_seq = '" & menu_seq & "'                      "
				subSql = subSql & schStr

				i = 1 + 1
				Rs.MoveNext
			Loop

			sql = ""
			sql = sql & " select count(com_seq) cnt "
			sql = sql & "   from ( "
			sql = sql & subSql
			sql = sql & "        ) aa "
			rs2.Open sql, conn, 3, 1

			If Not rs2.EOF Then
				RecordCount = rs2("cnt")
			End If
			rs2.close

			schSql = ""
			schSql = schSql & " select bb.*                                                                                 "
			schSql = schSql & "   from (select row_number() over( order by credt desc, menu_seq asc, com_seq asc) as rownum "
			schSql = schSql & "               ,aa.*                                                                         "
			schSql = schSql & "           from (                                                                            "
			schSql = schSql & subSql
			schSql = schSql & "                ) aa                                                                         "
			schSql = schSql & "        ) bb                                                                                 "
			schSql = schSql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & "                   "
			schSql = schSql & "  order by credt desc, menu_seq asc, com_seq asc                                             "
		End If
		rs.close
	End If

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) Then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If
%>
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2">통합검색 결과</h2>
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						총 <strong><%=FormatNumber(RecordCount,0)%></strong>건의 글이 있습니다.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1, '<%=session("ctTarget")%>')">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="cafe_sch" value="Y">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="album_seq" value="<%=com_seq%>">
						<input type="hidden" name="board_seq" value="<%=com_seq%>">
						<input type="hidden" name="job_seq" value="<%=com_seq%>">
						<input type="hidden" name="sale_seq" value="<%=com_seq%>">
						<input type="hidden" name="notice_seq" value="<%=com_seq%>">
						<input type="hidden" name="com_seq">
						<select id="sch_term" name="sch_term" class="sel w100p" onChange="setTerm(this)">
							<option value="">전체기간</option>
							<%=GetMakeCDCombo("sch_term", sch_term)%>
						</select>
						<input type="text" id="sch_st_date" name="sch_st_date" value="<%=sch_st_date%>" class="inp w100p" readonly />
						<input type="text" id="sch_ed_date" name="sch_ed_date" value="<%=sch_ed_date%>" class="inp w100p" readonly />
						<select id="sch_board" name="sch_board" class="sel w100p">
							<option value="">전체게시판</option>
<%
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
	rs2.Open sql, conn, 3, 1

	Do Until rs2.eof
		left_menu_type = rs2("menu_type")
		left_menu_name = rs2("menu_name")
		left_menu_seq  = rs2("menu_seq")
		left_hidden_yn = rs2("hidden_yn")
		left_menu_name = Replace(left_menu_name, " & amp;"," & ")
%>
							<option value="<%=left_menu_seq%>" <%=if3(CStr(left_menu_seq)=CStr(sch_board),"selected","")%>><%=left_menu_name%></option>
<%
		rs2.MoveNext
	Loop
	rs2.close
%>
						</select>
						<select id="sch_type" name="sch_type" class="sel w_auto">
							<option value="">전체</option>
							<option value="subject" <%=if3(sch_type="subject","selected","")%>>제목</option>
							<option value="agency" <%=if3(sch_type="agency","selected","")%>>글쓴이</option>
							<option value="contents" <%=if3(sch_type="contents","selected","")%>>내용</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w100p">
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
	If RecordCount > 0 Then
		rs2.Open schSql, conn, 3, 1
		If Not rs2.EOF Then
			Do Until rs2.EOF
				comment_cnt = rs2("comment_cnt")
				subject = rs2("subject")
				If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
					subject = "제목없음"
				End If

				subject_s = rmid(subject, 40, "..")
%>
								<tr>
									<td class="algC"><%=rs2("com_num")%></td>
									<td>
										<a href="javascript: goView('<%=rs2("menu_type")%>', '<%=rs2("com_seq")%>', '<%=rs2("no")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%>&nbsp;</a>
<%
				If comment_cnt > "0" Then
%>
										(<%=comment_cnt%>)
<%
				End If
%>
<%
				If CDate(DateAdd("d",2,rs2("reg_date"))) >= Date Then
%>
										<img src="/cafe/img/btn/new.png" />
<%
				End If
%>
									</td>
									<td class="algC"><%=rs2("agency")%></td>
									<td class="algC"><%=rs2("view_cnt")%></td>
									<td class="algC"><%=rs2("suggest_cnt")%></td>
									<td class="algC"><%=rs2("reg_date")%></td>
								</tr>
<%
				rs2.MoveNext
			Loop
		Else
%>
								<tr>
									<td colspan="6" class="td_nodata">검색된 글이 없습니다.</td>
								</tr>
<%
		End If
		rs2.close
		Set rs2 = Nothing
	Else
%>
								<tr>
									<td colspan="6" class="td_nodata">검색된 글이 없습니다.</td>
								</tr>
<%
	End If
%>
							</tbody>
						</table>
						</form>
					</div>
<!--#include virtual="/cafe/cafe_page_inc.asp"-->
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
		f.action = "cafe_search_list.asp";
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
		f.action = "cafe_search_list.asp";
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
</html>

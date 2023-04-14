<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkManager(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
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
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
<%
	End IF
%>
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
			kword = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(cafe_id) cnt "
	sql = sql & "   from cf_waste_sale "
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
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10),credt,120) as credt_txt "
	sql = sql & "   from (select row_number() over( order by credt desc) as rownum "
	sql = sql & "              ,* "
	sql = sql & "          from cf_waste_sale "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq = '" & menu_seq & "' "
	sql = sql & "    and step_num = 0 "
	sql = sql & "    and top_yn <> 'Y' "
	sql = sql & kword
	sql = sql & "       ) a "
	sql = sql & " where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & " "
	sql = sql & "  order by sale_seq desc "
	rs.Open sql, conn, 3, 1

	' 전체 페이지 수 얻기
	If RecordCount/pagesize = Int(RecordCount/pagesize) then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If
%>
			<script>
				function MovePage(page, gvTarget) {
					var f = document.search_form;
					f.page.value = page;
					f.target = gvTarget;
					f.action = "waste_sale_list.asp";
					f.submit();
				}

				function goView(sale_seq, gvTarget) {
					var f = document.search_form;
					f.sale_seq.value = sale_seq;
					f.target = gvTarget;
					f.action = "waste_sale_view.asp";
					f.submit();
				}

				function goSearch(gvTarget) {
					var f = document.search_form;
					f.page.value = 1;
					f.target = gvTarget;
					f.submit();

				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><font color="red"><%=menu_name%></font></h2>&nbsp;총 <%=FormatNumber(RecordCount,0)%>건의 매물이 있습니다.
				</div>
				<div class="search_box_flex">
					<div class="search_box_flex_item">
						총 <%=FormatNumber(RecordCount,0)%>건의 매물이 있습니다.
					</div>
					<div class="search_box_flex_item">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1, '<%=session("ctTarget")%>')">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="sale_seq">
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
								<col class="w10" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">번호</th>
									<th scope="col">매물제목</th>
									<th scope="col">소재지</th>
									<th scope="col">목적 및 용도</th>
									<th scope="col">면적(평)</th>
									<th scope="col">금액</th>
									<th scope="col">등록일</th>
									<th scope="col">등록자</th>
								</tr>
							</thead>
							<tbody>
<%
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
	sql = sql & "   from cf_waste_sale "
	sql = sql & "  where cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and top_yn = 'Y' "
	sql = sql & " order by sale_seq desc "

	rs2.Open Sql, conn, 3, 1

	If Not rs2.eof Then
		i = 1
		Do Until rs2.eof
%>
								<tr>
									<td class="algC"><img src="/cafe/skin/img/btn/btn_notice.png" /></td>
									<td><a href="javascript: goView('<%=rs2("sale_seq")%>', '<%=session("ctTarget")%>')"><%=subject%></a></td>
									<td class="algC"><%=rs2("location")%></td>
									<td class="algC"><%=rs2("purpose")%></td>
									<td class="algC"><%=rs2("area")%></td>
									<td class="algC"><%=rs2("price")%></td>
									<td class="algC"><%=rs2("credt_txt")%></td>
									<td class="algC"><%=rs2("agency")%><%=rs2("tel_no")%></td>
								</tr>
<%
			rs2.MoveNext
		Loop
	End If

	rs2.close
	Set rs2 = nothing

	If Not rs.EOF Then
		Do Until rs.eof
			subject = rs("subject")
			If isnull(subject) Or isempty(subject) Or Len(subject) = 0 Then
				subject = "제목없음"
			End if
			subject_s = rmid(subject, 35, "..")
%>
								<tr>
<%
			If rs("top_yn") = "Y" Then
%>
									<td class="algC"><img src="/cafe/skin/img/btn/btn_notice.png" /></td>
<%
			Else
%>
									<td class="algC"><%=rs("sale_num")%></td>
<%
			End If
%>
									<td>
<%
			If rs("level_num") > "0" Then
%>
										<img src="/cafe/skin/img/btn/re.gif" width="<%=rs("level_num")*10%>" height="0">
										<img src="/cafe/skin/img/btn/re.png" />
<%
			End If
%>
										<a href="javascript: goView('<%=rs("sale_seq")%>', '<%=session("ctTarget")%>')" title="<%=subject_s%>"><%=subject%></a>
<%
			If CDate(DateAdd("d",2,rs("credt_txt"))) >= Date Then
%>
										<img src="/cafe/skin/img/btn/new.png" />
<%
			End If
' 전화번호 없는 것 업데이트
' update t1                                              
'    set tel_no = phone                             
'    from (select ab.phone , aa.tel_no 
'            from cf_member ab                            
'                ,cf_sale aa                     
'           where ab.user_id = aa.user_id
'           and aa.tel_no is null) t1            
%>
									</td>
									<td class="algC"><%=rs("location")%></td>
									<td class="algC"><%=rs("purpose")%></td>
									<td class="algC"><%=rs("area")%></td>
									<td class="algC"><%=rs("price")%></td>
									<td class="algC"><%=rs("credt_txt")%></td>
									<td class="algC"><%=rs("agency")%><%If rs("tel_no") <> "" then%><br><%=rs("tel_no")%><%End if%></td>
<%
			rs.MoveNext
		Loop
	Else
%>
								<tr>
									<td colspan="8">등록된 글이 없습니다.</td>
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
						<button class="btn btn_c_a btn_n" type="button" onclick="<%=session("ctHref")%>location.href='/cafe/skin/sale_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
					</div>
<%
	End If
%>
				</div>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
<%
	End IF
%>
</body>
</html>

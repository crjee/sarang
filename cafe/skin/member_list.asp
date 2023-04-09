<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)
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

	PageSize = Request("PageSize")
	If PageSize = "" Then PageSize = 20

	page = Request("page")
	If page = "" then page = 1

	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	If sch_word <> "" then
		If sch_type = "all" Then
			kword = " and (mi.agency like '%" & sch_word & "%' or mi.kname like '%" & sch_word & "%' or mi.phone like '%" & sch_word & "%' or mi.mobile like '%" & sch_word & "%' or mi.addr1 like '%" & sch_word & "%' or mi.addr2 like '%" & sch_word & "%') "
		ElseIf sch_type = "agency" Then
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		ElseIf sch_type = "kname" Then
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		ElseIf sch_type = "phone" Then
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		ElseIf sch_type = "mobile" Then
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		ElseIf sch_type = "addr1" Then
			kword = " and (mi.addr1 like '%" & sch_word & "%' or mi.addr2 like '%" & sch_word & "%')"
		End If
	Else
		kword = ""
	End IF

	sort = Request("sort")
	If sort = "" then
		sort = "agency"
	End If

	ascdesc = Request("ascdesc")
	If ascdesc = "" then
		ascdesc = "asc"
	End if

	If ascdesc = "asc" then
		sort_chr = "↓"
	Else
		sort_chr = "↑"
	End If

	oword = " Order By " & sort & " " & ascdesc

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select  "
	sql = sql & "        cm.user_id "
	sql = sql & "       ,mi.agency "
	sql = sql & "       ,mi.kname "
	sql = sql & "       ,mi.mobile "
	sql = sql & "       ,mi.phone "
	sql = sql & "       ,mi.fax "
	sql = sql & "       ,mi.interphone "
	sql = sql & "       ,mi.license "
	sql = sql & "       ,mi.addr1 "
	sql = sql & "       ,mi.addr2 "
	sql = sql & "       ,mi.picture "
	sql = sql & "   from cf_cafe_member cm "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id "
	sql = sql & "  where cm.cafe_id = '" & cafe_id & "' "
	sql = sql & kword
	sql = sql & oword
	rs.Open Sql, conn, 3, 1
	rs.PageSize = PageSize
	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs.recordcount
	End If

	' 전체 페이지 수 얻기
	If RecordCount/PageSize = Int(RecordCount/PageSize) then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
		rs.AbsolutePage = page
		PageNum = rs.PageCount
	End If
%>
			<script>
				function MovePage(page) {
					document.all.page.value = page;
					document.search_form.submit();
				}

				function goSearch() {
					document.all.page.value = 1;
					document.search_form.submit();
				}

				function goSort(field) {

					if (document.all.sort.value == field) {
						if (document.all.ascdesc.value == "asc")
							document.all.ascdesc.value = "desc";
						else
							document.all.ascdesc.value = "asc";
					}
					else {
						document.all.ascdesc.value = "asc";
					}

					document.all.sort.value = field;
					search_form.submit();
				}
				function Rsize(img, ww, hh, aL) {
					var tt = imgRsize(img, ww, hh);
					if (img.width > ww || img.height > hh) {

						// 가로나 세로크기가 제한크기보다 크면
						img.width = tt[0];
						// 크기조정
						img.height = tt[1];
						img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

						if (aL) {
							// 자동링크 on
							img.onclick = function() {
								wT = Math.ceil((screen.width - tt[2])/2.6);
								// 클라이언트 중앙에 이미지위치.
								wL = Math.ceil((screen.height - tt[3])/2.6);
								var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
								var doc = mm.document;
								try{
									doc.body.style.margin = 0;
									// 마진제거
									doc.body.style.cursor = "hand";
									doc.title = "원본이미지";
								}
								catch(err) {
								}
								finally {
								}

							}
							img.style.cursor = "hand";
						}
					}
					else {
							img.onclick = function() {
								alert("현재이미지가 원본 이미지입니다.");
							}
					}
				}

				function imgRsize(img, rW, rH) {
					var iW = img.width;
					var iH = img.height;
					var g = new Array;
					if (iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
						g[0] = iW;
						g[1] = iH;
					}
					else {
						if (img.width > img.height) { // 원크기 가로가 세로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						else if (img.width < img.height) { //원크기의 세로가 가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
						else {
							g[0] = rW;
							g[1] = rH;
						}
						if (g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						if (g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
					}

					g[2] = img.width; // 원사이즈 가로
					g[3] = img.height; // 원사이즈 세로

					return g;
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%>&nbsp;총 <%=FormatNumber(RecordCount,0)%>건의 정보가 있습니다.</h2>
				</div>
				<div class="">
					<div class="search_box algR">
						<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<input type="hidden" name="sort" value="<%=sort%>">
						<input type="hidden" name="ascdesc" value="<%=ascdesc%>">
						<select id="sch_type" name="sch_type" class="sel w100p">
							<option value="all">전체</option>
								<option value="all">전체</option>
								<option value="agency" <%=if3(sch_type="agency","selected","")%>>업소명</option>
								<option value="kname" <%=if3(sch_type="kname","selected","")%>>회원명</option>
								<option value="phone" <%=if3(sch_type="phone","selected","")%>>전화번호</option>
								<option value="mobile" <%=if3(sch_type="mobile","selected","")%>>핸드폰번호</option>
								<option value="addr1" <%=if3(sch_type="addr1","selected","")%>>주소</option>
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
						<table class="tb_fixed">
							<colgroup>
								<%If instr(list_info, "agency") then%>     <col class="w10" /><%End if%>
								<%If instr(list_info, "kname") then%>      <col class="w10" /><%End if%>
								<%If instr(list_info, "license") then%>    <col class="w10" /><%End if%>
								<%If instr(list_info, "phone") then%>      <col class="w10" /><%End if%>
								<%If instr(list_info, "mobile") then%>     <col class="w10" /><%End if%>
								<%If instr(list_info, "fax") then%>        <col class="w10" /><%End if%>
								<%If instr(list_info, "interphone") then%> <col class="w10" /><%End if%>
								<%If instr(list_info, "addr") then%>       <col class="w_auto" /><%End if%>
							</colgroup>
							<thead>
								<tr>
								<%If instr(list_info, "agency") then%>     <th scope="col"><a href="javascript:goSort('agency')">상호</a><%=if3(sort="agency",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "kname") then%>      <th scope="col"><a href="javascript:goSort('kname')">대표자</a><%=if3(sort="kname",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "license") then%>    <th scope="col"><a href="javascript:goSort('license')">허가번호</a><%=if3(sort="license",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "phone") then%>      <th scope="col"><a href="javascript:goSort('phone')">전화번호</a><%=if3(sort="phone",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "mobile") then%>     <th scope="col"><a href="javascript:goSort('mobile')">핸드폰번호</a><%=if3(sort="mobile",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "fax") then%>        <th scope="col"><a href="javascript:goSort('fax')">팩스번호</a><%=if3(sort="fax",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "interphone") then%> <th scope="col"><a href="javascript:goSort('interphone')">내선번호</a><%=if3(sort="interphone",sort_chr,"")%></th><%End if%>
								<%If instr(list_info, "addr") then%>       <th><a href="javascript:goSort('addr1')">주소</a><%=if3(sort="addr1",sort_chr,"")%></th><%End if%>
								</tr>
							</thead>
							<tbody>
<%
	i = 1
	j = 0
	uploadUrl = ConfigAttachedFileURL & "picture/"
	If Not rs.EOF Then
		Do Until rs.EOF Or i > rs.PageSize
%>
								<tr>
<%
			If instr(list_info, "agency") Or instr(list_info, "picture") Then
%>
									<td><%=rs("agency")%>
<%
				If rs("picture") <> "" Then
%>
										<img src="<%=uploadUrl & rs("picture")%>" id="profile" name="profile" onLoad="Rsize(this, 20, 20, 1)" style="cursor:hand;border:1px solid #e5e5e5;" title="중개업소사진">
<%
				End if
%>
									</td>
<%
			End If
%>
									<%If instr(list_info, "kname") then%>      <td class="algC"><%=rs("kname")%></td><%End if%>
									<%If instr(list_info, "license") then%>    <td class="algC"><%=rs("license")%></td><%End if%>
									<%If instr(list_info, "phone") then%>      <td class="algC"><%=rs("phone")%></td><%End if%>
									<%If instr(list_info, "mobile") then%>     <td class="algC"><%=rs("mobile")%></td><%End if%>
									<%If instr(list_info, "fax") then%>        <td class="algC"><%=rs("fax")%></td><%End if%>
									<%If instr(list_info, "interphone") then%> <td class="algC"><%=rs("interphone")%></td><%End if%>
									<%If instr(list_info, "addr") then%>       <td><%=rs("addr1")%> <%=rs("addr2")%></td><%End if%>
								</tr>
<%
			i = i + 1
			rs.MoveNext

			If level_num = 0 Then
				j = j - 1
			End If
%>
								</tr>
<%
		Loop
	End If
	rs.close
	Set rs = nothing
%>
							</tbody>
						</table>
						</form>
					</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
				</div>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


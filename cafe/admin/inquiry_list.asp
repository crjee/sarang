<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	PageSize = Request("PageSize")
	If PageSize = "" Then PageSize = 20

	page = Request("page")
	If page = "" then page = 1

	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	If sch_type <> "" And sch_word <> "" then
		If sch_type = "l" Then
			kword = kword & " and (subject like '%" & sch_word & "%' or inq_cn like '%" & sch_word & "%') "
		Else
			kword = kword & " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = kword & ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select inq_id            "
	sql = sql & "       ,inq_se_cd         "
	sql = sql & "       ,co_nm             "
	sql = sql & "       ,pic_flnm          "
	sql = sql & "       ,mbl_telno         "
	sql = sql & "       ,eml_addr          "
	sql = sql & "       ,subject           "
	sql = sql & "       ,inq_cn            "
	sql = sql & "       ,atch_data_file_nm "
	sql = sql & "       ,ans_cn            "
	sql = sql & "       ,inq_prcs_cd       "
	sql = sql & "       ,creid             "
	sql = sql & "       ,credt             "
	sql = sql & "       ,modid             "
	sql = sql & "       ,moddt             "
	sql = sql & "       ,convert(varchar,credt,120) credt_txt "
	sql = sql & "   from cf_inquiry "
	sql = sql & "  where 1=1 "
	sql = sql & kword
	sql = sql & " order by inq_id desc "
	rs.open Sql, conn, 3, 1

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
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>회원 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>전체관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/admin/admin_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">광고/제휴 문의</h2>
			</div>
			<div class="adm_cont">
				<div class="search_box">

					<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="inq_id">
					<select id="sch_type" name="sch_type" class="sel w_auto">
						<option value="">전체</option>
						<option value="subject" <%=if3(sch_type="subject","selected","")%>>제목</option>
						<option value="inq_cn" <%=if3(sch_type="inq_cn","selected","")%>>내용</option>
					</select>
					<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w150p">
					<button type="button" class="btn btn_c_a btn_s" onclick="goSearch()">검색</button>
					</form>
				</div>
				<div class="tb tb_form_1">
					<table>
						<colgroup>
							<col class="w5" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="w_auto" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">문의구분</th>
								<th scope="col">회사명</th>
								<th scope="col">담당자이름</th>
								<th scope="col">담당자연락처</th>
								<th scope="col">담당자이메일주소</th>
								<th scope="col">제목</th>
								<th scope="col">요청일</th>
								<th scope="col">처리</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1

	If Not rs.EOF Then
		Do Until rs.EOF OR i > rs.PageSize
			inq_id            = rs("inq_id")
			inq_se_cd         = rs("inq_se_cd")
			co_nm             = rs("co_nm")
			pic_flnm          = rs("pic_flnm")
			mbl_telno         = rs("mbl_telno")
			eml_addr          = rs("eml_addr")
			subject           = rs("subject")
			inq_cn            = rs("inq_cn")
			atch_data_file_nm = rs("atch_data_file_nm")
			ans_cn            = rs("ans_cn")
			inq_prcs_cd       = rs("inq_prcs_cd")
			creid             = rs("creid")
			credt             = rs("credt")
			modid             = rs("modid")
			moddt             = rs("moddt")
			credt_txt         = rs("credt_txt")

			inq_se_cd_nm   = getCodeName("inq_se_cd", inq_se_cd)
			inq_prcs_cd_nm = getCodeName("inq_prcs_cd", inq_prcs_cd)
%>
							<tr>
								<td class="algC"><%=inq_id%></td>
								<td class="algC"><%=inq_se_cd_nm%></td>
								<td class="algC"><%=co_nm%></td>
								<td class="algC"><%=pic_flnm%></td>
								<td class="algC"><%=mbl_telno%></td>
								<td class="algC"><%=eml_addr%></td>
								<td><a href="javascript: goView('<%=rs("inq_id")%>')"><%=subject%></a></td>
								<td class="algC"><%=credt_txt%></td>
								<td class="algC"><%=inq_prcs_cd_nm%></td>
							</tr>
<%
			i = i + 1
			rs.MoveNext
		loop
	End If
	rs.close
	Set rs = nothing
	Set rs2 = nothing
%>
						</tbody>
					</table>
				</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
</body>
</html>
<script>
	function MovePage(page) {
		var f = document.search_form;
		f.page.value = page;
		f.action = "inquiry_list.asp";
		f.submit();
	}

	function goView(inq_id) {
		try{
			var f = document.search_form;
			f.inq_id.value = inq_id;
			f.action = "inquiry_view.asp";
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

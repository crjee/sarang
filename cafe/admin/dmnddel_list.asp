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
		If sch_type = "" Then
			kword = kword & " and (subject like '%" & sch_word & "%' or dmnd_cn like '%" & sch_word & "%') "
		Else
			kword = kword & " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = kword & ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select dm.dmnd_id           "
	sql = sql & "       ,dm.dmnd_se_cd        "
	sql = sql & "       ,dm.rqstr_flnm        "
	sql = sql & "       ,dm.mbl_telno         "
	sql = sql & "       ,dm.eml_addr          "
	sql = sql & "       ,dm.idcd_file_nm      "
	sql = sql & "       ,dm.co_nm             "
	sql = sql & "       ,dm.brct_file_nm      "
	sql = sql & "       ,dm.agt_idcd_file_nm  "
	sql = sql & "       ,dm.dlgt_file_nm      "
	sql = sql & "       ,dm.url_addr          "
	sql = sql & "       ,dm.subject           "
	sql = sql & "       ,dm.dmnd_cn           "
	sql = sql & "       ,dm.atch_data_file_nm "
	sql = sql & "       ,dm.dmnd_prcs_cd      "
	sql = sql & "       ,dm.dmnd_prcs_dt      "
	sql = sql & "       ,dm.creid             "
	sql = sql & "       ,dm.credt             "
	sql = sql & "       ,dm.modid             "
	sql = sql & "       ,dm.moddt             "
	sql = sql & "       ,convert(varchar,dm.credt,120) credt_txt "
	sql = sql & "   from cf_dmnddel dm "
	sql = sql & "  where 1=1 "
	sql = sql & kword
	sql = sql & " order by dmnd_id desc "
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
				<h2 class="h2">게시글 중단 요청</h2>
			</div>
			<div class="adm_cont">
				<div class="search_box">

					<form name="search_form" id="search_form" method="post" onsubmit="MovePage(1)">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="dmnd_id">
					<select id="sch_type" name="sch_type" class="sel w_auto">
						<option value="">전체</option>
						<option value="subject" <%=if3(sch_type="subject","selected","")%>>제목</option>
						<option value="dmnd_cn" <%=if3(sch_type="dmnd_cn","selected","")%>>내용</option>
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
								<th scope="col">요청구분</th>
								<th scope="col">이름/소속단체명</th>
								<th scope="col">휴대폰</th>
								<th scope="col">이메일주소</th>
								<th scope="col">제목</th>
								<th scope="col">첨부파일</th>
								<th scope="col">요청일</th>
								<th scope="col">처리</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1

	If Not rs.EOF Then
		Do Until rs.EOF OR i > rs.PageSize
			dmnd_id           = rs("dmnd_id")
			dmnd_se_cd        = rs("dmnd_se_cd")
			rqstr_flnm        = rs("rqstr_flnm")
			mbl_telno         = rs("mbl_telno")
			eml_addr          = rs("eml_addr")
			idcd_file_nm      = rs("idcd_file_nm")
			co_nm             = rs("co_nm")
			brct_file_nm      = rs("brct_file_nm")
			agt_idcd_file_nm  = rs("agt_idcd_file_nm")
			dlgt_file_nm      = rs("dlgt_file_nm")
			url_addr          = rs("url_addr")
			subject           = rs("subject")
			dmnd_cn           = rs("dmnd_cn")
			atch_data_file_nm = rs("atch_data_file_nm")
			dmnd_prcs_cd      = rs("dmnd_prcs_cd")
			dmnd_prcs_dt      = rs("dmnd_prcs_dt")
			creid             = rs("creid")
			credt             = rs("credt")
			modid             = rs("modid")
			moddt             = rs("moddt")
			credt_txt         = rs("credt_txt")

			dmnd_se_cd_nm = getCodeName("dmnd_se_cd", dmnd_se_cd)
			dmnd_prcs_cd_nm = getCodeName("dmnd_prcs_cd", dmnd_prcs_cd)
%>
							<tr>
								<td class="algC"><%=dmnd_id%></td>
								<td class="algC"><%=dmnd_se_cd_nm%></td>
								<td class="algC"><%=rqstr_flnm%>/<%=co_nm%></td>
								<td class="algC"><%=mbl_telno%></td>
								<td class="algC"><%=eml_addr%></td>
								<td><a href="javascript: goView('<%=rs("dmnd_id")%>')"><%=subject%></a></td>
								<td class="algC"><button type="button" class="btn f_awesome btn_file"><em>첨부파일</em></button></td>
								<td class="algC"><%=credt_txt%></td>
								<td class="algC"><%=dmnd_prcs_cd_nm%></td>
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
		f.action = "dmnddel_list.asp";
		f.submit();
	}

	function goView(dmnd_id) {
		try{
			var f = document.search_form;
			f.dmnd_id.value = dmnd_id;
			f.action = "dmnddel_view.asp";
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

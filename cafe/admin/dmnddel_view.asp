<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()
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
	<script src="/common/js/cafe.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>전체관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/admin/admin_left_inc.asp"-->
		</nav>
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	dmnd_id = Request("dmnd_id")

	Set rs = Server.CreateObject ("ADODB.Recordset")

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
	sql = sql & "  where dmnd_id = '" & dmnd_id & "' "
	rs.open Sql, conn, 3, 1

	If Not rs.eof Then
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
	End If
	rs.close
	Set rs = Nothing
%>
		<script type="text/javascript">
			function goList() {
				document.search_form.action = "dmnddel_list.asp";
				document.search_form.target = "_self"
				document.search_form.submit();
			}
			function goProcess() {
				document.search_form.action = "dmnddel_exec.asp"
				document.search_form.target = "hiddenfrm"
				document.search_form.submit();
			}
		</script>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">게시글 중단 요청 내용</h2>
			</div>
			<div class="btn_box view_btn">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="dmnd_id" value="<%=dmnd_id%>">
				<select id="dmnd_prcs_cd" name="dmnd_prcs_cd" class="sel w100p">
					<option value="">선택</option>
					<%=makeComboCD("dmnd_prcs_cd", dmnd_prcs_cd)%>
				</select>
				<button type="button" class="btn btn_c_n btn_n" onclick="goProcess()">처리</button>
				<button type="button" class="btn btn_c_n btn_n" onclick="goList()">목록</button>
				</form>
			</div>
			<div class="adm_cont">
				<div class="tb tb_form_1">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">요청구분</th>
								<td>
									<%=dmnd_se_cd_nm%>
								</td>
								<th scope="row">요청일시</th>
								<td>
									<%=credt%>
								</td>
							</tr>
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">
									<%=subject%>
								</td>
							</tr>
							<tr>
								<th scope="row">이름</th>
								<td>
									<%=rqstr_flnm%>
								</td>
								<th scope="row">연락처</th>
								<td>
									<%=mbl_telno%>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일 주소</th>
								<td>
									<%=eml_addr%>
								</td>
								<th scope="row">신분증 사본</th>
								<td>
<%
	If brct_file_nm <> "" Then
%>
									<a href="/download_exec.asp?menu_type=home&file_name=<%=idcd_file_nm%>" target="hiddenfrm" class="file">
									<img src="/cafe/skin/img/inc/file.png" /> <%=idcd_file_nm%></a>
<%
	End If
%>
								</td>
							</tr>
							<tr>
								<th scope="row">소속</th>
								<td>
									<%=co_nm%>
								</td>
								<th scope="row">사업자등록증</th>
								<td>
<%
	If brct_file_nm <> "" Then
%>
									<a href="/download_exec.asp?menu_type=home&file_name=<%=brct_file_nm%>" target="hiddenfrm" class="file">
									<img src="/cafe/skin/img/inc/file.png" /> <%=brct_file_nm%></a>
<%
	End If
%>
								</td>
							</tr>
							<tr>
								<th scope="row">대리인 신분증 사본</th>
								<td>
<%
	If agt_idcd_file_nm <> "" Then
%>
									<a href="/download_exec.asp?menu_type=home&file_name=<%=agt_idcd_file_nm%>" target="hiddenfrm" class="file">
									<img src="/cafe/skin/img/inc/file.png" /> <%=agt_idcd_file_nm%></a>
<%
	End If
%>
								</td>
								<th scope="row">위임장</th>
								<td>
<%
	If dlgt_file_nm <> "" Then
%>
									<a href="/download_exec.asp?menu_type=home&file_name=<%=dlgt_file_nm%>" target="hiddenfrm" class="file">
									<img src="/cafe/skin/img/inc/file.png" /> <%=dlgt_file_nm%></a>
<%
	End If
%>
								</td>
							</tr>
							<tr>
								<th scope="row">게시글 주소</th>
								<td colspan="3">
<%
	If url_addr <> "" Then
%>
									<a href="<%=url_addr%>" target="_blank"><%=url_addr%></a>
<%
	End If
%>
								</td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
								<td colspan="3">
<%
	If atch_data_file_nm <> "" Then
%>
									<a href="/download_exec.asp?menu_type=home&file_name=<%=atch_data_file_nm%>" target="hiddenfrm" class="file">
									<img src="/cafe/skin/img/inc/file.png" /> <%=atch_data_file_nm%></a>
<%
	End If
%>
								</td>
							</tr>
							<tr>
								<th scope="row">요청처리상태</th>
								<td>
									<%=dmnd_prcs_cd_nm%>
								</td>
								<th scope="row">요청처리일시</th>
								<td>
									<%=dmnd_prcs_dt%>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="bbs_cont">
					<%=dmnd_cn%>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
</html>
<script>
	function MovePage(page) {
		var f = document.search_form;
		f.page.value = page;
		f.action = "board_list.asp"
		f.submit();
	}

	function goView(dmnd_id) {
		try{
			var f = document.search_form;
			f.dmnd_id.value = dmnd_id;
			f.action = "dmnddel_view.asp"
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

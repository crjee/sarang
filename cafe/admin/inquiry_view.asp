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

	inq_id = Request("inq_id")

	Set rs = Server.CreateObject ("ADODB.Recordset")

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
	sql = sql & "       ,inq_prcs_dt       "
	sql = sql & "       ,creid             "
	sql = sql & "       ,credt             "
	sql = sql & "       ,modid             "
	sql = sql & "       ,moddt             "
	sql = sql & "       ,convert(varchar,credt,120) credt_txt "
	sql = sql & "   from cf_inquiry "
	sql = sql & "  where inq_id = '" & inq_id & "' "
	rs.open Sql, conn, 3, 1

	If Not rs.eof Then
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
		inq_prcs_dt       = rs("inq_prcs_dt")
		creid             = rs("creid")
		credt             = rs("credt")
		modid             = rs("modid")
		moddt             = rs("moddt")
		credt_txt         = rs("credt_txt")

		inq_se_cd_nm   = getCodeName("inq_se_cd", inq_se_cd)
		inq_prcs_cd_nm = getCodeName("inq_prcs_cd", inq_prcs_cd)
	End If
	rs.close
	Set rs = Nothing
%>
		<script type="text/javascript">
			function goList() {
				document.search_form.action = "inquiry_list.asp";
				document.search_form.target = "_self"
				document.search_form.submit();
			}
			function goProcess() {
				document.search_form.action = "inquiry_exec.asp"
				document.search_form.target = "hiddenfrm"
				document.search_form.submit();
			}
		</script>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">광고/제휴 문의 내용</h2>
			</div>
			<div class="btn_box view_btn">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="inq_id" value="<%=inq_id%>">
				<select id="inq_prcs_cd" name="inq_prcs_cd" class="sel w100p">
					<option value="">선택</option>
					<%=makeComboCD("inq_prcs_cd", inq_prcs_cd)%>
				</select>
				<button class="btn btn_c_n btn_n" type="button" onclick="goProcess()">처리</button>
				<button class="btn btn_c_n btn_n" type="button" onclick="goList()">목록</button>
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
								<th scope="row">문의구분</th>
								<td>
									<%=inq_se_cd_nm%>
								</td>
								<th scope="row">문의일시</th>
								<td>
									<%=credt%>
								</td>
							</tr>
							<tr>
								<th scope="row">회사명</th>
								<td>
									<%=co_nm%>
								</td>
								<th scope="row">담당자 이름</th>
								<td>
									<%=pic_flnm%>
								</td>
							</tr>
							<tr>
								<th scope="row">담당자 연락처</th>
								<td>
									<%=mbl_telno%>
								</td>
								<th scope="row">담당자 이메일 주소</th>
								<td>
									<%=eml_addr%>
								</td>
							</tr>
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">
									<%=subject%>
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
								<th scope="row">문의처리상태</th>
								<td>
									<%=inq_prcs_cd_nm%>
								</td>
								<th scope="row">문의처리일시</th>
								<td>
									<%=inq_prcs_dt%>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="bbs_cont">
					<%=inq_cn%>
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

	function goView(inq_id) {
		try{
			var f = document.search_form;
			f.inq_id.value = inq_id;
			f.action = "inquiry_view.asp"
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

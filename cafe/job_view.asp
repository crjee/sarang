<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckReadAuth(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL")
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
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	cafe_sch  = Request("cafe_sch")

	self_yn   = Request("self_yn")
	all_yn    = Request("all_yn")

	job_seq = Request("job_seq")

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select cj.* "
	sql = sql & "   from cf_job cj "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	rs.Open Sql, conn, 3, 1

	top_yn  = rs("top_yn")
	job_seq = rs("job_seq")
	subject = rs("subject")
	work    = rs("work")
	age     = rs("age")
	If age = "" Or age = "0" Then
		age = "무관"
	End If
	sex    = rs("sex")
	If sex = "" Then
		sex = "무관"
	elseIf sex = "M" Then
		sex = "남자"
	elseIf sex = "W" Then
		sex = "여자"
	End If
	work_year  = rs("work_year")
	If work_year = "" Then
		work_year = "무관"
	else
		work_year = work_year
	End If
	certify    = rs("certify")
	If certify = "Y" Then
		certify = "필수"
	else
		certify = "무관"
	End If
	work_place = rs("work_place")
	agency     = rs("agency")
	person     = rs("person")
	tel_no     = rs("tel_no")
	mbl_telno  = rs("mbl_telno")
	fax_no     = rs("fax_no")
	email      = rs("email")
	homepage   = rs("homepage")
	method     = rs("method")
	end_date   = rs("end_date")
	contents   = rs("contents")
	credt      = rs("credt")
	user_id    = rs("user_id")
%>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/cafe/com_move_edit_p.asp?com_seq=<%=job_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="com_move">
			<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
			</form>
			<form name="search_form" method="post">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="self_yn" value="<%=self_yn%>">
			<input type="hidden" name="all_yn" value="<%=all_yn%>">
			<input type="hidden" name="task">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="job_seq" value="<%=job_seq%>">
			<input type="hidden" name="com_seq" value="<%=job_seq%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If reply_auth <= cafe_mb_level Then
%>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goModify('<%=session("ctTarget")%>')">수정</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goMove()">이동</button>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goTopMove()"><%=if3(rs("top_yn")="Y","공지해제","공지지정")%></button>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goSuggest()">추천</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goPrint()">인쇄</button>
<%
	write_auth = GetOneValue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If GetToInt(write_auth) <= GetToInt(cafe_mb_level) Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="onCopyUrl()">글주소복사</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goList('<%=cafe_sch%>', '<%=session("ctTarget")%>')">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3" id="subject"><%=subject%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>글쓴이</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
								<li><span>조회</span><strong><%=rs("view_cnt")%></strong></li>
								<li><span>등록일시</span><strong><%=rs("credt")%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<!--#include virtual="/include/attach_view_inc.asp"-->
					</div>
					<div class="view_cont">
						<h4 class="f_awesome h4">자격조건</h4>
						<div class="tb">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w110p">
									<col class="w_remainder">
									<col class="w110p">
									<col class="w_remainder">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">담당업무</th>
										<td><%=work%></td>
										<th scope="row">연령</th>
										<td><%=age%></td>
									</tr>
									<tr>
										<th scope="row">성별</th>
										<td><%=sex%></td>
										<th scope="row">경력</th>
										<td><%=work_year%></td>
									</tr>
									<tr>
										<th scope="row">관력자격증</th>
										<td><%=certify%></td>
										<th scope="row">근무지역</th>
										<td><%=work_place%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="view_cont">
						<h4 class="f_awesome h4">문의및 접수방법</h4>
						<div class="tb">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w110p">
									<col class="w_remainder">
									<col class="w110p">
									<col class="w_remainder">
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">중개업소명</th>
										<td><%=agency%></td>
										<th scope="row">담당자</th>
										<td><%=person%></td>
									</tr>
									<tr>
										<th scope="row">전화번호</th>
										<td><%=tel_no%></td>
										<th scope="row">휴대전화번호</th>
										<td><%=mbl_telno%></td>
									</tr>
									<tr>
										<th scope="row">팩스</th>
										<td><%=fax_no%></td>
										<th scope="row">이메일</th>
										<td><%=email%></td>
									</tr>
									<tr>
										<th scope="row">홈페이지</th>
										<td><%=homepage%></td>
										<th scope="row">접수방법</th>
										<td><%=method%></td>
									</tr>
									<tr>
										<th scope="row">마감일</th>
										<td colspan="3"><%=end_date%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="view_cont">
						<h4 class="f_awesome h4">모집요강</h4>
					</div>
					<div class="bbs_cont">
						<%=rs("contents")%>
					</div>
				</div>
<!--#include virtual="/cafe/com_comment_list_inc.asp"-->
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
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
<script>
	function goPrint() {
		var initBody;
		window.onbeforeprint = function() {
			initBody = document.body.innerHTML;
			document.body.innerHTML =  document.getElementById('print_area').innerHTML;
		};
			window.onafterprint = function() {
			document.body.innerHTML = initBody;
		};
		window.print();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "/cafe/job_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goList(sch, gvTarget) {
		if (sch == 'Y') {
			document.search_form.action = "/cafe/cafe_search_list.asp";
		}
		else {
			document.search_form.action = "/cafe/job_list.asp";
		}
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goReply(gvTarget) {
		document.search_form.action = "/cafe/job_reply.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goModify(gvTarget) {
		document.search_form.action = "/cafe/job_modify.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.action = "/cafe/com_waste_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goTopMove() {
		document.search_form.action = "/cafe/com_top_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goSuggest() {
		document.search_form.action = "/cafe/com_suggest_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goMove() {
		document.open_form.action = "/win_open_exec.asp";
		document.open_form.target = "hiddenfrm";
		document.open_form.submit();
	}
	function onCopyUrl() {
		try{
			if (window.clipjobData) {
					window.clipjobData.setData("text", "<%=pageUrl%>");
					alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
			}
			else if (window.navigator.clipjob) {
					window.navigator.clipjob.writeText("<%=pageUrl%>").then(() => {
						alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
					});
			}
			else {
				temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
			}
		} catch(e) {
			alert(e)
		}
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

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
	<title>경인 홈</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	home_sch  = Request("home_sch")

	self_yn   = Request("self_yn")
	all_yn    = Request("all_yn")

	job_seq = Request("job_seq")

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	page_move = Request("page_move")

	If page_move = "prev" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
		sql = sql & "       ,job_seq as prev_seq                                                 "
		sql = sql & "   from gi_job                                                              "
		sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
		sql = sql & "    and job_seq > '" & job_seq & "'                                         "
		sql = sql & "  order by group_num asc, step_num desc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			prev_seq = rs("prev_seq")
		End If
		rs.close
		job_seq = prev_seq
	ElseIf page_move = "next" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
		sql = sql & "       ,job_seq as next_seq                                                 "
		sql = sql & "   from gi_job                                                              "
		sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
		sql = sql & "    and job_seq < '" & job_seq & "'                                         "
		sql = sql & "  order by group_num desc, step_num asc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			next_seq = rs("next_seq")
		End If
		rs.close
		job_seq = next_seq
	End If
	' Response.write "page_move : " & page_move & "<br>"
	' Response.write "job_seq : " & job_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	prev_seq = ""
	next_seq = ""
	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
	sql = sql & "       ,job_seq as prev_seq                                                 "
	sql = sql & "   from gi_job                                                              "
	sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
	sql = sql & "    and job_seq > '" & job_seq & "'                                         "
	sql = sql & "  order by group_num asc, step_num desc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		prev_seq = rs("prev_seq")
	End If
	rs.close

	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "       ,job_seq as next_seq                                                 "
	sql = sql & "   from gi_job                                                              "
	sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
	sql = sql & "    and job_seq < '" & job_seq & "'                                         "
	sql = sql & "  order by group_num desc, step_num asc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		next_seq = rs("next_seq")
	End If
	rs.close
	' Response.write "job_seq : " & job_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	sql = ""
	sql = sql & " select cj.* "
	sql = sql & "   from gi_job cj "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	rs.Open Sql, conn, 3, 1

	job_seq       = rs("job_seq")
	job_num       = rs("job_num")
	group_num     = rs("group_num")
	step_num      = rs("step_num")
	level_num     = rs("level_num")
	menu_seq      = rs("menu_seq")
	cafe_id       = rs("cafe_id")
	agency        = rs("agency")
	top_yn        = rs("top_yn")
	pop_yn        = rs("pop_yn")
	section_seq   = rs("section_seq")
	subject       = rs("subject")
	contents      = rs("contents")
	link          = rs("link")

	work          = rs("work")
	age           = rs("age")
	sex           = rs("sex")
	work_year     = rs("work_year")
	certify       = rs("certify")
	work_place    = rs("work_place")
	person        = rs("person")
	tel_no        = rs("tel_no")
	mbl_telno     = rs("mbl_telno")
	fax_no        = rs("fax_no")
	email         = rs("email")
	homepage      = rs("homepage")
	method        = rs("method")
	end_date      = rs("end_date")

	user_id       = rs("user_id")
	reg_date      = rs("reg_date")
	view_cnt      = rs("view_cnt")
	comment_cnt   = rs("comment_cnt")
	suggest_cnt   = rs("suggest_cnt")
	suggest_info  = rs("suggest_info")
	parent_seq    = rs("parent_seq")
	parent_del_yn = rs("parent_del_yn")
	move_job_num  = rs("move_job_num")
	move_menu_seq = rs("move_menu_seq")
	move_user_id  = rs("move_user_id")
	move_date     = rs("move_date")
	restoreid     = rs("restoreid")
	restoredt     = rs("restoredt")
	creid         = rs("creid")
	credt         = rs("credt")
	modid         = rs("modid")
	moddt         = rs("moddt")

	If age = "" Or age = "0" Then
		age = "무관"
	End If

	If sex = "" Then
		sex = "무관"
	ElseIf sex = "M" Then
		sex = "남자"
	ElseIf sex = "W" Then
		sex = "여자"
	End If

	If work_year = "" Then
		work_year = "무관"
	Else
		work_year = work_year
	End If

	If certify = "Y" Then
		certify = "필수"
	Else
		certify = "무관"
	End If
%>
			<div class="container">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="all_yn" value="<%=all_yn%>">
				<input type="hidden" name="page_move" value="<%=page_move%>">

				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="job_seq" value="<%=job_seq%>">
				<input type="hidden" name="com_seq" value="<%=job_seq%>">
				</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<!--#include virtual="/home/home_up_view_btn_inc.asp"-->
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3" id="subject"><%=subject%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>글쓴이</span><strong><a title="<%=tel_no%>"><%=agency%></a></strong></li>
								<li><span>조회</span><strong><%=view_cnt%></strong></li>
								<li><span>등록일시</span><strong><%=credt%></strong></li>
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
				<div class="btn_box">
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(prev_seq="","alert('처음 입니다.')","goPrev()")%>">이전글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(next_seq="","alert('마지막 입니다')","goNext()")%>">다음글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
				</div>
<%
	rs.close
	Set rs = Nothing
%>
<!--#include virtual="/home/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>

	<!-- 레이어 팝업 -->
	<div class="lypp lypp_sarang lypp_move">
		<header class="lypp_head">
			<h2 class="h2">게시물 이동</h2>
			<span class="posR">
				<button type="button" class="btn btn_close"><em>닫기</em></button>
			</span>
		</header>
		<div class="adm_cont">
			<form name="form" method="post"  action="com_move_exec.asp" target="hiddenfrm">
				<input type="hidden" name="com_seq" value="<%=job_seq%>">
				<input type="hidden" name="old_menu_seq" value="<%=menu_seq%>">
				<div class="tb tb_form_1">
					<table class="tb_input">
						<colgroup>
							<col class="w15">
							<col class="auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">게시판 선택</th>
								<td colspan="3">
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                                     "
	sql = sql & "   from cf_menu                               "
	sql = sql & "  where cafe_id = '" & cafe_id & "'           "
	sql = sql & "    and menu_seq <> '" & menu_seq & "'        "
	sql = sql & "    and menu_type = '" & menu_type & "'       "
	sql = sql & "    and write_auth <= '" & cafe_mb_level & "' "
	sql = sql & "  order by menu_name                          "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		okSubmit = "Y"
%>
									<select id="menu_seq" name="menu_seq" class="sel w_auto" required >
<%

		Do Until rs.eof
			menu_seq = rs("menu_seq")
			menu_name = rs("menu_name")
%>
										<option value="<%=menu_seq%>"><%=menu_name%></option>
<%
			rs.MoveNext
		Loop
%>
									</select>
<%
	Else
		okSubmit = "N"
%>
									이동 가능한 곳이 없습니다.
<%
	End If
	rs.close
	Set rs = Nothing
%>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box algC">
<%
	If okSubmit = "Y" Then
%>
					<button type="submit" class="btn btn_c_a btn_n">이동</button>
<%
	End If
%>
					<button type="reset" class="btn btn_c_n btn_n">취소</button>
				</div>
			</form>
		</div>
	</div>
<script>
//	function goWrite() {
//		document.search_form.action = "job_write.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goReply() {
//		document.search_form.action = "/cafe/job_reply.asp";
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goModify() {
//		document.search_form.action = "/cafe/job_modify.asp";
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goDelete() {
//		document.search_form.action = "/cafe/com_waste_exec.asp";
//		//document.search_form.target = "hiddenfrm";
//		document.search_form.submit();
//	}

//	function goMove() {
//		lyp('lypp_move');
//	}

//	function goTopMove() {
//		document.search_form.action = "com_top_exec.asp"
//		//document.search_form.target = "hiddenfrm";
//		document.search_form.submit();
//	}

//	function goSuggest() {
//		document.search_form.action = "/cafe/com_suggest_exec.asp";
//		//document.search_form.target = "hiddenfrm";
//		document.search_form.submit();
//	}

//	function goPrint() {
//		var initBody;
//		window.onbeforeprint = function() {
//			initBody = document.body.innerHTML;
//			document.body.innerHTML =  document.getElementById('print_area').innerHTML;
//		};
//		window.onafterprint = function() {
//			document.body.innerHTML = initBody;
//		};
//		window.print();
//	}

//	function onCopyUrl() {
//		try{
//			if (window.clipjobData) {
//					window.clipjobData.setData("text", "<%=pageUrl%>")
//					alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//			}
//			else if (window.navigator.clipjob) {
//					window.navigator.clipjob.writeText("<%=pageUrl%>").then(() => {
//						alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//					});
//			}
//			else {
//				temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
//			}
//		} catch(e) {
//			alert(e)
//		}
//	}
//	function onCopySubject() {
//		try{
//			str = document.getElementById("subject").innerText;
//			if (window.clipjobData) {
//					window.clipjobData.setData("text", str)
//					alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//			}
//			else if (window.navigator.clipjob) {
//					window.navigator.clipjob.writeText(str).then(() => {
//						alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//					});
//			}
//			else {
//				temp = prompt("해당 제목을 복사하십시오.", str);
//			}
//		} catch(e) {
//			alert(e)
//		}
//	}

//	function goPrev() {
//		document.search_form.page_move.value = "prev"
//		document.search_form.action = "job_view.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goNext() {
//		document.search_form.page_move.value = "next"
//		document.search_form.action = "job_view.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goList(sch) {
//		if (sch == 'Y') {
//			document.search_form.action = "home_search_list.asp";
//		}
//		else {
//			document.search_form.action = "job_list.asp";
//		}
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}
</script>
</html>

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

	Call CheckAdmin()

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckWasteExist(com_seq)

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
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	home_sch  = Request("home_sch")

	sale_seq = Request("sale_seq")
	waset_yn  = "Y"

	Call SetViewCnt(menu_type, com_seq)

	page_move = Request("page_move")

	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	If page_move = "prev" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
		sql = sql & "       ,sale_seq as prev_seq                                               "
		sql = sql & "   from gi_waste_sale                                                      "
		sql = sql & "  where sale_seq > '" & sale_seq & "'                                     "
		sql = sql & "  order by group_num asc, step_num desc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			prev_seq = rs("prev_seq")
		End If
		rs.close
		sale_seq = prev_seq
	ElseIf page_move = "next" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
		sql = sql & "       ,sale_seq as next_seq                                               "
		sql = sql & "   from gi_waste_sale                                                      "
		sql = sql & "  where sale_seq < '" & sale_seq & "'                                     "
		sql = sql & "  order by group_num desc, step_num asc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			next_seq = rs("next_seq")
		End If
		rs.close
		sale_seq = next_seq
	End If
	' Response.write "page_move : " & page_move & "<br>"
	' Response.write "sale_seq : " & sale_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	prev_seq = ""
	next_seq = ""
	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
	sql = sql & "       ,sale_seq as prev_seq                                               "
	sql = sql & "   from gi_waste_sale                                                      "
	sql = sql & "  where sale_seq > '" & sale_seq & "'                                     "
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
	sql = sql & "       ,sale_seq as next_seq                                               "
	sql = sql & "   from gi_waste_sale                                                      "
	sql = sql & "  where sale_seq < '" & sale_seq & "'                                     "
	sql = sql & "  order by group_num desc, step_num asc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		next_seq = rs("next_seq")
	End If
	rs.close
	' Response.write "sale_seq : " & sale_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	sql = ""
	sql = sql & "  with cd1                                                      "
	sql = sql & "    as (                                                        "
	sql = sql & "        select section_seq                                      "
	sql = sql & "              ,section_nm                                       "
	sql = sql & "          from cf_menu_section                                  "
	sql = sql & "         where menu_seq = '" & menu_seq & "'                    "
	sql = sql & "       )                                                        "
	sql = sql & " select cb.* "
	sql = sql & "       ,cd1.section_nm as section_nm "
	sql = sql & "   from gi_waste_sale cb "
	sql = sql & "   left join cd1 on cd1.section_seq = cb.section_seq "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		sale_seq      = rs("sale_seq")
		sale_num      = rs("sale_num")
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
		location      = rs("location")
		bargain       = rs("bargain")
		area          = rs("area")
		floor         = rs("floor")
		compose       = rs("compose")
		price         = rs("price")
		live_in       = rs("live_in")
		parking       = rs("parking")
		traffic       = rs("traffic")
		purpose       = rs("purpose")
		tel_no        = rs("tel_no")
		mbl_telno     = rs("mbl_telno")
		fax_no        = rs("fax_no")
		user_id       = rs("user_id")
		reg_date      = rs("reg_date")
		view_cnt      = rs("view_cnt")
		comment_cnt   = rs("comment_cnt")
		suggest_cnt   = rs("suggest_cnt")
		suggest_info  = rs("suggest_info")
		parent_seq    = rs("parent_seq")
		parent_del_yn = rs("parent_del_yn")
		move_sale_num = rs("move_sale_num")
		move_menu_seq = rs("move_menu_seq")
		move_user_id  = rs("move_user_id")
		move_date     = rs("move_date")
		delid         = rs("delid")
		deldt         = rs("deldt")
		creid         = rs("creid")
		credt         = rs("credt")
		modid         = rs("modid")
		moddt         = rs("moddt")
	End If
%>
				<form name="open_form" method="post">
				<input type="hidden" name="open_url" value="/cafe/com_move_edit_p.asp?com_seq=<%=sale_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
				<input type="hidden" name="open_name" value="com_move">
				<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
				</form>
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="page_move" value="<%=page_move%>">
				<input type="hidden" name="task">

				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="sale_seq" value="<%=sale_seq%>">
				<input type="hidden" name="com_seq" value="<%=sale_seq%>">

				<input type="hidden" name="group_num" value="<%=group_num%>">
				<input type="hidden" name="level_num" value="<%=level_num%>">
				<input type="hidden" name="step_num" value="<%=step_num%>">
				</form>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">휴지통 <%=menu_name%> 내용보기</font></h2>
				</div>
 				<div class="btn_box view_btn">
					<button type="button" class="btn btn_c_n btn_n" onclick="godel()">복원</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3" id="subject"><%=subject%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>글쓴이</span><strong><a title="<%=tel_no%>"><%=agency%></a></strong></li>
								<li><span>조회</span><strong><%=view_cnt%></strong></li>
								<li><span>추천</span><strong><%=suggest_cnt%></strong></li>
								<li><span>등록일시</span><strong><%=credt%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<!--#include virtual="/include/attach_view_inc.asp"-->
<%
	If link <> "" Then
		link_txt = rmid(link, 40, "..")
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
						<script>
							document.getElementById("linkBtn").onclick = function() {
								try{
									if (window.clipsaleData) {
											window.clipsaleData.setData("text", "<%=link%>")
											alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
									}
									else if (window.navigator.clipsale) {
											window.navigator.clipsale.writeText("<%=link%>").then(() => {
												alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
											});
									}
									else {
										temp = prompt("해당 URL을 복사하십시오.", "<%=link%>");
									}
								} catch(e) {
									alert(e)
								}
							};
						</script>
<%
	End If
%>
					</div>
					<div class="view_cont">
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
										<th scope="row">소재지</th>
										<td><%=location%></td>
										<th scope="row">계약상태</th>
										<td><%=bargain%></td>
									</tr>
									<tr>
										<th scope="row">면적(평)</th>
										<td><%=area%></td>
										<th scope="row">해당층/총층</th>
										<td><%=floor%></td>
									</tr>
									<tr>
										<th scope="row">방개수/욕실수</th>
										<td><%=compose%></td>
										<th scope="row">금액</th>
										<td><%=price%></td>
									</tr>
									<tr>
										<th scope="row">입주가능일</th>
										<td><%=live_in%></td>
										<th scope="row">주차여부</th>
										<td><%=parking%></td>
									</tr>
									<tr>
										<th scope="row">대중교통</th>
										<td><%=traffic%></td>
										<th scope="row">목적 및 용도</th>
										<td><%=purpose%></td>
									</tr>
									<tr>
										<th scope="row">연락처</th>
										<td><%=tel_no%></td>
										<th scope="row">팩스</th>
										<td><%=fax_no%></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="bbs_cont">
						<%=contents%>
					</div>
				</div>
				<div class="btn_box">
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(prev_seq="","alert('처음 입니다.')","goPrev()")%>">이전글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(next_seq="","alert('마지막 입니다')","goNext()")%>">다음글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
					<button type="button" class="btn btn_c_a btn_n" onclick="goPrint()">인쇄</button>
				</div>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
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
		f.action = "sale_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goList(sch) {
		if (sch == 'Y') {
			document.search_form.action = "home_search_list.asp";
		}
		else {
			document.search_form.action = "waste_sale_list.asp";
		}
		document.search_form.submit();
	}
	function godel() {
		document.search_form.task.value = "del";
		document.search_form.action = "waste_com_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.task.value = "delete";
		document.search_form.action = "waste_com_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
</script>
</html>

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

	pageUrl = GetPageUrl(menu_type, menu_seq, com_seq)
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

	board_seq = Request("board_seq")

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	page_move = Request("page_move")

	If page_move = "prev" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
		sql = sql & "       ,board_seq as prev_seq                                               "
		sql = sql & "   from gi_board                                                            "
		sql = sql & "  where menu_seq = '" & menu_seq & "'                                        "
		sql = sql & "    and board_seq > '" & board_seq & "'                                     "
		sql = sql & "  order by group_num asc, step_num desc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			prev_seq = rs("prev_seq")
		End If
		rs.close
		board_seq = prev_seq
	ElseIf page_move = "next" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
		sql = sql & "       ,board_seq as next_seq                                               "
		sql = sql & "   from gi_board                                                            "
		sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
		sql = sql & "    and board_seq < '" & board_seq & "'                                     "
		sql = sql & "  order by group_num desc, step_num asc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			next_seq = rs("next_seq")
		End If
		rs.close
		board_seq = next_seq
	End If
	' Response.write "page_move : " & page_move & "<br>"
	' Response.write "board_seq : " & board_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	prev_seq = ""
	next_seq = ""
	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
	sql = sql & "       ,board_seq as prev_seq                                               "
	sql = sql & "   from gi_board                                                            "
	sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
	sql = sql & "    and board_seq > '" & board_seq & "'                                     "
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
	sql = sql & "       ,board_seq as next_seq                                               "
	sql = sql & "   from gi_board                                                            "
	sql = sql & "  where menu_seq = '" & menu_seq & "'                                       "
	sql = sql & "    and board_seq < '" & board_seq & "'                                     "
	sql = sql & "  order by group_num desc, step_num asc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		next_seq = rs("next_seq")
	End If
	rs.close
	' Response.write "board_seq : " & board_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	sql = ""
	sql = sql & " select cb.*                                         "
	sql = sql & "       ,cm.phone as tel_no                           "
	sql = sql & "   from gi_board cb                                  "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where board_seq = '" & board_seq & "'              "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		board_seq      = rs("board_seq")
		board_num      = rs("board_num")
		group_num      = rs("group_num")
		step_num       = rs("step_num")
		level_num      = rs("level_num")
		menu_seq       = rs("menu_seq")
		cafe_id        = rs("cafe_id")
		agency         = rs("agency")
		top_yn         = rs("top_yn")
		pop_yn         = rs("pop_yn")
		section_seq    = rs("section_seq")
		subject        = rs("subject")
		contents       = rs("contents")
		link           = rs("link")
		user_id        = rs("user_id")
		reg_date       = rs("reg_date")
		view_cnt       = rs("view_cnt")
		comment_cnt    = rs("comment_cnt")
		suggest_cnt    = rs("suggest_cnt")
		suggest_info   = rs("suggest_info")
		parent_seq     = rs("parent_seq")
		parent_del_yn  = rs("parent_del_yn")
		move_board_num = rs("move_board_num")
		move_menu_seq  = rs("move_menu_seq")
		move_user_id   = rs("move_user_id")
		move_date      = rs("move_date")
		restoreid      = rs("restoreid")
		restoredt      = rs("restoredt")
		creid          = rs("creid")
		credt          = rs("credt")
		modid          = rs("modid")
		moddt          = rs("moddt")

		tel_no         = rs("tel_no")
	End If
	rs.close
%>
			<div class="container">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="page_move" value="<%=page_move%>">

				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="board_seq" value="<%=board_seq%>">
				<input type="hidden" name="com_seq" value="<%=board_seq%>">
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
									if (window.clipboardData) {
											window.clipboardData.setData("text", "<%=link%>")
											alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
									}
									else if (window.navigator.clipboard) {
											window.navigator.clipboard.writeText("<%=link%>").then(() => {
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
					<div class="bbs_cont">
						<%=contents%>
					</div>
				</div>
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
			<form name="form" method="post" action="com_move_exec.asp">
				<input type="hidden" name="com_seq" value="<%=board_seq%>">
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
										<option value=""></option>
<%
		Do Until rs.eof
			menu_seq  = rs("menu_seq")
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
					<button type="reset" class="btn btn_c_n btn_n">취소</button>
<%
	End If
%>
				</div>
			</form>
		</div>
	</div>
<script>
//	function goWrite() {
//		document.search_form.action = "board_write.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goReply() {
//		document.search_form.action = "board_reply.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goModify() {
//		document.search_form.action = "board_modify.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goDelete() {
//		document.search_form.action = "com_waste_exec.asp"
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
//		document.search_form.action = "com_suggest_exec.asp"
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
//			if (window.clipboardData) {
//					window.clipboardData.setData("text", "<%=pageUrl%>")
//					alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//			}
//			else if (window.navigator.clipboard) {
//					window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
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
//			if (window.clipboardData) {
//					window.clipboardData.setData("text", str)
//					alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
//			}
//			else if (window.navigator.clipboard) {
//					window.navigator.clipboard.writeText(str).then(() => {
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
//		document.search_form.action = "board_view.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goNext() {
//		document.search_form.page_move.value = "next"
//		document.search_form.action = "board_view.asp"
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}

//	function goList(sch) {
//		if (sch == 'Y') {
//			document.search_form.action = "home_search_list.asp";
//		}
//		else {
//			document.search_form.action = "board_list.asp";
//		}
//		document.search_form.target = "_self";
//		document.search_form.submit();
//	}
</script>
</html>

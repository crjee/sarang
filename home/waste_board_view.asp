<%@Language="VBScript" CODEPAGE="65001" %>
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

	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member                              "
	sql = sql & "    set ipin    = '" & ipin               & "' "
	sql = sql & "       ,modid   = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt   = getdate()                    "
	sql = sql & "  where user_id = '" & session("user_id") & "' "
	Conn.Execute(sql)

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	board_seq  = Request("board_seq")

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select cb.*                                         "
	sql = sql & "       ,cm.phone as tel_no                           "
	sql = sql & "   from gi_waste_board cb                            "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where board_seq = '" & board_seq & "'              "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		group_num      = rs("group_num")
		step_num       = rs("step_num")
		level_num      = rs("level_num")
		board_num      = rs("board_num")
		cafe_id        = rs("cafe_id")
		menu_seq       = rs("menu_seq")
		agency         = rs("agency")
		subject        = rs("subject")
		contents       = rs("contents")
		view_cnt       = rs("view_cnt")
		suggest_cnt    = rs("suggest_cnt")
		link           = rs("link")
		top_yn         = rs("top_yn")
		reg_date       = rs("reg_date")
		creid          = rs("creid")
		credt          = rs("credt")
		modid          = rs("modid")
		moddt          = rs("moddt")
		board_seq      = rs("board_seq")
		suggest_info   = rs("suggest_info")
		user_id        = rs("user_id")
		parent_seq     = rs("parent_seq")
		move_board_num = rs("move_board_num")
		parent_del_yn  = rs("parent_del_yn")
		move_menu_seq  = rs("move_menu_seq")
		move_user_id   = rs("move_user_id")
		move_date      = rs("move_date")
		delid          = rs("delid")
		deldt          = rs("deldt")
		comment_cnt    = rs("comment_cnt")
		section_seq    = rs("section_seq")
		pop_yn         = rs("pop_yn")

		tel_no         = rs("tel_no")
	End If
	rs.close
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
			<div class="container">
			<form name="search_form" method="post">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="task">

			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="board_seq" value="<%=board_seq%>">
			<input type="hidden" name="com_seq" value="<%=board_seq%>">

			<input type="hidden" name="group_num" value="<%=group_num%>">
			<input type="hidden" name="level_num" value="<%=level_num%>">
			<input type="hidden" name="step_num" value="<%=step_num%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">휴지통 <%=menu_name%> 내용보기</font></h2>
				</div>
				<div class="btn_box view_btn">
					<button type="button" class="btn btn_c_n btn_n" onclick="goRestore()">복원</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList()">목록</button>
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
<!--#include virtual="/home/waste_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
<script>
	function goList() {
		document.search_form.action = "/home/waste_board_list.asp";
		document.search_form.target = "_self";
		document.search_form.submit();
	}
	function goRestore() {
		document.search_form.task.value = "restore";
		document.search_form.action = "/home/waste_com_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.task.value = "delete";
		document.search_form.action = "/home/waste_com_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
</script>
</html>


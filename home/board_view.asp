<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&board_seq=" & Request("board_seq")

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	home_sch  = Request("home_sch")

	self_yn   = Request("self_yn")

	board_seq = Request("board_seq")

	Call setViewCnt(menu_type, board_seq)

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cb.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_board cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where board_seq = '" & board_seq & "' "
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
		restoreid      = rs("restoreid")
		restoredt      = rs("restoredt")
		comment_cnt    = rs("comment_cnt")
		section_seq    = rs("section_seq")
		pop_yn         = rs("pop_yn")

		tel_no         = rs("tel_no")
	Else
		msggo "정상적인 사용이 아닙니다.",""
	End If
	rs.close
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
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
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/home/com_move_edit_p.asp?com_seq=<%=board_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="com_move">
			<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
			</form>
			<form name="search_form" method="post">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="self_yn" value="<%=self_yn%>">

			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="board_seq" value="<%=board_seq%>">
			<input type="hidden" name="com_seq" value="<%=board_seq%>">

			<input type="hidden" name="group_num" value="<%=group_num%>">
			<input type="hidden" name="level_num" value="<%=level_num%>">
			<input type="hidden" name="step_num" value="<%=step_num%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If group_num = "" And reply_auth <= cafe_mb_level Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goReply()">답글</button>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or user_id = session("user_id") Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goModify()">수정</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
<%
		If step_num = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goMove()">이동</button>
<%
		End If
	End If
%>
<%
	If cafe_mb_level > 6 Then
		If step_num = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goNotice()"><%=if3(top_yn="Y","공지해제","공지지정")%></button>
<%
		End If
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goSuggest()">추천</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goPrint()">인쇄</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="copyUrl()">글주소복사</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="copySubject()">제목복사</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='/home/board_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3" id="subject"><%=subject%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>작성자</span><strong><a title="<%=tel_no%>"><%=agency%></a></strong></li>
								<li><span>조회</span><strong><%=view_cnt%></strong></li>
								<li><span>추천</span><strong><%=suggest_cnt%></strong></li>
								<li><span>등록일시</span><strong><%=credt%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<%
	uploadUrl = ConfigAttachedFileURL & menu_type & "/"
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_board_attach "
	sql = sql & "  where board_seq = '" & board_seq & "' "
	rs.Open Sql, conn, 3, 1
	i = 0
	If Not rs.eof Then
		Do Until rs.eof
			If (fso.FileExists(uploadFolder & rs("file_name"))) Then
				fileExt = LCase(Mid(rs("file_name"), InStrRev(rs("file_name"), ".") + 1))
				If fileExt = "pdf" Then
%>
						<%If i > 0 Then%><br><%End If%>
						<a href="<%=uploadUrl & rs("file_name")%>" class="file"><img src="/home/img/inc/file.png" /> <%=rs("file_name")%></a>
<%
				Else
%>
						<%If i > 0 Then%><br><%End If%>
						<a href="/download_exec.asp?menu_type=<%=menu_type%>&file_name=<%=rs("file_name")%>" class="file"><img src="/home/img/inc/file.png" /> <%=rs("file_name")%></a>
<%
				End If
			Else
%>
						<%If i > 0 Then%><br><%End If%>
						<a href="javascript:alert('파일이 존재하지 않습니다,')" class="file"><img src="/home/img/inc/file.png" /> <%=rs("file_name")%></a>
<%
			End If

			i = i + 1
			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing
	Set fso = Nothing

	If link <> "" Then
	link_txt = rmid(link, 40, "..")
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/home/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
						<script>
							document.getElementById("linkBtn").onclick = function() {
								try{
									if (window.clipboardData) {
											window.clipboardData.setData("text", "<%=link%>")
											alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
									}
									else if (window.navigator.clipboard) {
											window.navigator.clipboard.writeText("<%=link%>").Then(() => {
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
<%
	com_seq = board_seq
%>
<!--#include virtual="/home/com_comment_list_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
<script type="text/javascript">
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

	function goList(sch) {
		if (sch == 'Y') {
			document.search_form.action = "/home/home_search_list.asp";
		}
		else {
			document.search_form.action = "/home/board_list.asp";
		}
		document.search_form.target = "_self";
		document.search_form.submit();
	}
	function goReply() {
		document.search_form.action = "/home/board_reply.asp"
		document.search_form.target = "_self";
		document.search_form.submit();
	}
	function goModify() {
		document.search_form.action = "/home/board_modify.asp"
		document.search_form.target = "_self";
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.action = "/home/com_waste_exec.asp"
		document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goNotice() {
		document.search_form.action = "/home/com_top_exec.asp"
		document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goSuggest() {
		document.search_form.action = "/home/com_suggest_exec.asp"
		document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goMove() {
		document.open_form.action = "/win_open_exec.asp"
		document.open_form.target = "hiddenfrm";
		document.open_form.submit();
	}
	function copySubject() {
		try{
			str = document.getElementById("subject").innerText;
			if (window.clipboardData) {
					window.clipboardData.setData("text", str)
					alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
			}
			else if (window.navigator.clipboard) {
					window.navigator.clipboard.writeText(str).Then(() => {
						alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
					});
			}
			else {
				temp = prompt("해당 제목을 복사하십시오.", str);
			}
		} catch(e) {
			alert(e)
		}
	}
	function copyUrl() {
		try{
			if (window.clipboardData) {
					window.clipboardData.setData("text", "<%=pageUrl%>")
					alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
			}
			else if (window.navigator.clipboard) {
					window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
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

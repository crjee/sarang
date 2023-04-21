<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&board_seq=" & Request("board_seq")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
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
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
<%
	End IF
%>
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	cafe_sch  = Request("cafe_sch")

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
		delid          = rs("delid")
		deldt          = rs("deldt")
		comment_cnt    = rs("comment_cnt")
		section_seq    = rs("section_seq")
		pop_yn         = rs("pop_yn")

		tel_no         = rs("tel_no")
	Else
		msggo "정상적인 사용이 아닙니다.",""
	End If
	rs.close
%>
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="task">
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
					<button type="button" class="btn btn_c_n btn_s" onclick="goReply('<%=session("ctTarget")%>')">답글</button>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or user_id = session("user_id") Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goModify('<%=session("ctTarget")%>')">수정</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goDelete()">삭제</button>
<%
		If step_num = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="lyp('lypp_move')">이동</button>
<%
		End If
	End If
%>
<%
	If cafe_mb_level > 6 Then
		If step_num = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goNotice()"><%=if3(top_yn="Y","공지해제","공지지정")%></button>
<%
		End If
	End If
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goSuggest()">추천</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goPrint()">인쇄</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="copyUrl()">글주소복사</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="copySubject()">제목복사</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button type="button" class="btn btn_c_a btn_s" onclick="<%=session("ctHref")%>location.href='/cafe/skin/board_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goList('<%=cafe_sch%>', '<%=session("ctTarget")%>')">목록</button>
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
	Set rs = Server.CreateObject ("ADODB.Recordset")

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
						<a href="<%=uploadUrl & rs("file_name")%>" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs("file_name")%></a>
<%
				Else
%>
						<%If i > 0 Then%><br><%End If%>
						<a href="/download_exec.asp?menu_type=<%=menu_type%>&file_name=<%=rs("file_name")%>" target="" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs("file_name")%></a>
<%
				End If
			Else
%>
						<%If i > 0 Then%><br><%End If%>
						<a href="javascript:alert('파일이 존재하지 않습니다,')" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs("file_name")%></a>
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
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/skin/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
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
<%
	rs.close
	Set rs = nothing

	com_seq = board_seq
%>
				</div>
<%
	com_seq = board_seq
%>
<!--#include virtual="/cafe/skin/com_comment_list_inc.asp"-->
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
<%
	End IF
%>
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
</html>

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
									<select id="menu_seq" name="menu_seq" class="sel w_auto" required >
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq <> '" & menu_seq & "' "
	sql = sql & "    and menu_type = '" & menu_type & "' "
	sql = sql & "    and write_auth <= '" & toInt(cafe_mb_level) & "' "
	sql = sql & "  order by menu_name "
	rs.Open Sql, conn, 3, 1

	Do Until rs.eof
		menu_seq = rs("menu_seq")
		menu_name = rs("menu_name")
%>
										<option value="<%=menu_seq%>"><%=menu_name%></option>
<%
		rs.MoveNext
	Loop
	rs.close
	Set rs = nothing
%>
										<option value="I">이미지</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box algC">
					<button type="submit" class="btn btn_c_a btn_n">이동</button>
					<button type="reset" class="btn btn_c_n btn_n">취소</button>
				</div>
			</form>
		</div>
	</div>
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

				function goList(sch, gvTarget) {
					if (sch == 'Y') {
						document.search_form.action = "/cafe/skin/cafe_search_list.asp";
					}
					else {
						document.search_form.action = "/cafe/skin/board_list.asp";
					}
					document.search_form.target = gvTarget;
					document.search_form.submit();
				}
				function goReply(gvTarget) {
					document.search_form.action = "/cafe/skin/board_reply.asp";
					document.search_form.target = gvTarget;
					document.search_form.submit();
				}
				function goModify(gvTarget) {
					try{
						document.search_form.action = "/cafe/skin/board_modify.asp";
						document.search_form.target = gvTarget;
						document.search_form.submit();
					} catch(e) {
						alert(e)
					}
				}
				function goDelete() {
					document.search_form.action = "/cafe/skin/com_waste_exec.asp";
					document.search_form.target = "hiddenfrm";
					document.search_form.submit();
				}
				function goNotice() {
					document.search_form.action = "/cafe/skin/com_top_exec.asp";
					document.search_form.target = "hiddenfrm";
					document.search_form.submit();
				}
				function goSuggest() {
					document.search_form.action = "/cafe/skin/com_suggest_exec.asp"
					document.search_form.target = "hiddenfrm";
					document.search_form.submit();
				}
				function copySubject() {
					try{
						str = document.getElementById("subject").innerText;
						if (window.clipboardData) {
								window.clipboardData.setData("Text", str)
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
								window.clipboardData.setData("Text", "<%=pageUrl%>")
								alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
						}
						else if (window.navigator.clipboard) {
								window.navigator.clipboard.writeText("<%=pageUrl%>").Then(() => {
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

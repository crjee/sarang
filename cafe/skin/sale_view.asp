<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '" & ipin & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & session("user_id") & "' "
	Conn.Execute(sql)

	checkCafePage(cafe_id)
	checkReadAuth(cafe_id)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL") & "?menu_seq=" & Request("menu_seq") & "&sale_seq=" & Request("sale_seq")
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

	sale_seq = Request("sale_seq")

	Call setViewCnt(menu_type, sale_seq)

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cs.* "
	sql = sql & "   from cf_sale cs "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs.Open Sql, conn, 3, 1

	top_yn   = rs("top_yn")
	subject  = rs("subject")
	link     = rs("link")
	location = rs("location")
	bargain  = rs("bargain")
	area     = rs("area")
	floor    = rs("floor")
	compose  = rs("compose")
	price    = rs("price")
	live_in  = rs("live_in")
	parking  = rs("parking")
	traffic  = rs("traffic")
	purpose  = rs("purpose")
	contents = rs("contents")
	tel_no   = rs("tel_no")
	fax_no   = rs("fax_no")
	view_cnt = rs("view_cnt")
	credt = rs("credt")
	agency   = rs("agency")
	group_num   = rs("group_num")
	level_num   = rs("level_num")
	step_num   = rs("step_num")
%>
			<script type="text/javascript">
				function goPrint() {
					var initBody;
					window.onbeforeprint = function() {
						initBody = document.body.innerHTML;
						document.body.innerHTML =  document.getElementById('CenterContents').innerHTML;
					};
						window.onafterprint = function() {
						document.body.innerHTML = initBody;
					};
					window.print();
				}

				function goList(gvTarget, sch) {
					if (sch == 'Y') {
						document.search_form.action = "/cafe/skin/cafe_search_list.asp";
					}
					else {
						document.search_form.action = "/cafe/skin/sale_list.asp";
					}
					document.search_form.target = gvTarget;
					document.search_form.submit();
				}
				function goReply(gvTarget) {
					document.search_form.action = "/cafe/skin/sale_reply.asp";
					document.search_form.target = gvTarget;
					document.search_form.submit();
				}
				function goModify(gvTarget) {
					document.search_form.action = "/cafe/skin/sale_modify.asp";
					document.search_form.target = gvTarget;
					document.search_form.submit();
				}
				function goDelete() {
					document.search_form.action = "/cafe/skin/com_waste_exec.asp";
					document.search_form.target = "hiddenfrm";
					document.search_form.submit();
				}
				function goMove() {
					w = 340;    //팝업창의 너비
					h = 310;    //팝업창의 높이

					//중앙위치 구해오기
					LeftPosition=(parent.screen.width-w)/2;
					TopPosition=(parent.screen.height-h)/2;
					window.open("com_move.asp?com_seq=<%=sale_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>&user_id=<%=session("user_id")%>&ipin=<%=ipin%>","move","width="+w+",height="+h+",top="+TopPosition+",left="+LeftPosition+", scrollbars=no");
				}
				function goNotice() {
					document.search_form.action = "/cafe/skin/com_top_exec.asp";
					document.search_form.target = "hiddenfrm";
					document.search_form.submit();
				}
				function goSuggest() {
					document.search_form.action = "/cafe/skin/com_suggest_exec.asp";
					document.search_form.target = "hiddenfrm";
					document.search_form.submit();
				}
				function copyUrl() {
					try{
						if (window.clipboardData) {
								window.clipboardData.setData("Text", "<%=pageUrl%>");
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
			<form name="search_form" method="post">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="task">
			<input type="hidden" name="self_yn" value="<%=self_yn%>">
			<input type="hidden" name="sale_seq" value="<%=sale_seq%>">
			<input type="hidden" name="com_seq" value="<%=sale_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If group_num = "" And reply_auth <= cafe_mb_level Then
%>
					<!-- <button class="btn btn_c_n btn_n" type="button" onclick="goReply('<%=session("ctTarget")%>')">답글</button> -->
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_s" type="button" onclick="goModify('<%=session("ctTarget")%>')">수정</button>
					<button class="btn btn_c_n btn_s" type="button" onclick="goDelete()">삭제</button>
					<button class="btn btn_c_n btn_s" type="button" onclick="goMove()">이동</button>
<%
		End If
	End If
%>
<%
	If cafe_mb_level > 6 Then
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_s" type="button" onclick="goNotice()"><%=if3(rs("top_yn")="Y","공지해제","공지지정")%></button>
<%
		End If
	End If
%>
					<button class="btn btn_c_n btn_s" type="button" onclick="goSuggest()">추천</button>
					<button class="btn btn_c_n btn_s" type="button" onclick="goPrint()">인쇄</button>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button class="btn btn_c_a btn_s" type="button" onclick="<%=session("ctHref")%>location.href='/cafe/skin/sale_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If
%>
					<button class="btn btn_c_n btn_s" type="button" onclick="copyUrl()">글주소복사</button>
					<button class="btn btn_c_n btn_s" type="button" onclick="goList('<%=session("ctTarget")%>')">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
				<div class="view_head">
					<h3 class="h3" id="subject"><%=subject%></h3>
					<div class="wrt_info_box">
						<ul>
							<li><span>작성자</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
							<li><span>조회</span><strong><%=rs("view_cnt")%></strong></li>
							<li><span>등록일시</span><strong><%=rs("credt")%></strong></li>
						</ul>
					</div>
				</div>
				<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<%
	link_txt = rmid(link, 40, "..")
	
	If link_txt <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/skin/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<script>
	document.getElementById("linkBtn").onclick = function() {
		try{
			if (window.clipboardData) {
					window.clipboardData.setData("Text", "<%=link%>")
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
<%
	uploadUrl = ConfigAttachedFileURL & menu_type & "/"
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_sale_attach "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs2.Open Sql, conn, 3, 1

	i = 0
	If Not rs2.eof Then
%>
								<tr>
									<th scope="row">첨부파일</th>
									<td colspan="3" style="text-align:left">
<%
		Do Until rs2.eof
			If (fso.FileExists(uploadFolder & rs2("file_name"))) Then
				fileExt = LCase(Mid(rs2("file_name"), InStrRev(rs2("file_name"), ".") + 1))
				If fileExt = "pdf" Then
%>
										<%If i > 0 Then%><br><%End If%>
										<a href="<%=uploadUrl & rs2("file_name")%>" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
				Else
%>
										<%If i > 0 Then%><br><%End If%>
										<a href="/download_exec.asp?menu_type=<%=menu_type%>&file_name=<%=rs2("file_name")%>" target="hiddenfrm" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
				End If
			Else
%>
										<%If i > 0 Then%><br><%End If%>
										<a href="javascript:alert('파일이 존재하지 않습니다,')" class="file"><img src="/cafe/skin/img/inc/file.png" /> <%=rs2("file_name")%></a>
<%
			End If

			i = i + 1
			rs2.MoveNext
		Loop
%>
									</td>
								</tr>
<%
	End If
	rs2.close
	Set rs2 = Nothing
	Set fso = Nothing
%>
							</tbody>
						</table>
					</div>
				</div>
				<div class="bbs_cont">
					<%=rs("contents")%>
				</div>
<%
	com_seq = sale_seq
%>
<!--#include virtual="/cafe/skin/com_comment_list_inc.asp"-->
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
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
</body>
</html>

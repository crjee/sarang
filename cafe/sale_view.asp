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

	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '" & ipin & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & session("user_id") & "' "
	Conn.Execute(sql)

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

	Call SetViewCnt(menu_type, com_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select cs.* "
	sql = sql & "   from cf_sale cs "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs.Open Sql, conn, 3, 1

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
	restoreid     = rs("restoreid")
	restoredt     = rs("restoredt")
	creid         = rs("creid")
	credt         = rs("credt")
	modid         = rs("modid")
	moddt         = rs("moddt")
%>
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
	If reply_auth <= cafe_mb_level Then
%>
<%
	End If
%>
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
		If rs("step_num") = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goModify('<%=session("ctTarget")%>')">수정</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goDelete()">삭제</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goMove()">이동</button>
<%
		End If
	End If
%>
<%
	If cafe_mb_level > 6 Then
		If rs("step_num") = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goTopMove()"><%=if3(rs("top_yn")="Y","공지해제","공지지정")%></button>
<%
		End If
	End If
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="goSuggest()">추천</button>
					<button type="button" class="btn btn_c_n btn_s" onclick="goPrint()">인쇄</button>
<%
	write_auth = GetOneValue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If GetToInt(write_auth) <= GetToInt(cafe_mb_level) Then
%>
					<button type="button" class="btn btn_c_a btn_s" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_s" onclick="onCopyUrl()">글주소복사</button>
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
<%
	link_txt = rmid(link, 40, "..")
	
	If link_txt <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<script>
	document.getElementById("linkBtn").onclick = function() {
		try{
			if (window.clipjobData) {
					window.clipjobData.setData("text", "<%=link%>")
					alert("해당 URL이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
			}
			else if (window.navigator.clipjob) {
					window.navigator.clipjob.writeText("<%=link%>").then(() => {
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
						<%=rs("contents")%>
					</div>
				</div>
<!--#include virtual="/cafe/com_comment_list_inc.asp"-->
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<%
	End IF
%>
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
		f.action = "/cafe/sale_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goList(gvTarget, sch) {
		if (sch == 'Y') {
			document.search_form.action = "/cafe/cafe_search_list.asp";
		}
		else {
			document.search_form.action = "/cafe/sale_list.asp";
		}
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goReply(gvTarget) {
		document.search_form.action = "/cafe/sale_reply.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goModify(gvTarget) {
		document.search_form.action = "/cafe/sale_modify.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.action = "/cafe/com_waste_exec.asp";
		//document.search_form.target = "hiddenfrm";
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

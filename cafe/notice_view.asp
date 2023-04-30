<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
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
	End IF
%>
			<div class="container">
<%
	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '" & ipin & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & session("user_id") & "' "
	Conn.Execute(sql)

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	cafe_sch  = Request("cafe_sch")

	notice_seq = Request("notice_seq")
	com_seq    = notice_seq

	Call SetViewCnt("notice", notice_seq)

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select cb.*                                         "
	sql = sql & "       ,cm.phone as tel_no                           "
	sql = sql & "   from cf_notice cb                                 "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where notice_seq = '" & notice_seq & "'            "
	rs.Open Sql, conn, 3, 1
%>
			<form name="search_form" method="post">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="task">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="notice_seq" value="<%=notice_seq%>">
			<input type="hidden" name="com_seq" value="<%=notice_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2">경인네트웍스 전체공지 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If group_num = "" And reply_auth <= cafe_ad_level Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goReply('<%=session("ctTarget")%>')">답글</button>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goModify('<%=session("ctTarget")%>')">수정</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
<%
	If cafe_ad_level > 6 Then
		If rs("step_num") = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goPopup()"><%=if3(rs("pop_yn")="Y","팝업해제","팝업지정")%></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goNotice()"><%=if3(rs("top_yn")="Y","공지해제","공지지정")%></button>
<%
		End If
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goSuggest()">추천</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goPrint()">인쇄</button>
<%
	If cafe_ad_level = "10" Then ' 글쓰기 권한
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
						<h3 class="h3" id="subject"><%=rs("subject")%></h3>
						<div class="wrt_info_box">
							<ul>
								<li><span>글쓴이</span><strong><a title="<%=rs("tel_no")%>"><%=rs("agency")%></a></strong></li>
								<li><span>조회</span><strong><%=rs("view_cnt")%></strong></li>
								<li><span>추천</span><strong><%=rs("suggest_cnt")%></strong></li>
								<li><span>등록일시</span><strong><%=rs("credt")%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<!--#include virtual="/include/attach_view_inc.asp"-->
<%
	link = rs("link")
	link_txt = rmid(link, 40, "..")
	
	If link <> "" Then
%>
						<p class="file"><a href="<%=link%>" target="_blink" id="linkTxt"><%=link_txt%></a>&nbsp;<img src="/cafe/img/inc/copy.png" style="cursor:hand" id="linkBtn"/></p>
<%
	End If
%>
					</div>
					<div class="bbs_cont">
						<%=rs("contents")%>
					</div>
				</div>
<%
	rs.close
	Set rs = Nothing
%>
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
		f.action = "/cafe/notice_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goList(gvTarget, sch) {
		if (sch == 'Y') {
			document.search_form.action = "/cafe/cafe_search_list.asp";
		}
		else {
			document.search_form.action = "/cafe/notice_list.asp";
		}
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goReply(gvTarget) {
		document.search_form.action = "/cafe/notice_reply.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goModify(gvTarget) {
		document.search_form.action = "/cafe/notice_modify.asp";
		document.search_form.target = gvTarget;
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.action = "/cafe/com_waste_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goPopup() {
		document.search_form.action = "/cafe/notice_pop_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goNotice() {
		document.search_form.action = "/cafe/notice_top_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goSuggest() {
		document.search_form.action = "/cafe/notice_suggest_exec.asp";
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
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

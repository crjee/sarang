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
	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select cm.menu_seq "
	sql = sql & "       ,cm.cafe_id "
	sql = sql & "       ,cm.menu_name "
	sql = sql & "       ,cm.page_type "
	sql = sql & "       ,cm.menu_type "
	sql = sql & "       ,cs.regulation "
	sql = sql & "       ,cs.introduction "
	sql = sql & "       ,cs.greetings "
	sql = sql & "       ,cs.roster "
	sql = sql & "       ,cs.organogram "
	sql = sql & "       ,cs.picture "
	sql = sql & "   from cf_menu cm "
	sql = sql & "   left outer join cf_page cs on cm.cafe_id = cs.cafe_id "
	sql = sql & "  where cm.menu_seq = '" & menu_seq & "' "
	rs.Open Sql, conn, 3, 1

	If rs("page_type") = "1" Then '회칙
%>
				<div class="cont_tit">
					<h2 class="h2"><%=rs("menu_name")%></h2>
				</div>
				<div class="bbs_cont">
					<%=rs("regulation")%>
				</div>
<%
	ElseIf rs("page_type") = "2" Then '소개
%>
				<div class="cont_tit">
					<h2 class="h2">소개</h2>
				</div>
				<div class="bbs_cont">
					<%=rs("introduction")%>
				</div>
				<div class="bbs_add_cont">
					<div class="bbs_add_cont_head">
						<h4>회장님 인사말</h4>
					</div>
					<div class="bbs_add_cont_body">
						<dl class="bac_box">
							<dd>
<%
		If rs("picture") <> "" then
			uploadUrl = ConfigAttachedFileURL & "picture/"
%>
								<img src="<%=uploadUrl & rs("picture")%>" style="width:140px"/>
<%
		End If
%>
							</dd>
							<dd>
								<%=rs("greetings")%>
							</dd>
						</dl>
					</div>
				</div>
<%
	ElseIf rs("page_type") = "4" Then '명단
%>
				<div class="cont_tit">
					<h2 class="h2"><%=rs("menu_name")%></h2>
				</div>
				<div class="bbs_cont">
					<%=rs("roster")%>
				</div>
<%
	ElseIf rs("page_type") = "5" Then '조직도
%>
				<div class="cont_tit">
					<h2 class="h2"><%=rs("menu_name")%></h2>
				</div>
				<div class="bbs_cont">
					<%=rs("organogram")%>
				</div>
<%
	End If
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
	End If
%>
</body>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

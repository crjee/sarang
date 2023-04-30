<%@Language="VBScript" CODEPAGE="65001" %>
<%
	s_pop = "Y"
%>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)

	popup_num = Request("popup_num")
	notice_seq = Request("notice_seq")
	popup_key = Request("popup_key")

	set rs = server.createobject("adodb.recordset")

	If notice_seq = "" Then
		sql = ""
		sql = sql  & " select * "
		sql = sql  & "   from cf_board "
		sql = sql  & "  where menu_seq = '" & menu_seq & "' "
		sql = sql  & "    and board_num = '" & popup_num & "' "
		rs.Open sql, Conn, 1
	Else
		sql = ""
		sql = sql  & " select * "
		sql = sql  & "   from cf_notice "
		sql = sql  & "  where notice_seq = '" & notice_seq & "' "
		rs.Open sql, Conn, 1
		menu_name = "경인네트웍스 전체공지"
	End If

	If rs.eof Then
%>
<h3 style="color:#c9a7f3;font-size:12px;;">팝업지정이 잘못 되었습니다.</h3>
<%
		Response.end
	End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>팝업공지</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link href="/cafe/css/basic_layout.css" rel="stylesheet" type="text/css" />
<link href="/cafe/css/inc.css" rel="stylesheet" type="text/css" />
<link href="/cafe/css/btn.css" rel="stylesheet" type="text/css" />
<link href="/cafe/css/contents_page.css" rel="stylesheet" type="text/css" />
</head>
<body>
	<form name="form" method="post" action="popup_end_exec.asp">
	<input type="hidden" name="popup_key" value="<%=popup_key%>">
	<div id="CenterPopup">
		<div id="Contents_Popuptitle"><%=menu_name%></div>
		<div id="Contents_PopupContMain" style="width:100%;height:245px;border:1px;overflow:scroll;">
			<%=rs("subject")%><br>
			<%=rs("contents")%>
		</div>
		<input type="checkbox" class="inp_check" name="check1" value="Y" onclick="document.form.submit()"> 오늘하루 그만 보기
		<p class="right"><button type="button" class="btn_basic2txt" id="btn" onclick="document.form.submit()">닫기</button></p>
	</div>
	</form>
</body>
</html>

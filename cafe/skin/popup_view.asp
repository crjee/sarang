<%s_pop="Y"%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = Request("cafe_id")
	menu_seq = Request("menu_seq")
	popup_num = Request("popup_num")
	notice_seq = Request("notice_seq")
	popup_key = Request("popup_key")

	set rs = server.createobject("adodb.recordset")

	If notice_seq = "" then
		sql = ""
		sql = sql  & " select * "
		sql = sql  & "   from cf_menu "
		sql = sql  & "  where menu_seq = '" & menu_seq  & "'  "
		sql = sql & "    and cafe_id = '" & cafe_id  & "' "
		rs.Open Sql, conn, 3, 1

		If rs.EOF Then
			msggo "�������� ����� �ƴմϴ�.",""
		Else
			menu_type = rs("menu_type")
			menu_name = rs("menu_name")
			cafe_id = rs("cafe_id")
		End If
		rs.close

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
		menu_name = "���γ�Ʈ���� ��ü����"
	End If


	If rs.eof Then
%>
<h3 style="color:#c9a7f3;font-size:12px;;">�˾������� �߸� �Ǿ����ϴ�.</h3>
<%
		Response.end
	End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<meta charset="euc-kr" />
<title>�˾�����</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link href="/cafe/skin/css/basic_layout.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/inc.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/btn.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/contents_page.css" rel="stylesheet" type="text/css" />
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
		<input type="checkbox" name="check1" value="Y" onclick="document.form.submit()"> �����Ϸ� �׸� ����
		<p class="right"><button class="btn_basic2txt" id="btn" type="button" onclick="document.form.submit()">�ݱ�</button></p>
	</div>
	</form>
</body>
</html>

<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<!--#include virtual="/ipin_inc.asp"-->
<%
	memo_seq = Request("memo_seq")
	del_seq = Request("del_seq")
	If del_seq <> "" Then
		sql = ""
		sql = sql & " delete cf_memo "
		sql = sql & "  where memo_seq = '" & del_seq & "' "
		conn.Execute(sql)
		Response.Write "<script>alert('삭제 되었습니다.');opener.parent.list_form.submit();self.close();</script>"
		Response.end
	End If

	sql = ""
	sql = sql & " update cf_memo "
	sql = sql & "    set stat = '1' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where memo_seq = '" & memo_seq & "' "
	sql = sql & "    and (to_user = '" & user_id & "' "
	sql = sql & "     or  fr_user = '" & user_id & "') "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " select mm.* "
	sql = sql & "       ,frmi.agency fragency "
	sql = sql & "       ,tomi.agency toagency "
	sql = sql & "   from cf_memo mm "
	sql = sql & "  inner join cf_member frmi on frmi.user_id = mm.fr_user "
	sql = sql & "  inner join cf_member tomi on tomi.user_id = mm.to_user "
	sql = sql & "  where mm.memo_seq = '" & memo_seq & "' "
	sql = sql & "    and (mm.to_user = '" & user_id & "' "
	sql = sql & "     or  mm.fr_user = '" & user_id & "') "
	Set rs = Server.CreateObject("ADODB.Recordset")
	rs.open sql, Conn, 3

	If rs.eof Then
		msggo "메시지가 존재하지 않습니다.","close"
	End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<meta charset="utf-8" />
<title>쪽지내용</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link href="/cafe/skin/css/basic_layout.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/inc.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/btn.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/contents_page.css" rel="stylesheet" type="text/css" />

</head>
<body>
	<div id="LblockCenter">
		<div id="CenterContents">
			<div id="Contents_title"><%=menu_name%> 내용보기</div>
			<div id="Contents_Wrap">
				<ul>
					<li>
						<table class="messagewrite">
							<tr>
								<th>제목</th>
								<td><%=rs("subject")%></td>
							</tr>
							<tr>
								<th>보낸이</th>
								<td><%=rs("fragency")%></td>
							</tr>
							<tr>
								<th>받는이</th>
								<td><%=rs("toagency")%></td>
							</tr>
							<tr>
								<th class="end2">보낸시간</th>
								<td class="end"><%=rs("credt")%></td>
							</tr>
						</table>
					</li>
					<li>
						<div id="Contents_txtarea" style="overflow-y:scroll;"><%=rs("contents")%></div>
					</li>
				</ul>
			</div>
		</div>
		<p class="right">
			<button type="button" class="btn_basic2txt" onclick="<%=session("svHref")%>location.href='/cafe/skin/memo_view.asp?del_seq=<%=memo_seq%>'">삭제</button>
			<button type="button" class="btn_basic2txt" onclick="self.close()">닫기</button>
		</p>
	</div>
</body>
</html>

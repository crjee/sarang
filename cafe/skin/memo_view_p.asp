<!--#include virtual="/ipin_inc.asp"-->
<!--#include virtual="/include/config_inc.asp"-->
<%
	memo_seq = Request("memo_seq")
	del_seq = Request("del_seq")
	If del_seq <> "" Then
		sql = ""
		sql = sql & " delete cf_memo "
		sql = sql & "  where memo_seq = '" & del_seq & "' "
		conn.Execute(sql)
		Response.Write "<script>alert('���� �Ǿ����ϴ�.');opener.parent.list_form.submit();self.close();</script>"
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
		msggo "�޽����� �������� �ʽ��ϴ�.","close"
	End If
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<meta charset="euc-kr" />
<title>��������</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link href="/cafe/skin/css/basic_layout.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/inc.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/btn.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/contents_page.css" rel="stylesheet" type="text/css" />

</head>
<body>
	<div id="LblockCenter">
		<div id="CenterContents">
			<div id="Contents_title"><%=menu_name%> ���뺸��</div>
			<div id="Contents_Wrap">
				<ul>
					<li>
						<table class="messagewrite">
							<tr>
								<th>����</th>
								<td><%=rs("subject")%></td>
							</tr>
							<tr>
								<th>������</th>
								<td><%=rs("fragency")%></td>
							</tr>
							<tr>
								<th>�޴���</th>
								<td><%=rs("toagency")%></td>
							</tr>
							<tr>
								<th class="end2">�����ð�</th>
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
			<button class="btn_basic2txt" type="button" onclick="location.href='memo_view.asp?del_seq=<%=memo_seq%>'">����</button>
			<button class="btn_basic2txt" type="button" onclick="self.close()">�ݱ�</button>
		</p>
	</div>
</body>
</html>

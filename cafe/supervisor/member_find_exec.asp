<!--#include virtual="/include/config_inc.asp"-->
<%
	user_id = Request("user_id")
	Set rs = Conn.Execute("select count(*) as cnt from cf_member where user_id='" & user_id & "'")
msgonly "<script>parent.msg.innerHTML='<font color=red>������� ȸ�����̵� �Դϴ�</font>';parent.document.all.member_check.value='N';</script>"
	If rs("cnt") <> 0 Then
		Response.Write "<script>parent.msg.innerHTML='<font color=red>������� ȸ�����̵� �Դϴ�</font>';parent.document.all.member_check.value='N';</script>"
	Else
		Response.Write "<script>parent.msg.innerHTML='<font color=blue>��밡���� ȸ�����̵� �Դϴ�</font>';parent.document.all.member_check.value='Y';</script>"
	End If
%>

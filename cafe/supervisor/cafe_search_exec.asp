<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = Request("cafe_id")
	Set rs = Conn.Execute("select count(*) as cnt from cf_cafe where cafe_id='" & cafe_id & "'")

	If rs("cnt") <> 0 Then
		Response.Write "<script>parent.msg.innerHTML='<font color=red>������� �������̵� �Դϴ�</font>';parent.document.all.cafe_check.value='N';</script>"
	Else
		Response.Write "<script>parent.msg.innerHTML='<font color=blue>��밡���� �������̵� �Դϴ�</font>';parent.document.all.cafe_check.value='Y';</script>"
	End If
%>
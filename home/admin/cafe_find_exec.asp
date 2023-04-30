<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	cafe_id = Request("cafe_id")
	Set rs = Conn.Execute("select count(*) as cnt from cf_cafe where cafe_id='" & cafe_id & "'")

	If rs("cnt") <> 0 Then
		Response.Write "<script>parent.msg.innerHTML='<font color=red>사용중인 사랑방아이디 입니다</font>';parent.document.all.cafe_check.value='N';</script>"
	Else
		Response.Write "<script>parent.msg.innerHTML='<font color=blue>사용가능한 사랑방아이디 입니다</font>';parent.document.all.cafe_check.value='Y';</script>"
	End If
%>

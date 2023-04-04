<!--#include virtual="/include/config_inc.asp"-->
<%
	user_id = Request("user_id")
	Set rs = Conn.Execute("select count(*) as cnt from cf_member where user_id='" & user_id & "'")
msgonly "<script>parent.msg.innerHTML='<font color=red>사용중인 회원아이디 입니다</font>';parent.document.all.member_check.value='N';</script>"
	If rs("cnt") <> 0 Then
		Response.Write "<script>parent.msg.innerHTML='<font color=red>사용중인 회원아이디 입니다</font>';parent.document.all.member_check.value='N';</script>"
	Else
		Response.Write "<script>parent.msg.innerHTML='<font color=blue>사용가능한 회원아이디 입니다</font>';parent.document.all.member_check.value='Y';</script>"
	End If
%>

<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	If cafe_id = "" Then
		msgend("선택한 요청이 없습니다.")
	End If

	dmnd_id = request("dmnd_id")
	dmnd_prcs_cd = request("dmnd_prcs_cd")

	sql = ""
	sql = sql & " update cf_dmnddel                            "
	sql = sql & "    set dmnd_prcs_cd = '" & dmnd_prcs_cd & "' "
	sql = sql & "       ,dmnd_prcs_dt = getdate()              "
	sql = sql & "       ,modid = '" & Session("user_id") & "'  "
	sql = sql & "       ,moddt = getdate()                     "
	sql = sql & "  where dmnd_id = '" & dmnd_id & "'           "
	Conn.Execute(sql)
%>
<script>
	alert("처리 되었습니다.");
	parent.location = 'dmnddel_view.asp?dmnd_id=<%=dmnd_id%>';
</script>

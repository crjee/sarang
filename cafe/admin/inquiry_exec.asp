<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	inq_id = request("inq_id")
	inq_prcs_cd = request("inq_prcs_cd")

	sql = ""
	sql = sql & " update cf_inquiry                           "
	sql = sql & "    set inq_prcs_cd = '" & inq_prcs_cd & "'  "
	sql = sql & "       ,inq_prcs_dt = getdate()              "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate()                    "
	sql = sql & "  where inq_id = '" & inq_id & "'            "
	Response.write sql
	Conn.Execute(sql)
%>
<script>
	alert("처리 되었습니다.");
	parent.location = 'inquiry_view.asp?inq_id=<%=inq_id%>';
</script>

<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)

	banner_seq = Request("banner_seq")
	sql = ""
	sql = sql & " delete from cf_banner "
	sql = sql & "  where banner_seq = '" & banner_seq & "' "
	Conn.Execute(sql)
%>
<script>
	parent.location = 'banner_list.asp';
</script>

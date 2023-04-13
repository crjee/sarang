<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	For i = 1 To Request("banner_seq").count
		banner_seq = Request("banner_seq")(i)
		banner_num = i

		sql = ""
		sql = sql & " update cf_banner "
		sql = sql & "    set banner_num = '" & banner_num & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where banner_seq = '" & banner_seq & "' "
		Conn.Execute(sql)
	Next
%>
<script>
	parent.location = 'banner_list.asp';
</script>

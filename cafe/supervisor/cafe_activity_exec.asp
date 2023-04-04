<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	for i = 1 to Request("cafe_id").count
		cafe_id = Request("cafe_id")(i)

		sql = ""
		sql = sql & " update cf_cafe "
		sql = sql & "    set activity_yn = case when isnull(activity_yn, 'Y') = 'Y' Then 'N' else 'Y' end "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		Conn.Execute(sql)
	Next

%>
<script>
	alert("변경되었습니다.");
	parent.search_form.target = parent.window.name;
	parent.search_form.action = "cafe_list.asp";
	parent.search_form.submit();
</script>

<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	user_id = Request("user_id")

	sql = ""
	sql = sql & " update cf_cafe_member "
	sql = sql & "    set cafe_mb_level = '2' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & user_id & "' "
	Conn.Execute(sql)
%>
<script>
alert("���Խ��� �Ǿ����ϴ�.")
parent.location = 'join_list.asp'
</script>
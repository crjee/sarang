<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)

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
alert("가입승인 되었습니다.")
parent.location = 'join_list.asp'
</script>

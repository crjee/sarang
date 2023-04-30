<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	If Request("user_id") <> ""  Then
		Set rs = Server.CreateObject("ADODB.Recordset")

		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_admin "
		sql = sql & "  where user_id = '" & Request("user_id") & "' "
		rs.open Sql, conn, 3, 1

		If Not rs.eof And Request("user_id") <> user_id Then
			sql = ""
			sql = sql & " delete "
			sql = sql & "   from cf_admin "
			sql = sql & "  where user_id = '" & Request("user_id") & "' "
			Conn.Execute(sql)
		ElseIf Not rs.eof And Request("user_id")=user_id Then
			Response.WRite "<script>alert('자신을 설정 또는 삭제할수없습니다');</script>"
			Response.end
		Else
			sql = ""
			sql = sql & " insert into cf_admin(               "
			sql = sql & "        user_id                      "
			sql = sql & "       ,cafe_ad_level                "
			sql = sql & "       ,creid                        "
			sql = sql & "       ,credt                        "
			sql = sql & "      ) values(                      "
			sql = sql & "        '" & Request("user_id") & "' "
			sql = sql & "       ,'10'                         "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())                   "
			Conn.Execute(sql)
		End If
		rs.close
		Set rs = Nothing
	End If
%>
<script>
	alert("변경되었습니다.");
	parent.search_form.target = parent.window.name;
	parent.search_form.action = "member_list.asp";
	parent.search_form.submit();
</script>

<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	cafe_mb_level = Request.Form("cafe_mb_level")

	For i = 1 To Request("user_id").count
		user_id = Request("user_id")(i)

		' ��������� �����丮 ����
		sql = ""
		sql = sql & " insert into cf_cafe_member_history( "
		sql = sql & "        cafe_id "
		sql = sql & "       ,user_id "
		sql = sql & "       ,cafe_mb_level "
		sql = sql & "       ,remark "
		sql = sql & "       ,stdate "
		sql = sql & "       ,eddate "
		sql = sql & "      )  "
		sql = sql & " select cafe_id "
		sql = sql & "       ,user_id "
		sql = sql & "       ,cafe_mb_level "
		sql = sql & "       ,'��޺���(���������)' "
		sql = sql & "       ,stdate "
		sql = sql & "       ,getdate() "
		sql = sql & "   from cf_cafe_member "
		sql = sql & "  where user_id = '" & user_id & "' "
		Conn.Execute(sql)

		' �����ȸ����� ����
		sql = ""
		sql = sql & " update cf_cafe_member "
		sql = sql & "    set cafe_mb_level = '" & cafe_mb_level & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where user_id = '" & user_id & "' "
		Conn.Execute(sql)
	Next

	Response.Write "<script>alert('����Ǿ����ϴ�.');parent.document.search_form.submit();</script>"
%>

<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	For i = 1 To Request("chk_user").count
		user_id = Request("chk_user")(i)

		stat = getonevalue("stat","cf_cafe_member","where user_id = '" & user_id & "'")

		If stat = "Y" Then
			' ��������� �����丮 ����
			sql = ""
			sql = sql & " insert into cf_cafe_member_history( "
			sql = sql & "        cafe_id "
			sql = sql & "       ,user_i "
			sql = sql & "       ,cafe_mb_level "
			sql = sql & "       ,remark "
			sql = sql & "       ,stdate "
			sql = sql & "       ,eddate "
			sql = sql & "      ) "
			sql = sql & "select cafe_id "
			sql = sql & "      ,user_id "
			sql = sql & "      ,cafe_mb_level "
			sql = sql & "      ,'ȸ������(������)' "
			sql = sql & "      ,stdate "
			sql = sql & "      ,getdate() "
			sql = sql & "  from cf_cafe_member "
			sql = sql & " where user_id = '" & user_id & "' "
			Conn.Execute(sql)

			' ��������� Ȱ������
			sql = ""
			sql = sql & " update cf_cafe_member "
			sql = sql & "    set stat = 'N' "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where user_id = '" & user_id & "' "
			Conn.Execute(sql)
		Else
			' ��������� �����丮 ����
			sql = ""
			sql = sql & " insert into cf_cafe_member_history( "
			sql = sql & "        cafe_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,cafe_mb_level "
			sql = sql & "       ,remark "
			sql = sql & "       ,stdate "
			sql = sql & "       ,eddate "
			sql = sql & "      ) "
			sql = sql & " select cafe_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,cafe_mb_level "
			sql = sql & "       ,'ȸ����������(������)' "
			sql = sql & "       ,stdate "
			sql = sql & "       ,getdate() "
			sql = sql & "   from cf_cafe_member "
			sql = sql & "  where user_id = '" & user_id & "' "
			Conn.Execute(sql)

			' ��������� Ȱ����
			sql = ""
			sql = sql & " update cf_cafe_member "
			sql = sql & "    set stat = 'Y' "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where user_id = '" & user_id & "' "
			Conn.Execute(sql)
		End If
	Next

	Response.Write "<script>alert('����Ǿ����ϴ�.');parent.document.search_form.submit();</script>"
%>

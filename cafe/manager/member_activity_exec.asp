<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)

	for i=1 to Request("user_id").count
		user_id = Request("user_id")(i)
		stat = GetOneValue("stat","cf_cafe_member","where user_id = '" & user_id & "'")

		If stat = "Y" Then
			' 이전사랑방 히스토리 저장
			sql = ""
			sql = sql & " insert into cf_cafe_member_history( "
			sql = sql & "        cafe_id                      "
			sql = sql & "       ,user_id                      "
			sql = sql & "       ,cafe_mb_level                "
			sql = sql & "       ,remark                       "
			sql = sql & "       ,stdate                       "
			sql = sql & "       ,eddate                       "
			sql = sql & "      )                              "
			sql = sql & " select cafe_id                      "
			sql = sql & "       ,user_id                      "
			sql = sql & "       ,cafe_mb_level                "
			sql = sql & "       ,'사랑방정지(사랑방지기)'           "
			sql = sql & "       ,stdate                       "
			sql = sql & "       ,getdate()                    "
			sql = sql & "   from cf_cafe_member               "
			sql = sql & "  where user_id = '" & user_id & "'  "
			Conn.Execute(sql)

			' 사랑방 활동정지
			sql = ""
			sql = sql & " update cf_cafe_member "
			sql = sql & "    set stat = 'N' "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where user_id = '" & user_id & "' "
			Conn.Execute(sql)
		Else

			' 사랑방 히스토리 저장
			sql = ""
			sql = sql & " insert into cf_cafe_member_history( "
			sql = sql & "        cafe_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,cafe_mb_level "
			sql = sql & "       ,remark "
			sql = sql & "       ,stdate "
			sql = sql & "       ,eddate "
			sql = sql & "      )  "
			sql = sql & " select cafe_id  "
			sql = sql & "       ,user_id  "
			sql = sql & "       ,cafe_mb_level  "
			sql = sql & "       ,'사랑방활동(사랑방지기)'  "
			sql = sql & "       ,stdate "
			sql = sql & "       ,getdate() "
			sql = sql & "     from cf_cafe_member "
			sql = sql & "    where user_id = '" & user_id & "' "
			Conn.Execute(sql)

			' 사랑방 활동중
			sql = ""
			sql = sql & " update cf_cafe_member "
			sql = sql & "    set stat = 'Y' "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where user_id = '" & user_id & "' "
			Conn.Execute(sql)
		End If

	next

	Response.Write "<script>alert('변경되었습니다.');parent.document.search_form.submit();</script>"
%>

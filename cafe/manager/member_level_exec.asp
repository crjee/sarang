<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	cafe_mb_level = Request.Form("cafe_mb_level")

	For i = 1 To Request("user_id").count
		user_id = Request("user_id")(i)

		' 이전사랑방 히스토리 저장
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
		sql = sql & "       ,'등급변경(사랑방지기)' "
		sql = sql & "       ,stdate "
		sql = sql & "       ,getdate() "
		sql = sql & "   from cf_cafe_member "
		sql = sql & "  where user_id = '" & user_id & "' "
		Conn.Execute(sql)

		' 사랑방회원등급 변경
		sql = ""
		sql = sql & " update cf_cafe_member "
		sql = sql & "    set cafe_mb_level = '" & cafe_mb_level & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where user_id = '" & user_id & "' "
		Conn.Execute(sql)
	Next

	Response.Write "<script>alert('변경되었습니다.');parent.document.search_form.submit();</script>"
%>

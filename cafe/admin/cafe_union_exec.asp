<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	For i = 1 To Request("cafe_id").count
		cafe_id = Request("cafe_id")(i)
		union_id = Request("union_id_" & cafe_id)
		old_union_id = Request("old_union_id_" & cafe_id)

		' 이전 연합회지기 히스토리 저장
		sql = ""
		sql = sql & " insert into cf_union_manager_history( "
		sql = sql & "        union_id "
		sql = sql & "       ,user_id "
		sql = sql & "       ,union_mb_level "
		sql = sql & "       ,remark "
		sql = sql & "       ,stdate "
		sql = sql & "       ,eddate "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "        )  "
		sql = sql & " select union_id "
		sql = sql & "       ,user_id "
		sql = sql & "       ,union_mb_level "
		sql = sql & "       ,'연합회지기 삭제(관리자)' "
		sql = sql & "       ,stdate "
		sql = sql & "       ,getdate() "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate() "
		sql = sql & "   from cf_union_manager "
		sql = sql & "  where user_id in (select user_id from cf_cafe_member where cafe_id = '" & cafe_id & "') "
		sql = sql & "    and union_id = '" & old_union_id & "' "
		Conn.Execute(sql)

		' 기존 연합회지기 삭제
		sql = ""
		sql = sql & " delete cf_union_manager "
		sql = sql & "  where user_id in (select user_id from cf_cafe_member where cafe_id = '" & cafe_id & "') "
		sql = sql & "    and union_id = '" & old_union_id & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " update cf_cafe "
		sql = sql & "    set union_id = '" & union_id & "' "
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

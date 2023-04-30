<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	cafe_cnt = Request("cafe_id").count

	If cafe_cnt = 0 Then
		msgend("선택한 사랑방이 없습니다.")
	End If

	For i = 1 To Request("cafe_id").count
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

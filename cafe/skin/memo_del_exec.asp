<!--#include virtual="/include/config_inc.asp"-->
<%
	stype = Request("stype")

	for i = 1 to Request("memo_seq").count
		memo_seq = Request("memo_seq")(i)
		If stype = "o" Then
			va = "fr_stat"
		Else
			va = "to_stat"
		End If

		sql = ""
		sql = sql & " update cf_memo "
		sql = sql & "    set " & va & " = 'Y' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where memo_seq = '" & memo_seq & "' "
		Conn.Execute(sql)
	Next
%>
<script>
	alert('삭제되었습니다')
	top.location.href='memo_list.asp?stype=<%=stype%>';
</script>

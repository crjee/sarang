<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	stype = Request("stype")

	For i = 1 to Request("memo_seq").count
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
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("삭제 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='memo_list.asp?stype=<%=stype%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/location.href=memo_list.asp?stype=<%=stype%>') ;
<%
	End if
%>
</script>

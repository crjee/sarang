<!--#include virtual="/include/config_inc.asp"-->
<%
	open_url = Request("open_url")
	open_name = Request("open_name")
	open_specs = Request("open_specs")

	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '" & ipin & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '" & session("user_id") & "' "
	Conn.Execute(sql)

	open_url = open_url & " & user_id=" & session("user_id") & " & ipin=" & ipin
%>
<script>
	var <%=ipin%> = window.open("<%=open_url%>","<%=open_name%>","<%=open_specs%>");
	setTimeout(function(){<%=ipin%>.focus()}, 500);
</script>

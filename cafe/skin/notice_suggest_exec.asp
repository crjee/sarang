<!--#include virtual="/include/config_inc.asp"-->
<%
	menu_type = "notice"

	page      = request("page")
	sch_type  = request("sch_type")
	sch_word  = request("sch_word")

	Set row = Server.CreateObject ("ADODB.Recordset")

	notice_seq = Request("notice_seq")

	Set rs = Conn.Execute("select * from cf_notice where notice_seq = '" & notice_seq & "' ")
	If Not rs.eof Then

		If instr(rs("suggest_info"), user_id) Then
			Response.Write "<script>alert('" & session("agency") & "���� �̹� ��õ�ϼ̽��ϴ�.');history.back();</script>"
			Response.End
		Else

			remote_addr = request.ServerVariables("REMOTE_ADDR")

			sql = ""
			sql = sql & " update cf_notice "
			sql = sql & "    set suggest_cnt = suggest_cnt + 1 "
			sql = sql & "       ,suggest_info = suggest_info + CAST('" & remote_addr & "' + '" & user_id & ",' as VARCHAR(MAX)) "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where notice_seq = '" & notice_seq & "' "
			Conn.Execute(sql)

		End If
	Else
		Response.Write "<script>alert('�Խù��� ���������ʽ��ϴ�.');history.back();</script>"
		Response.End
	End If
%>
<script>
	alert("��õ �Ǿ����ϴ�.");
	location.href='notice_view.asp?notice_seq=<%=notice_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>

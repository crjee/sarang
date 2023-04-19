<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_type = "notice"

	page      = request("page")
	sch_type  = request("sch_type")
	sch_word  = request("sch_word")

	Set row = Server.CreateObject ("ADODB.Recordset")

	notice_seq = Request("notice_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_notice "
	sql = sql & "  where notice_seq = '" & notice_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then

		If instr(rs("suggest_info"), user_id) Then
			Response.Write "<script>alert('" & session("agency") & "님은 이미 추천하셨습니다.');history.back();</script>"
			Response.End
		Else

			remote_addr = request.ServerVariables("REMOTE_ADDR")

			sql = ""
			sql = sql & " update cf_notice "
			sql = sql & "    set suggest_cnt = isnull(suggest_cnt, 0) + 1 "
			sql = sql & "       ,suggest_info = isnull(suggest_info, '') + CAST('" & remote_addr & "' + '" & user_id & ",' as VARCHAR(MAX)) "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where notice_seq = '" & notice_seq & "' "
			Conn.Execute(sql)

		End If
	Else
		Response.Write "<script>alert('게시물이 존재하지않습니다.');history.back();</script>"
		Response.End
	End If
	rs.close
	Set rs = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("추천 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='notice_view.asp?notice_seq=<%=notice_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/notice_view.asp?notice_seq=<%=notice_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>') ;
<%
	End if
%>
</script>

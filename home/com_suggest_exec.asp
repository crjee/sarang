<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)

	page      = request("page")
	sch_type  = request("sch_type")
	sch_word  = request("sch_word")

	com_seq = Request("com_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & " "
	sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "'' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If instr(rs("suggest_info"), user_id) Then
			Response.Write "<script>alert('" & session("agency") & "님은 이미 추천하셨습니다.');history.back();</script>"
			Response.End
		Else
			remote_addr = request.ServerVariables("REMOTE_ADDR")

			sql = ""
			sql = sql & " update cf_" & menu_type & " "
			sql = sql & "    set suggest_cnt = suggest_cnt + 1 "
			sql = sql & "       ,suggest_info = suggest_info + CAST('" & remote_addr & "' + '" & user_id & ",' as VARCHAR(MAX)) "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
			Conn.Execute(sql)
		End If
	Else
		Response.Write "<script>alert('게시물이 존재하지않습니다.');history.back();</script>"
		Response.End
	End If

	If instr("notice,board,news,pds",menu_type) Then
		pgm = "board"
	Else
		pgm = menu_type
	End If
%>
<script>
	alert("추천 되었습니다.");
	location.href='<%=pgm%>_view.asp?<%=menu_type%>_seq=<%=com_seq%>&menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>

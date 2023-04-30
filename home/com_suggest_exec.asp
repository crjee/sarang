<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckReadAuth(cafe_id)

	page     = request("page")
	sch_type = request("sch_type")
	sch_word = request("sch_word")

	com_seq = Request("com_seq")

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from gi_" & menu_type & " "
	sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
	rs.Open Sql, conn, 3, 1

	If instr(rs("suggest_info"), user_id) Then
		msgend session("agency") & "님은 이미 추천하셨습니다."
	Else
		remote_addr = request.ServerVariables("REMOTE_ADDR")

		sql = ""
		sql = sql & " update gi_" & menu_type & " "
		sql = sql & "    set suggest_cnt = isnull(suggest_cnt, 0) + 1 "
		sql = sql & "       ,suggest_info = isnull(suggest_info, '') + CAST('" & remote_addr & "' + '" & Session("user_id") & ",' as VARCHAR(MAX)) "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		Conn.Execute(sql)
	End If

	If instr("notice,board,news,pds",menu_type) Then
		pgm = "board"
	Else
		pgm = menu_type
	End If
%>
<script>
	alert("추천 되었습니다.");
	parent.location.href='<%=pgm%>_view.asp?<%=menu_type%>_seq=<%=com_seq%>&menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
</script>

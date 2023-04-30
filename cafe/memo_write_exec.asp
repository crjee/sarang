<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	subject   = Replace(Request.Form("subject"),"'","&#39;")
	contents  = Replace(Request.form("contents"),"'","&#39;")
	alluser   = Request.Form("alluser")
	opt_value = Request.Form("opt_value")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	new_seq = GetComSeq("cf_memo")

	If alluser = "all" Then
	
		Set rs = Server.CreateObject("ADODB.Recordset")
		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_cafe_member cm "
		sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.stat = 'Y' and mi.memo_receive_yn != 'N' "
		sql = sql & "  where cm.cafe_id = '" & cafe_id & "'"
		sql = sql & "    and cm.user_id != '" & Session("user_id") & "'"
		rs.Open Sql, conn, 1, 1

		Do Until rs.eof

			sql = ""
			sql = sql & " insert into cf_memo( "
			sql = sql & "        memo_seq "
			sql = sql & "       ,fr_user "
			sql = sql & "       ,to_user "
			sql = sql & "       ,subject "
			sql = sql & "       ,contents "
			sql = sql & "       ,fr_stat "
			sql = sql & "       ,to_stat "
			sql = sql & "       ,stat "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & user_id & "' "
			sql = sql & "       ,'" & rs("user_id") & "' "
			sql = sql & "       ,'" & subject & "' "
			sql = sql & "       ,'" & contents & "' "
			sql = sql & "       ,'0' "
			sql = sql & "       ,'0' "
			sql = sql & "       ,'0' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
			rs.MoveNext

		loop
	Else
		to_user = Split(opt_value, ",")
		for i=0 to UBound(to_user)

			sql = ""
			sql = sql & " insert into cf_memo( "
			sql = sql & "        memo_seq "
			sql = sql & "       ,fr_user "
			sql = sql & "       ,to_user "
			sql = sql & "       ,subject "
			sql = sql & "       ,contents "
			sql = sql & "       ,fr_stat "
			sql = sql & "       ,to_stat "
			sql = sql & "       ,stat "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,'" & Trim(to_user(i)) & "' "
			sql = sql & "       ,'" & subject & "' "
			sql = sql & "       ,'" & contents & "' "
			sql = sql & "       ,'0' "
			sql = sql & "       ,'0' "
			sql = sql & "       ,'0' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		Next
	End If

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("전송 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.document.location = "memo_write.asp?menu_seq=<%=menu_seq%>"
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', './skin/memo_write.asp?menu_seq=<%=menu_seq%>') ;
<%
	End If
%>
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End If
%>

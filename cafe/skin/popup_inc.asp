<script type="text/javascript">
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_popup cp "
	sql = sql & "  where cp.cafe_id = '" & cafe_id & "' "
	sql = sql & "    and cp.popup_num <> 0 "
	rs.open sql, Conn, 3
	popup_cnt = rs.recordcount

	p_left = "170"
	p_top = "150"
	i = 1

	If Not rs.eof Then
		Do Until rs.eof
			menu_seq = rs("menu_seq")
			popup_num = rs("popup_num")

			popup_key = "popup_" & menu_seq & "_" & popup_num

			if len(Request.Cookies(popup_key))="0" or Request.Cookies(popup_key)<>"ok" Then
%>
	var openwin<%=i%> = window.open('/cafe/skin/popup_view.asp?cafe_id=<%=cafe_id%>&popup_key=<%=popup_key%>&menu_seq=<%=menu_seq%>&popup_num=<%=popup_num%>&user_id=<%=session("user_id")%>&ipin=<%=ipin%>', 'open<%=i%>', 'width=450px,height=350px,left=<%=p_left%>,top=<%=p_top%>,resizable=yes');
	setTimeout(function(){
		openwin<%=i%>.focus()
	}, 500);

	var open<%=i%> = true;
<%
				If (popup_cnt > 3 And i = 2) or (popup_cnt = 3 And i = 3) Then
					p_top = p_top + 390
					p_left = 170
				else
					p_left = p_left + 460
				End If

				i = i + 1
			End If

			rs.MoveNext
		Loop
	End If
	rs.close

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_notice cp "
	sql = sql & "  where cp.pop_yn = 'Y' "
	sql = sql & "    and (cafe_id = null or cafe_id = '' or ', ' + cafe_id + ', ' like '%" & ", " & cafe_id & ", " & "%') "
	rs.open sql, Conn, 3
	popup_cnt = rs.recordcount

	p_left = "200"
	p_top = "180"
	i = 1

	If Not rs.eof Then
		Do Until rs.eof
			notice_seq = rs("notice_seq")

			popup_key = "notice_seq_" & notice_seq

			if len(Request.Cookies(popup_key))="0" or Request.Cookies(popup_key)<>"ok" Then
%>
	var opennotice<%=i%> = window.open('/cafe/skin/popup_view.asp?notice_seq=<%=notice_seq%>&popup_key=<%=popup_key%>&user_id=<%=session("user_id")%>&ipin=<%=ipin%>', 'notice<%=i%>', 'width=450px,height=350px,left=<%=p_left%>,top=<%=p_top%>,resizable=yes');
	setTimeout(function(){
		opennotice<%=i%>.focus()
	}, 500);

	var open<%=i%> = true;
<%
				If (popup_cnt > 3 And i = 2) or (popup_cnt = 3 And i = 3) Then
					p_top = p_top + 380
					p_left = 0
				else
					p_left = p_left + 460
				End If

				i = i + 1
			End If

			rs.MoveNext
		Loop
	End If
	rs.close

	Set rs = nothing
%>
	function resetPop(){
		if (open1 && openwin1)
		{
			openwin1.close();
		}
		if (open2 && openwin2)
		{
			openwin2.close();
		}
		if (open3 && openwin3)
		{
			openwin3.close();
		}
		if (open4 && openwin4)
		{
			openwin4.close();
		}
	}
</script>

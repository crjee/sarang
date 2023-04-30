<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)

	task = Request("task")

	Set rs = Server.CreateObject("ADODB.Recordset")

	If task = "ins" Then
		com_seq     = Request("" & menu_type & "_seq")
		comment_seq = Request("comment_seq")
		comment     = Request("comment")
		new_seq     = GetComSeq("cf_" & menu_type & "_comment")

		If comment_seq = "" Then ' 새글
			group_num = new_seq
			level_num = 0
			step_num = 0
		Else ' 답글
			sql = ""
			sql = sql & " select * "
			sql = sql & "   from cf_" & menu_type & "_comment "
			sql = sql & "  where comment_seq = '" & comment_seq  & "' "
			rs.Open Sql, conn, 3, 1

			If Not rs.EOF Then
				group_num = rs("group_num")
				level_num = rs("level_num")
				step_num = rs("step_num")
			End If
			rs.close

			level_num = level_num + 1

			sql = ""
			sql = sql & " update cf_" & menu_type & "_comment "
			sql = sql & "    set step_num = step_num + 1 "
			sql = sql & "  where group_num = " & group_num  & " "
			sql = sql & "    and step_num > " & step_num  & " "
			Conn.Execute(sql)

			step_num = step_num + 1
		End If

		sql = ""
		sql = sql & " insert into cf_" & menu_type & "_comment( "
		sql = sql & "        comment_seq "
		sql = sql & "       ,group_num "
		sql = sql & "       ,step_num "
		sql = sql & "       ,level_num "
		sql = sql & "       ,user_id "
		sql = sql & "       ," & menu_type & "_seq "
		sql = sql & "       ,comment "
		sql = sql & "       ,agency "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & new_seq & "' "
		sql = sql & "       ,'" & group_num & "' "
		sql = sql & "       ,'" & step_num & "' "
		sql = sql & "       ,'" & level_num & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,'" & com_seq & "' "
		sql = sql & "       ,'" & comment & "' "
		sql = sql & "       ,'" & Session("agency") & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)

		sql = ""
		sql = sql & " update cf_" & menu_type & " "
		sql = sql & "    set comment_cnt = (select count(" & menu_type & "_seq) from cf_" & menu_type & "_comment where " & menu_type & "_seq = '" & com_seq & "') "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = " & com_seq & " "
		Conn.Execute(sql)

		Response.Write "<script>alert('저장 되었습니다.');</script>"
	Else ' 삭제
		comment_seq = Request("comment_seq")
		cafe_mb_level = GetUserLevel(cafe_id)

		If cafe_mb_level >= 6 Then ' 사랑방지기 이면 하위 댓글까지 삭제
			Call ExecDeleteComment(menu_type, comment_seq)
			Response.Write "<script>alert('삭제 되었습니다.');</script>"
		Else
			sql = ""
			sql = sql & " select * "
			sql = sql & "  from cf_" & menu_type & "_comment "
			sql = sql & "  where user_id = '" & Session("user_id") & "' "
			sql = sql & "     and comment_seq = '" & comment_seq & "' "
			rs.Open Sql, conn, 3, 1

			If Not rs.eof Then ' 글쓴이 이면 하위 댓글까지 삭제
				Call ExecDeleteComment(menu_type, comment_seq)
				Response.Write "<script>alert('삭제 되었습니다.');</script>"
			Else ' 글쓴이 아니면
				Response.Write "<script>alert('권한이없습니다');</script>"
				Response.End
			End If
		End If
	End If

	If instr("notice,board,news,pds",menu_type) Then
		pgm = "board"
	Else
		pgm = menu_type
	End If
%>
<script>
	var f = parent.document.search_form;
	f.action = "<%=pgm%>_view.asp";
	f.submit()
</script>

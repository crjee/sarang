<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	For i = 1 To 4
		menu_seq = Request("menu_seq" & i)
		popup_num = Request("popup_num" & i)

		If menu_seq <> "" Then

			sql = ""
			sql = sql & " select * "
			sql = sql & "   from cf_board "
			sql = sql & "  where cafe_id = '" & cafe_id & "' "
			sql = sql & "    and menu_seq = '" & menu_seq & "' "
			sql = sql & "    and board_num = '" & popup_num & "' "

			Set rs = Conn.Execute(sql)
			If Not rs.eof Then

				sql = ""
				sql = sql & " select * "
				sql = sql & "   from cf_popup "
				sql = sql & "  where popup_order = '" & i & "' "
				sql = sql & "     and cafe_id = '" & cafe_id & "' "

				Set row = Conn.Execute(sql)

				If Not row.eof Then

					sql = ""
					sql = sql & " update cf_popup "
					sql = sql & "    set menu_seq = '" & menu_seq & "' "
					sql = sql & "       ,popup_num = '" & popup_num & "' "
					sql = sql & "       ,modid = '" & Session("user_id") & "' "
					sql = sql & "       ,moddt = getdate() "
					sql = sql & "  where cafe_id = '" & cafe_id & "' "
					sql = sql & "    and popup_order = '" & i & "' "

					Conn.Execute(sql)

				Else

					new_seq = getSeq("cf_popup")

					sql = ""
					sql = sql & " insert into cf_popup( "
					sql = sql & "        popup_seq "
					sql = sql & "       ,popup_order "
					sql = sql & "       ,cafe_id "
					sql = sql & "       ,menu_seq "
					sql = sql & "       ,popup_num "
					sql = sql & "       ,creid "
					sql = sql & "       ,credt "
					sql = sql & "      ) values( "
					sql = sql & "        '" & new_seq & "' "
					sql = sql & "       ,'" & i & "' "
					sql = sql & "       ,'" & cafe_id & "' "
					sql = sql & "       ,'" & menu_seq & "' "
					sql = sql & "       ,'" & popup_num & "' "
					sql = sql & "       ,'" & Session("user_id") & "' "
					sql = sql & "       ,getdate())"
					Conn.Execute(sql)

				End If
			Else
				msgonly i& " 번째 게시판의 " & popup_num & " 글번호는 존재하지 않습니다."
				sql = ""
				sql = sql & " delete cf_popup "
				sql = sql & "  where cafe_id = '" & cafe_id & "' "
				sql = sql & "    and popup_order = '" & i & "' "
				Conn.Execute(sql)
			End If
		Else
			sql = ""
			sql = sql & " delete cf_popup "
			sql = sql & "  where cafe_id = '" & cafe_id & "' "
			sql = sql & "    and popup_order = '" & i & "' "
			Conn.Execute(sql)
		End If
	Next

%>
<script>
parent.location = 'popup_list.asp'
</script>

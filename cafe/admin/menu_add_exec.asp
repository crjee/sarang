<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()
	cafe_id = "home"

	For i = 1 To Request("menu_seq").count
		menu_seq  = Request("menu_seq")(i)
		menu_name = Request("menu_name")(i)
		page_type = Request("page_type")(i)
		menu_type = Request("menu_type")(i)

		If menu_seq = "" Then
			menu_num = i

			If menu_type = "group" Then
				new_seq = getSeq("cf_menu")

				sql = ""
				sql = sql & " insert into cf_menu( "
				sql = sql & "        menu_seq  "
				sql = sql & "       ,cafe_id   "
				sql = sql & "       ,menu_name "
				sql = sql & "       ,page_type "
				sql = sql & "       ,menu_type "
				sql = sql & "       ,menu_num  "
				sql = sql & "       ,hidden_yn "
				sql = sql & "       ,home_cnt  "
				sql = sql & "       ,home_num  "
				sql = sql & "       ,creid     "
				sql = sql & "       ,credt     "
				sql = sql & "      ) values(  "
				sql = sql & "        '" & new_seq   & "' "
				sql = sql & "       ,'" & cafe_id   & "' "
				sql = sql & "       ,'" & menu_name & "' "
				sql = sql & "       ,'gr'                "
				sql = sql & "       ,'" & menu_type & "' "
				sql = sql & "       ,'" & menu_num  & "' "
				sql = sql & "       ,'N'  "
				sql = sql & "       ,null "
				sql = sql & "       ,'0'  "
				sql = sql & "       ,'" & Session("user_id") & "'"
				sql = sql & "       ,getcate())"
				Conn.Execute(sql)
			Else
				new_seq = getSeq("cf_menu")

				If InStr("board,pds", page_type) > 0 Then
					write_auth = 1
				Else
					write_auth = 10
				End If
				
				sql = ""
				sql = sql & " insert into cf_menu(menu_seq "
				sql = sql & "       ,cafe_id    "
				sql = sql & "       ,menu_name  "
				sql = sql & "       ,page_type  "
				sql = sql & "       ,menu_type  "
				sql = sql & "       ,menu_num   "
				sql = sql & "       ,hidden_yn  "
				sql = sql & "       ,home_cnt   "
				sql = sql & "       ,home_num   "
				sql = sql & "       ,top_cnt    "
				sql = sql & "       ,write_auth "
				sql = sql & "       ,reply_auth "
				sql = sql & "       ,read_auth  "
				sql = sql & "       ,editor_yn  "
				sql = sql & "       ,daily_cnt  "
				sql = sql & "       ,inc_del_yn "
				sql = sql & "       ,list_info  "
				sql = sql & "       ,creid      "
				sql = sql & "       ,credt      "
				sql = sql & "      ) values(    "
				sql = sql & "        '" & new_seq   & "' "
				sql = sql & "       ,'" & cafe_id   & "' "
				sql = sql & "       ,'" & menu_name & "' "
				sql = sql & "       ,'" & page_type & "' "
				sql = sql & "       ,'" & menu_type & "' "
				sql = sql & "       ,'" & menu_num  & "' "
				sql = sql & "       ,'N'  "
				sql = sql & "       ,null "
				sql = sql & "       ,'0'  "
				sql = sql & "       ,0    "
				sql = sql & "       ,'" & write_auth & "' "
				sql = sql & "       ,'" & write_auth & "' "
				sql = sql & "       ,'1'  "
				sql = sql & "       ,'Y'  "
				sql = sql & "       ,9999 "
				sql = sql & "       ,'Y'  "
				sql = sql & "       ,null "
				sql = sql & "       ,'" & Session("user_id") & "'"
				sql = sql & "       ,getcate())"
				Conn.Execute(sql)
				Response.write sql & "<br><br>"
			End If
		Else
			sql = ""
			sql = sql & " update cf_menu "
			sql = sql & "    set menu_num = '" & i & "' "
			sql = sql & "  where menu_seq = '" & menu_seq & "' "
			Conn.Execute(sql)
		End If
	Next
%>
<script>
	parent.location = parent.location;
</script>

<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

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
				sql = sql & " insert into cf_menu(menu_seq "
				sql = sql & "       ,cafe_id "
				sql = sql & "       ,menu_name "
				sql = sql & "       ,page_type "
				sql = sql & "       ,menu_type "
				sql = sql & "       ,menu_num "
				sql = sql & "       ,hidden_yn "
				sql = sql & "       ,home_cnt "
				sql = sql & "       ,home_num "
				sql = sql & "       ,creid "
				sql = sql & "       ,credt "
				sql = sql & "      ) values( "
				sql = sql & "        '" & new_seq & "' "
				sql = sql & "       ,'" & cafe_id & "' "
				sql = sql & "       ,'" & menu_name & "' "
				sql = sql & "       ,'gr' "
				sql = sql & "       ,'" & menu_type & "' "
				sql = sql & "       ,'" & menu_num & "' "
				sql = sql & "       ,'N' "
				sql = sql & "       ,null "
				sql = sql & "       ,'0' "
				sql = sql & "       ,'" & Session("user_id") & "' "
				sql = sql & "       ,getdate())"
				Conn.Execute(sql)
			Else
				new_seq = getSeq("cf_menu")

				If InStr("board,pds", page_type) > 0 Then
					write_auth = 1
				Else
					write_auth = 10
				End If
				
				sql = "insert into cf_menu(menu_seq,cafe_id,menu_name,page_type,menu_type,menu_num,hidden_yn,home_cnt,home_num,top_cnt,write_auth,reply_auth,read_auth,editor_yn,daily_cnt,inc_del_yn,list_info,creid) values "
				sql = sql & "('" & new_seq & "','" & cafe_id & "','" & menu_name & "','" & page_type & "','" & menu_type & "','" & menu_num & "','N','','0',0,'" & write_auth & "','" & write_auth & "','1','Y',9999,'Y',null,'" & Session("user_id") & "')"
				Conn.Execute(sql)
				Response.write sql & "<br><br>"
			End If
		Else
			sql = ""
			sql = sql & " update cf_menu "
			sql = sql & "    set menu_num = '" & i & "' "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where menu_seq = '" & menu_seq & "' "
			Conn.Execute(sql)
		End If
	Next
%>
<script>
	parent.location = parent.location;
</script>

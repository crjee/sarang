<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()
	cafe_id = "home"

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set home_num = '0' "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_seq = '" & Request("menu_seq") & "' "
	Conn.Execute(sql)

	'���θ޴� ó��
	sql = ""
	sql = sql & " update cf_menu                                                     "
	sql = sql & "    set home_num = 0                                                "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                                     "
	sql = sql & "    and hidden_yn = 'Y'                                             "
	sql = sql & " ;                                                                  "
	sql = sql & " update t1                                                          "
	sql = sql & "    set home_num = rownum                                           "
	sql = sql & "   from (select row_number() over (order by home_num asc) as rownum "
	sql = sql & "               ,*                                                   "
	sql = sql & "          from cf_menu cm                                           "
	sql = sql & "         where cafe_id = '" & cafe_id & "'                              "
	sql = sql & "           and menu_type not in ('page','group','division')         "
	sql = sql & "           and home_num != 0                                        "
	sql = sql & "        ) t1                                                        "
	Conn.Execute(sql)
%>
<script>
parent.location = 'main_list.asp';
</script>

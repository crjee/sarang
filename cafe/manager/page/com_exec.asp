<!--#include virtual="/include/config_inc.asp"-->
<%
	menu_seq   = Request("menu_seq")
	menu_type  = Request("menu_type")
	cafe_id    = Request("cafe_id")
	menu_name  = Request("menu_name")
	home_cnt   = Request("home_cnt")
	hidden_yn  = Request("hidden_yn")
	write_auth = Request("write_auth")
	reply_auth = Request("reply_auth")
	read_auth  = Request("read_auth")
	editor_yn  = Request("editor_yn")
	daily_cnt  = Request("daily_cnt")
	inc_del_yn = Request("inc_del_yn")
	list_info  = Request("list_info")

	if hidden_yn = "" Then hidden_yn = "N"

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set menu_name  = '" & menu_name  & "' "
	sql = sql & "       ,home_cnt   = '" & home_cnt   & "' "
	sql = sql & "       ,hidden_yn  = '" & hidden_yn  & "' "
	sql = sql & "       ,write_auth = '" & write_auth & "' "
	sql = sql & "       ,reply_auth = '" & reply_auth & "' "
	sql = sql & "       ,read_auth  = '" & read_auth  & "' "
	sql = sql & "       ,editor_yn  = '" & editor_yn  & "' "
	sql = sql & "       ,daily_cnt  = '" & daily_cnt  & "' "
	sql = sql & "       ,inc_del_yn = '" & inc_del_yn & "' "
	sql = sql & "       ,list_info  = '" & list_info  & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	'메인메뉴 처리
	sql = ""
	sql = sql & " update cf_menu                                                     "
	sql = sql & "    set home_num = 0                                                "
	sql = sql & "       ,modid = '" & Session("user_id") & "'                            "
	sql = sql & "       ,moddt = getdate()                                           "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                                     "
	sql = sql & "    and hidden_yn = 'Y'                                             "
	sql = sql & " ;                                                                  "
	sql = sql & " update t1                                                          "
	sql = sql & "    set home_num = rownum                                           "
	sql = sql & "       ,modid = '" & Session("user_id") & "'                            "
	sql = sql & "       ,moddt = getdate()                                           "
	sql = sql & "   from (select row_number() over (order by home_num asc) as rownum "
	sql = sql & "               ,*                                                   "
	sql = sql & "          from cf_menu cm                                           "
	sql = sql & "         where cafe_id = '" & cafe_id & "'                              "
	sql = sql & "           and menu_type not in ('page','group','division')         "
	sql = sql & "           and home_num != 0                                        "
	sql = sql & "        ) t1                                                        "
	Conn.Execute(sql)
%>
<form name="form" action="../menu_list.asp" method="post" target="_parent">
	<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
	<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
	<input type="hidden" name="menu_type" value="<%=menu_type%>">
</form>
<script>
	document.form.submit();
</script>

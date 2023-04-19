<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq       = Request("menu_seq")
	menu_type      = Request("menu_type")
	cafe_id        = Request("cafe_id")
	menu_name      = Request("menu_name")
	home_cnt       = Request("home_cnt")
	hidden_yn      = Request("hidden_yn")
	write_auth     = Request("write_auth")
	reply_auth     = Request("reply_auth")
	read_auth      = Request("read_auth")
	editor_yn      = Request("editor_yn")
	daily_cnt      = Request("daily_cnt")
	inc_del_yn     = Request("inc_del_yn")
	list_info      = Request("list_info")
	tab_use_yn     = Request("tab_use_yn")
	tab_nm         = Request("tab_nm")
	all_tab_use_yn = Request("all_tab_use_yn")
	etc_tab_use_yn = Request("etc_tab_use_yn")

	If hidden_yn = "" Then hidden_yn = "N"

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set menu_name      = '" & menu_name      & "' "
	sql = sql & "       ,home_cnt       = '" & home_cnt       & "' "
	sql = sql & "       ,hidden_yn      = '" & hidden_yn      & "' "
	sql = sql & "       ,write_auth     = '" & write_auth     & "' "
	sql = sql & "       ,reply_auth     = '" & reply_auth     & "' "
	sql = sql & "       ,read_auth      = '" & read_auth      & "' "
	sql = sql & "       ,editor_yn      = '" & editor_yn      & "' "
	sql = sql & "       ,daily_cnt      = '" & daily_cnt      & "' "
	sql = sql & "       ,inc_del_yn     = '" & inc_del_yn     & "' "
	sql = sql & "       ,list_info      = '" & list_info      & "' "
	sql = sql & "       ,tab_use_yn     = '" & tab_use_yn     & "' "
	sql = sql & "       ,tab_nm         = '" & tab_nm         & "' "
	sql = sql & "       ,all_tab_use_yn = '" & all_tab_use_yn & "' "
	sql = sql & "       ,etc_tab_use_yn = '" & etc_tab_use_yn & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	'메인메뉴 처리
	sql = ""
	sql = sql & " update cf_menu                                                     "
	sql = sql & "    set home_num = 0                                                "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                                 "
	sql = sql & "    and hidden_yn = 'Y'                                             "
	sql = sql & " ;                                                                  "
	sql = sql & " update t1                                                          "
	sql = sql & "    set home_num = rownum                                           "
	sql = sql & "   from (select row_number() over (order by home_num asc) as rownum "
	sql = sql & "               ,*                                                   "
	sql = sql & "          from cf_menu cm                                           "
	sql = sql & "         where cafe_id = '" & cafe_id & "'                          "
	sql = sql & "           and menu_type not in ('page','group','division')         "
	sql = sql & "           and home_num != 0                                        "
	sql = sql & "        ) t1                                                        "
	Conn.Execute(sql)

	For i = 1 To Request("section_seq").count
		If Request("section_nm")(i) <> "" Then
			If Request("section_seq")(i) = "" Then
				new_seq    = getSeq("cf_menu_section")
				section_nm = Request("section_nm")(i)

				use_yn = "Y"
				ip_addr = request.ServerVariables("remote_addr")

				sql = ""
				sql = sql & " insert into cf_menu_section(        "
				sql = sql & "        section_seq                  "
				sql = sql & "       ,menu_seq                     "
				sql = sql & "       ,section_nm                   "
				sql = sql & "       ,section_expl                 "
				sql = sql & "       ,section_sn                   "
				sql = sql & "       ,use_yn                       "
				sql = sql & "       ,del_yn                       "
				sql = sql & "       ,rgtr_id                      "
				sql = sql & "       ,reg_dt                       "
				sql = sql & "       ,reg_ip_addr                  "
				sql = sql & "      ) values(                      "
				sql = sql & "        '" & new_seq & "'            "
				sql = sql & "       ,'" & menu_seq & "'           "
				sql = sql & "       ,'" & section_nm & "'         "
				sql = sql & "       ,null                         "
				sql = sql & "       ,'" & i & "'                  "
				sql = sql & "       ,'Y'                          "
				sql = sql & "       ,'N'                          "
				sql = sql & "       ,'" & Session("user_id") & "' "
				sql = sql & "       ,getdate()                    "
				sql = sql & "       ,'" & ip_addr & "'            "
				sql = sql & "      )                              "
				Conn.Execute(sql)
			Else
				section_seq = Request("section_seq")(i)
				section_nm  = Request("section_nm")(i)
				use_yn      = Request("use_yn"&(i))
				If use_yn = "" Then use_yn = "N"
				ip_addr = request.ServerVariables("remote_addr")

				sql = ""
				sql = sql & " update cf_menu_section                              "
				sql = sql & "    set section_nm    = '" & section_nm & "'         "
				sql = sql & "       ,section_sn    = '" & i & "'                  "
				sql = sql & "       ,use_yn        = '" & use_yn & "'             "
				sql = sql & "       ,mdfr_id       = '" & Session("user_id") & "' "
				sql = sql & "       ,mdfcn_dt      = getdate()                    "
				sql = sql & "       ,mdfcn_ip_addr = '" & ip_addr & "'            "
				sql = sql & " where section_seq = '" & section_seq & "'           "
				Conn.Execute(sql)
			End If
		End If
	Next
%>
<form name="form" action="../menu_list.asp" method="post" target="_parent">
	<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
	<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
	<input type="hidden" name="menu_type" value="<%=menu_type%>">
</form>
<script>
	document.form.submit();
</script>

<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	skin_id             = Request.Form("skin_id")
	skin_left_id        = Request.Form("skin_left_id")
	skin_left_color01   = Request.Form("skin_left_color01")
	skin_left_color02   = Request.Form("skin_left_color02")
	skin_left_color03   = Request.Form("skin_left_color03")
	skin_left_font01    = Request.Form("skin_left_font01")
	skin_center_id      = Request.Form("skin_center_id")
	skin_center_color01 = Request.Form("skin_center_color01")
	skin_center_color02 = Request.Form("skin_center_color02")
	skin_center_font01  = Request.Form("skin_center_font01")
	skin_center_font02  = Request.Form("skin_center_font02")
	skin_body_id        = Request.Form("skin_body_id")
	skin_body_color01   = Request.Form("skin_body_color01")

	sql = ""
	sql = sql & "  merge into cf_skin tbl "
	sql = sql & "  using (select '" & cafe_id & "' as col) src "
	sql = sql & "     on (tbl.cafe_id = src.col) "
	sql = sql & "   when matched Then "
	sql = sql & " update set skin_id             = '" & skin_id             & "' "
	sql = sql & "           ,skin_left_id        = '" & skin_left_id        & "' "
	sql = sql & "           ,skin_left_color01   = '" & skin_left_color01   & "' "
	sql = sql & "           ,skin_left_color02   = '" & skin_left_color02   & "' "
	sql = sql & "           ,skin_left_color03   = '" & skin_left_color03   & "' "
	sql = sql & "           ,skin_left_font01    = '" & skin_left_font01    & "' "
	sql = sql & "           ,skin_center_id      = '" & skin_center_id      & "' "
	sql = sql & "           ,skin_center_color01 = '" & skin_center_color01 & "' "
	sql = sql & "           ,skin_center_color02 = '" & skin_center_color02 & "' "
	sql = sql & "           ,skin_center_font01  = '" & skin_center_font01  & "' "
	sql = sql & "           ,skin_center_font02  = '" & skin_center_font02  & "' "
	sql = sql & "           ,skin_body_id        = '" & skin_body_id        & "' "
	sql = sql & "           ,skin_body_color01   = '" & skin_body_color01   & "' "
	sql = sql & "           ,modid               = '" & Session("user_id")  & "' "
	sql = sql & "           ,moddt               = getdate()                 "
	sql = sql & "   when not matched Then "
	sql = sql & " insert (cafe_id             "
	sql = sql & "        ,skin_id             "
	sql = sql & "        ,skin_left_id        "
	sql = sql & "        ,skin_left_color01   "
	sql = sql & "        ,skin_left_color02   "
	sql = sql & "        ,skin_left_color03   "
	sql = sql & "        ,skin_left_font01    "
	sql = sql & "        ,skin_center_id      "
	sql = sql & "        ,skin_center_color01 "
	sql = sql & "        ,skin_center_color02 "
	sql = sql & "        ,skin_center_font01  "
	sql = sql & "        ,skin_center_font02  "
	sql = sql & "        ,skin_body_id        "
	sql = sql & "        ,skin_body_color01   "
	sql = sql & "        ,creid               "
	sql = sql & "        ,credt               "
	sql = sql & "        )   "
	sql = sql & " values ('" & cafe_id             & "' "
	sql = sql & "        ,'" & skin_id             & "' "
	sql = sql & "        ,'" & skin_left_id        & "' "
	sql = sql & "        ,'" & skin_left_color01   & "' "
	sql = sql & "        ,'" & skin_left_color02   & "' "
	sql = sql & "        ,'" & skin_left_color03   & "' "
	sql = sql & "        ,'" & skin_left_font01    & "' "
	sql = sql & "        ,'" & skin_center_id      & "' "
	sql = sql & "        ,'" & skin_center_color01 & "' "
	sql = sql & "        ,'" & skin_center_color02 & "' "
	sql = sql & "        ,'" & skin_center_font01  & "' "
	sql = sql & "        ,'" & skin_center_font02  & "' "
	sql = sql & "        ,'" & skin_body_id        & "' "
	sql = sql & "        ,'" & skin_body_color01   & "' "
	sql = sql & "        ,'" & Session("user_id")  & "' "
	sql = sql & "        ,getdate()                 "
	sql = sql & "        );   "
	Conn.Execute(sql)
	session("skin_id") = skin_id

	For i = 1 To Request("home_num").count
		home_num                 = Request("home_num")(i)
		menu_skin_center_id      = Request("menu_skin_center_id")(i)
		menu_skin_center_color01 = Request("menu_skin_center_color01")(i)
		menu_skin_center_color02 = Request("menu_skin_center_color02")(i)
		menu_skin_center_color03 = Request("menu_skin_center_color03")(i)

		sql = ""
		sql = sql & " update cf_menu                                                     "
		sql = sql & "    set menu_skin_center_id      = '" & menu_skin_center_id       & "' "
		sql = sql & "       ,menu_skin_center_color01 = '" & menu_skin_center_color01  & "' "
		sql = sql & "       ,menu_skin_center_color02 = '" & menu_skin_center_color02  & "' "
		sql = sql & "       ,menu_skin_center_color03 = '" & menu_skin_center_color03  & "' "
		sql = sql & "  where cafe_id = '" & cafe_id & "'                                     "
		sql = sql & "    and home_num = '" & home_num & "'                                   "
		Conn.Execute(sql)
	Next
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("스킨을 저장했습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='/cafe/main.asp';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/main.asp') ;
<%
	End if
%>
</script>

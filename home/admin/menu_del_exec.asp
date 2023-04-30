<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()
	cafe_id = "home"

	menu_seq = Request("menu_seq")
	
	set rs = server.createobject("adodb.recordset")

	sql = ""
	sql = sql & " select menu_type                     "
	sql = sql & "       ,page_type                     "
	sql = sql & "   from cf_menu                       "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	sql = sql & "    and cafe_id  = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	menu_type = rs("menu_type")
	page_type = rs("page_type")
	rs.close

	Select Case menu_type
		Case "page"
			Select Case page_type
				Case "1" : cnt = 0
				Case "2" : cnt = 0
				Case "4" : cnt = 0
				Case "5" : cnt = 0
			End Select
		Case "memo"    : cnt = 0 ' GetOneValue("count(*)","cf_memo","where menu_seq='" & menu_seq & "'")
		Case "land"    : cnt = 0
		Case "album"   : cnt = GetOneValue("count(*)","cf_album","where menu_seq='" & menu_seq & "'")
		Case "board"   : cnt = GetOneValue("count(*)","cf_board","where menu_seq='" & menu_seq & "'")
		Case "sale"    : cnt = GetOneValue("count(*)","cf_sale","where menu_seq='" & menu_seq & "'")
		Case "nsale"   : cnt = GetOneValue("count(*)","cf_nsale","where menu_seq='" & menu_seq & "'")
		Case "job"     : cnt = GetOneValue("count(*)","cf_story","where menu_seq='" & menu_seq & "'")
		Case "poll"    : cnt = 0 ' GetOneValue("count(*)","cf_poll","where menu_seq='" & menu_seq & "'")
		Case "member"  : cnt = 0
		Case "group"   : cnt = 0
		Case Else msgonly "dd"
	End Select

	If cnt > 0 Then
		msggo "해당 메뉴에 등록된 정보가 있어 삭제할 수 없습니다.\n\n메뉴감추기 기능을 이용하세요.", "preload"
		Response.end
	End If

	'메뉴 삭제
	sql = ""
	sql = sql & " delete                               "
	sql = sql & "   from cf_menu                       "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	'메인메뉴 처리
	sql = ""
	sql = sql & " update cf_menu                                                      "
	sql = sql & "    set home_num = 0                                                 "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                                  "
	sql = sql & "    and hidden_yn = 'Y'                                              "
	sql = sql & " ;                                                                   "
	sql = sql & " update t1                                                           "
	sql = sql & "    set home_num = rownum                                            "
	sql = sql & "   from (select row_number() over (order by home_num asc) as rownum  "
	sql = sql & "               ,*                                                    "
	sql = sql & "          from cf_menu cm                                            "
	sql = sql & "         where cafe_id = '" & cafe_id & "'                           "
	sql = sql & "           and menu_type not in ('page','group','division')          "
	sql = sql & "           and home_num != 0                                         "
	sql = sql & "        ) t1                                                         "
	Conn.Execute(sql)
%>
<script>
	parent.location = parent.location;
</script>

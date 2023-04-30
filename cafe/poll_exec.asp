<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	poll_seq = Request("poll_seq")
	ans = Request.Form("ans")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_poll_user "
	sql = sql & "  where user_id = '" & Session("user_id") & "' "
	sql = sql & "    and poll_seq  = '" & poll_seq & "' "

	Set row = Conn.Execute(sql)

	If row.eof Then
		sql = ""
		sql = sql & " update cf_poll_ans "
		sql = sql & "        set " & ans & " = " & ans & "+1 "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where poll_seq='" & poll_seq & "'"
		Conn.Execute(sql)

		sql = ""
		sql = sql & " insert into cf_poll_user( "
		sql = sql & "        poll_seq           "
		sql = sql & "       ,user_id            "
		sql = sql & "       ,creid              "
		sql = sql & "       ,credt              "
		sql = sql & "      ) values(            "
		sql = sql & "        '" & poll_seq & "' "
		sql = sql & "       ,'" & Session("user_id")  & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)

		Response.Write "<script>alert('투표하였습니다')</script>"
		Response.End
	Else
		Response.Write "<script>alert('이미 설문조사에 참여하신 회원이십니다')</script>"
	End If
%>

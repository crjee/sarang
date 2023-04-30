<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	member_seq    = Request.Form("member_seq")
	user_id       = Request.Form("user_id")
	user_pw       = Request.Form("user_pw")
	kname         = Request.Form("kname")
	ename         = Request.Form("ename")
	agency        = Request.Form("agency")
	license       = Request.Form("license")
	birth         = Request.Form("birth")
	sex           = Request.Form("sex")
	email         = Request.Form("email")
	mobile        = Request.Form("mobile")
	phone         = Request.Form("phone")
	interphone    = Request.Form("interphone")
	fax           = Request.Form("fax")
	erec          = Request.Form("erec")
	mrec          = Request.Form("mrec")
	zipcode       = Request.Form("zipcode")
	addr1         = Request.Form("addr1")
	addr2         = Request.Form("addr2")
	stat          = Request.Form("stat")
	cafe_id       = Request.Form("cafe_id")
	cafe_mb_level = Request.Form("cafe_mb_level")
	email         = Request.Form("email1") & "@" & Request.Form("email2")
	mobile        = Request.Form("mobile1") & "-" & Request.Form("mobile2") & "-" & Request.Form("mobile3")
	stat = "Y"
	memo_receive_yn = "Y"

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn

	sql = ""
	sql = sql & " insert into cf_member( "
	sql = sql & "        user_id "
	sql = sql & "       ,user_pw "
	sql = sql & "       ,kname "
	sql = sql & "       ,ename "
	sql = sql & "       ,agency "
	sql = sql & "       ,license "
	sql = sql & "       ,birth "
	sql = sql & "       ,sex "
	sql = sql & "       ,email "
	sql = sql & "       ,mobile "
	sql = sql & "       ,phone "
	sql = sql & "       ,interphone "
	sql = sql & "       ,fax "
	sql = sql & "       ,zipcode "
	sql = sql & "       ,addr1 "
	sql = sql & "       ,addr2 "
	sql = sql & "       ,stat "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,mlevel "
	sql = sql & "       ,memo_receive_yn "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values( "
	sql = sql & "        '" & user_id & "' "
	sql = sql & "       ,'" & user_pw & "' "
	sql = sql & "       ,'" & kname & "' "
	sql = sql & "       ,'" & ename & "' "
	sql = sql & "       ,'" & agency & "' "
	sql = sql & "       ,'" & license & "' "
	sql = sql & "       ,'" & birth & "' "
	sql = sql & "       ,'" & sex & "' "
	sql = sql & "       ,'" & email & "' "
	sql = sql & "       ,'" & mobile & "' "
	sql = sql & "       ,'" & phone & "' "
	sql = sql & "       ,'" & interphone & "' "
	sql = sql & "       ,'" & fax & "' "
	sql = sql & "       ,'" & zipcode & "' "
	sql = sql & "       ,'" & addr1 & "' "
	sql = sql & "       ,'" & addr2 & "' "
	sql = sql & "       ,'" & stat & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & cafe_mb_level & "' "
	sql = sql & "       ,'" & memo_receive_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate()"
	Conn.Execute(sql)

	If cafe_id <> "" Then
		' 신규 사랑방 회원정보 가입
		sql = ""
		sql = sql & " insert into cf_cafe_member( "
		sql = sql & "        cafe_id "
		sql = sql & "       ,user_id "
		sql = sql & "       ,stat "
		sql = sql & "       ,stdate "
		sql = sql & "       ,cafe_mb_level "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & cafe_id & "' "
		sql = sql & "       ,'" & user_id & "' "
		sql = sql & "       ,'Y' "
		sql = sql & "       ,getdate() "
		sql = sql & "       ,'" & cafe_mb_level & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate() "
		sql = sql & ") "
		Conn.Execute(sql)
	End If

	If Err.Number <> 0 Then
		'// DB를 롤백 후 DB객체 소멸
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 발생했습니다.<%=Err.Description%>");
</script>
<%
	Else
		'// DB롤 커밋 후 DB객체 소멸
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("등록되었습니다");
	parent.location.href = 'member_list.asp';
</script>
<%
	End If
%>

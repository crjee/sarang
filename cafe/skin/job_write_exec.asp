<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request.Form("menu_seq")
	top_yn = Request.Form("top_yn")

	subject = Replace(Request.Form("subject"),"'","&#39;")
	work  = Request.Form("work")
	age1  = Request.Form("age1")
	age2  = Request.Form("age2")

	sex        = Request.Form("sex")
	work_year  = Request.Form("work_year")
	certify    = Request.Form("certify")
	work_place = Request.Form("work_place")
	agency     = Request.Form("agency")
	person     = Request.Form("person")
	tel_no     = Request.Form("tel_no")
	mbl_telno  = Request.Form("mbl_telno")
	fax_no     = Request.Form("fax_no")
	email      = Request.Form("email")
	homepage   = Request.Form("homepage")
	method     = Request.Form("method")
	end_date   = Request.Form("end_date")
	contents   = Request.Form("ir1")

	If age1 <> "" Or age2 <> "" Then
	age  = age1 & "~" & age2
	End if

	on Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	new_seq = getSeq("cf_job")

	sql = ""
	sql = sql & " insert into cf_job(job_seq "
	sql = sql & "       ,subject "
	sql = sql & "       ,work "
	sql = sql & "       ,age "
	sql = sql & "       ,sex "
	sql = sql & "       ,work_year "
	sql = sql & "       ,certify "
	sql = sql & "       ,work_place "
	sql = sql & "       ,agency "
	sql = sql & "       ,person "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,fax_no "
	sql = sql & "       ,email "
	sql = sql & "       ,homepage "
	sql = sql & "       ,method "
	sql = sql & "       ,end_date "
	sql = sql & "       ,contents "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,user_id "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values("
	sql = sql & "       ,'" & new_seq & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & work & "' "
	sql = sql & "       ,'" & age & "' "
	sql = sql & "       ,'" & sex & "' "
	sql = sql & "       ,'" & work_year & "' "
	sql = sql & "       ,'" & certify & "' "
	sql = sql & "       ,'" & work_place & "' "
	sql = sql & "       ,'" & agency & "' "
	sql = sql & "       ,'" & person & "' "
	sql = sql & "       ,'" & tel_no & "' "
	sql = sql & "       ,'" & fax_no & "' "
	sql = sql & "       ,'" & email & "' "
	sql = sql & "       ,'" & homepage & "' "
	sql = sql & "       ,'" & method & "' "
	sql = sql & "       ,'" & end_date & "' "
	sql = sql & "       ,'" & contents & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & user_id & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_job where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_job "
	sql = sql & "  where cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	Set UploadForm = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("입력 되었습니다.");
	parent.location.href='job_list.asp?menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>';
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End if
%>


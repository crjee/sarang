<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('수정 권한이없습니다');</script>"
		Response.End
	End If

	menu_seq  = Request("menu_seq")
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	self_yn   = Request("self_yn")
	all_yn    = Request("all_yn")

	job_seq = Request.Form("job_seq")
	top_yn = Request.Form("top_yn")
	subject = Request.Form("subject")
	work  = Request.Form("work")
	age1  = Request.Form("age1")
	age2  = Request.Form("age2")

	If age1 <> "" Or age2 <> "" Then
	age  = age1 & "~" & age2
	End if
	sex  = Request.Form("sex")
	work_year  = Request.Form("work_year")
	certify  = Request.Form("certify")
	work_place  = Request.Form("work_place")
	agency  = Request.Form("agency")
	person  = Request.Form("person")
	tel_no  = Request.Form("tel_no")
	fax_no  = Request.Form("fax_no")
	email  = Request.Form("email")
	homepage  = Request.Form("homepage")
	method  = Request.Form("method")
	end_date1 = Request.Form("end_date1")
	end_date2 = Request.Form("end_date2") : If Len(end_date2) = 1 Then end_date2 = "0" & end_date2
	end_date3 = Request.Form("end_date3") : If Len(end_date3) = 1 Then end_date3 = "0" & end_date3
	If end_date1 <> "" And end_date2 <> "" And end_date3 <> "" Then
		end_date = end_date1 & "-" & end_date2 & "-" & end_date3
	End if
	contents  = Request.Form("ir1")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " update cf_job "
	sql = sql & "    set subject    = '" & subject & "' "
	sql = sql & "       ,work       = '" & work & "' "
	sql = sql & "       ,age        = '" & age & "' "
	sql = sql & "       ,sex        = '" & sex & "' "
	sql = sql & "       ,work_year  = '" & work_year & "' "
	sql = sql & "       ,certify    = '" & certify & "' "
	sql = sql & "       ,work_place = '" & work_place & "' "
	sql = sql & "       ,agency     = '" & agency & "' "
	sql = sql & "       ,person     = '" & person & "' "
	sql = sql & "       ,tel_no     = '" & tel_no & "' "
	sql = sql & "       ,fax_no     = '" & fax_no & "' "
	sql = sql & "       ,email      = '" & email & "' "
	sql = sql & "       ,homepage   = '" & homepage & "' "
	sql = sql & "       ,method     = '" & method & "' "
	sql = sql & "       ,end_date   = '" & end_date & "' "
	sql = sql & "       ,contents   = '" & contents & "' "
	sql = sql & "       ,top_yn     = '" & top_yn & "' "
	sql = sql & "       ,modid      = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt      = getdate() "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_job where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)
%>
<script>
	parent.location.href='job_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&job_seq=<%=job_seq%>&self_yn=<%=self_yn%>&all_yn=<%=all_yn%>';
</script>


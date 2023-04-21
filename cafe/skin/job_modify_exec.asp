<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & request("menu_seq")  & "'")
	If toInt(write_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('수정 권한이없습니다');</script>"
		Response.End
	End If

	menu_seq  = request("menu_seq")
	page      = request("page")
	pagesize  = request("pagesize")
	sch_type  = request("sch_type")
	sch_word  = request("sch_word")
	self_yn   = request("self_yn")
	all_yn    = request("all_yn")

	job_seq     = request.Form("job_seq")
	top_yn      = request.Form("top_yn")
	subject     = request.Form("subject")
	work        = request.Form("work")
	age1        = request.Form("age1")
	age2        = request.Form("age2")
	sex         = request.Form("sex")
	work_year   = request.Form("work_year")
	certify     = request.Form("certify")
	work_place  = request.Form("work_place")
	agency      = request.Form("agency")
	person      = request.Form("person")
	tel_no      = request.Form("tel_no")
	mbl_telno   = request.Form("mbl_telno")
	fax_no      = request.Form("fax_no")
	email       = request.Form("email")
	homepage    = request.Form("homepage")
	method      = request.Form("method")
	end_date    = request.Form("end_date")
	contents    = request.Form("ir1")
	section_seq = request.Form("section_seq")

	If age1 <> "" Or age2 <> "" Then
		age  = age1 & "~" & age2
	End if

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " update cf_job                                     "
	sql = sql & "    set subject     = '" & subject            & "' "
	sql = sql & "       ,work        = '" & work               & "' "
	sql = sql & "       ,age         = '" & age                & "' "
	sql = sql & "       ,sex         = '" & sex                & "' "
	sql = sql & "       ,work_year   = '" & work_year          & "' "
	sql = sql & "       ,certify     = '" & certify            & "' "
	sql = sql & "       ,work_place  = '" & work_place         & "' "
	sql = sql & "       ,agency      = '" & agency             & "' "
	sql = sql & "       ,person      = '" & person             & "' "
	sql = sql & "       ,tel_no      = '" & tel_no             & "' "
	sql = sql & "       ,mbl_telno   = '" & mbl_telno          & "' "
	sql = sql & "       ,fax_no      = '" & fax_no             & "' "
	sql = sql & "       ,email       = '" & email              & "' "
	sql = sql & "       ,homepage    = '" & homepage           & "' "
	sql = sql & "       ,method      = '" & method             & "' "
	sql = sql & "       ,end_date    = '" & end_date           & "' "
	sql = sql & "       ,contents    = '" & contents           & "' "
	sql = sql & "       ,top_yn      = '" & top_yn             & "' "
	sql = sql & "       ,section_seq = '" & section_seq        & "' "
	sql = sql & "       ,modid       = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt       = getdate()                    "
	sql = sql & "  where job_seq = '" & job_seq & "'                "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_job where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='job_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&job_seq=<%=job_seq%>&self_yn=<%=self_yn%>&all_yn=<%=all_yn%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/job_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&job_seq=<%=job_seq%>&self_yn=<%=self_yn%>&all_yn=<%=all_yn%>') ;
<%
	End if
%>
</script>

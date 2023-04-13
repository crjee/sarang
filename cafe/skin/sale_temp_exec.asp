<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	ScriptTimeOut = 5000
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "sale\"
	uploadform.DefaultPath = uploadFolder
	' 하나의 파일 크기를 10MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024
	' 전체 파일의 크기를 50MB 이하로 제한.
	uploadform.TotalLen = 50*1024*1024

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	Set rs = server.createobject("adodb.recordset")

	sale_seq  = uploadform("sale_seq")
	level_num = uploadform("level_num")
	step_num  = uploadform("step_num")
	location  = uploadform("location")
	bargain   = uploadform("bargain")
	area      = uploadform("area")
	floor     = uploadform("floor")
	compose   = uploadform("compose")
	price     = uploadform("price")
	live_in   = uploadform("live_in")
	parking   = uploadform("parking")
	traffic   = uploadform("traffic")
	purpose   = uploadform("purpose")
	tel_no    = uploadform("tel_no")
	fax_no    = uploadform("fax_no")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_sale "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	new_seq = getSeq("cf_temp_sale")

	parent_seq = ""
	sale_num = getNum("sale", cafe_id, menu_seq)
	group_num = sale_num
	level_num = 0
	step_num = 0

	sql = ""
	sql = sql & " insert into cf_temp_sale( "
	sql = sql & "        sale_seq "
	sql = sql & "       ,parent_seq "
	sql = sql & "       ,group_num "
	sql = sql & "       ,step_num "
	sql = sql & "       ,level_num "
	sql = sql & "       ,sale_num "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,menu_seq "
	sql = sql & "       ,agency "
	sql = sql & "       ,location "
	sql = sql & "       ,bargain "
	sql = sql & "       ,area "
	sql = sql & "       ,floor "
	sql = sql & "       ,compose "
	sql = sql & "       ,price "
	sql = sql & "       ,live_in "
	sql = sql & "       ,parking "
	sql = sql & "       ,traffic "
	sql = sql & "       ,purpose "
	sql = sql & "       ,subject "
	sql = sql & "       ,contents "
	sql = sql & "       ,tel_no "
	sql = sql & "       ,fax_no "
	sql = sql & "       ,view_cnt "
	sql = sql & "       ,suggest_cnt "
	sql = sql & "       ,link "
	sql = sql & "       ,top_yn "
	sql = sql & "       ,user_id "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values( "
	sql = sql & "        '" & new_seq & "' "
	sql = sql & "       ,'" & parent_seq & "' "
	sql = sql & "       ,'" & group_num & "' "
	sql = sql & "       ,'" & level_num & "' "
	sql = sql & "       ,'" & step_num & "' "
	sql = sql & "       ,'" & sale_num & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & menu_seq & "' "
	sql = sql & "       ,'" & Session("agency") & "' "
	sql = sql & "       ,'" & location & "' "
	sql = sql & "       ,'" & bargain & "' "
	sql = sql & "       ,'" & area & "' "
	sql = sql & "       ,'" & floor & "' "
	sql = sql & "       ,'" & compose & "' "
	sql = sql & "       ,'" & price & "' "
	sql = sql & "       ,'" & live_in & "' "
	sql = sql & "       ,'" & parking & "' "
	sql = sql & "       ,'" & traffic & "' "
	sql = sql & "       ,'" & purpose & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & ir1 & "' "
	sql = sql & "       ,'" & tel_no & "' "
	sql = sql & "       ,'" & fax_no & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	sale_seq = new_seq

	Set UploadForm = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
</script>
<%
	End if
%>

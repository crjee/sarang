<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "sale\"
	uploadform.DefaultPath = uploadFolder

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	step_num = uploadform("step_num")
	level_num = uploadform("level_num")
	sale_seq = uploadform("sale_seq")
	page_type = uploadform("page_type")
	kname = uploadform("kname")
	location = uploadform("location")
	bargain = uploadform("bargain")
	area = uploadform("area")
	floor = uploadform("floor")
	compose = uploadform("compose")
	price = uploadform("price")
	live_in = uploadform("live_in")
	parking = uploadform("parking")
	traffic = uploadform("traffic")
	purpose = uploadform("purpose")
	subject = uploadform("subject")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	tel_no = uploadform("tel_no")
	fax_no = uploadform("fax_no")
	top_yn = uploadform("top_yn")

	For Each item In uploadform("file_name")
		If item <> "" Then
			IF item.FileLen > UploadForm.MaxFileLen Then
				call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
				Set UploadForm = Nothing
				Response.End
			End If
		End If
	Next

	For Each item In uploadform("file_name")
		If item <> "" Then
			FilePath = item.Save(,False)
		End If
	Next

	sql = ""
	sql = sql & " update cf_sale "
	sql = sql & "    set subject = '" & subject  & "' "
	sql = sql & "       ,contents= '" & ir1      & "' "
	sql = sql & "       ,top_yn  = '" & top_yn   & "'  "
	sql = sql & "       ,location= '" & location & "' "
	sql = sql & "       ,bargain = '" & bargain  & "' "
	sql = sql & "       ,area    = '" & area     & "' "
	sql = sql & "       ,floor   = '" & floor    & "' "
	sql = sql & "       ,compose = '" & compose  & "' "
	sql = sql & "       ,price   = '" & price    & "' "
	sql = sql & "       ,live_in = '" & live_in  & "' "
	sql = sql & "       ,parking = '" & parking  & "' "
	sql = sql & "       ,traffic = '" & traffic  & "' "
	sql = sql & "       ,purpose = '" & purpose  & "'  "
	sql = sql & "       ,tel_no  = '" & tel_no   & "'  "
	sql = sql & "       ,fax_no  = '" & fax_no   & "' "
	sql = sql & "       ,modid   = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt   = getdate() "
	sql = sql & " where sale_seq='" & sale_seq & "'"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_sale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid   = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt   = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	For Each item In uploadform("file_name")
		If item <> "" Then
			new_seq = getSeq("cf_sale_data")

			sql = ""
			sql = sql & " insert into cf_sale_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,sale_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & sale_seq & "' "
			sql = sql & "       ,'" & item.LastSavedFileName & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate())"
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='sale_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&sale_seq=<%=sale_seq%>';
<%
	Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/sale_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&sale_seq=<%=sale_seq%>') ;
<%
	End if
%>
</script>


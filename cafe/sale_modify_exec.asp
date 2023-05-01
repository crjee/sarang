<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	Call CheckMultipart()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "sale\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = uploadform(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckModifyAuth(cafe_id)

	dsplyFolder  = ConfigAttachedFileFolder & "display\sale\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\sale\"

	Set fso = CreateObject("Scripting.FileSystemObject")
	Set rs = Server.CreateObject("ADODB.Recordset")

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	sale_seq   = uploadform("sale_seq")

	top_yn      = uploadform("top_yn")
	pop_yn      = uploadform("pop_yn")
	section_seq = uploadform("section_seq")
	subject     = Replace(uploadform("subject"),"'","&#39;")
	contents    = Replace(uploadform("contents"),"'","&#39;")
	link        = uploadform("link")
	If link     = "http://" Then link = ""

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

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
	mbl_telno = uploadform("mbl_telno")
	fax_no    = uploadform("fax_no")

	sql = ""
	sql = sql & " update cf_sale                                          "
	sql = sql & "    set top_yn            = '" & top_yn             & "' "
	sql = sql & "       ,pop_yn            = '" & pop_yn             & "' "
	sql = sql & "       ,section_seq       = '" & section_seq        & "' "
	sql = sql & "       ,subject           = '" & subject            & "' "
	sql = sql & "       ,contents          = '" & contents           & "' "
	sql = sql & "       ,link              = '" & link               & "' "

	sql = sql & "       ,location          = '" & location           & "' "
	sql = sql & "       ,bargain           = '" & bargain            & "' "
	sql = sql & "       ,area              = '" & area               & "' "
	sql = sql & "       ,floor             = '" & floor              & "' "
	sql = sql & "       ,compose           = '" & compose            & "' "
	sql = sql & "       ,price             = '" & price              & "' "
	sql = sql & "       ,live_in           = '" & live_in            & "' "
	sql = sql & "       ,parking           = '" & parking            & "' "
	sql = sql & "       ,traffic           = '" & traffic            & "' "
	sql = sql & "       ,purpose           = '" & purpose            & "' "
	sql = sql & "       ,tel_no            = '" & tel_no             & "' "
	sql = sql & "       ,mbl_telno         = '" & mbl_telno          & "' "
	sql = sql & "       ,fax_no            = '" & fax_no             & "' "

	sql = sql & "       ,modid             = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt             = getdate()                    "
	sql = sql & "  where sale_seq         = '" & sale_seq            & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu                                                                                         "
	sql = sql & "    set top_cnt   = (select count(*) from cf_sale where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate()                                                                           "
	sql = sql & "       ,modid     = '" & Session("user_id") & "'                                                        "
	sql = sql & "       ,moddt     = getdate()                                                                           "
	sql = sql & "  where menu_seq  = '" & menu_seq & "'                                                                  "
	Conn.Execute(sql)

	com_seq = sale_seq

%>
<!--#include  virtual="/include/attach_exec_inc.asp"-->
<%

	Set rs = Nothing
	Set fso = Nothing
	Set uploadform = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
<%
		If session("noFrame") = "Y" Then
%>
	parent.location.href='sale_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&self_yn=<%=self_yn%>&sale_seq=<%=sale_seq%>';
<%
		Else
%>
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/sale_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&self_yn=<%=self_yn%>&sale_seq=<%=sale_seq%>') ;
<%
		End If
%>
</script>
<%
		Set fso = CreateObject("Scripting.FileSystemObject")

		uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
		dsplyFolder  = ConfigAttachedFileFolder & "display\" & menu_type & "\"
		thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\" & menu_type & "\"

		For j = 1 To img_i
			If img_file_name(j) <> "" Then
				If (fso.FileExists(uploadFolder & img_file_name(j))) Then
					fso.DeleteFile(uploadFolder & img_file_name(j))
				End If
				If (fso.FileExists(dsplyFolder & dsply_file_nm(j))) Then
					fso.DeleteFile(dsplyFolder & dsply_file_nm(j))
				End If
				If (fso.FileExists(thmbnlFolder & thmbnl_file_nm(j))) Then
					fso.DeleteFile(thmbnlFolder & thmbnl_file_nm(j))
				End If
			End If
		Next

		For j = 1 To data_i
			If data_file_name(j) <> "" Then
				If (fso.FileExists(uploadFolder & data_file_name(j))) Then
					fso.DeleteFile(uploadFolder & data_file_name(j))
				End If
			End If
		Next

		Set fso = Nothing
	End If
%>

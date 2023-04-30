<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckMultipart()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "picture\"
	uploadform.DefaultPath = uploadFolder

	' 하나의 파일 크기를 1MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024
	' 전체 파일의 크기를 50MB 이하로 제한.
	uploadform.TotalLen = 50*1024*1024

	Call CheckManager(cafe_id)

	If uploadform("picture") <> "" Then
		FilePath = uploadform("picture").Save(,False)
		picture = uploadform("picture").LastSavedFileName
	End If

	menu_seq  = uploadform("menu_seq")
	cafe_id   = uploadform("cafe_id")
	menu_type = uploadform("menu_type")
	page_type = uploadform("page_type")
	menu_name = uploadform("menu_name")
	hidden_yn = uploadform("hidden_yn")
	contents = Replace(uploadform("contents"),"'","&#39;")
	contents2 = Replace(uploadform("contents2"),"'","&#39;")
	doc = uploadform("doc")

	Select Case page_type
	Case "1"
		regulation = contents
	Case "2"
		introduction = contents
		greetings = contents2
	Case "4"
		roster = contents
	Case "5"
		organogram = contents
	End Select

	If hidden_yn = "" Then hidden_yn = "N"

	If page_type <> "" Then
		sql = ""
		sql = sql & " update cf_page "
		Select Case page_type
		Case "1"
		sql = sql & "    set regulation = '" & contents & "' "
		Case "2"
		sql = sql & "    set introduction = '" & contents & "' "
		sql = sql & "       ,greetings = '" & contents2 & "' "
		sql = sql & "       ,picture = '" & picture & "' "
		Case "4"
		sql = sql & "    set roster = '" & contents & "' "
		Case "5"
		sql = sql & "    set organogram = '" & contents & "' "
		End select
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		Conn.Execute(sql)
	End If

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set menu_name = '" & menu_name & "' "
	sql = sql & "       ,hidden_yn = '" & hidden_yn & "' "
	sql = sql & "       ,doc = '" & doc & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)
%>
<form name="form" action="../menu_list.asp" method="post" target="_parent">
	<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
	<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
	<input type="hidden" name="menu_type" value="<%=menu_type%>">
</form>
<script>
	document.form.submit();
</script>

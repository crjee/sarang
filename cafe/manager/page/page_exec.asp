<!--#include virtual="/include/config_inc.asp"-->
<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")

	uploadFolder = ConfigAttachedFileFolder & "picture\"
	uploadform.DefaultPath = uploadFolder
	' �ϳ��� ���� ũ�⸦ 1MB���Ϸ� ����.
	uploadform.MaxFileLen = 10*1024*1024
	' ��ü ������ ũ�⸦ 50MB ���Ϸ� ����.
	uploadform.TotalLen = 50*1024*1024

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
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	ir12 = Replace(uploadform("ir12"),"'"," & #39;")
	doc = uploadform("doc")

	Select Case page_type
	Case "1"
		regulation = ir1
	Case "2"
		introduction = ir1
		greetings = ir12
	Case "4"
		roster = ir1
	Case "5"
		organogram = ir1
	End Select

	If hidden_yn = "" Then hidden_yn = "N"

	If page_type <> "" Then
		sql = ""
		sql = sql & " update cf_page "
		Select Case page_type
		Case "1"
		sql = sql & "    set regulation = '" & ir1 & "' "
		Case "2"
		sql = sql & "    set introduction = '" & ir1 & "' "
		sql = sql & "       ,greetings = '" & ir12 & "' "
		sql = sql & "       ,picture = '" & picture & "' "
		Case "4"
		sql = sql & "    set roster = '" & ir1 & "' "
		Case "5"
		sql = sql & "    set organogram = '" & ir1 & "' "
		End select
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		Conn.Execute(sql)
	End if

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
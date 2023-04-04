<!--#include virtual="/include/config_inc.asp"-->
<%
	Set rs = Conn.Execute("select picture from cf_page where cafe_id = '" & cafe_id & "' ")

	Set fso = CreateObject("Scripting.FileSystemObject")
	uploadFolder = ConfigAttachedFileFolder & "picture\"
	strFileName = uploadFolder & rs("picture")

	If (fso.FileExists(strFileName)) Then
		fso.DeleteFile(strFileName)
	End If

	sql = ""
	sql = sql & " update cf_page "
	sql = sql & "    set picture = null "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	Conn.Execute(sql)
%>
<script>
	str = '<input type="file" class="input" name="picture" style="width:70%;">';
	parent.document.all.attachDiv.innerHTML = str;
</script>

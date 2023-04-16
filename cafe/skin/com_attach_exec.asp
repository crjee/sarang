<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	attach_seq = Request("attach_seq")
	ag = Request("ag")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	If menu_seq <> "" Then
		checkCafePage(cafe_id)
	Else
		menu_type = "notice"
	End If

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	dsplyFolder  = ConfigAttachedFileFolder & "display\" & menu_type & "\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\" & menu_type & "\"
	
	Set fso = CreateObject("Scripting.FileSystemObject")
	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & "_attach "
	sql = sql & "  where attach_seq = '" & attach_seq  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		album_seq      = rs("album_seq")
		rprs_file_yn   = rs("rprs_file_yn")
		file_name      = rs("file_name")
		dsply_file_nm  = rs("dsply_file_nm")
		thmbnl_file_nm = rs("thmbnl_file_nm")
	End If
	rs.close

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_" & menu_type & "_attach "
	sql = sql & "  where attach_seq = '" & attach_seq  & "' "
	Conn.Execute(sql)

	If rprs_file_yn = "Y" Then
		attach_num = getonevalue("min(attach_num)", "cf_album_attach", "where album_seq = ' " & album_seq & "'")

		sql = ""
		sql = sql & " update cf_" & menu_type & "_attach "
		sql = sql & "    set rprs_file_yn = 'N' "
		sql = sql & "  where attach_seq = '" & attach_seq & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " update cf_" & menu_type & "_attach "
		sql = sql & "    set rprs_file_yn = 'Y' "
		sql = sql & "  where attach_seq = '" & attach_seq & "' "
		sql = sql & "    and attach_num = '" & attach_num & "' "
		Conn.Execute(sql)
	End If

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing

		If file_name <> "" Then
			If (fso.FileExists(uploadFolder & file_name)) Then
				fso.DeleteFile(uploadFolder & file_name)
			End If
		End If

		If dsply_file_nm <> "" Then
			If (fso.FileExists(dsplyFolder & dsply_file_nm)) Then
				fso.DeleteFile(dsplyFolder & dsply_file_nm)
			End If
		End If

		If thmbnl_file_nm <> "" Then
			If (fso.FileExists(thmbnlFolder & thmbnl_file_nm)) Then
				fso.DeleteFile(thmbnlFolder & thmbnl_file_nm)
			End If
		End If

		Set fso = Nothing
%>
<script>
	alert("삭제 되었습니다.");
	str = '<input type="file" class="input" name="file_name" style="width:70%;">';
<%
	if ag = "1" Then
%>
	str = str + '<button class="btn_plus" type="button" onclick="addAttach()">&nbsp;</button>';
	str = str + '<button class="btn_minus" type="button" onclick="delAttach()">&nbsp;</button>';
<%
	End If
%>
	parent.document.all.attachDiv<%=ag%>.innerHTML = str;
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
	End If
%>

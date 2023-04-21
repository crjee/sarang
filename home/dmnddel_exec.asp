<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "home\"
	uploadform.DefaultPath = uploadFolder
	' 하나의 파일 크기를 1MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024
	' 전체 파일의 크기를 50MB 이하로 제한.
	uploadform.TotalLen = 50*1024*1024

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	If uploadform("idcd_file_nm") <> "" Then
		FilePath = uploadform("idcd_file_nm").Save(,False)
		idcd_file_nm = uploadform("idcd_file_nm").LastSavedFileName
	End If

	If uploadform("brct_file_nm") <> "" Then
		FilePath = uploadform("brct_file_nm").Save(,False)
		brct_file_nm = uploadform("brct_file_nm").LastSavedFileName
	End If

	If uploadform("agt_idcd_file_nm") <> "" Then
		FilePath = uploadform("agt_idcd_file_nm").Save(,False)
		agt_idcd_file_nm = uploadform("agt_idcd_file_nm").LastSavedFileName
	End If

	If uploadform("dlgt_file_nm") <> "" Then
		FilePath = uploadform("dlgt_file_nm").Save(,False)
		dlgt_file_nm = uploadform("dlgt_file_nm").LastSavedFileName
	End If

	If uploadform("atch_data_file_nm") <> "" Then
		FilePath = uploadform("atch_data_file_nm").Save(,False)
		atch_data_file_nm = uploadform("atch_data_file_nm").LastSavedFileName
	End If

	dmnd_id           = getSeq("cf_dmnddel")
	dmnd_se_cd        = uploadform("dmnd_se_cd")
	subject           = uploadform("subject")
	rqstr_flnm        = uploadform("rqstr_flnm")
	mbl_telno         = uploadform("mbl_telno")
	eml_addr          = uploadform("eml_addr")
	idcd_file_nm      = uploadform("idcd_file_nm")
	co_nm             = uploadform("co_nm")
	brct_file_nm      = uploadform("brct_file_nm")
	agt_idcd_file_nm  = uploadform("agt_idcd_file_nm")
	dlgt_file_nm      = uploadform("dlgt_file_nm")
	url_addr          = uploadform("url_addr")
	dmnd_cn           = Replace(uploadform("ir1"),"'","&#39;")
	dmnd_cn           = uploadform("dmnd_cn")
	atch_data_file_nm = uploadform("atch_data_file_nm")

	sql = ""
	sql = sql & " insert into cf_dmnddel( "
	sql = sql & "        dmnd_id           "
	sql = sql & "       ,dmnd_se_cd        "
	sql = sql & "       ,subject           "
	sql = sql & "       ,rqstr_flnm        "
	sql = sql & "       ,mbl_telno         "
	sql = sql & "       ,eml_addr          "
	sql = sql & "       ,idcd_file_nm      "
	sql = sql & "       ,co_nm             "
	sql = sql & "       ,brct_file_nm      "
	sql = sql & "       ,agt_idcd_file_nm  "
	sql = sql & "       ,dlgt_file_nm      "
	sql = sql & "       ,url_addr          "
	sql = sql & "       ,dmnd_cn           "
	sql = sql & "       ,atch_data_file_nm "
	sql = sql & "       ,dmnd_prcs_cd      "
	sql = sql & "       ,dmnd_prcs_dt      "
	sql = sql & "       ,creid             "
	sql = sql & "       ,credt             "
	sql = sql & "      ) values( "
	sql = sql & "        '" & dmnd_id           & "' "
	sql = sql & "       ,'" & dmnd_se_cd        & "' "
	sql = sql & "       ,'" & subject           & "' "
	sql = sql & "       ,'" & rqstr_flnm        & "' "
	sql = sql & "       ,'" & mbl_telno         & "' "
	sql = sql & "       ,'" & eml_addr          & "' "
	sql = sql & "       ,'" & idcd_file_nm      & "' "
	sql = sql & "       ,'" & co_nm             & "' "
	sql = sql & "       ,'" & brct_file_nm      & "' "
	sql = sql & "       ,'" & agt_idcd_file_nm  & "' "
	sql = sql & "       ,'" & dlgt_file_nm      & "' "
	sql = sql & "       ,'" & url_addr          & "' "
	sql = sql & "       ,'" & dmnd_cn           & "' "
	sql = sql & "       ,'" & atch_data_file_nm & "' "
	sql = sql & "       ,'0'                         "
	sql = sql & "       ,null                        "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	Set uploadform = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("입력 되었습니다.");
	parent.location.href='/home';
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

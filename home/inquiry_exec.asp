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

	If uploadform("atch_data_file_nm") <> "" Then
		FilePath = uploadform("atch_data_file_nm").Save(,False)
		atch_data_file_nm = uploadform("atch_data_file_nm").LastSavedFileName
	End If

	inq_id            = getSeq("cf_inuriry")
	inq_se_cd         = uploadform("inq_se_cd")
	co_nm             = uploadform("co_nm")
	pic_flnm          = uploadform("pic_flnm")
	mbl_telno         = uploadform("mbl_telno")
	eml_addr          = uploadform("eml_addr")
	subject           = Replace(uploadform("subject"),"'"," & #39;")
	inq_cn            = Replace(uploadform("ir1"),"'"," & #39;")
	atch_data_file_nm = atch_data_file_nm

	sql = ""
	sql = sql & " insert into cf_inquiry( "
	sql = sql & "        inq_id            "
	sql = sql & "       ,inq_se_cd         "
	sql = sql & "       ,co_nm             "
	sql = sql & "       ,pic_flnm          "
	sql = sql & "       ,mbl_telno         "
	sql = sql & "       ,eml_addr          "
	sql = sql & "       ,subject           "
	sql = sql & "       ,inq_cn            "
	sql = sql & "       ,atch_data_file_nm "
	sql = sql & "       ,ans_cn            "
	sql = sql & "       ,inq_prcs_cd       "
	sql = sql & "       ,inq_prcs_dt       "
	sql = sql & "       ,creid             "
	sql = sql & "       ,credt             "
	sql = sql & "      ) values( "
	sql = sql & "        '" & inq_id            & "' "
	sql = sql & "       ,'" & inq_se_cd         & "' "
	sql = sql & "       ,'" & co_nm             & "' "
	sql = sql & "       ,'" & pic_flnm          & "' "
	sql = sql & "       ,'" & mbl_telno         & "' "
	sql = sql & "       ,'" & eml_addr          & "' "
	sql = sql & "       ,'" & subject           & "' "
	sql = sql & "       ,'" & inq_cn            & "' "
	sql = sql & "       ,'" & atch_data_file_nm & "' "
	sql = sql & "       ,null                        "
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

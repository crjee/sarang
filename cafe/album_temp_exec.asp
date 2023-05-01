<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	Call CheckMultipart()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "album\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)

	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")
	menu_seq  = uploadform("menu_seq")

	album_seq = uploadform("album_seq")
	group_num = uploadform("group_num") ' 답글에 대한 원본 글
	level_num = uploadform("level_num")
	step_num  = uploadform("step_num")

	subject   = Replace(uploadform("subject"),"'","&#39;")
	contents  = Replace(uploadform("contents"),"'","&#39;")
	link      = uploadform("link")
	If link   = "http://" Then link = ""
	top_yn    = uploadform("top_yn")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	sql = ""
	sql = sql & " delete                               "
	sql = sql & "   from cf_temp_album                 "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	sql = sql & "    and cafe_id  = '" & cafe_id  & "' "
	sql = sql & "    and user_id  = '" & Session("user_id")  & "' "
	Conn.Execute(sql)

	new_seq = GetComSeq("cf_temp_album")

	Set rs = server.createobject("adodb.recordset")

	parent_seq = ""
	album_num = GetComNum("album", cafe_id, menu_seq)
	group_num = album_num
	level_num = 0
	step_num = 0

	sql = ""
	sql = sql & " insert into cf_temp_album( "
	sql = sql & "        album_seq           "
	sql = sql & "       ,parent_seq          "
	sql = sql & "       ,group_num           "
	sql = sql & "       ,level_num           "
	sql = sql & "       ,step_num            "
	sql = sql & "       ,album_num           "
	sql = sql & "       ,cafe_id             "
	sql = sql & "       ,menu_seq            "
	sql = sql & "       ,agency              "
	sql = sql & "       ,subject             "
	sql = sql & "       ,contents            "
	sql = sql & "       ,view_cnt            "
	sql = sql & "       ,suggest_cnt         "
	sql = sql & "       ,link                "
	sql = sql & "       ,top_yn              "
	sql = sql & "       ,user_id             "
	sql = sql & "       ,creid               "
	sql = sql & "       ,credt               "
	sql = sql & "      ) values (            "
	sql = sql & "        '" & new_seq & "' "
	sql = sql & "       ,'" & parent_seq & "' "
	sql = sql & "       ,'" & group_num & "' "
	sql = sql & "       ,'" & level_num & "' "
	sql = sql & "       ,'" & step_num & "' "
	sql = sql & "       ,'" & album_num & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & menu_seq & "' "
	sql = sql & "       ,'" & Session("agency") & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & contents & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	album_seq = new_seq

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
	End If
%>

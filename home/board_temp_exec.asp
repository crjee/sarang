<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	Call CheckMultipart()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

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

	sql = ""
	sql = sql & " delete                                         "
	sql = sql & "   from gi_temp_board                           "
	sql = sql & "  where menu_seq = '" & menu_seq           & "' "
	sql = sql & "    and cafe_id  = '" & cafe_id            & "' "
	sql = sql & "    and user_id  = '" & Session("user_id") & "' "
	Conn.Execute(sql)

	new_seq = GetComSeq("gi_temp_board")

	parent_seq = ""
	board_num = GetComNum(menu_type, cafe_id, menu_seq)
	group_num = board_num
	level_num = 0
	step_num  = 0

	sql = ""
	sql = sql & " insert into gi_temp_board(          "
	sql = sql & "        board_seq                    "
	sql = sql & "       ,board_num                    "
	sql = sql & "       ,group_num                    "
	sql = sql & "       ,step_num                     "
	sql = sql & "       ,level_num                    "
	sql = sql & "       ,menu_seq                     "
	sql = sql & "       ,cafe_id                      "
	sql = sql & "       ,agency                       "
	sql = sql & "       ,top_yn                       "
	sql = sql & "       ,pop_yn                       "
	sql = sql & "       ,section_seq                  "
	sql = sql & "       ,subject                      "
	sql = sql & "       ,contents                     "
	sql = sql & "       ,link                         "

	sql = sql & "       ,user_id                      "
	sql = sql & "       ,reg_date                     "
	sql = sql & "       ,view_cnt                     "
	sql = sql & "       ,comment_cnt                  "
	sql = sql & "       ,suggest_cnt                  "
	sql = sql & "       ,parent_seq                   "
	sql = sql & "       ,creid                        "
	sql = sql & "       ,credt                        "
	sql = sql & "      ) values(                      "
	sql = sql & "        '" & new_seq            & "' "
	sql = sql & "       ,'" & board_num          & "' "
	sql = sql & "       ,'" & group_num          & "' "
	sql = sql & "       ,'" & step_num           & "' "
	sql = sql & "       ,'" & level_num          & "' "
	sql = sql & "       ,'" & menu_seq           & "' "
	sql = sql & "       ,'" & cafe_id            & "' "
	sql = sql & "       ,'" & Session("agency")  & "' "
	sql = sql & "       ,'" & top_yn             & "' "
	sql = sql & "       ,'" & pop_yn             & "' "
	sql = sql & "       ,'" & section_seq        & "' "
	sql = sql & "       ,'" & subject            & "' "
	sql = sql & "       ,'" & contents           & "' "
	sql = sql & "       ,'" & link               & "' "

	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Date()             & "' "
	sql = sql & "       ,0 "
	sql = sql & "       ,0 "
	sql = sql & "       ,0 "
	sql = sql & "       ,'" & parent_seq         & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())                   "
	Conn.Execute(sql)

	board_seq = new_seq

	Set uploadform = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	var cValue = "";
	var cDay = 1;
	var cName = "subject";
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
	if (typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;
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

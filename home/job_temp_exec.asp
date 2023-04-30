<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckMultipart()

	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	' 하나의 파일 크기를 10MB이하로 제한.
	uploadform.MaxFileLen = 10*1024*1024
	' 전체 파일의 크기를 50MB 이하로 제한.
	uploadform.TotalLen = 50*1024*1024

	menu_seq = uploadform("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	uploadFolder = ConfigAttachedFileFolder & menu_type & "\"
	uploadform.DefaultPath = uploadFolder

	job_seq = uploadform("job_seq")
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	subject = Replace(uploadform("subject"),"'","&#39;")
	contents = Replace(uploadform("contents"),"'","&#39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from gi_temp_job "
	sql = sql & "  where menu_seq = '" & menu_seq           & "' "
	sql = sql & "    and cafe_id  = '" & cafe_id            & "' "
	sql = sql & "    and user_id  = '" & Session("user_id") & "' "
	Conn.Execute(sql)

	new_seq = GetComSeq("gi_temp_job")

	parent_seq = ""
	job_num    = GetComNum(menu_type, cafe_id, menu_seq)
	group_num  = job_num
	level_num  = 0
	step_num   = 0

	work       = uploadform("work")
	age        = uploadform("age")
	sex        = uploadform("sex")
	work_year  = uploadform("work_year")
	certify    = uploadform("certify")
	work_place = uploadform("work_place")
	person     = uploadform("person")
	tel_no     = uploadform("tel_no")
	mbl_telno  = uploadform("mbl_telno")
	fax_no     = uploadform("fax_no")
	email      = uploadform("email")
	homepage   = uploadform("homepage")
	method     = uploadform("method")
	end_date   = uploadform("end_date")

	sql = ""
	sql = sql & " insert into gi_temp_job(            "
	sql = sql & "        job_seq                      "
	sql = sql & "       ,job_num                      "
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

	sql = sql & "       ,work                         "
	sql = sql & "       ,age                          "
	sql = sql & "       ,sex                          "
	sql = sql & "       ,work_year                    "
	sql = sql & "       ,certify                      "
	sql = sql & "       ,work_place                   "
	sql = sql & "       ,person                       "
	sql = sql & "       ,tel_no                       "
	sql = sql & "       ,mbl_telno                    "
	sql = sql & "       ,fax_no                       "
	sql = sql & "       ,email                        "
	sql = sql & "       ,homepage                     "
	sql = sql & "       ,method                       "
	sql = sql & "       ,end_date                     "

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
	sql = sql & "       ,'" & job_num            & "' "
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

	sql = sql & "       ,'" & work               & "' "
	sql = sql & "       ,'" & age                & "' "
	sql = sql & "       ,'" & sex                & "' "
	sql = sql & "       ,'" & work_year          & "' "
	sql = sql & "       ,'" & certify            & "' "
	sql = sql & "       ,'" & work_place         & "' "
	sql = sql & "       ,'" & person             & "' "
	sql = sql & "       ,'" & tel_no             & "' "
	sql = sql & "       ,'" & mbl_telno          & "' "
	sql = sql & "       ,'" & fax_no             & "' "
	sql = sql & "       ,'" & email              & "' "
	sql = sql & "       ,'" & homepage           & "' "
	sql = sql & "       ,'" & method             & "' "
	sql = sql & "       ,'" & end_date           & "' "

	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Date()             & "' "
	sql = sql & "       ,0 "
	sql = sql & "       ,0 "
	sql = sql & "       ,0 "
	sql = sql & "       ,'" & parent_seq         & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())                   "
	Conn.Execute(sql)

	job_seq = new_seq

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

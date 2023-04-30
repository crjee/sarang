<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()

	skin_id = Request.Form("skin_id")

	If skin_id = "" Then
		msggo "스킨이 선택되지 않았습니다", ""
	End If

	cafe_id   = Request.Form("cafe_id")
	cafe_name = Request.Form("cafe_name")
	cafe_img  = Request.Form("cafe_img")
	open_yn   = Request.Form("open_yn")
	cate_id   = Request.Form("cate_id")
	cafe_type = Request.Form("cafe_type")

	If cafe_id = "" Then
		msgend("선택한 사랑방이 없습니다.")
	End If

	'On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn

	sql = ""
	sql = sql & " insert into cf_cafe( "
	sql = sql & "        cafe_name "
	sql = sql & "       ,cafe_img "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,open_yn "
	sql = sql & "       ,reg_type "
	sql = sql & "       ,cate_id "
	sql = sql & "       ,visit_cnt "
	sql = sql & "       ,cafe_type "
	sql = sql & "       ,activity_yn "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values( "
	sql = sql & "        '" & cafe_name & "' "
	sql = sql & "       ,'" & cafe_img & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & open_yn & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & cate_id & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & cafe_type & "' "
	sql = sql & "       ,'Y' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " insert into cf_menu( "
	sql = sql & "        menu_seq "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,menu_name "
	sql = sql & "       ,page_type "
	sql = sql & "       ,menu_type "
	sql = sql & "       ,menu_num "
	sql = sql & "       ,hidden_yn "
	sql = sql & "       ,home_cnt "
	sql = sql & "       ,home_num "
	sql = sql & "       ,top_cnt "
	sql = sql & "       ,write_auth "
	sql = sql & "       ,reply_auth "
	sql = sql & "       ,read_auth "
	sql = sql & "       ,editor_yn "
	sql = sql & "       ,daily_cnt "
	sql = sql & "       ,list_info "
	sql = sql & "       ,creid"
	sql = sql & "       ,credt"
	sql = sql & "      ) values "
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','사랑방소개'               ,'gr'      ,'group','1'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " 회칙' ,'1'       ,'page' ,'2'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " 소개' ,'2'       ,'page' ,'3'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " 명단' ,'4'       ,'page' ,'4'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " 조직도','5'       ,'page' ,'5'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','커뮤니티'                 ,'gr'     ,'group','6'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " 소식지','news'    ,'board','7'   ,'N'   ,'5'       ,'3' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','공지사항'                 ,'notice' ,'board','8'   ,'N'   ,'5'       ,'1' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','쪽지보내기'               ,null      ,'memo' ,'9'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','부동산뉴스'               ,null      ,'land','10'  ,'N'   ,'5'       ,'4' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','앨범'                   ,null       ,'album','11'  ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','자료실'                  ,'pds'      ,'board','12'  ,'N'   ,'5'       ,'0' ,0,'1','1','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','자유게시판'               ,'board'    ,'board' ,'13'  ,'N'   ,'5'       ,'2' ,0,'1','1','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','급매물구합니다'             ,null      ,'sale','14'  ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','설문조사'                 ,null      ,'poll'  ,'15'  ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & GetComSeq("cf_menu") & "','" & cafe_id & "','직원채용'                 ,null      ,'job','16'  ,'N'   ,'5'       ,'5' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate())"
	Conn.Execute(sql)

	Set rs = Server.CreateObject("ADODB.RecordSet")

	sql = ""
	sql = sql & " insert cf_skin(             "
	sql = sql & "         cafe_id             "
	sql = sql & "        ,skin_id             "
	sql = sql & "        ,skin_left_id        "
	sql = sql & "        ,skin_left_color01   "
	sql = sql & "        ,skin_left_color02   "
	sql = sql & "        ,skin_left_color03   "
	sql = sql & "        ,skin_left_font01    "
	sql = sql & "        ,skin_center_id      "
	sql = sql & "        ,skin_center_color01 "
	sql = sql & "        ,skin_center_color02 "
	sql = sql & "        ,skin_center_font01  "
	sql = sql & "        ,skin_center_font02  "
	sql = sql & "        ,skin_body_id        "
	sql = sql & "        ,skin_body_color01   "
	sql = sql & "        ,creid               "
	sql = sql & "        ,credt               "
	sql = sql & "       ) values( "
	sql = sql & "         '" & cafe_id             & "' "
	sql = sql & "        ,'" & skin_id             & "' "
	sql = sql & "        ,'" & skin_left_id        & "' "
	sql = sql & "        ,'" & skin_left_color01   & "' "
	sql = sql & "        ,'" & skin_left_color02   & "' "
	sql = sql & "        ,'" & skin_left_color03   & "' "
	sql = sql & "        ,'" & skin_left_font01    & "' "
	sql = sql & "        ,'" & skin_center_id      & "' "
	sql = sql & "        ,'" & skin_center_color01 & "' "
	sql = sql & "        ,'" & skin_center_color02 & "' "
	sql = sql & "        ,'" & skin_center_font01  & "' "
	sql = sql & "        ,'" & skin_center_font02  & "' "
	sql = sql & "        ,'" & skin_body_id        & "' "
	sql = sql & "        ,'" & skin_body_color01   & "' "
	sql = sql & "        ,'" & Session("user_id")  & "' "
	sql = sql & "        ,getdate())"

	Conn.Execute(sql)

	Session("cafe_id") = cafe_id

	If Err.Number <> 0 Then
		'// DB를 롤백 후 DB객체 소멸
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 발생했습니다.<%=Err.Description%>");
</script>
<%
	Else
		'// DB롤 커밋 후 DB객체 소멸
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("개설되었습니다");
	parent.location.href = 'cafe_list.asp?cafe_id=<%=cafe_id%>';
</script>
<%
	End If
%>

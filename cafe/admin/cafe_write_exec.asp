<!--#include virtual="/include/config_inc.asp"-->
<%
	skin_id = Request.Form("skin_id")

	If skin_id = "" Then
		Response.Write "<script>alert('��Ų�� ���õ��� �ʾҽ��ϴ�')history.back()</script>"
	End if

	cafe_id   = Request.Form("cafe_id")
	cafe_name = Request.Form("cafe_name")
	cafe_img  = Request.Form("cafe_img")
	open_yn   = Request.Form("open_yn")
	cate_id   = Request.Form("cate_id")
	cafe_type = Request.Form("cafe_type")

	On Error Resume Next
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
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','�����Ұ�'               ,'gr'      ,'group','1'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " ȸĢ' ,'1'       ,'page' ,'2'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " �Ұ�' ,'2'       ,'page' ,'3'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " ���' ,'4'       ,'page' ,'4'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " ������','5'       ,'page' ,'5'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','Ŀ�´�Ƽ'                 ,'gr'     ,'group','6'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','" & cafe_name & " �ҽ���','news'    ,'board','7'   ,'N'   ,'5'       ,'3' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','��������'                 ,'notice' ,'board','8'   ,'N'   ,'5'       ,'1' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','����������'               ,null      ,'memo' ,'9'   ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','�ε��괺��'               ,null      ,'land','10'  ,'N'   ,'5'       ,'4' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','�ٹ�'                   ,null       ,'album','11'  ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','�ڷ��'                  ,'pds'      ,'board','12'  ,'N'   ,'5'       ,'0' ,0,'1','1','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','�����Խ���'               ,'board'    ,'board' ,'13'  ,'N'   ,'5'       ,'2' ,0,'1','1','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','�޸Ź����մϴ�'             ,null      ,'sale','14'  ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','��������'                 ,null      ,'poll'  ,'15'  ,'N'   ,'5'       ,'0' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate()),"
	sql = sql & "      ('" & getSeq("cf_menu") & "','" & cafe_id & "','����ä��'                 ,null      ,'job','16'  ,'N'   ,'5'       ,'5' ,0,'10','10','1','Y',3,null,'" & Session("user_id") & "',getdate())"
	Conn.Execute(sql)

	Set rs = Server.CreateObject("ADODB.RecordSet")

	sql = ""
	sql = sql & " insert cf_skin(        "
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
		'// DB�� �ѹ� �� DB��ü �Ҹ�
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("������ �߻��߽��ϴ�.<%=Err.Description%>");
</script>
<%
	Else
		'// DB�� Ŀ�� �� DB��ü �Ҹ�
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("�����Ǿ����ϴ�");
	parent.location.href = 'cafe_list.asp?cafe_id=<%=cafe_id%>';
</script>
<%
	End If
%>

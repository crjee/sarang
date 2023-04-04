<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<%
	cafe_mb_level = getUserLevel(cafe_id)
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('���� �����̾����ϴ�');history.back()</script>"
		Response.End
	End If

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select isnull(daily_cnt,9999) as daily_cnt "
	sql = sql & "       ,inc_del_yn "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & Request("menu_seq")  & "' "
	rs.Open Sql, conn, 3, 1
	daily_cnt = rs("daily_cnt")
	inc_del_yn = rs("inc_del_yn")
	rs.close

	If daily_cnt < "9999" Then
		If inc_del_yn = "N" Then
			sql = ""
			sql = sql & " select count(menu_seq) as write_cnt "
			sql = sql & "   from cf_board "
			sql = sql & "  where menu_seq = '" & Request("menu_seq")  & "' "
			sql = sql & "    and cafe_id = '" & cafe_id  & "' "
			sql = sql & "    and agency = '" & session("agency")  & "' "
			sql = sql & "    and convert(varchar(10),credt,120) = '" & date & "' "
			rs.Open Sql, conn, 3, 1
			write_cnt = rs("write_cnt")
			rs.close
		Else
			sql = ""
			sql = sql & " select count(wl.menu_seq) as write_cnt "
			sql = sql & "   from cf_write_log wl "
			sql = sql & "   left join cf_member cm on cm.user_id = wl.user_id "
			sql = sql & "  where wl.menu_seq = '" & Request("menu_seq")  & "' "
			sql = sql & "    and wl.cafe_id = '" & cafe_id  & "' "
			sql = sql & "    and cm.agency = '" & session("agency")  & "' "
			sql = sql & "    and convert(varchar(10),wl.credt,120) = '" & date & "' "
			rs.Open Sql, conn, 3, 1
			write_cnt = rs("write_cnt")
			rs.close
		End If

		If cint(write_cnt) >= cint(daily_cnt) Then
			Response.Write "<script>alert('1�� ��� ���� " & daily_cnt & "���� �ʰ� �Ͽ����ϴ�');history.back()</script>"
			Response.End
		End If
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�ε����̾߱� : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="sub">
			<div class="container">
<%
	menu_seq = Request("menu_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "�������� ����� �ƴմϴ�.",""
	Else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	link = "http://"
%>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> ���</h2>
				</div>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" id="attachCnt" name="attachCnt" value="1">
				<input type="hidden" name="temp" value="Y">
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	If cafe_mb_level > 6 Then
%>
							<tr>
								<th scope="row">����</th>
								<td>
									<input type="checkbox" id="top_yn" name="top_yn" class="inp_check" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>������ ����</em></label>
								</td>
							</tr>
<%
	End If
%>
							<tr>
								<th scope="row">����</th>
								<td>
<%
	sql = ""
	sql = sql & " select *                       "
	sql = sql & "   from sys_cd                  "
	sql = sql & "  where CD_NM = 'pst_rgn_se_cd' "
	sql = sql & "    and use_yn = 'Y'            "
	sql = sql & "  order by CD_SN                "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		Do Until rs.EOF
			CMN_CD  = rs("CMN_CD")
			CD_EXPL = rs("CD_EXPL")
%>
									<span class="">
										<input type="radio" id="pst_rgn_se_cd_<%=CMN_CD%>" name="pst_rgn_se_cd" class="inp_radio" value="<%=CMN_CD%>" <%=if3(InStr(pst_rgn_se_cd, CMN_CD)>0,"checked","")%> required />
										<label for="pst_rgn_se_cd_<%=CMN_CD%>"><em><%=CD_EXPL%></em></label>
									</span>
<%
			rs.MoveNext
		Loop
	End If
	rs.close
%>
								</td>
							</tr>
							<tr>
								<th scope="row">����(*)</th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
<%
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_com_form "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		form = rs("form")
	End if

	If contents = "" Then
		contents = form
	End if
	If editor_yn = "Y" Then
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	else
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	End if
%>
					</div>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">��ũ�ּ�</th>
								<td>
									<input type="text" id="link" name="link" class="inp" value="<%=link%>">
								</td>
							</tr>
							<tr>
								<th scope="row" class="add_files">
									÷������
									<div class="dp_inline">
										<button type="button" class="btn btn_inp_add" onclick="addAttach()"><em>�߰�</em></button>
										<button type="button" class="btn btn_inp_del" onclick="delAttach()"><em>����</em></button>
									</div>
								</th>
								<td>
									<ul class="add_files_inp">
										<li class="stxt">
											<input type="file" class="inp" name="file_name">
										</li>
<%
	For i = 2 To 10
%>
										<li class="stxt" id="attachDiv<%=i%>" style="display:none">
											<input type="file" class="inp" name="file_name">
										</li>
<%
	Next
%>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>���</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='story_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
				</div>
				</form>
				<script>
				function addAttach(){
					var attachCnt = Number(document.all.attachCnt.value);
					if (attachCnt < 10)
					{
						document.all.attachCnt.value = ++attachCnt;
						for(i=2;i<=attachCnt;i++){
							eval("attachDiv"+i+".style.display='block'")
						}
					}
				}
				function delAttach(){
					var attachCnt = document.all.attachCnt.value;
					eval("attachDiv"+attachCnt+".style.display='none'");
					document.all.attachCnt.value = Number(attachCnt)-1;
				}
				</script>
				<script>
					var oEditors = [];

					// �߰� �۲� ���
					//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];

					nhn.husky.EZCreator.createInIFrame({
						oAppRef: oEditors,
						elPlaceHolder: "ir1",
						sSkinURI: "/smart/SmartEditor2Skin.html",
						htParams : {
							bUseToolbar : true,				// ���� ��� ���� (true:���/ false:������� ����)
							bUseVerticalResizer : true,		// �Է�â ũ�� ������ ��� ���� (true:���/ false:������� ����)
							bUseModeChanger : true,			// ��� ��(Editor | HTML | TEXT) ��� ���� (true:���/ false:������� ����)
							//aAdditionalFontList : aAdditionalFontSet,		// �߰� �۲� ���
							fOnBeforeUnload : function(){
								var f = document.form;
								if (f.temp.value == "Y" && f.subject.value != "")
								{
									oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
									f.action = "story_temp_exec.asp";
									f.temp.value = "N";
									f.target = "hiddenfrm";
									f.submit();
									alert("�ۼ����� ������ �ӽ÷� ����Ǿ����ϴ�.");
								}
							}
						}, //boolean
						fOnAppLoad : function(){
							//���� �ڵ�
							//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
						},
						fCreator: "createSEditor2"
					})

					function submitContents(elClickedObj) {
						oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
						try {
							elClickedObj.action = "story_write_exec.asp";
							elClickedObj.temp.value = "N";
							elClickedObj.target = "hiddenfrm";
							elClickedObj.submit()
						} catch(e) {alert(e)}
					}
				</script>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>
<script>
	function fc_chk_byte(frm_nm, ari_max, cnt_view) { 
	//	var frm = document.regForm;
		var ls_str = frm_nm.value; // �̺�Ʈ�� �Ͼ ��Ʈ���� value �� 
		var li_str_len = ls_str.length; // ��ü���� 

		// �����ʱ�ȭ 
		var li_max = ari_max; // ������ ���ڼ� ũ�� 
		var i = 0; // for���� ��� 
		var li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
		var li_len = 0; // substring�ϱ� ���ؼ� ��� 
		var ls_one_char = ""; // �ѱ��ھ� �˻��Ѵ� 
		var ls_str2 = ""; // ���ڼ��� �ʰ��ϸ� �����Ҽ� ������������ �����ش�. 

		for(i=0; i< li_str_len; i++) { 
		// �ѱ������� 
			ls_one_char = ls_str.charAt(i); 

			// �ѱ��̸� 2�� ���Ѵ�. 
			if (escape(ls_one_char).length > 4) { 
				li_byte += 2; 
			} 
			// �׹��� ���� 1�� ���Ѵ�. 
			else { 
				li_byte++; 
			} 

			// ��ü ũ�Ⱑ li_max�� ���������� 
			if(li_byte <= li_max) { 
				li_len = i + 1; 
			} 
		} 

		// ��ü���̸� �ʰ��ϸ� 
		if(li_byte > li_max) { 
			alert( li_max + "byte ���ڸ� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. "); 
			ls_str2 = ls_str.substr(0, li_len);
			frm_nm.value = ls_str2; 

			li_str_len = ls_str2.length; // ��ü���� 
			li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
			for(i=0; i< li_str_len; i++) { 
			// �ѱ������� 
				ls_one_char = ls_str2.charAt(i); 

				// �ѱ��̸� 2�� ���Ѵ�. 
				if (escape(ls_one_char).length > 4) { 
					li_byte += 2; 
				} 
				// �׹��� ���� 1�� ���Ѵ�. 
				else { 
					li_byte++; 
				} 
			} 
		} 
		if (cnt_view != ""){
			var inner_form = eval("document.all."+ cnt_view) 
			inner_form.innerHTML = li_byte ;		//frm.txta_Memo.value.length;
		}
	//	frm_nm.focus(); 

	} 
</script>
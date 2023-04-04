<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('���� �����̾����ϴ�');history.back()</script>"
		Response.End
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>��Ų-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<%
	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "�������� ����� �ƴմϴ�.",""
	else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	sale_seq       = Request("sale_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_sale "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And session("user_id") <> rs("user_id") then
			Response.Write "<script>alert('���� �����̾����ϴ�');history.back();</script>"
			Response.End
		End If

		step_num = rs("step_num")
		top_yn   = rs("top_yn")
		subject  = rs("subject")
		location = rs("location")
		bargain  = rs("bargain")
		area     = rs("area")
		floor    = rs("floor")
		compose  = rs("compose")
		price    = rs("price")
		live_in  = rs("live_in")
		parking  = rs("parking")
		traffic  = rs("traffic")
		purpose  = rs("purpose")
		contents = rs("contents")
		tel_no  = rs("tel_no")
		fax_no = rs("fax_no")

		If rs("link") = "" Then
			link = "http://"
		Else
			link = rs("link")
		End If
	End if
	rs.close
%>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="sale_seq" value="<%=sale_seq%>">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> ����</h2>
				</div>
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	If cafe_mb_level > 6 Then
		If step_num = "0" Then
%>
							<tr>
								<th scope="row">����</th>
								<td colspan="3">
									<input type="checkbox" id="top_yn" name="top_yn" class="inp_check" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>������ ����</em></label>
								</td>
							</tr>
<%
		End If
	End If
%>
							<tr>
								<th scope="row">����<em class="required">�ʼ��Է�</em></th></th>
								<td colspan="3">
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
							<tr>
								<th scope="row">������</th>
								<td>
									<input type="text" class="inp" tabindex=2 name="location" value="<%=location%>" />
								</td>
								<th scope="row">������</th>
								<td>
									<input type="text" class="inp" tabindex=3 name="bargain" value="<%=bargain%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">����</th>
								<td>
									<input type="text" class="inp" tabindex=4 name="area" value="<%=area%>" />
								</td>
								<th scope="row">�ش���/����</th>
								<td>
									<input type="text" class="inp" tabindex=5 name="floor" value="<%=floor%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">�氳��/��Ǽ�</th>
								<td>
									<input type="text" class="inp" tabindex=6 name="compose" value="<%=compose%>" />
								</td>
								<th scope="row">�ݾ�</th>
								<td>
									<input type="text" class="inp" tabindex=7 name="price" value="<%=price%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">���ְ�����</th>
								<td>
									<input type="text" class="inp" tabindex=8 name="live_in" value="<%=live_in%>" />
								</td>
								<th scope="row">��������</th>
								<td>
									<input type="text" class="inp" tabindex=9 name="parking" value="<%=parking%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">���߱���</th>
								<td>
									<input type="text" class="inp" tabindex=10 name="traffic" value="<%=traffic%>" />
								</td>
								<th scope="row">�뵵</th>
								<td>
									<input type="text" class="inp" tabindex=11 name="purpose" value="<%=purpose%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">����ó</th>
								<td>
									<input type="text" class="inp" tabindex=12 name="tel_no" value="<%=tel_no%>" />
								</td>
								<th scope="row">�ѽ�</th>
								<td>
									<input type="text" class="inp" tabindex=13 name="fax_no" value="<%=fax_no%>" />
								</td>
							</tr>
						<tbody>
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
	End If
	rs.close

	If contents = "" Then
		contents = form
	End If

	If editor_yn = "Y" Then
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
<%
	Else
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
<%
	com_seq = board_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n" tabindex=26>���</button>
					<button type="button" class="btn btn_c_n btn_n" tabindex=27 onclick="location.href='job_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
				</div>
				</form>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>



			<script>
			var oEditors = [];

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
						//alert("�Ϸ�!")
					}
				}, //boolean
				fOnAppLoad : function(){
					//���� �ڵ�
					//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
				},
				fCreator: "createSEditor2"
			})

			function view(elClickedObj) {
				oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
				try {
					//elClickedObj.target = "hiddenfrm"
					elClickedObj.form.submit()
				} catch(e) {}
			}

			function submitContents(elClickedObj) {
				oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
				try {
					elClickedObj.action = "sale_modify_exec.asp";
					elClickedObj.target = "hiddenfrm";
					elClickedObj.form.submit()

				} catch(e) {}
			}

			function view_(obj){
				oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
				window.open("","popup","width=640,height=540,scrollbars=yes");
				form.action="view.asp";
				form.method="post";
				form.target="popup";
				form.submit();
			}
			</script>

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
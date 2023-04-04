<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	If cafe_mb_level < 2 Then
		Response.Write "<script>alert('������ �������� ��ȸ������ �����մϴ�');history.back();</script>"
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
	<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
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
	sql = sql & " select cm.user_id "
	sql = sql & "       ,mi.agency "
	sql = sql & "       ,mi.kname "
	sql = sql & "   from cf_cafe_member cm "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.stat = 'Y' and mi.memo_receive_yn != 'N' "
	sql = sql & "  where cm.cafe_id = '" & cafe_id & "'"
	sql = sql & "    and cm.user_id != '" & Session("user_id") & "'"
	rs.Open Sql, conn, 3, 1
	i = 0

	If Not rs.EOF Then
		Do Until rs.eof

			arr_user = ""
			i = i + 1
			rs.MoveNext
		loop
	End If
	rs.close

	If menu_seq = "" Then
		menu_name = "����"
	Else
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
		End If
		rs.close
	End if
	Set rs = nothing
%>
			<script>
				function goAll(obj){
					if (obj.checked == true)
					{
						document.form.opt_value.value = "";
						document.form.opt_text.value = "��üȸ��";
					}
					else{
						document.form.opt_value.value = "";
						document.form.opt_text.value = "";
					}
				}
			</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> ���</h2>
				</div>
				<form name="form" method="post" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="opt_value">
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">����</th>
								<td>
									<input type="text" class="inp" id="subject" name="subject" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView');setCookie('subject',this.value,1)" required style="" />
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
							<tr>
								<th scope="row">�޴� ���</th>
								<td>
									<span class="mr10">
										<button type="button" class="btn btn_c_n btn_s btn_long" onclick="goUser()">�޴»�� ����</button>
									</span>
									<span class="mr10">
										<input type="checkbox" id="alluser" name="alluser" value="all" onclick="goAll(this)" class="inp_check"><label for="alluser"><em>��üȸ��</em></label>
									</span>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
						<div class="editor">
							<textarea name="opt_text" class="retextarea2" readonly required style="display:none"></textarea>
							<textarea name="ir1" id="ir1" style="width: 100%; height: 400px; display: none;"></textarea>
						</div>
					</div>
					<p class="txt_guide_1 mt10">���ΰ�ħ�� ������ ������ �������� �ʽ��ϴ�.</p>
				</div>
				<div class="btn_box">
					<!-- <button type="submit" class="btn btn_c_a btn_n btn_2txt_sel">Ȯ��</button> -->
					<button type="submit" class="btn btn_c_a btn_n">���</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='job_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
				</div>
				</form>

			<script type="text/javascript">
				function goUser(){
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}
			</script>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/cafe/skin/memo_user_edit_p.asp?cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="memo_user">
			<input type="hidden" name="open_specs" value="width=600, height=600, left=200, top=200">
			</form>
			<script type="text/javascript">
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
						//alert("�Ϸ�!");
					}
				}, //boolean
				fOnAppLoad : function(){
					//���� �ڵ�
					//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."]);
				},
				fCreator: "createSEditor2"
			});

			function pasteHTML() {
				var sHTML = "<span style=color:#FF0000;>�̹����� ���� ������� �����մϴ�.<\/span>";
				oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
			}

			function showHTML() {
				var sHTML = oEditors.getById["ir1"].getIR();
				alert(sHTML);
			}

			function submitContents(elClickedObj) {
				oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", []);	// �������� ������ textarea�� ����˴ϴ�.

				// �������� ���뿡 ���� �� ������ �̰����� document.getElementById("ir1").value�� �̿��ؼ� ó���ϸ� �˴ϴ�.
				try {
					if (document.getElementById("ir1").value == "" || document.getElementById("ir1").value == "<p>&nbsp;</p>"){
						alert("������ �Է��ϼ���");
						return;
					}
					elClickedObj.action = "memo_write_exec.asp";
					elClickedObj.target = "hiddenfrm";
					elClickedObj.submit();
				} catch(e) {}
			}

			function setDefaultFont() {
				var sDefaultFont = "�ü�";
				var nFontSize = 24;
				oEditors.getById["ir1"].setDefaultFont(sDefaultFont, nFontSize);
			}
			</script>
	<!--Center-->

<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
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

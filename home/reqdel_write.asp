<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�Խñ� �ߴ� ��û�ϱ�</title>
	<link rel="stylesheet" type="text/css" href="/common/css/styles.css">
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
			<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" id="attachCnt" name="attachCnt" value="1">
			<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2">�Խñ� �ߴ� ��û�ϱ�</h2>
					<span class="posR"><em class="required">�ʼ��Է�</em>�� �ʼ� ���� �׸��Դϴ�.</span>
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
							<tr>
								<th scope="row">��û����<em class="required">�ʼ��Է�</em></th>
								<td colspan="3">
									<span class="">
										<input type="radio" id="s_group1" name="s_group" class="inp_radio" required>
										<label for="s_group1"><em>����</em></label>
									</span>
									<span class="ml20">
										<input type="radio" id="s_group2" name="s_group" class="inp_radio" required>
										<label for="s_group2"><em>��ü</em></label>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">�̸�<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
								<th scope="row">����ó<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">�̸��� �ּ�<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
								<th scope="row">�ź��� �纻<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="" name="" class="inp w300p" required>
									<button type="button" class="btn btn_c_s btn_s">ã�ƺ���</button>
								</td>
							</tr>
							<tr>
								<th scope="row">�Ҽ�<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
								<th scope="row">����ڵ����<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="" name="" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">�븮�� �ź��� �纻</th>
								<td>
									<input type="text" id="" name="" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">ã�ƺ���</button>
									<p class="txt_point mt10">�븮�� ��� �ʼ�</p>
								</td>
								<th scope="row">������</th>
								<td>
									<input type="text" id="" name="" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">ã�ƺ���</button>
									<p class="txt_point mt10">�븮�� ��� �ʼ�</p>
								</td>
							</tr>
							<tr>
								<th scope="row">�Խñ� �ּ�<em class="required">�ʼ��Է�</em></th>
								<td colspan="3">
									<input type="text" id="" name="" class="inp">
								</td>
							</tr>
							<tr>
								<th scope="row">÷������</th>
								<td colspan="3">
									<input type="text" id="" name="" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">ã�ƺ���</button>
									<p class="txt_point mt10">���������� hwp, doc(docx), ppt, pdf ���ϸ� ��� �����մϴ�.</p>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
					</div>
					<div class="agree_box mt30">
						<h3 class="h3">�������� �����̿뿡 ���� ����</h3>
						<ul class="">
							<li>�����׸� : [�ʼ�] ����� ����ó, ����� �̸��� �ּ�, ȸ���, ����� �̸�</li>
							<li>�����׸� : [�ʼ�] ����� ����ó, ����� �̸��� �ּ�, ȸ���, ����� �̸�</li>
							<li>�����׸� : [�ʼ�] ����� ����ó, ����� �̸��� �ּ�, ȸ���, ����� �̸�</li>
						</ul>
					</div>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">��û�ϱ�</button>
					<button type="reset" class="btn btn_c_n btn_n"><em>���</em></button>
				</div>
			</form>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
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
			fOnBeforeUnload : function() {
				var f = document.form;
				if (f.temp.value == "Y" && f.subject.value != "")
				{
					oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
					f.action = "board_temp_exec.asp";
					f.temp.value = "N";
					f.target = "hiddenfrm";
					f.submit();
					alert("�ۼ����� ������ �ӽ÷� ����Ǿ����ϴ�.");
				}
			}
		}, //boolean
		fOnAppLoad : function() {
			//���� �ڵ�
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
		},
		fCreator: "createSEditor2"
	})

	function submitContents(elClickedObj) {
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
		try {
			elClickedObj.action = "reqdel_exec.asp";
			elClickedObj.temp.value = "N";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()
		} catch(e) {alert(e)}
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

		for (i=0; i< li_str_len; i++) { 
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
			if (li_byte <= li_max) { 
				li_len = i + 1; 
			} 
		} 

		// ��ü���̸� �ʰ��ϸ� 
		if (li_byte > li_max) { 
			alert( li_max + "byte ���ڸ� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. "); 
			ls_str2 = ls_str.substr(0, li_len);
			frm_nm.value = ls_str2; 

			li_str_len = ls_str2.length; // ��ü���� 
			li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
			for (i=0; i< li_str_len; i++) { 
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
		if (cnt_view != "") {
			var inner_form = eval("document.all."+ cnt_view) 
			inner_form.innerHTML = li_byte ;		//frm.txta_Memo.value.length;
		}
	//	frm_nm.focus(); 

	} 
</script>

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
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="sub">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2">ȸ������</h2>
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
							<tr>
								<th scope="row">����</th>
								<td>
									<span class="">
										<input type="radio" id="pst_rgn_se_cd_<%=CMN_CD%>" name="pst_rgn_se_cd" class="inp_radio" value="<%=CMN_CD%>" <%=if3(InStr(pst_rgn_se_cd, CMN_CD)>0,"checked","")%> required />
										<label for="pst_rgn_se_cd_<%=CMN_CD%>"><em><%=CD_EXPL%></em></label>
									</span>
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
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>���</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='story_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
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

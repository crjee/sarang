<!--#include virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkWriteAuth(cafe_id)
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
	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_member "
	sql = sql & "  where user_id = '" & session("user_id")  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		agency = rs("agency")
		tel_no = rs("phone")
		fax_no = rs("fax")
	End If
	rs.close

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_temp_job "
	sql = sql & "  where cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	rs.Open Sql, conn, 3, 1

	If not rs.EOF Then
		msgonly "�ӽ� ����� ������ �ֽ��ϴ�."

		top_yn     = rs("top_yn")
		subject    = rs("subject")
		work       = rs("work")
		age        = rs("age")
		sex        = rs("sex")
		work_year  = rs("work_year")
		certify    = rs("certify")
		work_place = rs("work_place")
		agency     = rs("agency")
		person     = rs("person")
		tel_no     = rs("tel_no")
		fax_no     = rs("fax_no")
		email      = rs("email")
		homepage   = rs("homepage")
		method     = rs("method")
		end_date   = rs("end_date")
		contents  = rs("contents")

		arr_age   = split(age, "~")
		If ubound(arr_age) = 1 Then
			age1 = arr_age(0)
			age2 = arr_age(1)
		End if
	End If
	rs.close
%>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> ���</h2>
				</div>
				<form name="form" method="post" onsubmit="return submitContents(this)">
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
								<th scope="row">����<em class="required">�ʼ��Է�</em></th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">�ڰ�����</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">������<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="text" class="inp" tabindex=2 name="work" value="<%=work%>" required />
									</td>
									<th scope="row">����<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="radio" class="checkbox" tabindex=3 name="age" value="" onclick="chkage(0)" <%=If3(age="","checked","")%>>���� &nbsp;
										<input type="radio" class="checkbox" tabindex=4 name="age" value="Y" onclick="chkage(1)" <%=If3(age<>"","checked","")%>>�������� &nbsp;
										<input type="text" class="inp" tabindex=5 name="age1" value="<%=age1%>" style="width:40px" <%=If3(age="","disabled","")%>>�� ~
										<input type="text" class="inp" tabindex=6 name="age2" value="<%=age2%>" style="width:40px" <%=If3(age="","disabled","")%>>��
										<script>
										function chkage(idx) {
											if (idx == 0)
											{
												document.form.age1.disabled = true;
												document.form.age2.disabled = true;
												document.form.age1.value = "";
												document.form.age2.value = "";
												document.form.age1.required = false;
												document.form.age2.required = false;
											}else {
												document.form.age1.disabled = false;
												document.form.age2.disabled = false;
												document.form.age1.required = true;
												document.form.age2.required = true;
											}
										}
										</script>
									</td>
								</tr>
								<tr>
									<th scope="row">����<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="radio" class="checkbox" tabindex=7 name="sex" value="" <%=if3(sex="","checked","")%>>���� &nbsp; &nbsp;
										<input type="radio" class="checkbox" tabindex=8 name="sex" value="M" <%=if3(sex="M","checked","")%>>�� &nbsp; &nbsp;
										<input type="radio" class="checkbox" tabindex=9 name="sex" value="W" <%=if3(sex="W","checked","")%>>��
									</td>
									<th scope="row">���<em class="required">�ʼ��Է�</em></th>
									<td>
										<select name="work_year" tabindex=10>
											<option value="">����</option>
<% For i = 1 To 50 %>
											<option value="<%=i%>" <%=if3(work_year=CStr(i),"selected","")%>><%=i%>�� �̻�</option>
<% Next %>
										</select>
									</td>
								</tr>
								<tr>
									<th class="end2">�����ڰ���<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="radio" class="checkbox" tabindex=11 name="certify" value="Y" <%=if3(certify="Y","checked","")%>>�ʼ� &nbsp; &nbsp;
										<input type="radio" class="checkbox" tabindex=12 name="certify" value="N" <%=if3(certify="N","checked","")%>>����
									</td>
									<th class="end2">�ٹ�����<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="text" class="inp" tabindex=13 name="work_place" value="<%=work_place%>" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">���ǹ� �������</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">�߰����Ҹ�<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="text" class="inp" tabindex=14 name="agency" value="<%=agency%>" required />
									</td>
									<th scope="row">����ڸ�<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="text" class="inp" tabindex=15 name="person" value="<%=person%>" required />
									</td>
								</tr>
								<tr>
									<th scope="row">����ó<em class="required">�ʼ��Է�</em></th>
									<td>
										<input type="text" class="inp" tabindex=16 name="tel_no" value="<%=tel_no%>" required />
									</td>
									<th scope="row">�ѽ�</th>
									<td>
										<input type="text" class="inp" tabindex=17 name="fax_no" value="<%=fax_no%>" />
									</td>
								</tr>
								<tr>
									<th class="end2">�̸���</th>
									<td>
										<input type="text" class="inp" tabindex=18 name="email" value="<%=email%>" />
									</td>
									<th class="end2">Ȩ������</th>
									<td>
										<input type="text" class="inp" tabindex=19 name="homepage" value="<%=homepage%>" />
									</td>
								</tr>
								<tr>
									<th class="end2">�������</th>
									<td>
										<input type="checkbox" class="checkbox" tabindex=20 value="�̸���" name="method" <%=if3(instr(method,"�̸���")>0,"checked","")%>>�̸���
										<input type="checkbox" class="checkbox" tabindex=21 value="�ѽ�" name="method" <%=if3(instr(method,"�ѽ�")>0,"checked","")%>>�ѽ�
										<input type="checkbox" class="checkbox" tabindex=22 value="����" name="method" <%=if3(instr(method,"����")>0,"checked","")%>>����
										<input type="checkbox" class="checkbox" tabindex=23 value="�湮" name="method" <%=if3(instr(method,"�湮")>0,"checked","")%>>�湮
									</td>
									<th class="end2">������</th>
									<td>
										<input type="text" tabindex=24 id="end_date" name="end_date" value="<%=end_date%>" class="inp" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">�����䰭</h4>
					<div class="tb">
<%
	If editor_yn = "Y" Then
%>
								<textarea tabindex=27 name="ir1" id="ir1" style="width:100%;display:none;">
<%
		If contents = "" Then
%>
								<p>[�޿�����] :</p>
								<p>[���⼭��] :</p>
								<p>[������ġ] :</p>
								<p>[��Ÿ����] :</p>
<%
		Else
%>
								<%=contents%>
<%
		End if
%>
								</textarea>
<%
	Else
%>
								<textarea tabindex=27 name="ir1" id="ir1" style="width:100%;display:none;">
<%
		If contents = "" Then
%>
								<p>[�޿�����] :</p>
								<p>[���⼭��] :</p>
								<p>[������ġ] :</p>
								<p>[��Ÿ����] :</p>
<%
		Else
%>
								<%=contents%>
<%
		End if
%>
								</textarea>
<%
	End If
%>
						<li class="orange">���ΰ�ħ�� ������ ������ �������� �ʽ��ϴ�.</li>
					</div>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	com_seq = job_seq
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
						fOnBeforeUnload : function() {
							var f = document.form;
							if (f.temp.value == "Y" && f.subject.value != "")
							{
								oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
								f.action = "job_temp_exec.asp";
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
						elClickedObj.action = "job_write_exec.asp";
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

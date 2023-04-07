<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
	checkWriteAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�о�ҽ� : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<!-- �޷� ���� -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd',
		prevText: '���� ��',
		nextText: '���� ��',
		monthNames: ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'],
		monthNamesShort: ['1��', '2��', '3��', '4��', '5��', '6��', '7��', '8��', '9��', '10��', '11��', '12��'],
		dayNames: ['��', '��', 'ȭ', '��', '��', '��', '��'],
		dayNamesShort: ['��', '��', 'ȭ', '��', '��', '��', '��'],
		dayNamesMin: ['��', '��', 'ȭ', '��', '��', '��', '��'],
		showMonthAfterYear: true,
		yearSuffix: '��'
	});

	$( function() {
		$("#rect_notice_date").datepicker();
		$("#frst_receipt_acpt_date").datepicker();
		$("#scnd_receipt_acpt_date").datepicker();
		$("#prize_anc_date").datepicker();
		$("#cnt_st_date").datepicker();
		$("#cnt_ed_date").datepicker();
		$("#resale_st_date").datepicker();
		$("#resale_ed_date").datepicker();
		$("#mvin_date").datepicker();
	} );
</script>
<!-- �޷� �� -->
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
<%

	link = "http://"

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_temp_board "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	rs.Open Sql, conn, 3, 1

	If not rs.EOF Then
		msgonly "�ӽ� ����� ������ �ֽ��ϴ�."
		top_yn   = rs("top_yn")
		link     = rs("link")
		subject  = rs("subject")
		contents = rs("contents")
	End If
	rs.close
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
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">������/����</th>
								<td colspan="3">
									<input type="text" id="subject" name="subject" value="<%=subject%>" class="inp w70 mr20">
									<input type="checkbox" id="open_yn" name="open_yn" class="inp_check" value="Y" <%=if3(open_yn="Y","checked","")%> />
									<label for="open_yn"><em>üũ �� �̳���</em></label>
								</td>
							</tr>
							<tr>
								<th scope="row">�о�����</th>
								<td colspan="3">
<%
	sql = ""
	sql = sql & " select *                       "
	sql = sql & "   from sys_cd                  "
	sql = sql & "  where cd_nm = 'nsale_rgn_cd'    "
	sql = sql & "    and USE_YN = 'Y'            "
	sql = sql & "  order by cd_sn asc            "
	rs.open Sql, conn, 3, 1

	Do Until rs.eof
		cmn_cd  = rs("cmn_cd")
		cd_expl = rs("cd_expl")
%>
									<span class="">
										<input type="radio" id="nsale_rgn_cd_<%=cmn_cd%>" name="nsale_rgn_cd" value="<%=cmn_cd%>" <%=if3(nsale_rgn_cd,"checked","")%> class="inp_radio">
										<label for="nsale_rgn_cd_<%=cmn_cd%>"><em><%=cd_expl%></em></label>
									</span>
<%
		rs.MoveNext
	Loop
	rs.close
%>
								</td>
							<tr>
								<th scope="row">�о��ּ�</th>
								<td colspan="3">
									<input type="text" id="nsale_addr" name="nsale_addr" value="<%=nsale_addr%>" class="inp">
								</td>
							</tr>
							<tr>
								<th scope="row">��������</th>
								<td>
<%
	sql = ""
	sql = sql & " select *                       "
	sql = sql & "   from sys_cd                  "
	sql = sql & "  where cd_nm = 'cmpl_se_cd'    "
	sql = sql & "    and USE_YN = 'Y'            "
	sql = sql & "  order by cd_sn asc            "
	rs.open Sql, conn, 3, 1

	Do Until rs.eof
		cmn_cd  = rs("cmn_cd")
		cd_expl = rs("cd_expl")
%>
									<span class="">
										<input type="radio" id="cmpl_se_cd_<%=cmn_cd%>" name="cmpl_se_cd" value="<%=cmn_cd%>" <%=if3(cmpl_se_cd=cmn_cd,"checked","")%> class="inp_radio">
										<label for="cmpl_se_cd_<%=cmn_cd%>"><em><%=cd_expl%></em></label>
									</span>
<%
		rs.MoveNext
	Loop
	rs.close
%>
								</td>
								<th scope="row">�о�ܰ�</th>
								<td>
<%
	sql = ""
	sql = sql & " select cmn_cd                                               "
	sql = sql & "       ,cd_nm                                              "
	sql = sql & "   from cf_code                                              "
	sql = sql & "  where up_cd_id = (select cd_id                     "
	sql = sql & "                          from cf_code                       "
	sql = sql & "                         where up_cd_id = 'CD0000000000' "
	sql = sql & "                           and cmn_cd = 'nsale_stts_cd'      "
	sql = sql & "                           and del_yn = 'N'                  "
	sql = sql & "                           and use_yn = 'Y'                  "
	sql = sql & "                       )                                     "
	sql = sql & "    and del_yn = 'N'                                         "
	sql = sql & "    and use_yn = 'Y'                                         "
	sql = sql & "  order by cd_sn                                             "
	rs.open Sql, conn, 3, 1

	Do Until rs.eof
		cmn_cd = rs("cmn_cd")
		cd_nm  = rs("cd_nm")
%>
									<span class="">
										<input type="radio" id="nsale_stts_cd_<%=cmn_cd%>" name="nsale_stts_cd" value="<%=cmn_cd%>" <%=if3(nsale_stts_cd=cmn_cd,"checked","")%> class="inp_radio">
										<label for="nsale_stts_cd_<%=cmn_cd%>"><em><%=cd_nm%></em></label>
									</span>
<%
		rs.MoveNext
	Loop
	rs.close
%>
								</td>
							</tr>
							<tr>
								<th scope="row">����������</th>
								<td>
									<input type="text" id="rect_notice_date" name="rect_notice_date" value="<%=rect_notice_date%>" class="inp" />
								</td>
								<th scope="row">û��������</th>
								<td>
									<span class="">
										<em class="mr5">1����</em>
										<input type="text" id="frst_receipt_acpt_date" name="frst_receipt_acpt_date" value="<%=frst_receipt_acpt_date%>" class="inp w120p" />
									</span>
									<span class="ml20">
										<em class="mr5">2����</em>
										<input type="text" id="scnd_receipt_acpt_date" name="scnd_receipt_acpt_date" value="<%=scnd_receipt_acpt_date%>" class="inp w120p" />
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">��÷��ǥ��</th>
								<td>
									<input type="text" id="prize_anc_date" name="prize_anc_date" value="<%=prize_anc_date%>" class="inp" />
								</td>
								<th scope="row">���Ⱓ</th>
								<td>
									<input type="text" id="cnt_st_date" name="cnt_st_date" value="<%=cnt_st_date%>" class="inp" />
									<input type="text" id="cnt_ed_date" name="cnt_ed_date" value="<%=cnt_ed_date%>" class="inp" />
								</td>
							</tr>
							<tr>
								<th scope="row">���űⰣ</th>
								<td>
									<input type="text" id="resale_st_date" name="resale_st_date" value="<%=resale_st_date%>" class="inp" />
									<input type="text" id="resale_ed_date" name="resale_ed_date" value="<%=resale_ed_date%>" class="inp" />
								</td>
								<th scope="row">������</th>
								<td>
									<input type="text" id="mvin_date" name="mvin_date" value="<%=mvin_date%>" class="inp" />
								</td>
							</tr>
							<tr>
								<th scope="row">���Ͽ콺 ��ġ</th>
								<td colspan="3">
									<input type="text" id="mdl_house_addr" name="mdl_house_addr" value="<%=mdl_house_addr%>" class="inp">
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
<%
	com_seq = nsale_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>���</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='nsale_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
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
									f.action = "nsale_temp_exec.asp";
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
							elClickedObj.action = "nsale_write_exec.asp";
							elClickedObj.temp.value = "N";
							elClickedObj.target = "hiddenfrm";
							elClickedObj.submit()
						} catch(e) {alert(e)}
					}
				</script>

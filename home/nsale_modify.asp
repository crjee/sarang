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
	Set rs = Server.CreateObject ("ADODB.Recordset")

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	menu_seq  = Request("menu_seq")

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

	nsale_seq = Request("nsale_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_nsale "
	sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And UCase(session("user_id")) <> UCase(rs("user_id")) then
			Response.Write "<script>alert('���� �����̾����ϴ�');history.back();</script>"
			Response.End
		End If

		subject                = rs("subject")
		open_yn                = rs("open_yn")
		nsale_rgn_se_cd        = rs("nsale_rgn_se_cd")
		nsale_addr             = rs("nsale_addr")
		cmpl_se_cd             = rs("cmpl_se_cd")
		nsale_stts_cd          = rs("nsale_stts_cd")
		rect_notice_date       = rs("rect_notice_date")
		frst_receipt_acpt_date = rs("frst_receipt_acpt_date")
		scnd_receipt_acpt_date = rs("scnd_receipt_acpt_date")
		prize_anc_date         = rs("prize_anc_date")
		cnt_st_date            = rs("cnt_st_date")
		cnt_ed_date            = rs("cnt_ed_date")
		resale_st_date         = rs("resale_st_date")
		resale_ed_date         = rs("resale_ed_date")
		mvin_date              = rs("mvin_date")
		mdl_house_addr         = rs("mdl_house_addr")
		contents               = rs("contents")
		creid                  = rs("creid")
		credt                  = rs("credt")
		modid                  = rs("modid")
		moddt                  = rs("moddt")
		cafe_id                = rs("cafe_id")
		nsale_seq              = rs("nsale_seq")
		top_yn                 = rs("top_yn")
		view_cnt               = rs("view_cnt")
		parent_seq             = rs("parent_seq")
		parent_del_yn          = rs("parent_del_yn")
		restoreid              = rs("restoreid")
		restoredt              = rs("restoredt")
		comment_cnt            = rs("comment_cnt")
		step_num               = rs("step_num")
		group_num              = rs("group_num")
		menu_seq               = rs("menu_seq")
		user_id                = rs("user_id")
		level_num              = rs("level_num")
		nsale_num              = rs("nsale_num")
		subject = Replace(subject, """", " & quot;")
	End if
	rs.close
%>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> ����</h2>
				</div>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="pagesize" value="<%=pagesize%>">
					<input type="hidden" name="sch_type" value="<%=sch_type%>">
					<input type="hidden" name="sch_word" value="<%=sch_word%>">
					<input type="hidden" name="nsale_seq" value="<%=nsale_seq%>">
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
	sql = sql & " select *                         "
	sql = sql & "   from sys_cd                    "
	sql = sql & "  where CD_NM = 'nsale_rgn_se_cd' "
	sql = sql & "    and USE_YN = 'Y'              "
	sql = sql & "  order by CD_SN asc              "
	rs.open Sql, conn, 3, 1

	Do Until rs.eof
		CMN_CD  = rs("CMN_CD")
		CD_EXPL = rs("CD_EXPL")
%>
									<span class="">
										<input type="radio" id="nsale_rgn_se_cd_<%=CMN_CD%>" name="nsale_rgn_se_cd" value="<%=CMN_CD%>" <%=if3(nsale_rgn_se_cd=CMN_CD,"checked","")%> class="inp_radio">
										<label for="nsale_rgn_se_cd_<%=CMN_CD%>"><em><%=CD_EXPL%></em></label>
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
	sql = sql & "  where CD_NM = 'cmpl_se_cd'    "
	sql = sql & "    and USE_YN = 'Y'            "
	sql = sql & "  order by CD_SN asc            "
	rs.open Sql, conn, 3, 1

	Do Until rs.eof
		CMN_CD  = rs("CMN_CD")
		CD_EXPL = rs("CD_EXPL")
%>
									<span class="">
										<input type="radio" id="cmpl_se_cd_<%=CMN_CD%>" name="cmpl_se_cd" value="<%=CMN_CD%>" <%=if3(cmpl_se_cd=CMN_CD,"checked","")%> class="inp_radio">
										<label for="cmpl_se_cd_<%=CMN_CD%>"><em><%=CD_EXPL%></em></label>
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
	sql = sql & " select *                       "
	sql = sql & "   from sys_cd                  "
	sql = sql & "  where CD_NM = 'nsale_stts_cd' "
	sql = sql & "    and USE_YN = 'Y'            "
	sql = sql & "  order by CD_SN asc            "
	rs.open Sql, conn, 3, 1

	Do Until rs.eof
		CMN_CD  = rs("CMN_CD")
		CD_EXPL = rs("CD_EXPL")
%>
									<span class="">
										<input type="radio" id="cmpl_se_cd_<%=CMN_CD%>" name="nsale_stts_cd" value="<%=CMN_CD%>" <%=if3(nsale_stts_cd=CMN_CD,"checked","")%> class="inp_radio">
										<label for="cmpl_se_cd_<%=CMN_CD%>"><em><%=CD_EXPL%></em></label>
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
	End If
	rs.close
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
					<input type="hidden" id="attachCnt" name="attachCnt" value="<%=i%>">
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>���</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='nsale_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
				</div>
				</form>
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
									f.action = "nsale_temp_exec.asp";
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
							elClickedObj.action = "nsale_modify_exec.asp";
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
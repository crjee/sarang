<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckWriteAuth(cafe_id)
	Call CheckDailyCount(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body class="skin_type_1">
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
	<div id="wrap" class="group">
<!--#include virtual="/cafe/cafe_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/cafe_left_inc.asp"-->
<%
	End If
%>
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select phone as tel_no "
	sql = sql & "       ,fax as fax_no "
	sql = sql & "   from cf_member "
	sql = sql & "  where user_id = '" & Session("user_id") & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		tel_no = rs("tel_no")
		fax_no = rs("fax_no")
	End If
	rs.close

	link = "http://"

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_temp_sale "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & Session("user_id")  & "' "
	rs.Open Sql, conn, 3, 1

	If not rs.EOF Then
		msgonly "임시 저장된 내용이 있습니다."

		sale_seq      = rs("sale_seq")
		sale_num      = rs("sale_num")
		group_num     = rs("group_num")
		step_num      = rs("step_num")
		level_num     = rs("level_num")
		menu_seq      = rs("menu_seq")
		cafe_id       = rs("cafe_id")
		agency        = rs("agency")
		top_yn        = rs("top_yn")
		pop_yn        = rs("pop_yn")
		section_seq   = rs("section_seq")
		subject       = rs("subject")
		contents      = rs("contents")
		link          = rs("link")
		location      = rs("location")
		bargain       = rs("bargain")
		area          = rs("area")
		floor         = rs("floor")
		compose       = rs("compose")
		price         = rs("price")
		live_in       = rs("live_in")
		parking       = rs("parking")
		traffic       = rs("traffic")
		purpose       = rs("purpose")
		tel_no        = rs("tel_no")
		mbl_telno     = rs("mbl_telno")
		fax_no        = rs("fax_no")
		user_id       = rs("user_id")
		reg_date      = rs("reg_date")
		view_cnt      = rs("view_cnt")
		comment_cnt   = rs("comment_cnt")
		suggest_cnt   = rs("suggest_cnt")
		suggest_info  = rs("suggest_info")
		parent_seq    = rs("parent_seq")
		parent_del_yn = rs("parent_del_yn")
		move_sale_num = rs("move_sale_num")
		move_menu_seq = rs("move_menu_seq")
		move_user_id  = rs("move_user_id")
		move_date     = rs("move_date")
		restoreid     = rs("restoreid")
		restoredt     = rs("restoredt")
		creid         = rs("creid")
		credt         = rs("credt")
		modid         = rs("modid")
		moddt         = rs("moddt")
	End If
	rs.close

	If contents = "" Then
		sql = ""
		sql = sql & " select form "
		sql = sql & "   from cf_com_form "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		rs.Open Sql, conn, 3, 1
		If Not rs.eof Then
			contents = rs("form")
		End If
		rs.close
	End If
%>
			<div class="container">
				<form name="form" method="post" onsubmit="return submitContents(this)" enctype="multipart/form-data">
				<input type="hidden" name="tb_prefix" value="cf">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 등록</h2>
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
	If cafe_mb_level = 10 Then
%>
							<tr>
								<th scope="row">공지</th>
								<td colspan="3">
									<input type="checkbox" id="top_yn" name="top_yn" class="inp_check" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>공지로 지정</em></label>
								</td>
							</tr>
<%
	End If
%>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th>
								<td colspan="3">
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>

							<tr>
								<th scope="row">소재지</th>
								<td>
									<input type="text" class="inp" tabindex=2 name="location" value="<%=location%>" />
								</td>
								<th scope="row">계약상태</th>
								<td>
									<input type="text" class="inp" tabindex=3 name="bargain" value="<%=bargain%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">면적(평)</th>
								<td>
									<input type="text" class="inp" tabindex=4 name="area" value="<%=area%>" />
								</td>
								<th scope="row">해당층/총층</th>
								<td>
									<input type="text" class="inp" tabindex=5 name="floor" value="<%=floor%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">방개수/욕실수</th>
								<td>
									<input type="text" class="inp" tabindex=6 name="compose" value="<%=compose%>" />
								</td>
								<th scope="row">금액</th>
								<td>
									<input type="text" class="inp" tabindex=7 name="price" value="<%=price%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">입주가능일</th>
								<td>
									<input type="text" class="inp" tabindex=8 name="live_in" value="<%=live_in%>" />
								</td>
								<th scope="row">주차여부</th>
								<td>
									<input type="text" class="inp" tabindex=9 name="parking" value="<%=parking%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">대중교통</th>
								<td>
									<input type="text" class="inp" tabindex=10 name="traffic" value="<%=traffic%>" />
								</td>
								<th scope="row">목적 및 용도</th>
								<td>
									<input type="text" class="inp" tabindex=11 name="purpose" value="<%=purpose%>" />
								</td>
							</tr>
							<tr>
								<th scope="row">연락처</th>
								<td>
									<input type="text" class="inp" tabindex=12 name="tel_no" value="<%=tel_no%>" />
								</td>
								<th scope="row">팩스</th>
								<td>
									<input type="text" class="inp" tabindex=13 name="fax_no" value="<%=fax_no%>" />
								</td>
							</tr>
						<tbody>
					</table>
					<div class="mt10">
						<textarea name="contents" id="contents" style="width:100%;display:none;"><%=contents%></textarea>
						<p class="txt_point mt10">새로고침시 에디터 내용은 유지되지 않습니다.</p>
					</div>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">링크주소</th>
								<td>
									<input type="text" id="link" name="link" class="inp" value="<%=link%>">
								</td>
							</tr>
						</tbody>
					</table>
<%
	com_seq = ""
%>
<!--#include virtual="/include/attach_form_inc.asp"-->
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n" tabindex=26>등록</button>
					<button type="button" class="btn btn_c_n btn_n" tabindex=27 onclick="goList('<%=session("ctTarget")%>')">취소</button>
				</div>
				</form>
				<form name="search_form" id="search_form" method="post">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				</form>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<%
	End If
%>
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
<script>
	var oEditors = [];

	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "contents",
		sSkinURI: "/smart/SmartEditor2Skin.html",
		htParams : {
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
			fOnBeforeUnload : function() {
				var f = document.form;
				if (f.temp.value == "Y" && f.subject.value != "")
				{
					oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", [])
					f.action = "sale_temp_exec.asp";
					f.temp.value = "N";
					f.target = "hiddenfrm";
					f.submit();
				}
			}
		}, //boolean
		fOnAppLoad : function() {
			//예제 코드
			//oEditors.getById["contents"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
		},
		fCreator: "createSEditor2"
	})

	function submitContents(elClickedObj) {
		oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", [])
		try {
			elClickedObj.action = "sale_write_exec.asp";
			elClickedObj.temp.value = "N";
			//elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()

		} catch(e) {}
	}

	function goList(gvTarget) {
		var f = document.search_form;
		f.action = "sale_list.asp";
		f.target = gvTarget;
		f.submit();
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

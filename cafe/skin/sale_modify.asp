<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkModifyAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="skin_type_1">
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
<%
	End IF
%>
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	self_yn   = Request("self_yn")

	sale_seq  = Request("sale_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_sale "
	sql = sql & "  where sale_seq = '" & sale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And session("user_id") <> rs("user_id") then
			Response.Write "<script>alert('수정 권한이없습니다');history.back();</script>"
			Response.End
		End If

		step_num    = rs("step_num")
		top_yn      = rs("top_yn")
		subject     = rs("subject")
		location    = rs("location")
		bargain     = rs("bargain")
		area        = rs("area")
		floor       = rs("floor")
		compose     = rs("compose")
		price       = rs("price")
		live_in     = rs("live_in")
		parking     = rs("parking")
		traffic     = rs("traffic")
		purpose     = rs("purpose")
		contents    = rs("contents")
		tel_no      = rs("tel_no")
		fax_no      = rs("fax_no")
		section_seq = rs("section_seq")
		link        = rs("link")

		If link = "" Then
			link = "http://"
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
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="sale_seq" value="<%=sale_seq%>">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 수정</h2>
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
								<th scope="row">공지</th>
								<td colspan="3">
									<input type="checkbox" id="top_yn" name="top_yn" class="inp_check" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>공지로 지정</em></label>
								</td>
							</tr>
<%
		End If
	End If
%>
<%
	If tab_use_yn = "Y" Then
%>
							<tr>
								<th scope="row"><%=tab_nm%><em class="required">필수입력</em></th>
								<td>
									<%=makeSection("R", "section_seq", section_seq, "")%>
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
<%
	com_seq = board_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n" tabindex=26>등록</button>
					<button type="button" class="btn btn_c_n btn_n" tabindex=27 onclick="<%=session("svHref")%>location.href='/cafe/skin/job_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
<%
	End IF
%>
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>
</body>
</html>

<script>
	var oEditors = [];

	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "ir1",
		sSkinURI: "/smart/SmartEditor2Skin.html",
		htParams : {
			bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
			bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
			//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
			fOnBeforeUnload : function() {
				//alert("완료!")
			}
		}, //boolean
		fOnAppLoad : function() {
			//예제 코드
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
		},
		fCreator: "createSEditor2"
	})

	function submitContents(elClickedObj) {
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
		try {
<%
	If tab_use_yn = "Y" Then
%>
			if ( ! $('input[name=section_seq]:checked').val()) {
				alert('<%=tab_nm%>을 선택해주세요.');
				return false;
			}
<%
	End If
%>
			elClickedObj.action = "sale_modify_exec.asp";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.form.submit()
		} catch(e) {}
	}
</script>

<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
	checkWriteAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>부동산이야기 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="sub">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 수정</h2>
				</div>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
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
								<th scope="row">공지</th>
								<td>
									<input type="checkbox" id="top_yn" name="top_yn" class="inp_check" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>공지로 지정</em></label>
								</td>
							</tr>
<%
	End If
%>
							<tr>
								<th scope="row">지역<em class="required">필수입력</em></th></th>
								<td>
									<%=makeRadioCD("pst_rgn_se_cd", pst_rgn_se_cd, "required")%>
								</td>
							</tr>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th></th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
<%
	link = "http://"

	Set rs = Server.CreateObject ("ADODB.Recordset")

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
								<th scope="row">링크주소</th>
								<td>
									<input type="text" id="link" name="link" class="inp" value="<%=link%>">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>등록</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='story_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
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
							bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
							bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
							bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
							//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
							fOnBeforeUnload : function() {
								var f = document.form;
								if (f.temp.value == "Y" && f.subject.value != "")
								{
									oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
									f.action = "story_temp_exec.asp";
									f.temp.value = "N";
									f.target = "hiddenfrm";
									f.submit();
									alert("작성중인 내용이 임시로 저장되었습니다.");
								}
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
							elClickedObj.action = "story_write_exec.asp";
							elClickedObj.temp.value = "N";
							elClickedObj.submit()
						} catch(e) {alert(e)}
					}
				</script>

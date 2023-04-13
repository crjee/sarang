<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	menu_type = "notice"
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
	<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
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

	Set rs = Server.CreateObject ("ADODB.Recordset")

	notice_seq = Request("notice_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_notice "
	sql = sql & "  where notice_seq = '" & notice_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_ad_level) < 6 And UCase(session("user_id")) <> UCase(rs("user_id")) then
			Response.Write "<script>alert('수정 권한이없습니다');history.back();</script>"
			Response.End
		End If

		step_num = rs("step_num")
		top_yn   = rs("top_yn")
		pop_yn   = rs("pop_yn")
		cafe_id  = rs("cafe_id")
		user_id  = rs("user_id")
		subject  = rs("subject")
		contents = rs("contents")
		subject  = Replace(subject, """", " & quot;")

		If rs("link")="" Then
			link = "http://"
		Else
			link = rs("link")
		End If

		If cafe_id = "" Then
			cafe_name = "전체사랑방"
		Else

			arrCafe = Split(cafe_id, ",")

			For i = 0 To ubound(arrCafe)
				cafe = Trim(arrCafe(i))
				If i = 0 then
					cafe_name = getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
				Else
					cafe_name = cafe_name & ", " & getonevalue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
				End If
			Next
		End If
		
	End if
	rs.close
%>
			<script>
				function goAll(obj) {
					if (obj.checked == true)
					{
						document.form.add_glist.value = "";
						document.form.opt_text.value = "전체사랑방";
					}
					else {
						document.form.add_glist.value = "";
						document.form.opt_text.value = "";
					}
				}
			</script>
				<form name="form" method="post" onsubmit="return submitContents(this)" enctype="multipart/form-data">
				<input type="hidden" name="opt_value" value="<%=cafe_id%>">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="notice_seq" value="<%=notice_seq%>">
				<input type="hidden" name="add_glist" value="<%=cafe_id%>">
				<div class="cont_tit">
					<h2 class="h2">경인네트웍스 전체공지 수정</h2>
				</div>
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
<%
	If cafe_ad_level > 6 Then
		If step_num = "0" Then
%>
							<tr>
								<th scope="row">팝업/공지</th>
								<td>
									<input type="checkbox" class="inp_check" id="pop_yn" name="pop_yn" value="Y" <%=if3(pop_yn="Y","checked","")%> />
									<label for="pop_yn"><em>팝업으로 지정</em></label>
									<input type="checkbox" class="inp_check" id="top_yn" name="top_yn" value="Y" <%=if3(top_yn="Y","checked","")%> />
									<label for="top_yn"><em>공지로 지정</em></label>
								</td>
							</tr>
<%
		End If
	End If
%>
							<tr>
								<th scope="row">사랑방</th>
								<td>
									<button type="button" class="btn_long" onclick="goCafe()">사랑방 선택</button>
									<input type="checkbox" class="inp_check" name="allcafe" value="all" onclick="goAll(this)" <%=if3(cafe_id="","checked","")%>> 전체사랑방
									<textarea name="opt_text" class="retextarea2" readonly required><%=cafe_name%></textarea>
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
								<th scope="row">링크주소</th>
								<td>
									<input type="text" id="link" name="link" class="inp" value="<%=link%>">
								</td>
							</tr>
<%
	com_seq = notice_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=session("svHref")%>location.href='/cafe/skin/notice_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>
				<script type="text/javascript">
					function goCafe() {
						document.open_form.action = "/win_open_exec.asp"
						document.open_form.target = "hiddenfrm";
						document.open_form.submit();
					}
				</script>
				<form name="open_form" method="post">
				<input type="hidden" name="open_url" value="/cafe/skin/notice_cafe_edit_p.asp?cafe_id=<%=cafe_id%>">
				<input type="hidden" name="open_name" value="notice_cafe">
				<input type="hidden" name="open_specs" value="width=600, height=600, left=200, top=200">
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
			elClickedObj.action = "notice_modify_exec.asp";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.form.submit()

		} catch(e) {}
	}
	</script>

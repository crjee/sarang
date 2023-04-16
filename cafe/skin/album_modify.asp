<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkCafePage(cafe_id)
	checkWriteAuth(cafe_id)
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
			<div class="container" id="album">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	self_yn   = Request("self_yn")

	album_seq = Request("album_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & " "
	sql = sql & "  where album_seq = '" & album_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And session("user_id") <> rs("user_id") then
			Response.Write "<script>alert('수정 권한이없습니다');history.back();</script>"
			Response.End
		End If

		step_num = rs("step_num")
		top_yn = rs("top_yn")
		user_id = rs("user_id")
		subject = rs("subject")
		contents = rs("contents")

		If rs("link") = "" Then
			link = "http://"
		Else
			link = rs("link")
		End If
	End if
	rs.close
%>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 수정</h2>
				</div>
				<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this, '/cafe/skin/album_modify_exec.asp', 'N')">
				<div class="tb">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="page" value="<%=page%>">
					<input type="hidden" name="pagesize" value="<%=pagesize%>">
					<input type="hidden" name="sch_type" value="<%=sch_type%>">
					<input type="hidden" name="sch_word" value="<%=sch_word%>">
					<input type="hidden" name="self_yn" value="<%=self_yn%>">
					<input type="hidden" name="album_seq" value="<%=album_seq%>">
					<input type="hidden" name="temp" value="N">
					<table class="tb_input tb_fixed">
						<colgroup>
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
								<td>
									<input name="top_yn" type="checkbox" class="checkbox" value="Y" <%=if3(top_yn="Y","checked","")%> /> 공지로 지정
								</td>
							</tr>
<%
		End If
	End If
%>
							<tr>
								<th scope="row">제목 *</th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
<%
	If edit = "edit" Then
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;" onkeyup="setCookie('ir1',this.value,1)"><%=contents%></textarea>
<%
	Else
%>
						<textarea name="ir1" id="ir1" style="width:100%;display:none;" onkeyup="setCookie('ir1',this.value,1)"><%=contents%></textarea>
<%
	End if
%>
							<li class="orange">새로고침시 에디터 내용은 유지되지 않습니다.</li>
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
	com_seq = album_seq
%>
<!--#include virtual="/include/attach_inc.asp"-->
						</tbody>
					</table>
							<li class="orange">jpg, png, gif, bmp 파일만 첨부 가능합니다.</li>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>등록</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=session("svHref")%>location.href='/cafe/skin/album_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>
				<div>
	<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;height:100px;width:1000px;">sss</iframe>
	</div>
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
								f.action = "album_temp_exec.asp";
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

				function submitContents(elClickedObj, url, tmp) {
					oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
					try {
						elClickedObj.action = url;
//						elClickedObj.temp.value = tmp;
						elClickedObj.submit()
					} catch(e) {alert(e)}
				}
</script>


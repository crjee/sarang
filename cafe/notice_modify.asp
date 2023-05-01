<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	Call CheckAdmin()

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)
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
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")

	link = "http://"

	Set rs = Server.CreateObject("ADODB.Recordset")

	notice_seq = Request("notice_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_notice "
	sql = sql & "  where notice_seq = '" & notice_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		notice_seq      = rs("notice_seq")
		notice_num      = rs("notice_num")
		group_num      = rs("group_num")
		step_num       = rs("step_num")
		level_num      = rs("level_num")
		menu_seq       = rs("menu_seq")
		cafe_id        = rs("cafe_id")
		agency         = rs("agency")
		top_yn         = rs("top_yn")
		pop_yn         = rs("pop_yn")
		section_seq    = rs("section_seq")
		subject        = rs("subject")
		contents       = rs("contents")
		link           = rs("link")
		user_id        = rs("user_id")
		reg_date       = rs("reg_date")
		view_cnt       = rs("view_cnt")
		comment_cnt    = rs("comment_cnt")
		suggest_cnt    = rs("suggest_cnt")
		suggest_info   = rs("suggest_info")
		parent_seq     = rs("parent_seq")
		parent_del_yn  = rs("parent_del_yn")
		move_notice_num = rs("move_notice_num")
		move_menu_seq  = rs("move_menu_seq")
		move_user_id   = rs("move_user_id")
		move_date      = rs("move_date")
		restoreid      = rs("restoreid")
		restoredt      = rs("restoredt")
		creid          = rs("creid")
		credt          = rs("credt")
		modid          = rs("modid")
		moddt          = rs("moddt")

		subject     = Replace(subject, """", "&quot;")

		If cafe_id = "" Then
			cafe_name = "전체사랑방"
		Else
			arrCafe = Split(cafe_id, ",")

			For i = 0 To ubound(arrCafe)
				cafe = Trim(arrCafe(i))
				If i = 0 then
					cafe_name = GetOneValue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
				Else
					cafe_name = cafe_name & ", " & GetOneValue("cafe_name","cf_cafe","where cafe_id = '" & cafe & "'")
				End If
			Next
		End If
		
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
	If cafe_ad_level = 10 Then
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
<%
	If tab_use_yn = "Y" Then
%>
							<tr>
								<th scope="row"><%=tab_nm%><em class="required">필수입력</em></th>
								<td>
									<%=GetMakeSectionTag("R", "section_seq", section_seq, "")%>
								</td>
							</tr>
<%
	End If
%>
							<tr>
								<th scope="row">사랑방<em class="required">필수입력</em></th>
								<td>
									<button type="button" class="btn_long" onclick="onCafe()">사랑방 선택</button>
									<input type="checkbox" class="inp_check" name="allcafe" value="all" onclick="goAll(this)" <%=if3(cafe_id="","checked","")%>> 전체사랑방
									<textarea name="opt_text" class="retextarea2" readonly required><%=cafe_name%></textarea>
								</td>
							</tr>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
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
	com_seq = notice_seq
%>
<!--#include virtual="/include/attach_form_inc.asp"-->
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=session("ctTarget")%>')">취소</button>
				</div>
				</form>
				<script>
					function onCafe() {
						document.open_form.action = "/win_open_exec.asp"
						document.open_form.target = "hiddenfrm";
						document.open_form.submit();
					}
				</script>
				<form name="open_form" method="post">
				<input type="hidden" name="open_url" value="/cafe/notice_cafe_edit_p.asp?cafe_id=<%=cafe_id%>">
				<input type="hidden" name="open_name" value="notice_cafe">
				<input type="hidden" name="open_specs" value="width=600, height=600, left=200, top=200">
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
				//alert("완료!")
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
<%
	If tab_use_yn = "Y" Then
%>
							<tr>
								<th scope="row"><%=tab_nm%><em class="required">필수입력</em></th>
								<td>
									<%=GetMakeSectionTag("R", "section_seq", section_seq, "")%>
								</td>
							</tr>
<%
	End If
%>
			elClickedObj.action = "notice_modify_exec.asp";
			//elClickedObj.target = "hiddenfrm";
			elClickedObj.form.submit()
		} catch(e) {}
	}

	function goList(gvTarget) {
		var f = document.search_form;
		f.action = "notice_list.asp";
		f.target = gvTarget;
		f.submit();
	}

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
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

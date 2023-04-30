<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckMemoSendAuth(cafe_id)
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
	End IF
%>
			<div class="container">
				<script>
					function goAll(obj) {
						if (obj.checked == true)
						{
							document.form.opt_value.value = "";
							document.form.opt_text.value = "전체회원";
						}
						else {
							document.form.opt_value.value = "";
							document.form.opt_text.value = "";
						}
					}
				</script>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 등록</h2>
				</div>
				<form name="form" method="post" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="opt_value">
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th>
								<td>
									<input type="text" class="inp" id="subject" name="subject" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView');setCookie('subject',this.value,1)" required style="" />
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
							<tr>
								<th scope="row">받는 사람<em class="required">필수입력</em></th>
								<td>
									<span class="mr10">
										<button type="button" class="btn btn_c_n btn_s btn_long" onclick="lyp('lypp_member')">받는사람 선택</button>
									</span>
									<span class="mr10">
										<input type="checkbox" id="alluser" name="alluser" value="all" onclick="goAll(this)" class="inp_check"><label for="alluser"><em>전체회원</em></label>
									</span>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
						<div class="editor">
							<textarea name="opt_text" class="retextarea2" readonly required style="display:none"></textarea>
							<textarea name="contents" id="contents" style="width: 100%; height: 400px; display: none;"></textarea>
						</div>
					</div>
					<p class="txt_guide_1 mt10">새로고침시 에디터 내용은 유지되지 않습니다.</p>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=session("ctTarget")%>')">취소</button>
				</div>
				</form>
				<form name="search_form" id="search_form" method="post">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				</form>

				<script>
					function goUser() {
						document.open_form.action = "/win_open_exec.asp"
						document.open_form.target = "hiddenfrm";
						document.open_form.submit();
					}
				</script>
				<form name="open_form" method="post">
				<input type="hidden" name="open_url" value="/cafe/memo_user_edit_p.asp?cafe_id=<%=cafe_id%>">
				<input type="hidden" name="open_name" value="memo_user">
				<input type="hidden" name="open_specs" value="width=600, height=600, left=200, top=200">
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
	End IF
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
				//alert("완료!");
			}
		}, //boolean
		fOnAppLoad : function() {
			//예제 코드
			//oEditors.getById["contents"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."]);
		},
		fCreator: "createSEditor2"
	});

	function pasteHTML() {
		var sHTML = "<span style=color:#FF0000;>이미지도 같은 방식으로 삽입합니다.<\/span>";
		oEditors.getById["contents"].exec("PASTE_HTML", [sHTML]);
	}

	function showHTML() {
		var sHTML = oEditors.getById["contents"].getIR();
		alert(sHTML);
	}

	function submitContents(elClickedObj) {
		oEditors.getById["contents"].exec("UPDATE_CONTENTS_FIELD", []);	// 에디터의 내용이 textarea에 적용됩니다.

		// 에디터의 내용에 대한 값 검증은 이곳에서 document.getElementById("contents").value를 이용해서 처리하면 됩니다.
		try {
			if (document.getElementById("contents").value == "" || document.getElementById("contents").value == "<p>&nbsp;</p>") {
				alert("내용을 입력하세요");
				return;
			}
			elClickedObj.action = "memo_write_exec.asp";
			//elClickedObj.target = "hiddenfrm";
			elClickedObj.submit();
		} catch(e) {}
	}

	function setDefaultFont() {
		var sDefaultFont = "궁서";
		var nFontSize = 24;
		oEditors.getById["contents"].setDefaultFont(sDefaultFont, nFontSize);
	}

	function goList(gvTarget) {
		var f = document.search_form;
		f.action = "memo_list.asp";
		f.target = gvTarget;
		f.submit();
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

	<!-- 레이어 팝업 -->
	<div class="lypp lypp_sarang lypp_member">
		<header class="lypp_head">
			<h2 class="h2">회원 선택</h2>
			<span class="posR">
				<button type="button" class="btn btn_close"><em>닫기</em></button>
			</span>
		</header>
		<div class="adm_cont">
		</div>
	</div>


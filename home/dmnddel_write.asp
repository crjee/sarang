<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>게시글 중단 요청하기</title>
	<link rel="stylesheet" type="text/css" href="/common/css/styles.css">
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
			<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2">게시글 중단 요청하기</h2>
					<span class="posR"><em class="required">필수입력</em>는 필수 기재 항목입니다.</span>
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
							<tr>
								<th scope="row">요청구분<em class="required">필수입력</em></th>
								<td colspan="3">
									<%=makeRadioCD("dmnd_se_cd", "", "required")%>
								</td>
							</tr>
							<tr>
								<th scope="row">제목<em class="required">필수입력</em></th>
								<td colspan="3">
									<input type="text" id="subject" name="subject" class="inp w100" required>
								</td>
							</tr>
							<tr>
								<th scope="row">이름<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="rqstr_flnm" name="rqstr_flnm" class="inp" required>
								</td>
								<th scope="row">연락처<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="mbl_telno" name="mbl_telno" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">이메일 주소<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="eml_addr" name="eml_addr" class="inp" required>
								</td>
								<th scope="row">신분증 사본<em class="required">필수입력</em></th>
								<td>
									<input type="file" id="idcd_file_nm" name="idcd_file_nm" class="inp w300p" required>
									<button type="button" class="btn btn_c_s btn_s">찾아보기</button>
								</td>
							</tr>
							<tr>
								<th scope="row">소속<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="co_nm" name="co_nm" class="inp" required>
								</td>
								<th scope="row">사업자등록증<em class="required">필수입력</em></th>
								<td>
									<input type="file" id="brct_file_nm" name="brct_file_nm" class="inp" required>
								</td>
							</tr>
							<tr>
								<th scope="row">대리인 신분증 사본</th>
								<td>
									<input type="file" id="agt_idcd_file_nm" name="agt_idcd_file_nm" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">찾아보기</button>
									<p class="txt_point mt10">대리인 경우 필수</p>
								</td>
								<th scope="row">위임장</th>
								<td>
									<input type="file" id="dlgt_file_nm" name="dlgt_file_nm" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">찾아보기</button>
									<p class="txt_point mt10">대리인 경우 필수</p>
								</td>
							</tr>
							<tr>
								<th scope="row">게시글 주소<em class="required">필수입력</em></th>
								<td colspan="3">
									<input type="text" id="url_addr" name="url_addr" class="inp">
								</td>
							</tr>
							<tr>
								<th scope="row">첨부파일</th>
								<td colspan="3">
									<input type="file" id="atch_data_file_nm" name="atch_data_file_nm" class="inp w300p">
									<button type="button" class="btn btn_c_s btn_s">찾아보기</button>
									<p class="txt_point mt10">파일형식은 hwp, doc(docx), ppt, pdf 파일만 등록 가능합니다.</p>
								</td>
							</tr>
						</tbody>
					</table>
					<div class="mt10">
						<textarea name="ir1" id="ir1" style="width:100%;display:none;"><%=contents%></textarea>
					</div>
					<div class="agree_box mt30">
						<h3 class="h3">개인정보 수집이용에 대한 동의</h3>
						<ul class="">
							<li>수집 항목 : [필수] 담당자 연락처, 담당자 이메일 주소, 회사명, 담당자 이름</li>
							<li>수집 목적 : 제휴/광고신청에 따른 신청인 확인 및 결과 회신</li>
							<li>이용 기간 : 개인정보의 수집 및 이용 목적이 달성된 후에 해당 정보를 복구할 수 없는 방법으로 지체 없이 파기합니다. 단, 관례법령의 규정에 따라 보존의 필요성이 있는 경우 일정기간(3년) 동안 개인 정보를 관리할 수 있습니다. 본 개인정보 제공에 동의하지 않으시는 경우, 동의를 거부할 수 있으며 이 경우 제휴/광고 문의가 제한
될 수 있습니다.</li>
							<li>상기 내용 외의 사항은 뽐뿌 개인정보처리방침에 따라 처리됩니다.</li>
						</ul>
					</div>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">요청하기</button>
					<button type="reset" class="btn btn_c_n btn_n"><em>취소</em></button>
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
			elClickedObj.action = "dmnddel_exec.asp";
			elClickedObj.temp.value = "N";
			elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()
		} catch(e) {alert(e)}
	}
</script>

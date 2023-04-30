<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckDataExist(com_seq)
	Call CheckModifyAuth(cafe_id)
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
<!-- 달력 시작 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd' //달력 날짜 형태
		,showOtherMonths: true //빈 공간에 현재월의 앞뒤월의 날짜를 표시
		,showMonthAfterYear:true // 월- 년 순서가아닌 년도 - 월 순서
		,changeYear: true //option값 년 선택 가능
		,changeMonth: true //option값  월 선택 가능                
		,showOn: "both" //button:버튼을 표시하고,버튼을 눌러야만 달력 표시 ^ both:버튼을 표시하고,버튼을 누르거나 input을 클릭하면 달력 표시  
		,buttonImage: "http://jqueryui.com/resources/demos/datepicker/images/calendar.gif" //버튼 이미지 경로
		,buttonImageOnly: true //버튼 이미지만 깔끔하게 보이게함
		,buttonText: "선택" //버튼 호버 텍스트              
		,yearSuffix: "년" //달력의 년도 부분 뒤 텍스트
		,monthNamesShort: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 텍스트
		,monthNames: ['1월','2월','3월','4월','5월','6월','7월','8월','9월','10월','11월','12월'] //달력의 월 부분 Tooltip
		,dayNamesMin: ['일','월','화','수','목','금','토'] //달력의 요일 텍스트
		,dayNames: ['일요일','월요일','화요일','수요일','목요일','금요일','토요일'] //달력의 요일 Tooltip
		,minDate: "-5Y" //최소 선택일자(-1D:하루전, -1M:한달전, -1Y:일년전)
		,maxDate: "+5y" //최대 선택일자(+1D:하루후, -1M:한달후, -1Y:일년후)  
	});

	$( function() {
		$("#end_date").datepicker();
	} );
</script>
<!-- 달력 끝 -->
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
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	self_yn   = Request("self_yn")
	all_yn    = Request("all_yn")
	job_seq   = Request("job_seq")

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_job "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If GetToInt(cafe_mb_level) < 6 And UCase(session("user_id")) <> UCase(rs("user_id")) then
			Response.Write "<script>alert('" & session("user_id") & "수정 권한이없습니다" & rs("user_id") & "');history.back();</script>"
			Response.End
		End If

		top_yn      = rs("top_yn")
		subject     = rs("subject")
		work        = rs("work")
		age         = rs("age")
		sex         = rs("sex")
		work_year   = rs("work_year")
		certify     = rs("certify")
		work_place  = rs("work_place")
		agency      = rs("agency")
		person      = rs("person")
		tel_no      = rs("tel_no")
		mbl_telno   = rs("mbl_telno")
		fax_no      = rs("fax_no")
		email       = rs("email")
		homepage    = rs("homepage")
		method      = rs("method")
		end_date    = rs("end_date")
		contents    = rs("contents")
		section_seq = rs("section_seq")

		arr_age   = split(age, "~")
		If ubound(arr_age) = 1 Then
			age1 = arr_age(0)
			age2 = arr_age(1)
		End If
	End If
	rs.close
%>
				<form name="form" method="post" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="all_yn" value="<%=all_yn%>">
				<input type="hidden" name="job_seq" value="<%=job_seq%>">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 수정</h2>
				</div>
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
								<th scope="row">제목<em class="required">필수입력</em></th>
								<td>
									<input type="text" id="subject" name="subject" class="inp" value="<%=subject%>" maxlength="200" onKeyup="fc_chk_byte(this, 200, 'req_attnView')" required>
									<span id="req_attnView" name="req_attnView">0</span>/200
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">자격조건</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">담당업무<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=2 name="work" value="<%=work%>" required />
									</td>
									<th scope="row">연령<em class="required">필수입력</em></th>
									<td>
										<span class=''>
											<input type="radio" class="inp_radio" tabindex=3 id="age" name="age" value="" onclick="chkage(0)" <%=if3(age="","checked","")%> required>
											<label for='age'><em>무관</em></label>
										</span>
										<span class=''>
											<input type="radio" class="inp_radio" tabindex=4 id="ageY" name="age" value="Y" onclick="chkage(1)" <%=if3(age="Y","checked","")%> required>
											<label for='ageY'><em>연령제한</em></label>
										</span>
										<input type="text" class="inp" tabindex=5 name="age1" value="<%=age1%>" style="width:40px" <%=If3(age="","disabled","")%>>세 ~
										<input type="text" class="inp" tabindex=6 name="age2" value="<%=age2%>" style="width:40px" <%=If3(age="","disabled","")%>>세
										<script>
										function chkage(idx) {
											if (idx == 0) {
												document.form.age1.disabled = true;
												document.form.age2.disabled = true;
												document.form.age1.value = "";
												document.form.age2.value = "";
												document.form.age1.required = false;
												document.form.age2.required = false;
											} else {
												document.form.age1.disabled = false;
												document.form.age2.disabled = false;
												document.form.age1.required = true;
												document.form.age2.required = true;
											}
										}
										</script>
									</td>
								</tr>
								<tr>
									<th scope="row">성별<em class="required">필수입력</em></th>
									<td>
										<span class=''>
											<input type="radio" tabindex=7 id="sex" name="sex" value="" class="inp_radio" <%=if3(sex=""," checked","")%> required>
											<label for='sex'><em>무관</em></label>
										</span>
										<%=GetMakeCDRadio("sex", sex, "")%>
									</td>
									<th scope="row">경력<em class="required">필수입력</em></th>
									<td>
										<select name="work_year" tabindex=10 class="sel w_auto">
											<option value="">무관</option>
<% For i = 1 To 50 %>
											<option value="<%=i%>" <%=if3(work_year=CStr(i),"selected","")%>><%=i%>년 이상</option>
<% Next %>
										</select>
									</td>
								</tr>
								<tr>
									<th class="end2">관력자격증<em class="required">필수입력</em></th>
									<td>
										<span class=''>
											<input type="radio" class="inp_radio" tabindex=11 id="certifyY" name="certify" value="Y" <%=if3(certify="Y","checked","")%>>
											<label for='certifyY'><em>필수</em></label>
										</span>
										<span class=''>
											<input type="radio" class="inp_radio" tabindex=12 id="certifyN" name="certify" value="N" <%=if3(certify="N","checked","")%>>
											<label for='certifyN'><em>무관</em></label>
										</span>
									</td>
									<th class="end2">근무지역<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=13 name="work_place" value="<%=work_place%>" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">문의및 접수방법</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">중개업소명<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=14 name="agency" value="<%=agency%>" required />
									</td>
									<th scope="row">담당자명<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=15 name="person" value="<%=person%>" required />
									</td>
								</tr>
								<tr>
									<th scope="row">전화번호</th>
									<td>
										<input type="text" class="inp" tabindex=16 name="tel_no" value="<%=tel_no%>" required />
									</td>
									<th scope="row">휴대전화번호<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=17 name="mbl_telno" value="<%=mbl_telno%>" required />
									</td>
								</tr>
								<tr>
									<th scope="row">팩스</th>
									<td>
										<input type="text" class="inp" tabindex=17 name="fax_no" value="<%=fax_no%>" />
									</td>
									<th class="end2">이메일</th>
									<td>
										<input type="text" class="inp" tabindex=18 name="email" value="<%=email%>" />
									</td>
								</tr>
								<tr>
									<th class="end2">홈페이지</th>
									<td>
										<input type="text" class="inp" tabindex=19 name="homepage" value="<%=homepage%>" />
									</td>
									<th class="end2">접수방법</th>
									<td>
										<%=GetMakeCDCheckBox("method", method, "", "21")%>
									</td>
								</tr>
								<tr>
									<th class="end2">마감일</th>
									<td colspan="3">
										<input type="text" tabindex=24 id="end_date" name="end_date" value="<%=end_date%>" class="inp w10" readonly />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
<!--#include virtual="/include/attach_form_inc.asp"-->
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">모집요강</h4>
					<div class="tb">
						<textarea tabindex=25 name="contents" id="contents" style="width:100%;display:none;">
						<%=contents%>
						</textarea>
						<li class="orange">새로고침시 에디터 내용은 유지되지 않습니다.</li>
					</div>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n" tabindex=26>등록</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=session("ctTarget")%>')">취소</button>
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
			if ( ! $('input[name=section_seq]:checked').val()) {
				alert('<%=tab_nm%>을 선택해주세요.');
				return false;
			}
<%
	End If
%>
			elClickedObj.action = "job_modify_exec.asp";
			//elClickedObj.target = "hiddenfrm";
			elClickedObj.form.submit()

		} catch(e) {}
	}

	function goList(gvTarget) {
		var f = document.search_form;
		f.action = "job_list.asp";
		f.target = gvTarget;
		f.submit();
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

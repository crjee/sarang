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
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_member "
	sql = sql & "  where user_id = '" & session("user_id")  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		agency    = rs("agency")
		tel_no    = rs("phone")
		mbl_telno = rs("mobile")
		fax_no    = rs("fax")
	End If
	rs.close

	link = "http://"

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_temp_job "
	sql = sql & "  where cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & Session("user_id")  & "' "
	rs.Open Sql, conn, 3, 1

	If not rs.EOF Then
		msgonly "임시 저장된 내용이 있습니다."

		job_seq       = rs("job_seq")
		job_num       = rs("job_num")
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
		work          = rs("work")
		age           = rs("age")
		sex           = rs("sex")
		work_year     = rs("work_year")
		certify       = rs("certify")
		work_place    = rs("work_place")
		person        = rs("person")
		tel_no        = rs("tel_no")
		mbl_telno     = rs("mbl_telno")
		fax_no        = rs("fax_no")
		email         = rs("email")
		homepage      = rs("homepage")
		method        = rs("method")
		end_date      = rs("end_date")
		user_id       = rs("user_id")
		reg_date      = rs("reg_date")
		view_cnt      = rs("view_cnt")
		comment_cnt   = rs("comment_cnt")
		suggest_cnt   = rs("suggest_cnt")
		suggest_info  = rs("suggest_info")
		parent_seq    = rs("parent_seq")
		parent_del_yn = rs("parent_del_yn")
		move_job_num  = rs("move_job_num")
		move_menu_seq = rs("move_menu_seq")
		move_user_id  = rs("move_user_id")
		move_date     = rs("move_date")
		restoreid     = rs("restoreid")
		restoredt     = rs("restoredt")
		creid         = rs("creid")
		credt         = rs("credt")
		modid         = rs("modid")
		moddt         = rs("moddt")

		arr_age = split(age, "~")
		If ubound(arr_age) = 1 Then
			age1 = arr_age(0)
			age2 = arr_age(1)
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
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 등록</h2>
				</div>
				<form name="form" method="post" onsubmit="return submitContents(this)">
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
	If cafe_mb_level = 10 Then
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
											<input type="radio" class="inp_radio" tabindex=3 id="age" name="age" value="" onclick="chkage(0)" required>
											<label for='age'><em>무관</em></label>
										</span>
										<span class=''>
											<input type="radio" class="inp_radio" tabindex=4 id="ageY" name="age" value="Y" onclick="chkage(1)" required>
											<label for='ageY'><em>연령제한</em></label>
										</span>
										<input type="text" class="inp" tabindex=5 name="age1" value="<%=age1%>" style="width:40px" <%=If3(age="","disabled","")%>>세 ~
										<input type="text" class="inp" tabindex=6 name="age2" value="<%=age2%>" style="width:40px" <%=If3(age="","disabled","")%>>세
										<script>
										function chkage(idx) {
											if (idx == 0)
											{
												document.form.age1.disabled = true;
												document.form.age2.disabled = true;
												document.form.age1.value = "";
												document.form.age2.value = "";
												document.form.age1.required = false;
												document.form.age2.required = false;
											}else {
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
											<input type="radio" tabindex=7 id="sex" name="sex" value="" class="inp_radio" required>
											<label for='sex'><em>무관</em></label>
										</span>
										<%=GetMakeCDRadio("sex", "", "")%>
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
										<input type="text" class="inp" tabindex=16 name="tel_no" value="<%=tel_no%>" />
									</td>
									<th scope="row">휴대전화번호<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=17 name="mbl_telno" value="<%=mbl_telno%>" required />
									</td>
								</tr>
								<tr>
									<th scope="row">팩스</th>
									<td>
										<input type="text" class="inp" tabindex=18 name="fax_no" value="<%=fax_no%>" />
									</td>
									<th class="end2">이메일</th>
									<td>
										<input type="text" class="inp" tabindex=19 name="email" value="<%=email%>" />
									</td>
								</tr>
								<tr>
									<th class="end2">홈페이지</th>
									<td>
										<input type="text" class="inp" tabindex=20 name="homepage" value="<%=homepage%>" />
									</td>
									<th class="end2">접수방법</th>
									<td>
										<%=GetMakeCDCheckBox("method", method, "", "21")%>
									</td>
								</tr>
								<tr>
									<th class="end2">마감일</th>
									<td colspan="3">
										<input type="text" tabindex=25 id="end_date" name="end_date" value="<%=end_date%>" class="inp w10" readonly />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
<%
	com_seq = ""
%>
<!--#include virtual="/include/attach_form_inc.asp"-->
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">모집요강</h4>
					<div class="tb">
						<textarea tabindex=27 name="contents" id="contents" style="width:100%;display:none;">
<%
		If contents = "" Then
%>
							<p>[급여조건] :</p>
							<p>[제출서류] :</p>
							<p>[업소위치] :</p>
							<p>[기타사항] :</p>
<%
		Else
%>
							<%=contents%>
<%
		End If
%>
						</textarea>
						<li class="orange">새로고침시 에디터 내용은 유지되지 않습니다.</li>
					</div>
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

	// 추가 글꼴 목록
	//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];

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
					f.action = "job_temp_exec.asp";
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
			elClickedObj.action = "job_write_exec.asp";
			elClickedObj.temp.value = "N";
			//elClickedObj.target = "hiddenfrm";
			elClickedObj.submit()
		} catch(e) {alert(e)}
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

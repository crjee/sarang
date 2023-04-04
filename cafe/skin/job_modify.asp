<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_mb_level = getUserLevel(cafe_id)
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")
	If toInt(write_auth) > toInt(cafe_mb_level) Then
		Response.Write "<script>alert('" & (write_auth) & "수정 권한이없습니다" & (cafe_mb_level) & "');history.back()</script>"
		Response.End
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
<!-- 달력 시작 -->
<link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
<link rel="stylesheet" href="/resources/demos/style.css">
<script src="https://code.jquery.com/jquery-1.12.4.js"></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
<script>
	$.datepicker.setDefaults({
		dateFormat: 'yy-mm-dd',
		prevText: '이전 달',
		nextText: '다음 달',
		monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
		dayNames: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
		dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
		showMonthAfterYear: true,
		yearSuffix: '년'
	});

	$( function() {
		$("#end_date").datepicker();
	} );
</script>
<!-- 달력 끝 -->
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<%
	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	rs.Open Sql, conn, 3, 1

	If rs.EOF Then
		msggo "정상적인 사용이 아닙니다.",""
	else
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		editor_yn = rs("editor_yn")
		write_auth = rs("write_auth")
		reply_auth = rs("reply_auth")
		read_auth = rs("read_auth")
	End If
	rs.close

	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	self_yn   = Request("self_yn")
	all_yn    = Request("all_yn")
	job_seq   = Request("job_seq")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_job "
	sql = sql & "  where job_seq = '" & job_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		If toInt(cafe_mb_level) < 6 And UCase(session("user_id")) <> UCase(rs("user_id")) then
			Response.Write "<script>alert('" & session("user_id") & "수정 권한이없습니다" & rs("user_id") & "');history.back();</script>"
			Response.End
		End If

		top_yn     = rs("top_yn")
		subject    = rs("subject")
		work       = rs("work")
		age        = rs("age")
		sex        = rs("sex")
		work_year  = rs("work_year")
		certify    = rs("certify")
		work_place = rs("work_place")
		agency     = rs("agency")
		person     = rs("person")
		tel_no     = rs("tel_no")
		fax_no     = rs("fax_no")
		email      = rs("email")
		homepage   = rs("homepage")
		method     = rs("method")
		end_date   = rs("end_date")
		contents  = rs("contents")

		arr_end_date   = split(end_date, "-")
		If ubound(arr_end_date) = 2 Then
			end_date1 = arr_end_date(0)
			end_date2 = arr_end_date(1)
			end_date3 = arr_end_date(2)
		End if

		arr_age   = split(age, "~")
		If ubound(arr_age) = 1 Then
			age1 = arr_age(0)
			age2 = arr_age(1)
		End if
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
										<input type="radio" class="checkbox" tabindex=3 name="age" value="" onclick="chkage(0)" <%=If3(age="","checked","")%>>무관 &nbsp;
										<input type="radio" class="checkbox" tabindex=4 name="age" value="Y" onclick="chkage(1)" <%=If3(age<>"","checked","")%>>연령제한 &nbsp;
										<input type="text" class="inp" tabindex=5 name="age1" value="<%=age1%>" style="width:40px" <%=If3(age="","disabled","")%>>세 ~
										<input type="text" class="inp" tabindex=6 name="age2" value="<%=age2%>" style="width:40px" <%=If3(age="","disabled","")%>>세
										<script>
										function chkage(idx){
											if (idx == 0)
											{
												document.form.age1.disabled = true;
												document.form.age2.disabled = true;
												document.form.age1.value = "";
												document.form.age2.value = "";
												document.form.age1.required = false;
												document.form.age2.required = false;
											}else{
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
										<input type="radio" class="checkbox" tabindex=7 name="sex" value="" <%=if3(sex="","checked","")%>>무관 &nbsp; &nbsp;
										<input type="radio" class="checkbox" tabindex=8 name="sex" value="M" <%=if3(sex="M","checked","")%>>남 &nbsp; &nbsp;
										<input type="radio" class="checkbox" tabindex=9 name="sex" value="W" <%=if3(sex="W","checked","")%>>여
									</td>
									<th scope="row">경력<em class="required">필수입력</em></th>
									<td>
										<select name="work_year" tabindex=10>
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
										<input type="radio" class="checkbox" tabindex=11 name="certify" value="Y" <%=if3(certify="Y","checked","")%>>필수 &nbsp; &nbsp;
										<input type="radio" class="checkbox" tabindex=12 name="certify" value="N" <%=if3(certify="N","checked","")%>>무관
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
									<th scope="row">연락처<em class="required">필수입력</em></th>
									<td>
										<input type="text" class="inp" tabindex=16 name="tel_no" value="<%=tel_no%>" required />
									</td>
									<th scope="row">팩스</th>
									<td>
										<input type="text" class="inp" tabindex=17 name="fax_no" value="<%=fax_no%>" />
									</td>
								</tr>
								<tr>
									<th class="end2">이메일</th>
									<td>
										<input type="text" class="inp" tabindex=18 name="email" value="<%=email%>" />
									</td>
									<th class="end2">홈페이지</th>
									<td>
										<input type="text" class="inp" tabindex=19 name="homepage" value="<%=homepage%>" />
									</td>
								</tr>
								<tr>
									<th class="end2">접수방법</th>
									<td>
										<input type="checkbox" class="checkbox" tabindex=20 value="이메일" name="method" <%=if3(instr(method,"이메일")>0,"checked","")%>>이메일
										<input type="checkbox" class="checkbox" tabindex=21 value="팩스" name="method" <%=if3(instr(method,"팩스")>0,"checked","")%>>팩스
										<input type="checkbox" class="checkbox" tabindex=22 value="우편" name="method" <%=if3(instr(method,"우편")>0,"checked","")%>>우편
										<input type="checkbox" class="checkbox" tabindex=23 value="방문" name="method" <%=if3(instr(method,"방문")>0,"checked","")%>>방문
									</td>
									<th class="end2">마감일</th>
									<td>
										<input type="text" tabindex=24 id="end_date" name="end_date" value="<%=end_date%>" class="inp" />
									</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">모집요강</h4>
					<div class="tb">
						<textarea tabindex=25 name="ir1" id="ir1" style="width:100%;display:none;">
						<%=contents%>
						</textarea>
						<li class="orange">새로고침시 에디터 내용은 유지되지 않습니다.</li>
					</div>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n" tabindex=26>등록</button>
					<button type="button" class="btn btn_c_n btn_n" tabindex=27 onclick="location.href='job_list.asp?menu_seq=<%=menu_seq%>'"><em>취소</em></button>
				</div>
				</form>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
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
					fOnBeforeUnload : function(){
						//alert("완료!")
					}
				}, //boolean
				fOnAppLoad : function(){
					//예제 코드
					//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
				},
				fCreator: "createSEditor2"
			})

			function submitContents(elClickedObj) {
				oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
				try {
					elClickedObj.action = "job_modify_exec.asp";
					elClickedObj.target = "hiddenfrm";
					elClickedObj.form.submit()

				} catch(e) {}
			}
			</script>
<script>

function fc_chk_byte(frm_nm, ari_max, cnt_view) { 
//	var frm = document.regForm;
	var ls_str = frm_nm.value; // 이벤트가 일어난 컨트롤의 value 값 
	var li_str_len = ls_str.length; // 전체길이 

	// 변수초기화 
	var li_max = ari_max; // 제한할 글자수 크기 
	var i = 0; // for문에 사용 
	var li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
	var li_len = 0; // substring하기 위해서 사용 
	var ls_one_char = ""; // 한글자씩 검사한다 
	var ls_str2 = ""; // 글자수를 초과하면 제한할수 글자전까지만 보여준다. 

	for(i=0; i< li_str_len; i++) { 
	// 한글자추출 
		ls_one_char = ls_str.charAt(i); 

		// 한글이면 2를 더한다. 
		if (escape(ls_one_char).length > 4) { 
			li_byte += 2; 
		} 
		// 그밗의 경우는 1을 더한다. 
		else { 
			li_byte++; 
		} 

		// 전체 크기가 li_max를 넘지않으면 
		if(li_byte <= li_max) { 
			li_len = i + 1; 
		} 
	} 

	// 전체길이를 초과하면 
	if(li_byte > li_max) { 
		alert( li_max + "byte 글자를 초과 입력할수 없습니다. \n 초과된 내용은 자동으로 삭제 됩니다. "); 
		ls_str2 = ls_str.substr(0, li_len);
		frm_nm.value = ls_str2; 

		li_str_len = ls_str2.length; // 전체길이 
		li_byte = 0; // 한글일경우는 2 그밗에는 1을 더함 
		for(i=0; i< li_str_len; i++) { 
		// 한글자추출 
			ls_one_char = ls_str2.charAt(i); 

			// 한글이면 2를 더한다. 
			if (escape(ls_one_char).length > 4) { 
				li_byte += 2; 
			} 
			// 그밗의 경우는 1을 더한다. 
			else { 
				li_byte++; 
			} 
		} 
	} 
	if (cnt_view != ""){
		var inner_form = eval("document.all."+ cnt_view) 
		inner_form.innerHTML = li_byte ;		//frm.txta_Memo.value.length;
	}
//	frm_nm.focus(); 

} 
</script>

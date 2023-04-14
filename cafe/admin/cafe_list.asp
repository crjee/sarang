<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	PageSize = Request("PageSize")
	If PageSize = "" Then PageSize = 20

	page = Request("page")
	If page = "" then page = 1

	cafe_type = Request("cafe_type")
	If cafe_type = "U" then
		kword = kword & " and cafe_type = '" & cafe_type & "' "
	ElseIf cafe_type = "C" Then
		kword = kword & " and cafe_type = '" & cafe_type & "' "
	Else
		cafe_type = ""
	End IF

	open_yn = Request("open_yn")
	If open_yn <> "" then
		kword = kword & " and open_yn = '" & open_yn & "' "
	End IF

	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	If sch_type <> "" And sch_word <> "" then
		If sch_type = "" Then
			kword = kword & " and (cf.cafe_name like '%" & sch_word & "%' or cf.cafe_id like '%" & sch_word & "%') "
		Else
			kword = kword & " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = kword & ""
	End IF

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & "select cf.cafe_name "
	sql = sql & "      ,cf.cafe_img  "
	sql = sql & "      ,cf.cafe_id   "
	sql = sql & "      ,cf.open_yn "
	sql = sql & "      ,cf.reg_type  "
	sql = sql & "      ,cf.cate_id   "
	sql = sql & "      ,cf.visit_cnt "
	sql = sql & "      ,cf.cafe_type "
	sql = sql & "      ,cf.union_id "
	sql = sql & "      ,cf.reg_level "
	sql = sql & "      ,cf.activity_yn      "
	sql = sql & "      ,cf.creid     "
	sql = sql & "      ,convert(varchar,cf.credt,120) credt "
	sql = sql & "      ,cf.modid     "
	sql = sql & "      ,cf.moddt     "
	sql = sql & "  from cf_cafe cf "
	sql = sql & " where 1=1 "
	sql = sql & kword
	sql = sql & " order by cafe_name "

	rs.open Sql, conn, 3, 1

	rs.PageSize = PageSize
	RecordCount = 0 ' 자료가 없을때
	If Not rs.EOF Then
		RecordCount = rs.recordcount
	End If

	' 전체 페이지 수 얻기
	If RecordCount/PageSize = Int(RecordCount/PageSize) then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
		rs.AbsolutePage = page
		PageNum = rs.PageCount
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>전체관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/admin/admin_left_inc.asp"-->
		</nav>
			<script>
				function testCheck() {
					var chckType = document.getElementsByName('cafe_id');
					var j = 0;
					for (i = 0; i < chckType.length; i++) {
						if (chckType[i].checked == true) {
							j++;
						}
					}

					if (j == 0) {
						alert("사랑방을 선택하세요!");
						return false;
					}
					return true;
				}

				function goUnion() {
					if (!testCheck()) return;
					var f = document.search_form;
					f.target = "hiddenfrm";
					f.action = "cafe_union_exec.asp";
					f.submit();
				}

				function goActivity() {
					if (!testCheck()) return;
					var f = document.search_form;
					f.target = "hiddenfrm";
					f.action = "cafe_activity_exec.asp"
					f.submit();
				}

				function setColor(i) {
					eval("tr_"+i+".style.background='#ffffcc'")
				}

				function goSearch() {
					var f = document.search_form;
					f.page.value = 1;
					f.submit();
				}

				function MovePage(page) {
					var f = document.search_form;
					f.page.value = page;
					f.submit();
				}
			</script>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">사랑방 관리</h2>
			</div>
			<div class="adm_cont">
				<div class="status_box clearBoth">
					<span class="floatL">총 사랑방 <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>개</span>
					<span class="floatR">
						<input type="checkbox" checked="checked" class="inp_check" /><label for="t1"><em class="hide">선택</em></label>
						선택된 사랑방을
						<button type="button" class="btn btn_c_s btn_s" onclick="goUnion()">연합회 변경</button>
						<button type="button" class="btn btn_c_s btn_s" onclick="goActivity()">사랑방차단 또는 해제</button>합니다.
					</span>
				</div>
				<div class="search_box clearBoth">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
					<div class="floatL">
						<select name="cafe_type" class="sel w_auto">
							<option value="">사랑방종류</option>
							<%=makeComboCD("cafe_type", cafe_type)%>
						</select>
						<select name="open_yn" class="sel w_auto">
							<option value="">공개여부</option>
							<%=makeComboCD("open_yn", open_yn)%>
						</select>
						<select name="sch_type" class="sel w_auto">
							<option value="">사랑방전체</option>
							<option value="cf.cafe_name" <%=if3(sch_type="cf.cafe_name","selected","")%>>사랑방명</option>
							<option value="cf.cafe_id" <%=if3(sch_type="cf.cafe_id","selected","")%>>경로</option>
						</select>
						<input class="inp w300p" type="text" name="sch_word" value="<%=sch_word%>" onkeyDown='javascript:{if (event.keyCode==13) goSearch();}'>
						<button class="btn btn_c_a btn_s" type="button" onclick="goSearch()">검색</button>
					</div>
					<div class="floatR">
						<span class="mr5">출력수</span>
						<select class="sel w100p" id="pagesize" name="pagesize" onchange="goSearch()">
							<option value=""></option>
							<option value="20" <%=if3(pagesize="20","selected","")%>>20</option>
							<option value="50" <%=if3(pagesize="50","selected","")%>>50</option>
							<option value="100" <%=if3(pagesize="100","selected","")%>>100</option>
						</select>
					</div>
				</form>
				</div>
				<div class="tb tb_form_1">
				<form name="form" method="post" target="hiddenfrm">
					<table class="">
						<colgroup>
							<col class="w5" />
							<col class="w20" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="" />
							<col class="w8" />
							<col class="w6" />
							<col class="w6" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">선택</th>
								<th scope="col">사랑방명</th>
								<th scope="col">사랑방아이디</th>
								<th scope="col">사랑방지기</th>
								<th scope="col">회원수</th>
								<th scope="col">연합회</th>
								<th scope="col">개설일</th>
								<th scope="col">상태</th>
								<th scope="col">외부미노출</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1

	If Not rs.EOF Then
		Do Until rs.EOF OR i > rs.PageSize

			cafe_name = rs("cafe_name")
			cafe_img  = rs("cafe_img")
			cafe_id   = rs("cafe_id")
			open_yn = rs("open_yn")
			reg_type  = rs("reg_type")
			cate_id   = rs("cate_id")
			visit_cnt = rs("visit_cnt")
			cafe_type = rs("cafe_type")
			reg_level = rs("reg_level")
			activity_yn = rs("activity_yn")
			creid     = rs("creid")
			credt     = rs("credt")
			modid     = rs("modid")
			moddt     = rs("moddt")

			member_cnt = getonevalue("count(*)", "cf_cafe_member", "where cafe_id = '" & cafe_id & "'")


%>
							<tr id="tr_<%=i%>">
								<td class="algC"><input type="checkbox" class="inp_check" id="chk_cafe<%=i%>" name="chk_cafe" value="<%=cafe_id%>" /><label for="chk_cafe<%=i%>"><em class="hide">선택</em></label></td>
								<td class="algC"><a href="/cafe/main.asp?cafe_id=<%=cafe_id%>"><%=cafe_name%></a></td>
								<td class="algC"><%=cafe_id%></td>
								<td class="algC">
<%
			sql = ""
			sql = sql & " select kname "
			sql = sql & "   from cf_cafe_member cm"
			sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id "
			sql = sql & "  where cm.cafe_id = '" & cafe_id & "' "
			sql = sql & "    and cm.cafe_mb_level = '10' "
			sql = sql & "  union "
			sql = sql & " select kname "
			sql = sql & "   from cf_union_manager um"
			sql = sql & "  inner join cf_member mi on mi.user_id = um.user_id "
			sql = sql & "  where um.union_id = '" & cafe_id & "' "
			sql = sql & "    and um.union_mb_level = '10' "
			rs2.open Sql, conn, 3, 1

			If Not rs2.eof then
				Do Until rs2.eof
%>
										&nbsp;<%=rs2("kname")%>
<%
					rs2.MoveNext
				Loop
			End If
			rs2.close
%>
								</td>
								<td class="algC"><%=member_cnt%></td>
								<td class="algC">
									<input type="hidden" name="old_union_id_<%=cafe_id%>" value="<%=rs("union_id")%>">
<%
			If cafe_type <> "U" Then
				sql = ""
				sql = sql & " select * "
				sql = sql & "   from cf_cafe "
				sql = sql & "  where cafe_type = 'U' "
				rs2.open Sql, conn, 3, 1
%>
									<select id="union_id_<%=cafe_id%>" name="union_id_<%=cafe_id%>" class="sel w_auto" onchange="setColor('<%=i%>')">
<%
				If rs2.eof then
%>
										<option value="">등록된 연합회가 없습니다</option>
<%
				Else
%>
										<option value="">연합회를 선택하세요</option>
<%
				End If

				Do Until rs2.eof
%>
										<option value="<%=rs2("cafe_id")%>" <%=if3(rs2("cafe_id")=rs("union_id"),"selected","") %>><%=rs2("cafe_name")%></option>
<%
					rs2.MoveNext
				Loop
				rs2.close
%>
									</select>
<%
			Else
%>
									<font color="blue">연합회</font>
									<input type="hidden" name="union_id" value="<%=rs("union_id")%>">
<%
			End If
%>
								</td>
								<td class="algC"><%=left(CStr(credt),10)%></td>
								<td class="algC">
<%
			If activity_yn = "Y" Then
				Response.Write "<font color='blue'>정상</font>"
			else
				Response.Write "<font color='red'>차단</font>"
			End if
%>
								</td>
								<td class="algC"><button type="button" class="btn btn_c_s btn_s">노출</button></td>
							</tr>
<%
			i = i + 1
			rs.MoveNext
		loop
	End If
	rs.close
	Set rs = nothing
	Set rs2 = nothing
%>
						</tbody>
					</table>
				</div>
				<div class="btn_box algR">
					<a href="#n" class="btn btn_c_a btn_n" onclick="lyp('lypp_adm_group')">사랑방개설</a>
					<a href="#n" class="btn btn_c_n btn_n">삭제</a>
				</div>
				</form>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<!-- 사랑방 개설 : s -->
	<script>
		function Checkfm(f) {
			if (f.cafe_check.value=='N') {
				alert('중복된 사랑방 아이디 입니다')
				return false
			}
			if (f.skin_id.value=='') {
				alert('스킨이 선택되지 않았습니다')
				return false
			}
		}

		function cafe_find(cafe_id) {
			hiddenfrm.location.href='cafe_find_exec.asp?cafe_id='+cafe_id
		}
	</script>
	<aside class="lypp lypp_adm_default lypp_adm_group">
		<header class="lypp_head">
			<h2 class="h2">사랑방 개설</h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>닫기</em></button></span>
		</header>
		<div class="adm_cont">
			<form id="crtInfo" name="crtInfo" method="post" action="cafe_write_exec.asp" target="hiddenfrm" onSubmit="return Checkfm(this)">
			<div class="tb tb_form_1">
				<table class="tb_input">
					<colgroup>
						<col class="w15" />
						<col class="w35" />
						<col class="w15" />
						<col class="w35" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">사랑방 아이디</th>
							<td colspan="3">
								<input type="hidden" value="N" name="cafe_check">
								<input type="text" id="cafe_id" name="cafe_id" class="inp" required onkeyup="cafe_find(this.value)">
								<span id="msg"></span>
							</td>
						</tr>
						<tr>
							<th scope="row">사랑방 이름</th>
							<td colspan="3">
								<input type="text" id="" name="" class="inp w50" />
								<span class="dp_inline ml10">한글, 영문, 숫자, 기호만 입력해 주세요.</span>
							</td>
						</tr>
						<tr>
							<th scope="row">사랑방 분류</th>
							<td>
								<%=makeRadioCD("cafe_type", "", "required")%>
							</td>
							<th scope="row">공개여부</th>
							<td>
								<%=makeRadioCD("open_yn", "", "required")%>
							</td>
						</tr>
						<tr>
							<th scope="row">가입 방식</th>
							<td colspan="3">
								<span class="">
									<input type="radio" class="inp_radio" id="reg_type0" name="reg_type" value="0" checked required />
									<label for="reg_type0"><em>바로가입</em></label>
								</span>
								<span class="ml10">
									<input type="radio" class="inp_radio" id="reg_type1" name="reg_type" value="1" required />
									<label for="reg_type1"><em>비공개</em></label>
								</span>
								<span class="ml20 va_middle">비공개 사랑방은 운영진의 초대 또는 가입조건 퀴즈를 풀어야 가입할 수 있습니다.</span>
							</td>
						</tr>
						<tr>
							<th scope="row">사랑방스킨</th>
							<td colspan="3">
								<select id="skin_id" name="skin_id" class="sel w100p" required>
									<option value="">스킨선택</option>
									<option value="skin_01">#스킨 1</option>
									<option value="skin_02">#스킨 2</option>
									<option value="skin_03">#스킨 3</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button type="submit" class="btn btn_n">확인</button>
				<button type="reset" class="btn btn_n">취소</button>
			</div>
			</form>
		</div>
	</aside>
	<!-- //사랑방 개설 : e -->
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	</body>
</html>

<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	list_info = Request("list_info")
	If list_info = "" Then
		list_info = "agency,kname,phone,mobile,fax"
	End If

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	If sch_word <> "" Then
		If sch_type = "all" Then
			kword = " and mi.agency like '%" & sch_word & "%' or mi.kname like '%" & sch_word & "%' or mi.phone like '%" & sch_word & "%' "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End If

	Set row = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cm.user_id "
	sql = sql & "       ,mi.user_id "
	sql = sql & "       ,mi.kname "
	sql = sql & "       ,mi.email "
	sql = sql & "       ,mi.agency "
	sql = sql & "       ,mi.mobile "
	sql = sql & "       ,mi.phone "
	sql = sql & "       ,mi.fax "
	sql = sql & "       ,mi.interphone "
	sql = sql & "       ,mi.license "
	sql = sql & "       ,mi.addr1 "
	sql = sql & "       ,mi.addr2 "
	sql = sql & "       ,mi.picture "
	sql = sql & "       ,cm.cafe_id "
	sql = sql & "       ,cm.cafe_mb_level "
	sql = sql & "       ,cm.stat "
	sql = sql & "       ,cm.stdate "
	sql = sql & "       ,case cm.cafe_mb_level when '1' Then '준회원' "
	sql = sql & "                              when '2' Then '정회원' "
	sql = sql & "                              when '3' Then '우수회원' "
	sql = sql & "                              when '4' Then '특별회원' "
	sql = sql & "                              when '5' Then '운영자' "
	sql = sql & "                              when '10' Then '사랑방지기' "
	sql = sql & "                              Else '미지정' end ulevel_txt"
	sql = sql & "       ,(select count(*) from cf_board where user_id = mi.user_id) post_cnt "
	sql = sql & "   from cf_cafe cf "
	sql = sql & "  inner join cf_cafe_member cm on cm.cafe_id = cf.cafe_id "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id "
'	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.cafe_id = cm.cafe_id and mi.stat = 'Y' "
	sql = sql & "  where (cf.cafe_id = '" & cafe_id & "' or cf.union_id = '" & cafe_id & "') "
	sql = sql & kword
	sql = sql & "  order by mi.agency "

	row.Open Sql, conn, 3, 1

	row.PageSize = PageSize
	RecordCount = 0 ' 자료가 없을때
	If Not row.EOF Then
		RecordCount = row.recordcount
	End If

	' 전체 페이지 수 얻기
	If RecordCount/PageSize = Int(RecordCount/PageSize) Then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	If Not (row.EOF And row.BOF) Then
		row.AbsolutePage = page
		PageNum = row.PageCount
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>회원/운영진 관리 : 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>사랑방 관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">회원/운영진 관리</h2>
			</div>
			<div class="adm_cont">
				<div class="status_box clearBoth">
					<span class="floatL">총 회원 <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>명</span>
					<span class="floatR">
					<form name="form2" method="post" target="hiddenfrm">
						<input type="checkbox" id="t1" name="" checked="checked" disabled="disabled" /><label for="t1"><em class="hide">선택</em></label>
						선택된 회원을
						<select id="mb_level" name="mb_level" class="sel w100p">
							<option value="1">준회원</option>
							<option value="2">정회원</option>
						</select>
						<button type="button" class="btn btn_c_s btn_s" onclick="goLevel()">등급설정 변경</button>
						<button type="button" class="btn btn_c_s btn_s" onclick="goActivity()">활동정지 또는 활동</button>
					</form>
					</span>
				</div>
				<div class="search_box clearBoth">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
					<div class="floatL">
						<span class="">
							<input type="checkbox" id="list_info" name="list_info" value="agency" <%=if3(InStr(list_info, "agency")>0,"checked","")%> />
							<label for=""><em>상호</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="kname" <%=if3(InStr(list_info, "kname")>0,"checked","")%> />
							<label for=""><em>대표자명</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="picture" <%=if3(InStr(list_info, "picture")>0,"checked","")%> />
							<label for=""><em>대표자사진</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="license" <%=if3(InStr(list_info, "license")>0,"checked","")%> />
							<label for=""><em>허가번호</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="phone" <%=if3(InStr(list_info, "phone")>0,"checked","")%> />
							<label for=""><em>전화번호</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="mobile" <%=if3(InStr(list_info, "mobile")>0,"checked","")%> />
							<label for=""><em>핸드폰번호</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="fax" <%=if3(InStr(list_info, "fax")>0,"checked","")%> />
							<label for=""><em>팩스</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="interphone" <%=if3(InStr(list_info, "interphone")>0,"checked","")%> />
							<label for=""><em>내선번호</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="addr" <%=if3(InStr(list_info, "addr")>0,"checked","")%> />
							<label for=""><em>주소</em></label>
						</span>
					</div>
					<div class="floatR">
						<select id="sch_type" name="sch_type" class="sel w100p">
							<option value="all">전체</option>
							<option value="agency" <%=if3(sch_type="agency","selected","")%>>업소명</option>
							<option value="kname" <%=if3(sch_type="kname","selected","")%>>회원명</option>
							<option value="phone" <%=if3(sch_type="phone","selected","")%>>전화번호</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w300p" />
						<button class="btn btn_c_a btn_s" type="button" onclick="goSearch()">검색</button>
						<span class="ml20 mr5">출력수</span>
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
					<input type="hidden" id="cafe_mb_level" name="cafe_mb_level">
					<table>
						<colgroup>
							<col class="" />
<%If InStr(list_info, "agency") Then%>                                <col class="" /><%End If%>
<%If InStr(list_info, "kname") Or InStr(list_info, "picture") Then%>  <col class="" /><%End If%>
<%If InStr(list_info, "license") Then%>                               <col class="" /><%End If%>
<%If InStr(list_info, "phone") Then%>                                 <col class="" /><%End If%>
<%If InStr(list_info, "mobile") Then%>                                <col class="" /><%End If%>
<%If InStr(list_info, "fax") Then%>                                   <col class="" /><%End If%>
<%If InStr(list_info, "interp") Then%>                                <col class="" /><%End If%>
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"></th>
<%If InStr(list_info, "agency") Then%>                                <th scope="col">상호</th><%End If%>
<%If InStr(list_info, "kname") Or InStr(list_info, "picture") Then%>  <th scope="col">대표자</th><%End If%>
<%If InStr(list_info, "license") Then%>                               <th scope="col">허가번호</th><%End If%>
<%If InStr(list_info, "phone") Then%>                                 <th scope="col">전화번호</th><%End If%>
<%If InStr(list_info, "mobile") Then%>                                <th scope="col">핸드폰번호</th><%End If%>
<%If InStr(list_info, "fax") Then%>                                   <th scope="col">팩스</th><%End If%>
<%If InStr(list_info, "interp") Then%>                                <th scope="col">내선</th><%End If%>
								<th scope="col">회원등급</th>
								<th scope="col">가입일</th>
								<th scope="col">상태</th>
								<th scope="col">게시글</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1
	uploadUrl = ConfigAttachedFileURL & "picture/"
	If Not row.EOF Then
		Do Until row.EOF OR i > row.PageSize
			Set ml = Conn.Execute("select * from cf_cafe_member cm,cf_member mi where cm.cafe_id='" & cafe_id & "' and cm.user_id='" & row("user_id") & "' and cm.user_id=mi.user_id")

			user_id    = row("user_id")
			kname      = row("kname")
			email      = row("email")
			agency     = row("agency")
			mobile     = row("mobile")
			phone      = row("phone")
			fax        = row("fax")
			interphone = row("interphone")
			license    = row("license")
			picture    = row("picture")
			addr1      = row("addr1")
			addr2      = row("addr2")
			email      = row("email")
			stat       = row("stat")
			stdate     = row("stdate")
			cafe_id    = row("cafe_id")
			cafe_mb_level = row("cafe_mb_level")
			ulevel_txt = row("ulevel_txt")
			post_cnt   = row("post_cnt")

			cols = 4
%>
								<td class="algC" sch_typepan="<%=sch_type%>">
<%
			If ulevel_txt = "사랑방지기" Then
%>
								<input type="checkbox" disabled="disabled">
<%
			Else
%>
								<input type="checkbox" id="user_id" name="user_id" value="<%=user_id%>">
								<input type="hidden" id="stat" name="stat" value="<%=stat%>">
<%
			End If
%>
								</td>
<%
			If InStr(list_info, "agency") Then
				cols = cols + 1
%>
								<td class="algC"><%=agency%>
<%
				If picture <> "" Then
%>
									<img src="<%=uploadUrl & picture%>" id="profile" name="profile" onLoad="Rsize(this, 20, 20, 1)" style="cursor:hand;border:1px solid #e5e5e5;" title="중개업소사진">
<%
				End If
%>
								</td>
<%
			End If

			If InStr(list_info, "kname") Then
				cols = cols + 1
%>
								<td class="algC"><%=kname%></td>
<%
			End If

			If InStr(list_info, "license") Then
				cols = cols + 1
%>
								<td class="algC"><%=license%></td>
<%
			End If

			If InStr(list_info, "phone") Then
				cols = cols + 1
%>
								<td class="algC"><%=phone%></td>
<%
			End If

			If InStr(list_info, "mobile") Then
				cols = cols + 1
%>
								<td class="algC"><%=mobile%></td>
<%
			End If

			If InStr(list_info, "fax") Then
				cols = cols + 1
%>
								<td class="algC"><%=fax%></td>
<%
			End If

			If InStr(list_info, "interp") Then
				cols = cols + 1
%>
								<td class="algC"><%=interphone%></td>
<%
			End If
%>
								<td class="algC"><%=ulevel_txt%></td>
								<td class="algC"><%=left(stdate,10)%></td>
								<td class="algC">
<%
			If stat = "N" Then
%>
									<font color='red'>활동정지</font>
<%
			Else
%>
									<font color='blue'>활동</font>
<%
			End If
%>
								</td>
								<td class="algC"><%=post_cnt%></td>
							</tr>
<%
			If InStr(list_info, "addr") Then
%>
							</tr><td class="algC" colspan="<%=cols%>"><%=addr1%> <%=addr2%></td><tr>
<%
			End If
%>
<%
			i = i + 1
			row.MoveNext
		Loop
	End If
	row.close
	Set row = Nothing
%>
						</tbody>
					</table>
				</form>
				</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
</html>

	<script>
		function testCheck() {
			var chckType = document.getElementsByName('user_id');
			var j = 0;
			for (i = 0; i < chckType.length; i++) {
				if (chckType[i].checked == true) {
					j++;
				}
			}

			if (j == 0) {
				alert("회원을 선택하세요!");
				return false;
			}
			return true;
		}
		function goLevel() {
			if (!testCheck()) return;
			var f = document.form;
			var f2 = document.form2;
			f.cafe_mb_level.value = f2.cafe_mb_level.value
			f.action="member_level_exec.asp"
			f.submit()
		}
		function goActivity() {
			if (!testCheck()) return;
			var f = document.form;
			f.action="member_activity_exec.asp"
			f.submit()
		}

		function MovePage(page) {
			document.search_form.page.value = page;
			document.search_form.submit();
		}

		function goSearch() {
			try {
				var f = document.search_form;
				f.page.value = 1;
				f.submit();
			}
			catch (e) {
				alert(e);
			}
		}

		function Rsize(img, ww, hh, aL) {
			var tt = imgRsize(img, ww, hh);
			if (img.width > ww || img.height > hh) {

				// 가로나 세로크기가 제한크기보다 크면
				img.width = tt[0];
				// 크기조정
				img.height = tt[1];
				img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

				if (aL) {
					// 자동링크 on
					img.onclick = function() {
						wT = Math.ceil((screen.width - tt[2])/2.6);
						// 클라이언트 중앙에 이미지위치.
						wL = Math.ceil((screen.height - tt[3])/2.6);
						var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
						var doc = mm.document;
						try{
							doc.body.style.margin = 0;
							// 마진제거
							doc.body.style.cursor = "hand";
							doc.title = "원본이미지";
						}
						catch(err) {
						}
						finally {
						}

					}
					img.style.cursor = "hand";
				}
			}
			else {
					img.onclick = function() {
						alert("현재이미지가 원본 이미지입니다.");
					}
			}
		}

		function imgRsize(img, rW, rH) {
			var iW = img.width;
			var iH = img.height;
			var g = new Array;
			if (iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
				g[0] = iW;
				g[1] = iH;
			}
			else {
				if (img.width > img.height) { // 원크기 가로가 세로보다 크면
					g[0] = rW;
					g[1] = Math.ceil(img.height * rW / img.width);
				}
				else if (img.width < img.height) { //원크기의 세로가 가로보다 크면
					g[0] = Math.ceil(img.width * rH / img.height);
					g[1] = rH;
				}
				else {
					g[0] = rW;
					g[1] = rH;
				}
				if (g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
					g[0] = rW;
					g[1] = Math.ceil(img.height * rW / img.width);
				}
				if (g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
					g[0] = Math.ceil(img.width * rH / img.height);
					g[1] = rH;
				}
			}

			g[2] = img.width; // 원사이즈 가로
			g[3] = img.height; // 원사이즈 세로

			return g;
		}
	</script>

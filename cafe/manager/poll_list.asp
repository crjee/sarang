<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" then page = 1

	Set row = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_poll a "
	sql = sql & "       ,cf_poll_ans b "
	sql = sql & "  where a.poll_seq = b.poll_seq "
	sql = sql & "    and a.cafe_id = '" & cafe_id & "' "
	sql = sql & "  order by a.credt desc "

	row.Open Sql, conn, 3, 1

	row.PageSize = PageSize
	RecordCount = 0 ' 자료가 없을때
	If Not row.EOF Then
		RecordCount = row.recordcount
	End If

	' 전체 페이지 수 얻기
	If RecordCount/PageSize = Int(RecordCount/PageSize) then
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
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>설문관리 > 관리자</title>
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
				<h2 class="h2">설문 관리</h2>
			</div>
			<div class="adm_cont">
				<div class="status_box clearBoth">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
					<span class="floatL">총 설문 <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>개</span>
					<span class="floatR">
						<span class="ml20 mr5">출력수</span>
						<select class="sel w100p" id="pagesize" name="pagesize" onchange="goSearch()">
							<option value=""></option>
							<option value="10" <%=if3(pagesize="10","selected","")%>>10</option>
							<option value="20" <%=if3(pagesize="20","selected","")%>>20</option>
							<option value="50" <%=if3(pagesize="50","selected","")%>>50</option>
							<option value="100" <%=if3(pagesize="100","selected","")%>>100</option>
						</select>
					</span>
				</div>
				<div class="adm_menu_manage">
					<div class="tb tb_form_1">
						<table class="tb_fixed">
							<colgroup>
								<col class="w_remainder" />
								<col class="w_remainder" />
								<col class="w10" />
								<col class="w15" />
								<col class="w5" />
								<col class="w5" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">제목</th>
									<th scope="col">결과</th>
									<th scope="col">참여인원</th>
									<th scope="col">기간</th>
									<th scope="col">인증</th>
									<th scope="col">마감</th>
									<th scope="col">설정</th>
								</tr>
							</thead>
							<tbody>
<%
	i = 1
	If Not row.EOF Then
		Do Until row.EOF OR i > row.PageSize
%>
								<tr>
									<td class="algL"><%=row("subject")%></td>
									<td class="algL">
										<ul class="list_option">
<%
			total = 0
			For j = 1 To 10
				If row("ques" & j) <> "" then
					total = total + row("ans" & j)
				End If
			Next

			For j = 1 To 10
				If row("ques" & j) <> "" then
					If row("ans" & j) <> 0 Then
						ans = row("ans" & j) / total * 100
%>
											<li class="pl10">[ <%=FormatNumber(ans,0)%>% ]&nbsp;&nbsp;<%=row("ques" & j)%></li>
<%
					Else
%>
											<li class="pl10">[ 0% ]&nbsp;&nbsp;<%=row("ques" & j)%></li>
<%
					End If
				End If
			Next
%>
										</ul>
									</td>
									<td class="algC"><%=total%> 명</td>
									<td class="algC"><%=row("sdate") & " ~ " & row("edate")%></td>
									<td class="algC"><%=if3(row("rprsv_cert_use_yn")="Y","Y","")%></td>
									<td class="algC"><%=if3(row("ddln_yn")="Y","Y","")%></td>
									<td class="algC">
										<button type="button" class="btn btn_c_a btn_s btn_modi" onclick="onEdit('<%=row("poll_seq")%>')">수정</button>
										<button type="button" class="btn btn_c_a btn_s" onclick="hiddenfrm.location.href='poll_exec.asp?task=ddln&poll_seq=<%=row("poll_seq")%>'">마감</button>
										<button type="button" class="btn btn_c_a btn_s" onclick="hiddenfrm.location.href='poll_exec.asp?task=del&poll_seq=<%=row("poll_seq")%>'">삭제</button>
									</td>
								</tr>
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
					</div>
					<div class="btn_box algR">
						<a href="#n" class="btn btn_c_a btn_n" onclick="onRegi()">설문등록</a>
					</div>
				</form>
				</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<aside class="lypp lypp_adm_default lypp_adm_vote">
		<header class="lypp_head">
			<h2 class="h2">설문조사 <span id="regTitle"></span></h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>닫기</em></button></span>
		</header>
		<div class="adm_cont">
			<form id="regi_form" name="regi_form" method="post" action="poll_exec.asp" target="hiddenfrm">
			<input type="hidden" id="task" name="task">
			<input type="hidden" id="poll_seq" name="poll_seq">
			<div class="tb tb_form_1">
				<table class="tb_input">
					<colgroup>
						<col class="w100p" />
						<col class="w_auto" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">대표자인증</th>
							<td>
								<input type="radio" id="rprsv_cert_use_y" name="rprsv_cert_use_yn" value="Y" required />
								<label for="rprsv_cert_use_y"><em>사용</em></label>

								<input type="radio" id="rprsv_cert_use_n" name="rprsv_cert_use_yn" value="N" required />
								<label for="rprsv_cert_use_n"><em>미사용</em></label>
							</td>
						</tr>
						<tr>
							<th scope="row">마감</th>
							<td>
								<input type="radio" id="ddln_yn_y" name="ddln_yn" value="Y" required />
								<label for="ddln_yn_y"><em>마감</em></label>

								<input type="radio" id="ddln_yn_n" name="ddln_yn" value="N" required />
								<label for="ddln_yn_n"><em>사용</em></label>
							</td>
						</tr>
						<tr>
							<th scope="row">제목</th>
							<td>
								<input type="text" id="subject" name="subject" required class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">설문기간</th>
							<td>
								<select id="sy" name="sy" required class="sel w_auto">
									<option value="">년도</option>
<%
	For i = 2016 To year(date) + 1
%>
									<option value="<%=i%>" <%=If3(Trim(Left(sdate,4))=cstr(i),"selected","") %>><%=i%></option>
<%
	Next
%>
								</select>
								<select id="sm" name="sm" required class="sel w_auto">
									<option value="">월</option>
<%
	For i = 1 To 12
		If Len(i)=1 Then i = "0" & i
%>
									<option value="<%=i%>" <%=If3(Trim(Mid(sdate,6,2))=Trim(i),"selected""") %>><%=i%></option>
<%
	Next
%>
								</select>
								<select id="sd" name="sd" required class="sel w_auto">
									<option value="">일</option>
<%
	For i = 1 To 31
		If Len(i)=1 Then i = "0" & i
%>
									<option value="<%=i%>" <%=if3(Trim(Mid(sdate,9,2))=trim(i),"selected","") %>><%=i%></option>
<%
	Next
%>
								</select>
								~
								<select id="ey" name="ey" required class="sel w_auto">
									<option value="">년도</option>
<%
	For i = 2016 To year(date) + 1
%>
									<option value="<%=i%>" <%=if3(Trim(Left(edate,4))=cstr(i),"selected","") %>><%=i%></option>
<%
	Next
%>
								</select>
								<select id="em" name="em" required class="sel w_auto">
									<option value="">월</option>
<%
	For i = 1 To 12
		If Len(i)=1 Then i = "0" & i
%>
									<option value="<%=i%>" <%=if3(Trim(Mid(edate,6,2))=Trim(i),"selected","") %>><%=i%></option>
<%
	Next
%>
								</select>
								<select id="ed" name="ed" required class="sel w_auto">
									<option value="">일</option>
<%
	For i = 1 To 31
		If Len(i)=1 Then i = "0" & i
%>
									<option value="<%=i%>" <%=if3(Trim(Mid(edate,9,2))=trim(i),"selected","") %>><%=i%></option>
<%
	Next
%>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">문항</th>
							<td>
								<select id="count" name="count" required class="sel w_auto" onchange="ques_cnt(this.value)">
									<option value="">갯수선택</option>
<%
	For i = 1 To 10
%>
									<option value="<%=i%>" <%=If3(i=Cint(count),"selected","")%>><%=i%>개</option>
<%
	Next
%>
		</select>
								</select>
							</td>
						</tr>
<%
	For i = 1 To 10
	j = i
	If Len(j)=1 then j = "0" & i
%>
						<tr id="quess<%=i%>" style="display:none">
							<th scope="row">질문 <%=j%></th>
							<td>
								<input type="text" id="ques<%=j%>" name="ques<%=j%>" class="inp" />
							</td>
						</tr>
<%
	Next
%>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button id="submitBtn" type="submit" class="btn btn_n">확인</button>
				<button id="resetBtn" type="reset" class="btn btn_n">취소</button>
			</div>
			</form>
		</div>
	</aside>
</body>
</html>
	<script>

	function ques_cnt(v) {
		for (var i=1;i<=v;i++) {
			obj = "quess"+i;
			eval(obj+".style").display='block';
		}

		for (j=i;j<=10;j++) {
			obj = "quess"+j;
			eval(obj+".style").display='none';
		}
	}
	</script>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:"></iframe>

	<script>

	function onRegi() {
		$("#regi_form")[0].reset();
		$("#task").val("ins");
		document.getElementById("regTitle").innerText = "등록";
		lyp('lypp_adm_vote');
	}

	function onEdit(poll_seq) {
		$("#regi_form")[0].reset();
		$("#task").val("upd")
		document.getElementById("regTitle").innerText = "수정";
		lyp('lypp_adm_vote');

		try {
			var strHtml = [];

			$.ajax({
				type: "POST",
				dataType: "json",
				url: "/cafe/manager/poll_view_ajax.asp",
				data: {"poll_seq":poll_seq},
				success: function(xmlData) {
					if (xmlData.TotalCnt > 0) {
						for (i=0; i<xmlData.TotalCnt; i++) {
							//alert(xmlData.ResultList[i].poll_seq);
							$("#poll_seq").val(xmlData.ResultList[i].poll_seq);
							$("#subject").val(xmlData.ResultList[i].subject);
							$("#ques01").val(xmlData.ResultList[i].ques01);
							$("#ques02").val(xmlData.ResultList[i].ques02);
							$("#ques03").val(xmlData.ResultList[i].ques03);
							$("#ques04").val(xmlData.ResultList[i].ques04);
							$("#ques05").val(xmlData.ResultList[i].ques05);
							$("#ques06").val(xmlData.ResultList[i].ques06);
							$("#ques07").val(xmlData.ResultList[i].ques07);
							$("#ques08").val(xmlData.ResultList[i].ques08);
							$("#ques09").val(xmlData.ResultList[i].ques09);
							$("#ques10").val(xmlData.ResultList[i].ques10);
							$("#count").val(xmlData.ResultList[i].count);
							$("#sy").val(xmlData.ResultList[i].sy);
							$("#sm").val(xmlData.ResultList[i].sm);
							$("#sd").val(xmlData.ResultList[i].sd);
							$("#ey").val(xmlData.ResultList[i].ey);
							$("#em").val(xmlData.ResultList[i].em);
							$("#ed").val(xmlData.ResultList[i].ed);
							if (xmlData.ResultList[i].rprsv_cert_use_yn == "Y")
							$("#rprsv_cert_use_y").prop('checked',true);
							if (xmlData.ResultList[i].rprsv_cert_use_yn == "N")
							$("#rprsv_cert_use_n").prop('checked',true);
							if (xmlData.ResultList[i].ddln_yn == "Y")
							$("#ddln_yn_y").prop('checked',true);
							if (xmlData.ResultList[i].ddln_yn == "N")
							$("#ddln_yn_n").prop('checked',true);
							ques_cnt(xmlData.ResultList[i].count);
						}
					}
					else {
						alert("해당 설문이 없습니다");
					}
				},
				complete : function() {
				},
				error : function(xmlData) {
					alert("ERROR");
				}
			});
		}
		catch (e) {
			alert(e);
		}
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
	</script>

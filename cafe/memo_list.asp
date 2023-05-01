<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckReadAuth(cafe_id)
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
			<form name="open_form" method="post">
			<input type="hidden" name="open_url">
			<input type="hidden" name="open_name" value="memo">
			<input type="hidden" name="open_specs" value="width=900px, height=600px, left=150, top=150, scrollbars=yes">
			</form>
<%
	memo_receive_yn = Request("memo_receive_yn")

	If memo_receive_yn = "" Then
		memo_receive_yn = GetOneValue("memo_receive_yn", "cf_member", "where user_id = '" & Session("user_id") & "' ")
	Else
		sql = ""
		sql = sql & " update cf_member "
		sql = sql & "    set memo_receive_yn = '" & memo_receive_yn & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & " where user_id = '" & Session("user_id") & "' "
		Conn.Execute(sql)
	End If

	stype = Request("stype")
	If stype = "" Then stype = "i"

	Set rs = Server.CreateObject("ADODB.Recordset")

	If stype = "i" Then
		b1 = "btn btn-primary"
		b2 = "btn btn-default"

		read_cnt = GetOneValue("count(to_user)", "cf_memo", "where to_user = '" & Session("user_id") & "' and to_stat <> 'Y' and stat <> 1 ")

		sql = ""
		sql = sql & " select mm.* "
		sql = sql & "       ,frmi.agency fragency "
		sql = sql & "       ,tomi.agency toagency "
		sql = sql & "   from cf_memo mm "
		sql = sql & "  inner join cf_member frmi on frmi.user_id = mm.fr_user "
		sql = sql & "  inner join cf_member tomi on tomi.user_id = mm.to_user "
		sql = sql & "  where mm.to_stat <> 'Y' "
		sql = sql & "  order by mm.memo_seq desc "
	Else
		b1 = "btn btn-default"
		b2 = "btn btn-primary"

		read_cnt = GetOneValue("count(fr_user)", "cf_memo", "where fr_user = '" & Session("user_id") & "' and fr_stat <> 'Y' and stat <> 1 ")

		sql = ""
		sql = sql & " select mm.* "
		sql = sql & "       ,frmi.agency fragency "
		sql = sql & "       ,tomi.agency toagency "
		sql = sql & "   from cf_memo mm "
		sql = sql & "  inner join cf_member frmi on frmi.user_id = mm.fr_user "
		sql = sql & "  inner join cf_member tomi on tomi.user_id = mm.to_user "
		sql = sql & "  where mm.fr_user = '" & Session("user_id") & "' "
		sql = sql & "    and mm.fr_stat <> 'Y' "
		sql = sql & "  order by mm.memo_seq desc "
	End If

	rs.open sql, Conn, 3
	memo_cnt = rs.recordcount
%>
				<div class="cont_tit">
					<h2 class="h2">쪽지함&nbsp;<%=if3(stype="i","받은쪽지","보낸쪽지")%>&nbsp;총 <%=read_cnt%> / <%=memo_cnt%></h2>
				</div>
				<div class="">
					<div class="search_box algR">
						<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
						<input type="hidden" name="page" value="<%=page%>">
						<button type="button" class="btn btn_c_a btn_s" onclick="onAll()">전체선택</button>
						<button type="button" class="btn btn_c_a btn_s" onclick="onDel()">선택삭제</button>
						<button type="button" class="btn btn_c_a btn_s" onclick="goReceive('<%=session("ctTarget")%>')"><%=if3(memo_receive_yn="N","수신허용","수신거부")%></button><!-- js goReceive --><!-- /cafe/memo_list.asp?menu_seq=<%=menu_seq%>&stype=<%=stype%>&memo_receive_yn=<%=if3(memo_receive_yn="N","Y","N")%> -->
						<button type="button" class="btn btn_c_a btn_s" onclick="goWrite('<%=session("ctTarget")%>')">쪽지보내기</button><!-- js goWrite --><!-- /cafe/memo_write.asp?menu_seq=<%=menu_seq%> -->
					</div>
					<div class="tb">
						<form name="list_form" method="post">
						<input type="hidden" name="stype" value="<%=stype%>">
						<table class="tb_fixed">
							<colgroup>
								<col class="w5" />
								<col class="w10" />
								<col class="w10" />
								<col class="w_auto" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th></th>
									<th scope="col">보낸이</th>
									<th scope="col">받는이</th>
									<th scope="col">제목</th> 
									<th scope="col">등록일</th>
								</tr>
							</thead>
							<tbody>
<%
	i = 1
	Do Until rs.eof
		credt = rs("credt")
%>
								<tr>
									<td class="algC"><input type="checkbox" value="<%=rs("memo_seq")%>" name="memo_seq" class="inp_check"></td>
									<td class="algC"><%=rs("fragency")%></td>
									<td class="algC"><%=rs("toagency")%></td>
									<!-- <td><a href="#" onclick="goView('<%=rs("memo_seq")%>')"><%=rs("subject")%></a></td> -->
									<td><a href="#" onclick="lyp('lypp_memo')"><%=rs("subject")%></a></td>
									<td class="algC"><%=credt%></td>
								</tr>
<%
		rs.MoveNext
	Loop
	rs.close
	Set rs = Nothing
%>
							</tbody>
						</table>
						</form>
					</div>
				</div>
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

	<!-- 레이어 팝업 -->
	<div class="lypp lypp_sarang lypp_memo">
		<header class="lypp_head">
			<h2 class="h2">쪽지 내용보기</h2>
			<span class="posR">
				<button type="button" class="btn btn_close"><em>닫기</em></button>
			</span>
		</header>
		<div class="adm_cont">
			<form method="post" action="banner_exec.asp" enctype="multipart/form-data" target="hiddenfrm">
				<input type="hidden" name="tb_prefix" value="cf">
				<input type="hidden" name="task" value="upd">
				<input type="hidden" name="banner_seq" value="">
				<div class="tb tb_form_1">
					<table class="tb_input">
						<colgroup>
							<col class="w15">
							<col class="w30">
							<col class="w15">
							<col class="w30">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">제목</th>
								<td colspan="3">

								</td>
							</tr>
							<tr>
								<th scope="row">보낸이</th>
								<td>

								</td>
								<th scope="row">받는이</th>
								<td>

								</td>
							</tr>
							<tr>
								<th scope="row">보낸시간</th>
								<td>

								</td>
							</tr>
							<tr>
								<td colspan="4">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box algC">
					<button type="submit" class="btn btn_c_a btn_n">이동</button>
					<button type="reset" class="btn btn_c_n btn_n">취소</button>
				</div>
			</form>
		</div>
	</div>
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	function onDel() {
		if (!testCheck()) return;
		var f = document.list_form;
		f.action = "memo_del_exec.asp";
		//f.target = "hiddenfrm";
		f.submit()
	}

	function onAll() {
		var chckType = document.getElementsByName('memo_seq');
		for (i = 0; i < chckType.length; i++) {
			chckType[i].checked = true;
		}
	}

	function testCheck() {
		var chckType = document.getElementsByName('memo_seq');
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

	function goReceive(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/memo_list.asp";
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/memo_write.asp";
		f.submit();
	}

	function goView(memo_seq) {
		document.open_form.open_url.value = "/cafe/memo_view_p.asp?memo_seq="+memo_seq;
		document.open_form.action = "/win_open_exec.asp"
		document.open_form.target = "hiddenfrm";
		document.open_form.submit();
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

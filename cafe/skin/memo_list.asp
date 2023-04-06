<!--#include virtual="/include/config_inc.asp"-->
<%
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
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<script src="http://code.jquery.com/jquery-latest.min.js"></script>
			<script>
				function goDel() {
					if (!testCheck()) return;
					var f = document.list_form;
					f.action = "memo_del_exec.asp";
					f.submit()
				}

				function goAll() {
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

				function goView(memo_seq) {
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.open_url.value = "/cafe/skin/memo_view_p.asp?memo_seq="+memo_seq;
					document.open_form.submit();
				}
			</script>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url">
			<input type="hidden" name="open_name" value="memo">
			<input type="hidden" name="open_specs" value="width=900px, height=600px, left=150, top=150, scrollbars=yes">
			</form>
<%
	memo_receive_yn = Request("memo_receive_yn")

	If memo_receive_yn = "" Then
		memo_receive_yn = getonevalue("memo_receive_yn", "cf_member", "where user_id = '" & user_id & "' ")
	Else
		sql = ""
		sql = sql & " update cf_member "
		sql = sql & "    set memo_receive_yn = '" & memo_receive_yn & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & " where user_id = '" & user_id & "' "
		Conn.Execute(sql)
	End if

	stype = Request("stype")
	If stype = "" Then stype = "i"

	Set rs = Server.CreateObject("ADODB.Recordset")

	If stype = "i" Then
		b1 = "btn btn-primary"
		b2 = "btn btn-default"

		read_cnt = getonevalue("count(to_user)", "cf_memo", "where to_user = '" & user_id & "' and to_stat <> 'Y' and stat <> 1 ")

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

		read_cnt = getonevalue("count(fr_user)", "cf_memo", "where fr_user = '" & user_id & "' and fr_stat <> 'Y' and stat <> 1 ")

		sql = ""
		sql = sql & " select mm.* "
		sql = sql & "       ,frmi.agency fragency "
		sql = sql & "       ,tomi.agency toagency "
		sql = sql & "   from cf_memo mm "
		sql = sql & "  inner join cf_member frmi on frmi.user_id = mm.fr_user "
		sql = sql & "  inner join cf_member tomi on tomi.user_id = mm.to_user "
		sql = sql & "  where mm.fr_user = '" & user_id & "' "
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
						<button class="btn btn_c_a btn_s" type="button" onclick="goAll()">전체선택</button>
						<button class="btn btn_c_a btn_s" type="button" onclick="goDel()">선택삭제</button>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/memo_list.asp?menu_seq=<%=menu_seq%>&stype=<%=stype%>&memo_receive_yn=<%=if3(memo_receive_yn="N","Y","N")%>'"><%=if3(memo_receive_yn="N","수신허용","수신거부")%></button>
						<button class="btn btn_c_a btn_s" type="button" onclick="location.href='/cafe/skin/memo_write.asp?menu_seq=<%=menu_seq%>'">쪽지보내기</button>
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
									<td class="algC"><input type="checkbox" value="<%=rs("memo_seq")%>" name="memo_seq" class="row-select"></td>
									<td class="algC"><%=rs("fragency")%></td>
									<td class="algC"><%=rs("toagency")%></td>
									<td><a href="#" onclick="goView('<%=rs("memo_seq")%>')"><%=rs("subject")%></a></td>
									<td class="algC"><%=credt%></td>
								</tr>
<%
		rs.MoveNext
	Loop
	rs.close
	Set rs = nothing
%>
							</tbody>
						</table>
						</form>
					</div>
				</div>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


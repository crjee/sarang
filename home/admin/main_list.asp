<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()
	cafe_id = "home"

	sel_menu_seq = Request("menu_seq")
	sel_home_num = Request("home_num")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>회원 관리 > 관리자</title>
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
<!--#include virtual="/home/admin/admin_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">메인 관리</h2>
			</div>
			<div class="adm_guide_message">
				<ul>
					<li>홈 메인 화면에 나타나는 콘텐츠를 설정하는 페이지입니다.</li>
					<li>메뉴 선택에서 메인 화면에 나타날 항목을 메인 메뉴에 끌어 놓고 적용 버튼을 클릭하세요.</li>
					<li>메인 메뉴에서 메인 화면에 나타날 순서대로 끌어 놓고 적용 버튼을 클릭하세요.</li>
					<li>해당 콘텐츠의 형태 및 크기에 대해 설정한 후 저장 버튼을 클릭하세요.</li>
				</ul>
			</div>
			<div class="adm_menu_flex_manage">
				<div class="adm_menu_item">
					<div class="adm_menu_item_tit">메뉴 선택</div>
					<div class="adm_select_box">
						<div class="adm_select_tree_nav">
							<ul class="menu_handle" id="menu_handle1">
<%
	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu     "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and menu_type not in ('page','group','division','poll','memo','member') "
	sql = sql & "    and hidden_yn = 'N' "
	sql = sql & "    and home_num = 0 "
	sql = sql & "  order by home_num asc "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
			menu_seq  = rs("menu_seq")
			menu_name = rs("menu_name")
			home_num  = rs("home_num")
%>
								<li class="<%=if3(page_type = "gr", "tit", "")%>"><button type="button" class="btn_adm" menuSeq="<%=menu_seq%>" value="<%=home_num%>"><%=menu_name%></button>
									<input type="hidden" name="menu_seq" value="<%=menu_seq%>"><input type="hidden" name="home_num" value="<%=home_num%>">
								</li>
<%
			rs.MoveNext
		Loop
	End If
	rs.close
%>
							</ul>
						</div>
					</div>
				</div>
				<div class="adm_menu_item">
					<form name="form" method="post" action="main_add_exec.asp" target="hiddenfrm">
					<div class="adm_menu_item_tit">메인 메뉴</div>
					<div class="adm_select_box">
						<div class="adm_select_tree_nav">
							<ul class="menu_handle" id="menu_handle2">
<%
	sql = ""
	sql = sql & " select *                           "
	sql = sql & "   from cf_menu                     "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and home_num != 0               "
	sql = sql & "  order by home_num asc             "
	rs.Open Sql, conn, 3, 1

	i = 1
	If Not rs.eof Then
		Do Until rs.eof
			menu_seq  = rs("menu_seq")
			menu_name = rs("menu_name")
			home_num  = rs("home_num")

			If sel_menu_seq = "" Then
				sel_menu_seq = menu_seq
				sel_home_num = home_num
			End If
%>
								<li><button type="button" class="btn_adm" menuSeq="<%=menu_seq%>" value="<%=home_num%>"><%=menu_name%></button>
									<input type="hidden" name="menu_seq" value="<%=menu_seq%>"><input type="hidden" name="home_num" value="<%=home_num%>">
								</li>
<%
			i = i + 1
			rs.MoveNext
		Loop
	Else
%>
								<li id="emptyMenu" class="tit">이곳에 끌어 놓으세요</li>
<%
	End If
	rs.close
	Set rs = Nothing
%>
							</ul>
						</div>
					</div>
					<div class="adm_select_box_btn">
						<div class="floatL">
						</div>
						<div class="floatR">
							<button type="submit" class="btn btn_c_a btn_s">적용</button>
						</div>
					</div>
					</form>
				</div>
				<div class="adm_menu_item adm_menu_item_cont">
					<div class="adm_menu_item_tit">메인 설정</div>
						<iframe id="ifrm" class="iframe" name="ifrm" frameborder="1" scrolling="no" style="border:1px;height:100%;width:100%"></iframe>
					</div>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
<script src="https://code.jquery.com/jquery-3.6.0.js"></script>
<script src="https://code.jquery.com/ui/1.13.2/jquery-ui.js"></script>
<script>
	var menu_seq = "<%=sel_menu_seq%>";
	var home_num = "<%=sel_home_num%>";

	if (menu_seq != "" && home_num != "")
	{
		ifrm.location.href='page/main_edit.asp?menu_seq='+menu_seq+'&home_num='+home_num
	}

	$(document).on("mousedown",".adm_select_tree_nav ul li button",function(e) {
		menu_seq = $(this).attr("menuSeq");
		home_num = $(this).attr("value");
		if (home_num == "0") {
			ifrm.location.href='about:blank';
		}
		else
		{
			ifrm.location.href='page/main_edit.asp?menu_seq='+menu_seq+'&home_num='+home_num
		}
	});

	$("#menu_handle1").sortable({
		connectWith : "#menu_handle2",
		start : function (event, ui) {
			try {
			}
			catch (e) {
				alert(e);
			}
		},
		stop : function (event, ui) {
			try {
				if (document.getElementById('emptyMenu'))
				{
					document.getElementById('emptyMenu').outerHTML = "";
				}
			}
			catch (e) {
				alert(e);
			}
		},
		handle : 'button',
		cancel : ''
	}).disableSelection();

	$("#menu_handle2").sortable({
		stop : function (event, ui) {
			try {
				ifrm.location.href='page/main_edit.asp?menu_seq='+menu_seq+'&home_num='+home_num
			}
			catch (e) {
				alert(e);
			}
		},
		handle : 'button',
		cancel : ''
	});

	$(document).ready(function() {
		$("#ifrm").height($(window).height())
	})

	$(function() {
		$("iframe.iframe").load(function() { //iframe 콘텐츠가 로드 된 후에 호출됩니다.
			var frame = $(this).get(0);
			var doc = (frame.contentDocument) ? frame.contentDocument : frame.contentWindow.document;
			$(this).height(doc.body.scrollHeight+ 100);
			$(this).width(doc.body.scrollWidth);
		});
	});
</script>
</html>

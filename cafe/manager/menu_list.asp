<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)

	sel_menu_seq  = Request("menu_seq")
	sel_menu_type = Request("menu_type")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>메뉴 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
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
				<h2 class="h2">메뉴 관리</h2>
			</div>
			<div class="adm_menu_flex_manage">
				<div class="adm_menu_item">
					<div class="adm_menu_item_tit">메뉴추가</div>
					<div class="adm_select_box">
						<div class="adm_select_tree_nav">
							<ul class="menu_handle" id="menu_handle1">
<%
	page1  = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='1'")
	page2  = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='2'")
	page4  = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='4'")
	page5  = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='5'")
	memo   = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='memo'")
	land   = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='land'")
	job    = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='job'")
	poll   = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='poll'")
	member = GetOneValue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='member'")
%>
	<%If page1  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">회칙</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="1"><input type="hidden" name="menu_name" value="회칙"></li><%End If%>
	<%If page2  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">소개</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="2"><input type="hidden" name="menu_name" value="소개"></li><%End If%>
	<%If page4  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">명단</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="4"><input type="hidden" name="menu_name" value="명단"></li><%End If%>
	<%If page5  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">조직도</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="5"><input type="hidden" name="menu_name" value="조직도"></li><%End If%>
	<%If memo   = "0" then%>	<li><button type="button" menuSeq="0" value="memo" class="btn_adm">쪽지</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="memo"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="쪽지"></li><%End If%>
	<%If land   = "0" then%>	<li><button type="button" menuSeq="0" value="land" class="btn_adm">부동산뉴스</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="land"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="부동산뉴스"></li><%End If%>
								<li><button type="button" menuSeq="0" value="album" class="btn_adm">앨범</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="album"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="앨범"></li>
								<li><button type="button" menuSeq="0" value="board" class="btn_adm">게시판</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="board"><input type="hidden" name="page_type" value="board"><input type="hidden" name="menu_name" value="게시판"></li>
								<li><button type="button" menuSeq="0" value="sale" class="btn_adm">매물</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="sale"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="매물"></li>
	<%If job    = "0" then%>	<li><button type="button" menuSeq="0" value="job" class="btn_adm">채용</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="job"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="채용"></li><%End If%>
	<%If poll   = "0" then%>	<li><button type="button" menuSeq="0" value="poll" class="btn_adm">설문</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="poll"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="설문"></li><%End If%>
	<%If member = "0" then%>	<li><button type="button" menuSeq="0" value="member" class="btn_adm">회원</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="member"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="회원"></li><%End If%>
								<li class="tit"><button type="button" menuSeq="0" value="group" class="btn_adm">메뉴그룹</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="group"><input type="hidden" name="page_type" value="gr"><input type="hidden" name="menu_name" value="메뉴그룹"></li>
								<li><button type="button" menuSeq="0" value="division" class="btn_adm">-----------</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="division"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="구분선"></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="adm_menu_item">
					<form name="form" method="post" action="menu_add_exec.asp" target="hiddenfrm">
					<div class="adm_menu_item_tit">현재메뉴</div>
					<div class="adm_select_box">
						<div class="adm_select_tree_nav">
							<ul class="menu_handle" id="menu_handle2">
<%
	Set row = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                           "
	sql = sql & "   from cf_menu                     "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "  order by menu_num asc             "
	row.Open Sql, conn, 3, 1

	If Not row.eof Then
		Do Until row.eof
			menu_seq  = row("menu_seq")
			menu_name = row("menu_name")
			page_type = row("page_type")
			menu_type = row("menu_type")
			menu_num  = row("menu_num")
			Select Case menu_type
				Case "page"
					Select Case page_type
						Case "1" : txt = "회칙"
						Case "2" : txt = "소개"
						Case "4" : txt = "명단"
						Case "5" : txt = "조직도"
					End Select
				Case "memo"    : txt = "쪽지"
				Case "land"    : txt = "부동산뉴스"
				Case "album"   : txt = "앨범"
				Case "board"   : txt = "게시판"
				Case "sale"    : txt = "매물"
				Case "job"     : txt = "채용"
				Case "poll"    : txt = "설문"
				Case "member"  : txt = "회원"
				Case "group"   : txt = "메뉴그룹"
				Case "nsale"   : txt = "분양"

			End Select

			If sel_menu_seq = "" Then
				sel_menu_seq  = menu_seq
				sel_menu_type = menu_type
			End If
%>
								<li class="<%=if3(page_type = "gr", "tit", "")%>"><button type="button" class="btn_adm" menuSeq="<%=menu_seq%>" value="<%=menu_type%>"><%=menu_name%>(<%=txt%>)</button>
									<input type="hidden" name="menu_seq" value="<%=menu_seq%>"><input type="hidden" name="menu_type" value="<%=menu_type%>"><input type="hidden" name="page_type" value="<%=page_type%>"><input type="hidden" name="menu_name" value="<%=menu_name%>">
								</li>
<%
			row.MoveNext
		Loop
	Else
%>
								<li id="emptyMenu" class="tit">이곳에 끌어 놓으세요</li>
<%
	End If
	row.close
	Set row = Nothing
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
					<!-- <div class="adm_menu_item_tit">메뉴 설정</div> -->
						<iframe id="ifrm" class="iframe" name="ifrm" frameborder="1" scrolling="no" style="border:1px;height:100%;width:100%"></iframe>
					<!-- </div> -->
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
	var menu_type = "<%=sel_menu_type%>";

	if (menu_seq != "" && menu_type != "")
	{
		ifrm.location.href='page/menu_edit.asp?menu_seq='+menu_seq+'&menu_type='+menu_type
	}

	$(document).on("mousedown",".adm_select_tree_nav ul li button",function(e) {
		menu_seq = $(this).attr("menuSeq");
		menu_type = $(this).attr("value");

		if (menu_seq == "0") {
			ifrm.location.href='about:blank';
		}
		else {
			ifrm.location.href='page/menu_edit.asp?menu_seq='+menu_seq+'&menu_type='+menu_type
		}
	});

	var temp;
	try {
		temp = document.getElementById('menu_handle1').innerHTML
	}
	catch (e) {
		alert(e);
	}

	$("#menu_handle1").sortable({
		connectWith : "#menu_handle2",
		start : function (event, ui) {
			try {
				this.innerHTML = temp;
			}
			catch (e) {
				alert(e);
			}
		},
		stop : function (event, ui) {
			try {
				this.innerHTML = temp;

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
				if (menu_type == "division") {
					ifrm.location.href='about:blank';
				}
				else {
					ifrm.location.href='page/menu_edit.asp?menu_seq='+menu_seq+'&menu_type='+menu_type
				}
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
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	sel_menu_seq  = Request("menu_seq")
	sel_menu_type = Request("menu_type")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�޴� ���� > ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS ����<sub>����� ����</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">�޴� ����</h2>
			</div>
			<div class="adm_menu_flex_manage">
				<div class="adm_menu_item">
					<div class="adm_menu_item_tit">�޴��߰�</div>
					<div class="adm_select_box">
						<div class="adm_select_tree_nav">
							<ul class="menu_handle1" id="menu_handle1">
<%
	page1  = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='1'")
	page2  = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='2'")
	page4  = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='4'")
	page5  = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='page' and page_type='5'")
	memo   = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='memo'")
	land   = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='land'")
	job    = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='job'")
	poll   = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='poll'")
	member = getonevalue("count(*)","cf_menu","where cafe_id='" & cafe_id & "' and menu_type ='member'")
%>
	<%If page1  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">ȸĢ</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="1"><input type="hidden" name="menu_name" value="ȸĢ"></li><%End if%>
	<%If page2  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">�Ұ�</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="2"><input type="hidden" name="menu_name" value="�Ұ�"></li><%End if%>
	<%If page4  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">���</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="4"><input type="hidden" name="menu_name" value="���"></li><%End if%>
	<%If page5  = "0" then%>	<li><button type="button" menuSeq="0" value="page" class="btn_adm">������</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="page"><input type="hidden" name="page_type" value="5"><input type="hidden" name="menu_name" value="������"></li><%End if%>
	<%If memo   = "0" then%>	<li><button type="button" menuSeq="0" value="memo" class="btn_adm">����</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="memo"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="����"></li><%End if%>
	<%If land   = "0" then%>	<li><button type="button" menuSeq="0" value="land" class="btn_adm">�ε��괺��</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="land"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="�ε��괺��"></li><%End if%>
								<li><button type="button" menuSeq="0" value="album" class="btn_adm">�ٹ�</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="album"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="�ٹ�"></li>
								<li><button type="button" menuSeq="0" value="board" class="btn_adm">�Խ���</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="board"><input type="hidden" name="page_type" value="board"><input type="hidden" name="menu_name" value="�Խ���"></li>
								<li><button type="button" menuSeq="0" value="sale" class="btn_adm">�Ź�</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="sale"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="�Ź�"></li>
	<%If job    = "0" then%>	<li><button type="button" menuSeq="0" value="job" class="btn_adm">ä��</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="job"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="ä��"></li><%End if%>
	<%If poll   = "0" then%>	<li><button type="button" menuSeq="0" value="poll" class="btn_adm">����</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="poll"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="����"></li><%End if%>
	<%If member = "0" then%>	<li><button type="button" menuSeq="0" value="member" class="btn_adm">ȸ��</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="member"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="ȸ��"></li><%End if%>
								<li class="tit"><button type="button" menuSeq="0" value="group" class="btn_adm">�޴��׷�</button><input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="group"><input type="hidden" name="page_type" value="gr"><input type="hidden" name="menu_name" value="�޴��׷�"></li>
								<li><button type="button" menuSeq="0" value="division" class="btn_adm">-----------<input type="hidden" name="menu_seq"><input type="hidden" name="menu_type" value="division"><input type="hidden" name="page_type" value=""><input type="hidden" name="menu_name" value="���м�"></li>
							</ul>
						</div>
					</div>
				</div>
				<div class="adm_menu_item">
					<form name="form" method="post" action="menu_add_exec.asp" target="hiddenfrm">
					<div class="adm_menu_item_tit">����޴�</div>
					<div class="adm_select_box">
						<div class="adm_select_tree_nav">
							<ul class="menu_handle">
<%
	Set row = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                       "
	sql = sql & "   from cf_menu                 "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "  order by menu_num asc         "
	row.Open Sql, conn, 3, 1

	If Not row.eof Then
		Do Until row.eof
			menu_seq                 = row("menu_seq")
			cafe_id                  = row("cafe_id")
			menu_name                = row("menu_name")
			page_type                = row("page_type")
			menu_type                = row("menu_type")
			menu_num                 = row("menu_num")
			hidden_yn                = row("hidden_yn")
			home_num                 = row("home_num")
			home_cnt                 = row("home_cnt")
			top_cnt                  = row("top_cnt")
			doc                      = row("doc")
			creid                    = row("creid")
			credt                    = row("credt")
			modid                    = row("modid")
			moddt                    = row("moddt")
			write_auth               = row("write_auth")
			reply_auth               = row("reply_auth")
			read_auth                = row("read_auth")
			editor_yn                = row("editor_yn")
			daily_cnt                = row("daily_cnt")
			list_info                = row("list_info")
			inc_del_yn               = row("inc_del_yn")
			last_date                = row("last_date")
			menu_skin_center_id      = row("menu_skin_center_id")
			menu_skin_center_color01 = row("menu_skin_center_color01")
			menu_skin_center_color02 = row("menu_skin_center_color02")
			menu_skin_center_color03 = row("menu_skin_center_color03")
			wide_yn                  = row("wide_yn")
			list_type                = row("list_type")

			Select Case menu_type
				Case "page"
					Select Case page_type
						Case "1" : txt = "ȸĢ"
						Case "2" : txt = "�Ұ�"
						Case "4" : txt = "���"
						Case "5" : txt = "������"
					End Select
				Case "memo"    : txt = "����"
				Case "land"    : txt = "�ε��괺��"
				Case "album"   : txt = "�ٹ�"
				Case "board"   : txt = "�Խ���"
				Case "sale"    : txt = "�Ź�"
				Case "job"     : txt = "ä��"
				Case "poll"    : txt = "����"
				Case "member"  : txt = "ȸ��"
				Case "group"   : txt = "�޴��׷�"
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
							<button type="submit" class="btn btn_c_a btn_s">����</button>
						</div>
					</div>
					</form>
				</div>
				<div class="adm_menu_item adm_menu_item_cont">
					<div class="adm_menu_item_tit">�޴� ����</div>
						<iframe id="ifrm" class="iframe" name="ifrm" frameborder="1" scrolling="no" style="border:1px;height:100%;width:100%"></iframe>
					</div>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
</html>
	<script>
		var menu_seq = "<%=sel_menu_seq%>";
		var menu_type = "<%=sel_menu_type%>";

		if (menu_seq != "" && menu_type != "")
		{
			ifrm.location.href='page/menu_edit.asp?menu_seq='+menu_seq+'&menu_type='+menu_type
		}

		$(document).on("mousedown",".adm_select_tree_nav ul li button",function(e){
			menu_seq = $(this).attr("menuSeq");
			menu_type = $(this).attr("value");
			if (menu_seq == "0"){
				ifrm.location.href='about:blank';
			}
			else
			{
				ifrm.location.href='page/menu_edit.asp?menu_seq='+menu_seq+'&menu_type='+menu_type
			}
		});

		var temp;
		try {
			temp = document.getElementById('menu_handle1').innerHTML
		}
		catch (e){
			alert(e);
		}

		$(".menu_handle1").sortable({
			connectWith : ".menu_handle",
			start : function (event, ui) {
				try {
					this.innerHTML = temp;
				}
				catch (e){
					alert(e);
				}
			},
			stop : function (event, ui) {
				try {
					this.innerHTML = temp;
				}
				catch (e){
					alert(e);
				}
			},
			handle : 'button',
			cancel : ''
		}).disableSelection();

		$(".menu_handle").sortable({
			stop : function (event, ui) {
				try {
					if (menu_type == "division"){
						ifrm.location.href='about:blank';
					}
					else
					{
						ifrm.location.href='page/menu_edit.asp?menu_seq='+menu_seq+'&menu_type='+menu_type
					}
				}
				catch (e){
					alert(e);
				}
			},
			handle : 'button',
			cancel : ''
		});
	</script>
<script LANGUAGE="JavaScript">
<!--
	$(document).ready(function() {
		$("#ifrm").height($(window).height())
	})

	$(function(){
		$("iframe.iframe").load(function(){ //iframe �������� �ε� �� �Ŀ� ȣ��˴ϴ�.
			var frame = $(this).get(0);
			var doc = (frame.contentDocument) ? frame.contentDocument : frame.contentWindow.document;
			$(this).height(doc.body.scrollHeight+ 100);
			$(this).width(doc.body.scrollWidth);
		});
	});
//-->
</script>

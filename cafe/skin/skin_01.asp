<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<%
	skin_yn = "Y"
%>
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/skin/skin_center_inc.asp"-->
<%
	Else
%>
				<iframe name="cafe_main" id="cafe_main" title="카페 메인" src="about:blank" width="100%" height="100%" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
				<script type="text/javascript">
				try {
					$('#cafe_main').attr('src', '/cafe/skin/skin_center_view.asp?cafe_id=<%=cafe_id%>') ;
						$("#cafe_main").height($(window).height())
				} catch(e) {aleret(e)}

				$(document).ready(function() {
					$('#cafe_main').on('load', function() {
						if(this.contentDocument) {
							$(this).height(this.contentDocument.documentElement.scrollHeight);
						}
						else {
							$(this).height(this.contentWindow.document.body.scrollHeight);
						}
					});
				});
				</script>
<%
	End IF
%>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
<!--#include virtual="/cafe/skin/popup_inc.asp"-->
<!--#include virtual="/cafe/skin/skin_edit_inc.asp"-->
</body>
</html>

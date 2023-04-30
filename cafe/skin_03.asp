<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
%>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>스킨-3 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
	<script src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<%
	skin_yn = "Y"
%>
<!--#include virtual="/cafe/cafe_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/cafe_left_inc.asp"-->
			<div class="container">
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_center_inc.asp"-->
<%
	Else
%>
<%
	End IF
%>
			</div>
				<iframe id="cafe_main" name="cafe_main" title="카페 메인" src="about:blank" style="display:none;" width="0" height="0" frameborder="0" scrolling="no" marginwidth="0" marginheight="0"></iframe>
				<script>
				try {
					$('#cafe_main').attr('src', '/cafe/cafe_center_view.asp?cafe_id=<%=cafe_id%>') ;
				} catch(e) {aleret(e)}
				var crjee = 0;
				$(document).ready(function() {
					$('#cafe_main').on('load', function() {
//try
//{if (this.contentDocument.getElementsByClassName("container")[0].id)
//{
////	alert("crjee : " + crjee)
////alert("id : " + this.contentDocument.getElementsByClassName("container")[0].id)
//}
//}
//catch (e)
//{
//	alert(e)
//}
						if(crjee == 0) {
							if (this.contentDocument.getElementsByClassName("container")[0].id)
							{
								var jsID = this.contentDocument.getElementsByClassName("container")[0].id;

								var items = $('head').find('script');
								if(items.length == 0) {
									alert("작성된 아이템이 없습니다.");
									return false;
								}

								var flag = true;
								
							//	for(var j = 0; j < items.length; j++) {
							//		try{
							//			}
							//			catch(e){
							//				alert(e)
							//				}
								//	if($(items.get(i)).id() == jsID) {
								//		flag = false;
								//		alert("사용한 메누.");
								//		break;
								//	}
								//}

									try{
											var childElement = document.querySelector('#'+jsID);
											if(childElement) {
											// #child 요소 제거
											childElement.remove();
											}
											else {
												var head= document.getElementsByTagName('head')[0];
												var script= document.createElement('script');
												script.type= 'text/javascript';
												script.src= '/common/js/' + jsID + '.js';
												script.id = jsID;
												script.async = 'Async';
												head.appendChild(script);
											}
										}
										catch(e){
											alert(e)
										}
							}
							document.getElementsByClassName("container")[0].innerHTML = this.contentDocument.getElementsByClassName("container")[0].innerHTML;
							$('#cafe_main').attr('src', 'about:blank') ;
						}
						else {
							$(this).height(100);
							if(this.contentDocument) {
								$(this).height(this.contentDocument.documentElement.scrollHeight);
							}
							else {
								$(this).height(this.contentWindow.document.body.scrollHeight);
							}
						}
					});
				});
				</script>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<!--#include virtual="/cafe/popup_inc.asp"-->
<!--#include virtual="/cafe/skin_edit_inc.asp"-->
</body>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

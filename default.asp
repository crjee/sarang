<%@Language="VBScript" CODEPAGE="65001" %>
<%
	cafe_id = Request("cafe_id")

	If cafe_id <> "" Then
'		Response.Write "<script>parent.location.href='/cafe/main.asp?cafe_id=" & cafe_id & "';</script>"
		Response.Write "<script>parent.location.href='/" & cafe_id & "';</script>"
		Response.End
	ElseIf cafe_id = "" And Session("user_id") = "" then
		Response.Write "<script>parent.location.href='/home';</script>"
'		Response.Write "<script>parent.location.href='/login_form.asp';</script>"
		Response.End
	ElseIf Session("cafe_id") <> "" Then
'		Response.Write "<script>parent.location.href='/cafe/main.asp?cafe_id=" & Session("cafe_id") & "';</script>"
		Response.Write "<script>parent.location.href='/" & Session("cafe_id") & "';</script>"
		Response.End
	ElseIf Session("cafe_ad_level") = "10" then
'		Response.Write "<script>parent.location.href='/cafe/main.asp?cafe_id=hanwul';</script>"
		Response.Write "<script>parent.location.href='/hanwul';</script>"
		Response.End
	ElseIf Session("cafe_mb_level") = "0" then
				Response.Write "<script>parent.location.href='/home';</script>"
		Response.End
	Else
		session.Abandon
		Response.Write "<script>alert('올바르지 않은 접근입니다.');history.back();</script>"
		Response.End
	End If
%>

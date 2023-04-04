<%
	If Request("check1") = "Y" Then
		popup_key = request("popup_key")

		Response.Cookies(popup_key) = "ok"
		Response.Cookies(popup_key).expires = DATE()+1
	End If
%>
<script Language="Javascript">
	self.close();
</SCRIPT>

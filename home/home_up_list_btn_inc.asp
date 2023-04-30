<%
	If cafe_ad_level = 10 Then
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWaste()">휴지통</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWrite()">글쓰기</button>
<%
	End If
%>

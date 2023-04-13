					<div class="pagenation">
						<button type="button" class="btn btn_c_peach f_awesome btnPrev" onclick="Javascript:MovePage(1, '<%=session("ctTarget")%>')");"><em><<</em></button>
<%
	If page/20 = Int(page/20) Then ' 현재 페이지가 10의 배수이면
		BlockStart = page - 20 + 1
	Else ' 10의 배수가 아니면
		BlockStart = Int(page/20) * 20 + 1
	End If

	' 네비게이션 블럭의 끝 페이지 설정
	BlockEnd = BlockStart + 19
	If BlockEnd > PageCount then
		BlockEnd = PageCount
	End If

	' 이전 블럭이 있으면 '이전 10개' 출력
	If BlockStart > 1 Then
%>
						<button type="button" class="btn btn_c_peach f_awesome btnPrev" onclick="Javascript:MovePage(<%=BlockStart-1%>, '<%=session("ctTarget")%>')");"><em>이전</em></button>
<%
	Else
%>
						<button type="button" class="btn btn_c_peach f_awesome btnPrev"><em>이전</em></button>
<%
	End If

	For j = BlockStart to BlockEnd
		If j = CInt(page) Then
%>
						<button type="button" onclick="MovePage(<%=j%>, '<%=session("ctTarget")%>')");" title="<%=j%> Page" class="on"><%=j%></button>
<%
		Else
%>
						<button type="button" onclick="MovePage(<%=j%>, '<%=session("ctTarget")%>')");" title="<%=j%> Page" class=""><%=j%></button>
<%
		End If
	Next

	If BlockStart + 19 < PageCount Then
%>
						<button type="button" class="btn btn_c_peach f_awesome btnNext" onclick="Javascript:MovePage(<%=BlockEnd+1%>, '<%=session("ctTarget")%>')");"><em>다음</em></button>
<%
	Else
%>
						<button type="button" class="btn btn_c_peach f_awesome btnNext"><em>다음</em></button>
<%
	End If
%>
						<button type="button" class="btn btn_c_peach f_awesome btnNext" onclick="Javascript:MovePage(<%=PageCount%>, '<%=session("ctTarget")%>')");"><em>>></em></button>
					</div>

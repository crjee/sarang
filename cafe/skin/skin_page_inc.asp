					<div class="pagenation">
						<button type="button" class="btn btn_c_peach f_awesome btnPrev" onclick="Javascript:MovePage(1);"><em><<</em></button>
<%
	If page/20 = Int(page/20) Then ' ���� �������� 10�� ����̸�
		BlockStart = page - 20 + 1
	Else ' 10�� ����� �ƴϸ�
		BlockStart = Int(page/20) * 20 + 1
	End If

	' �׺���̼� ���� �� ������ ����
	BlockEnd = BlockStart + 19
	If BlockEnd > PageCount then
		BlockEnd = PageCount
	End If

	' ���� ���� ������ '���� 10��' ���
	If BlockStart > 1 Then
%>
						<button type="button" class="btn btn_c_peach f_awesome btnPrev" onclick="Javascript:MovePage(<%=BlockStart-1%>);"><em>����</em></button>
<%
	Else
%>
						<button type="button" class="btn btn_c_peach f_awesome btnPrev"><em>����</em></button>
<%
	End If

	For j = BlockStart to BlockEnd
		If j = CInt(page) Then
%>
						<button type="button" onclick="MovePage(<%=j%>);" title="<%=j%> Page" class="on"><%=j%></button>
<%
		Else
%>
						<button type="button" onclick="MovePage(<%=j%>);" title="<%=j%> Page" class=""><%=j%></button>
<%
		End If
	Next

	If BlockStart + 19 < PageCount Then
%>
						<button type="button" class="btn btn_c_peach f_awesome btnNext" onclick="Javascript:MovePage(<%=BlockEnd+1%>);"><em>����</em></button>
<%
	Else
%>
						<button type="button" class="btn btn_c_peach f_awesome btnNext"><em>����</em></button>
<%
	End If
%>
						<button type="button" class="btn btn_c_peach f_awesome btnNext" onclick="Javascript:MovePage(<%=PageCount%>);"><em>>></em></button>
					</div>

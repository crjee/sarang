<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	Set objImage = server.CreateObject("DEXT.ImageProc")
	Set fso = CreateObject("Scripting.FileSystemObject")

	If True = objImage.SetSourceFile(Server.MapPath("\") & "\sys\test.jpg") Then

		Call objImage.SetSourceFile(Server.MapPath("\") & "\sys\test.jpg")

		If (fso.FileExists(Server.MapPath("\") & "\sys\test.jpg")) Then
			Set F = fso.GetFile(Server.MapPath("\") & "\sys\test.jpg")
			Size = FormatNumber(F.size / 1024, 0) ' ���� ������ ����
			Set F = Nothing
		End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����Ȯ�����ڵ�  = <%=objImage.ImageFormat%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ũ��      = <%=Size%>KB <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̹�������ũ��  = <%=objImage.ImageWidth%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̹�������ũ��  = <%=objImage.ImageHeight%> <br>
<%
		If orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' ������
			img_frm_cd         = "������" ' �̹��������ڵ� ������
		ElseIf orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' ������
			img_frm_cd         = "������" ' �̹��������ڵ� ������
		Else ' ���簢��
			img_frm_cd         = "���簢��" ' �̹��������ڵ� ���簢��
		End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̹��������ڵ�  = <%=img_frm_cd%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;���� <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="test.jpg" border="0" width="140" /><br /><br />
<%
		For i = 0 To 9
			If (fso.FileExists(Server.MapPath("\") & "\sys\test_" & i & ".jpg")) Then
				Set F = fso.GetFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg")
				fso.DeleteFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg") ' ���� ������ ����
				Set F = Nothing
			End If

			Call objImage.SaveasThumbnail(Server.MapPath("\") & "\sys\test_" & i & ".jpg", objImage.ImageWidth * (10-i)/10, objImage.ImageHeight * (10-i)/10, false, true)
			Call objImage.SetSourceFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg")

			If (fso.FileExists(Server.MapPath("\") & "\sys\test_" & i & ".jpg")) Then
				Set F = fso.GetFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg")
				Size = FormatNumber(F.size / 1024, 0) ' ���� ������ ����
				Set F = Nothing
			End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����Ȯ�����ڵ�  = <%=objImage.ImageFormat%> <br>
<!--
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ǥ���Ͽ���   = "Y" <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;��ǥ���Ͽ���   = "N" <br>
 -->
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;����ũ��      = <%=Size%>KB <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̹�������ũ��  = <%=objImage.ImageWidth%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̹�������ũ��  = <%=objImage.ImageHeight%> <br>
<%
			If orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' ������
				img_frm_cd = "������" ' �̹��������ڵ� ������
			ElseIf orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' ������
				img_frm_cd = "������" ' �̹��������ڵ� ������
			Else ' ���簢��
				img_frm_cd = "���簢��" ' �̹��������ڵ� ���簢��
			End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�̹��������ڵ�  = <%=img_frm_cd%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= (10-i)*10 %>% <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="test_<%=i%>.jpg" border="0" width="140" /><br /><br />
<%
		Next
	End If
%>

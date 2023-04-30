<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	Set objImage = server.CreateObject("DEXT.ImageProc")
	Set fso = CreateObject("Scripting.FileSystemObject")

	If True = objImage.SetSourceFile(Server.MapPath("\") & "\sys\test.jpg") Then

		Call objImage.SetSourceFile(Server.MapPath("\") & "\sys\test.jpg")

		If (fso.FileExists(Server.MapPath("\") & "\sys\test.jpg")) Then
			Set F = fso.GetFile(Server.MapPath("\") & "\sys\test.jpg")
			Size = FormatNumber(F.size / 1024, 0) ' 파일 사이즈 추출
			Set F = Nothing
		End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;파일확장자코드  = <%=objImage.ImageFormat%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;파일크기      = <%=Size%>KB <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이미지가로크기  = <%=objImage.ImageWidth%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이미지세로크기  = <%=objImage.ImageHeight%> <br>
<%
		If orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' 가로형
			img_frm_cd         = "가로형" ' 이미지형태코드 가로형
		ElseIf orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' 세로형
			img_frm_cd         = "세로형" ' 이미지형태코드 세로형
		Else ' 정사각형
			img_frm_cd         = "정사각형" ' 이미지형태코드 정사각형
		End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이미지형태코드  = <%=img_frm_cd%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;원본 <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="test.jpg" border="0" width="140" /><br /><br />
<%
		For i = 0 To 9
			If (fso.FileExists(Server.MapPath("\") & "\sys\test_" & i & ".jpg")) Then
				Set F = fso.GetFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg")
				fso.DeleteFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg") ' 파일 사이즈 추출
				Set F = Nothing
			End If

			Call objImage.SaveasThumbnail(Server.MapPath("\") & "\sys\test_" & i & ".jpg", objImage.ImageWidth * (10-i)/10, objImage.ImageHeight * (10-i)/10, false, true)
			Call objImage.SetSourceFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg")

			If (fso.FileExists(Server.MapPath("\") & "\sys\test_" & i & ".jpg")) Then
				Set F = fso.GetFile(Server.MapPath("\") & "\sys\test_" & i & ".jpg")
				Size = FormatNumber(F.size / 1024, 0) ' 파일 사이즈 추출
				Set F = Nothing
			End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;파일확장자코드  = <%=objImage.ImageFormat%> <br>
<!--
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대표파일여부   = "Y" <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;대표파일여부   = "N" <br>
 -->
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;파일크기      = <%=Size%>KB <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이미지가로크기  = <%=objImage.ImageWidth%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이미지세로크기  = <%=objImage.ImageHeight%> <br>
<%
			If orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' 가로형
				img_frm_cd = "가로형" ' 이미지형태코드 가로형
			ElseIf orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' 세로형
				img_frm_cd = "세로형" ' 이미지형태코드 세로형
			Else ' 정사각형
				img_frm_cd = "정사각형" ' 이미지형태코드 정사각형
			End If
%>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;이미지형태코드  = <%=img_frm_cd%> <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<%= (10-i)*10 %>% <br>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src="test_<%=i%>.jpg" border="0" width="140" /><br /><br />
<%
		Next
	End If
%>

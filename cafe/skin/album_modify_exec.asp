<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "album\"
	uploadform.DefaultPath = uploadFolder
	dsplyFolder  = ConfigAttachedFileFolder & "display\album\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\album\"

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set objImage = server.CreateObject("DEXT.ImageProc")
	Set fso = CreateObject("Scripting.FileSystemObject")

	menu_seq  = uploadform("menu_seq")
	page      = uploadform("page")
	pagesize  = uploadform("pagesize")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")
	self_yn   = uploadform("self_yn")

	step_num  = uploadform("step_num")
	level_num = uploadform("level_num")
	album_seq = uploadform("album_seq")
	kname = uploadform("kname")
	subject = uploadform("subject")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	For Each item In uploadform("file_name")
		If item <> "" Then
			If item.FileLen > UploadForm.MaxFileLen Then
				call msggo("파일의 크기는 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘어서는 안됩니다","")
				Set UploadForm = Nothing
				Response.End
			End If
		End If
	Next

	On Error Resume Next
	Conn.BeginTrans
	Set BeginTrans = Conn
	CntError = 0

	Dim atch_rt_nm()
	Dim orgnl_file_nm()
	Dim file_name()
	Dim file_extn_cd()
	Dim rprs_file_yn()
	Dim file_sz()
	Dim dwnld_cnt()
	Dim file_mimetype_cd()
	Dim orgnl_img_wdth_sz()
	Dim orgnl_img_hght_sz()
	Dim orgnl_file_sz()
	Dim img_frm_cd()
	Dim dsply_img_wdth_sz()
	Dim dsply_img_hght_sz()
	Dim dsply_file_nm()
	Dim dsply_file_sz()
	Dim thmbnl_img_wdth_sz()
	Dim thmbnl_img_hght_sz()
	Dim thmbnl_file_nm()
	Dim thmbnl_file_sz()

	i = 0
	attach_num = getonevalue("max(attach_num)", "cf_album_attach", "where album_seq = ' " & album_seq & "'")

	For Each item In uploadform("file_name")
		If item <> "" Then
			'MimeType이 image/jpeg ,image/gif이 아닌경우 업로드 중단
			IF instr("image/jpeg/image/jpg,image/gif,image/png,image/bmp", MimeType) Then
				i = i + 1

				ReDim Preserve file_name(i)
				ReDim Preserve atch_rt_nm(i)
				ReDim Preserve orgnl_file_nm(i)
				ReDim Preserve file_extn_cd(i)
				ReDim Preserve rprs_file_yn(i)
				ReDim Preserve file_sz(i)
				ReDim Preserve dwnld_cnt(i)
				ReDim Preserve file_mimetype_cd(i)
				ReDim Preserve orgnl_img_wdth_sz(i)
				ReDim Preserve orgnl_img_hght_sz(i)
				ReDim Preserve orgnl_file_sz(i)
				ReDim Preserve img_frm_cd(i)
				ReDim Preserve dsply_img_wdth_sz(i)
				ReDim Preserve dsply_img_hght_sz(i)
				ReDim Preserve dsply_file_nm(i)
				ReDim Preserve dsply_file_sz(i)
				ReDim Preserve thmbnl_img_wdth_sz(i)
				ReDim Preserve thmbnl_img_hght_sz(i)
				ReDim Preserve thmbnl_file_nm(i)
				ReDim Preserve thmbnl_file_sz(i)

				MimeType  = item.MimeType
				atch_rt_nm(i) = uploadFolder
				orgnl_file_nm(i) = item.FileName

				file_extn_cd(i) = right(orgnl_file_nm(i),len(orgnl_file_nm(i))-instr(orgnl_file_nm(i),"."))
				file_extn_cd(i) = right(orgnl_file_nm(i),len(orgnl_file_nm(i))-instr(orgnl_file_nm(i),"."))

				If i = 1 Then
					rprs_file_yn(i) = "Y" ' 대표파일여부
				Else
					rprs_file_yn(i) = "N" ' 대표파일여부
				End If

				Call item.Save(,False)
				file_name(i) = item.LastSavedFileName

				Set F = fso.GetFile(uploadFolder & file_name(i))
				Size = F.size              '// PRE 파일 사이즈 추출
				Set F = Nothing

				file_sz(i)            = Size ' 파일크기
				dwnld_cnt(i)          = 0 ' 다운로드수
				atch_file_se_cd       = "" ' 첨부파일구분코드
				file_mimetype_cd(i)   = item.MimeType ' 파일마임타입코드
				orgnl_file_sz(i)      = Size' 원본파일크기

				If True = objImage.SetSourceFile(uploadFolder & file_name(i)) Then
					orgnl_img_wdth_sz(i)  = objImage.ImageWidth ' 원본이미지가로크기
					orgnl_img_hght_sz(i)  = objImage.ImageHeight ' 원본이미지세로크기
					dsply_file_nm(i)      =  "DSPLY"  & numc(Year(date), 4) & numc(Month(date), 2) & numc(Day(date), 2) & numc(Hour(Now), 2) & numc(Minute(Now), 2) & numc(Second(Now), 2) & numc(attach_num + i, 3) & ".jpg"
					thmbnl_file_nm(i)     =  "THMBNL" & numc(Year(date), 4) & numc(Month(date), 2) & numc(Day(date), 2) & numc(Hour(Now), 2) & numc(Minute(Now), 2) & numc(Second(Now), 2) & numc(attach_num + i, 3) & ".jpg"

					If orgnl_img_wdth_sz(i) > orgnl_img_hght_sz(i) Then ' 가로형
						img_frm_cd(i)         = "HRZ" ' 이미지형태코드 가로형
					ElseIf orgnl_img_wdth_sz(i) > orgnl_img_hght_sz(i) Then ' 세로형
						img_frm_cd(i)         = "VTC" ' 이미지형태코드 세로형
					Else ' 정사각형
						img_frm_cd(i)         = "SQR" ' 이미지형태코드 정사각형
					End If

					If orgnl_img_wdth_sz(i) <= 600 Then
						dsply_img_wdth_sz(i) = orgnl_img_wdth_sz(i)
						dsply_img_hght_sz(i) = orgnl_img_hght_sz(i)
					Else
						dsply_img_wdth_sz(i) = 600
						dsply_img_hght_sz(i) = CInt(orgnl_img_hght_sz(i) / (orgnl_img_wdth_sz(i) / 600))
					End If

					Call objImage.SaveasThumbnail(dsplyFolder & dsply_file_nm(i), dsply_img_wdth_sz(i), dsply_img_hght_sz(i), false, true)
					Call objImage.SetSourceFile(dsplyFolder & dsply_file_nm(i))
					Set F = fso.GetFile(dsplyFolder & dsply_file_nm(i))
					Size = F.size              '// PRE 파일 사이즈 추출
					Set F = Nothing

					dsply_img_wdth_sz(i)  = objImage.ImageWidth ' 전시이미지가로크기
					dsply_img_hght_sz(i)  = objImage.ImageHeight ' 전시이미지세로크기
					dsply_file_nm(i)      = dsply_file_nm(i) ' 전시파일명
					dsply_file_sz(i)      = Size ' 전시파일크기

					If orgnl_img_wdth_sz(i) <= 300 Then
						thmbnl_img_wdth_sz(i) = orgnl_img_wdth_sz(i)
						thmbnl_img_hght_sz(i) = orgnl_img_hght_sz(i)
					Else
						thmbnl_img_wdth_sz(i) = 300
						thmbnl_img_hght_sz(i) = CInt(orgnl_img_hght_sz(i) / (orgnl_img_wdth_sz(i) / 300))
					End If

					Call objImage.SaveasThumbnail(thmbnlFolder & thmbnl_file_nm(i), thmbnl_img_wdth_sz(i), thmbnl_img_hght_sz(i), false, true)
					Call objImage.SetSourceFile(thmbnlFolder & thmbnl_file_nm(i))
					Set F = fso.GetFile(thmbnlFolder & thmbnl_file_nm(i))
					Size = F.size              '// PRE 파일 사이즈 추출
					Set F = Nothing

					thmbnl_img_wdth_sz(i) = objImage.ImageWidth ' 썸네일이미지가로크기
					thmbnl_img_hght_sz(i) = objImage.ImageHeight ' 썸네일이미지세로크기
					thmbnl_file_nm(i)     = thmbnl_file_nm(i) ' 썸네일파일명
					thmbnl_file_sz(i)     = Size ' 썸네일파일크기
				End If
			Else
				msgonly uploadform.FileName & " 은 이미지파일이 아닙니다."
			End If
		End If
	Next

	sql = ""
	sql = sql & " update cf_album "
	sql = sql & "    set subject = '" & subject & "' "
	sql = sql & "       ,contents = '" & ir1 & "' "
	sql = sql & "       ,top_yn = '" & top_yn & "' "
	sql = sql & "       ,link = '" & link & "' "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where album_seq = '" & album_seq & " '"
	Conn.Execute(sql)

	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_album where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	For i = 1 To UBound(file_name)
		new_seq = getSeq("cf_album_attach")

		sql = ""
		sql = sql & " insert into cf_album_attach( "
		sql = sql & "        attach_seq  "
		sql = sql & "       ,album_seq   "
		sql = sql & "       ,attach_num  "
		sql = sql & "       ,file_name   "

		sql = sql & "       ,atch_rt_nm         "
		sql = sql & "       ,orgnl_file_nm      "
		sql = sql & "       ,file_extn_cd       "
		sql = sql & "       ,rprs_file_yn       "
		sql = sql & "       ,file_sz            "
		sql = sql & "       ,dwnld_cnt          "
		sql = sql & "       ,file_mimetype_cd   "
		sql = sql & "       ,orgnl_img_wdth_sz  "
		sql = sql & "       ,orgnl_img_hght_sz  "
		sql = sql & "       ,orgnl_file_sz      "
		sql = sql & "       ,img_frm_cd         "
		sql = sql & "       ,dsply_img_wdth_sz  "
		sql = sql & "       ,dsply_img_hght_sz  "
		sql = sql & "       ,dsply_file_nm      "
		sql = sql & "       ,dsply_file_sz      "
		sql = sql & "       ,thmbnl_img_wdth_sz "
		sql = sql & "       ,thmbnl_img_hght_sz "
		sql = sql & "       ,thmbnl_file_nm     "
		sql = sql & "       ,thmbnl_file_sz     "

		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & new_seq        & "' "
		sql = sql & "       ,'" & album_seq      & "' "
		sql = sql & "       ,'" & attach_num + i & "' "
		sql = sql & "       ,'" & file_name(i)   & "' "

		sql = sql & "       ,'" & atch_rt_nm(i)         & "' "
		sql = sql & "       ,'" & orgnl_file_nm(i)      & "' "
		sql = sql & "       ,'" & file_extn_cd(i)       & "' "
		sql = sql & "       ,'" & rprs_file_yn(i)       & "' "
		sql = sql & "       ,'" & file_sz(i)            & "' "
		sql = sql & "       ,'" & dwnld_cnt(i)          & "' "
		sql = sql & "       ,'" & file_mimetype_cd(i)   & "' "
		sql = sql & "       ,'" & orgnl_img_wdth_sz(i)  & "' "
		sql = sql & "       ,'" & orgnl_img_hght_sz(i)  & "' "
		sql = sql & "       ,'" & orgnl_file_sz(i)      & "' "
		sql = sql & "       ,'" & img_frm_cd(i)         & "' "
		sql = sql & "       ,'" & dsply_img_wdth_sz(i)  & "' "
		sql = sql & "       ,'" & dsply_img_hght_sz(i)  & "' "
		sql = sql & "       ,'" & dsply_file_nm(i)      & "' "
		sql = sql & "       ,'" & dsply_file_sz(i)      & "' "
		sql = sql & "       ,'" & thmbnl_img_wdth_sz(i) & "' "
		sql = sql & "       ,'" & thmbnl_img_hght_sz(i) & "' "
		sql = sql & "       ,'" & thmbnl_file_nm(i)     & "' "
		sql = sql & "       ,'" & thmbnl_file_sz(i)     & "' "

		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate()) "
		Conn.Execute(sql)
	Next

	Set UploadForm = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	alert("수정 되었습니다.");
try
{
<%
	If session("noFrame") = "Y" Then
%>
	parent.location.href='album_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&self_yn=<%=self_yn%>&album_seq=<%=album_seq%>';
<%
	Else
%>
<%
	End if
%>
	alert($('#cafe_main', parent.parent.document).attr('src'));
	$('#cafe_main', parent.parent.document).attr('src', '/cafe/skin/album_view.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&pagesize=<%=pagesize%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>&self_yn=<%=self_yn%>&album_seq=<%=album_seq%>') ;
}
catch (e)
{
	alert(e)
}
</script>
<%
	Else
		conn.RollbackTrans
		conn.Close
		Set conn = Nothing
%>
<script>
	alert("오류가 뱔생했습니다.\n\n에러내용 : <%=Err.Description%>(<%=Err.Number%>)");
</script>
<%
	End If
%>

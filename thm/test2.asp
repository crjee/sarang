<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	ScriptTimeOut = 5000
	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	Set objImage = server.CreateObject("DEXT.ImageProc")
	Set fso = CreateObject("Scripting.FileSystemObject")

	uploadFolder = ConfigAttachedFileFolder & "album\"
	dsplyFolder  = ConfigAttachedFileFolder & "display\album\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\album\"

	sql = ""
	sql = sql & " select ca.*                                                                                                                "
	sql = sql & "       ,'DSPLY'  + FORMAT(cast(credt as datetime), 'yyyyMMddHHmmss') + FORMAT(album_seq, '00000000') + FORMAT(attach_num, '000') + '.jpg' as dsply_file_nm  "
	sql = sql & "       ,'THMBNL' + FORMAT(cast(credt as datetime), 'yyyyMMddHHmmss') + FORMAT(album_seq, '00000000') + FORMAT(attach_num, '000') + '.jpg' as thmbnl_file_nm "
	sql = sql & "   from cf_album_attach ca                                                                                                  "
	sql = sql & "  where attach_num > 1                                                                                                      "
	sql = sql & "    and (dsply_img_wdth_sz is null or dsply_img_wdth_sz = '')                                                               "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
			attach_seq = rs("attach_seq")
			attach_num = rs("attach_num")
			file_name  = rs("file_name")
			dsply_file_nm      = rs("dsply_file_nm")
			thmbnl_file_nm     = rs("thmbnl_file_nm")
'			file_extn_cd       = rs("file_extn_cd")      ' 파일확장자코드
'			rprs_file_yn       = rs("rprs_file_yn")      ' 대표파일여부
'			file_sz            = rs("file_sz")           ' 파일크기
'			dwnld_cnt          = rs("dwnld_cnt")         ' 다운로드수
'			atch_file_se_cd    = rs("atch_file_se_cd")   ' 첨부파일구분코드
'			file_mimetype_cd   = rs("file_mimetype_cd")  ' 파일마임타입코드
			orgnl_img_wdth_sz  = rs("orgnl_img_wdth_sz") ' 원본이미지가로크기
			orgnl_img_hght_sz  = rs("orgnl_img_hght_sz") ' 원본이미지세로크기
'			orgnl_file_sz      = rs("orgnl_file_sz")     ' 원본파일크기
'			img_frm_cd         = rs("img_frm_cd")        ' 이미지형태코드 정사각형

			If (fso.FileExists(uploadFolder & file_name)) Then
				If True = objImage.SetSourceFile(uploadFolder & file_name) Then

					If orgnl_img_wdth_sz <= 600 Then
						dsply_img_wdth_sz = orgnl_img_wdth_sz
						dsply_img_hght_sz = orgnl_img_hght_sz
					Else
						dsply_img_wdth_sz = 600
						dsply_img_hght_sz = CInt(orgnl_img_hght_sz / (orgnl_img_wdth_sz / 600))
					End If

					Call objImage.SaveasThumbnail(dsplyFolder & dsply_file_nm, dsply_img_wdth_sz, dsply_img_hght_sz, false, true)
					Call objImage.SetSourceFile(dsplyFolder & dsply_file_nm)
					Set F = fso.GetFile(dsplyFolder & dsply_file_nm)
					Size = F.size              '// PRE 파일 사이즈 추출
					Set F = Nothing

					dsply_img_wdth_sz  = objImage.ImageWidth ' 전시이미지가로크기
					dsply_img_hght_sz  = objImage.ImageHeight ' 전시이미지세로크기
					dsply_file_nm      = dsply_file_nm ' 전시파일명
					dsply_file_sz      = Size ' 전시파일크기

					If orgnl_img_wdth_sz <= 300 Then
						thmbnl_img_wdth_sz = orgnl_img_wdth_sz
						thmbnl_img_hght_sz = orgnl_img_hght_sz
					Else
						thmbnl_img_wdth_sz = 300
						thmbnl_img_hght_sz = CInt(orgnl_img_hght_sz / (orgnl_img_wdth_sz / 300))
					End If

					Call objImage.SaveasThumbnail(thmbnlFolder & thmbnl_file_nm, thmbnl_img_wdth_sz, thmbnl_img_hght_sz, false, true)
					Call objImage.SetSourceFile(thmbnlFolder & thmbnl_file_nm)
					Set F = fso.GetFile(thmbnlFolder & thmbnl_file_nm)
					Size = F.size              '// PRE 파일 사이즈 추출
					Set F = Nothing

					thmbnl_img_wdth_sz = objImage.ImageWidth ' 썸네일이미지가로크기
					thmbnl_img_hght_sz = objImage.ImageHeight ' 썸네일이미지세로크기
					thmbnl_file_nm     = thmbnl_file_nm ' 썸네일파일명
					thmbnl_file_sz     = Size ' 썸네일파일크기
					
					sql = ""
					sql = sql & " update cf_album_attach                                   "
					sql = sql & "    set dsply_img_wdth_sz  = '" & dsply_img_wdth_sz  & "' "
					sql = sql & "       ,dsply_img_hght_sz  = '" & dsply_img_hght_sz  & "' "
					sql = sql & "       ,dsply_file_nm      = '" & dsply_file_nm      & "' "
					sql = sql & "       ,dsply_file_sz      = '" & dsply_file_sz      & "' "
					sql = sql & "       ,thmbnl_img_wdth_sz = '" & thmbnl_img_wdth_sz & "' "
					sql = sql & "       ,thmbnl_img_hght_sz = '" & thmbnl_img_hght_sz & "' "
					sql = sql & "       ,thmbnl_file_nm     = '" & thmbnl_file_nm     & "' "
					sql = sql & "       ,thmbnl_file_sz     = '" & thmbnl_file_sz     & "' "
					sql = sql & "  where attach_seq         = '" & attach_seq         & "' "
'					Response.write sql & "<br>"
					Conn.Execute(sql)
				End If
			Else
				Response.write uploadFolder & file_name & "<br>"
			End If

			rs.MoveNext
		Loop
	End If
	extime("test 실행시간")
%>

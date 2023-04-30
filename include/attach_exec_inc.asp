<%
	Dim atch_file_se_cd()
	Dim atch_rt_nm()
	Dim img_file_name()
	Dim file_sz()
	Dim file_extn_cd()
	Dim file_mimetype_cd()
	Dim dwnld_cnt()
	Dim orgnl_file_nm()
	Dim orgnl_file_sz()
	Dim orgnl_img_wdth_sz()
	Dim orgnl_img_hght_sz()

	Dim rprs_file_yn()
	Dim img_frm_cd()
	Dim dsply_file_nm()
	Dim dsply_file_sz()
	Dim dsply_img_wdth_sz()
	Dim dsply_img_hght_sz()
	Dim thmbnl_file_nm()
	Dim thmbnl_file_sz()
	Dim thmbnl_img_wdth_sz()
	Dim thmbnl_img_hght_sz()

	Set objImage = server.CreateObject("DEXT.ImageProc")

	attach_num = GetOneValue("isnull(max(attach_num), 0)", "" & tb_prefix & "_" & menu_type & "_attach", "where " & menu_type & "_seq = '" & com_seq & "'")
	attach_num1 = attach_num
	attach_num2 = attach_num

	img_i = 0

	For Each item In uploadform("img_file_name")
		If item <> "" Then
			IF item.FileLen <= uploadform.MaxFileLen Then
				'MimeType이 image/jpeg ,image/gif이 아닌경우 업로드 중단
				If GetImgMimeTypeYN(item.MimeType) = "Y" Then
					img_i = img_i + 1
					attach_num1 = attach_num1 + 1

					ReDim Preserve atch_file_se_cd(img_i)
					ReDim Preserve atch_rt_nm(img_i)
					ReDim Preserve file_extn_cd(img_i)
					ReDim Preserve file_mimetype_cd(img_i)
					ReDim Preserve img_file_name(img_i)
					ReDim Preserve file_sz(img_i)
					ReDim Preserve dwnld_cnt(img_i)
					ReDim Preserve orgnl_file_nm(img_i)
					ReDim Preserve orgnl_file_sz(img_i)
					ReDim Preserve orgnl_img_wdth_sz(img_i)
					ReDim Preserve orgnl_img_hght_sz(img_i)

					ReDim Preserve rprs_file_yn(img_i)
					ReDim Preserve img_frm_cd(img_i)
					ReDim Preserve dsply_file_nm(img_i)
					ReDim Preserve dsply_file_sz(img_i)
					ReDim Preserve dsply_img_wdth_sz(img_i)
					ReDim Preserve dsply_img_hght_sz(img_i)
					ReDim Preserve thmbnl_file_nm(img_i)
					ReDim Preserve thmbnl_file_sz(img_i)
					ReDim Preserve thmbnl_img_wdth_sz(img_i)
					ReDim Preserve thmbnl_img_hght_sz(img_i)

					atch_file_se_cd(img_i)  = "IMG" ' 첨부파일구분코드 IMG,DATA
					atch_rt_nm(img_i)       = uploadFolder
					file_extn_cd(img_i)     = Right(item.FileName, Len(item.FileName) - InStrRev(item.FileName, "."))
					file_mimetype_cd(img_i) = item.MimeType          ' 파일마임타입코드
					img_file_name(img_i)    = "IMG" & numc(Year(date), 4) & numc(Month(date), 2) & numc(Day(date), 2) & numc(Hour(Now), 2) & numc(Minute(Now), 2) & numc(Second(Now), 2) & numc(com_seq, 8) & numc(attach_num1, 3) & "." & file_extn_cd(img_i)
					Call item.SaveAs(img_file_name(img_i), False)
					img_file_name(img_i)    = item.LastSavedFileName ' 저장파일명
					file_sz(img_i)          = item.FileLen           ' 파일크기
					dwnld_cnt(img_i)        = 0                      ' 다운로드수
					orgnl_file_nm(img_i)    = item.FileName          ' 원본파일명
					orgnl_file_sz(img_i)    = item.FileLen           ' 원본파일크기

					If img_i = 1 Then
						rprs_file_yn(img_i) = "Y" ' 대표파일여부
					Else
						rprs_file_yn(img_i) = "N" ' 대표파일여부
					End If

					If True = objImage.SetSourceFile(uploadFolder & img_file_name(img_i)) Then
						orgnl_img_wdth_sz(img_i)  = objImage.ImageWidth ' 원본이미지가로크기
						orgnl_img_hght_sz(img_i)  = objImage.ImageHeight ' 원본이미지세로크기
						dsply_file_nm(img_i)      =  "DSPLY"  & numc(Year(date), 4) & numc(Month(date), 2) & numc(Day(date), 2) & numc(Hour(Now), 2) & numc(Minute(Now), 2) & numc(Second(Now), 2) & numc(com_seq, 8) & numc(attach_num1, 3) & ".jpg"
						thmbnl_file_nm(img_i)     =  "THMBNL" & numc(Year(date), 4) & numc(Month(date), 2) & numc(Day(date), 2) & numc(Hour(Now), 2) & numc(Minute(Now), 2) & numc(Second(Now), 2) & numc(com_seq, 8) & numc(attach_num1, 3) & ".jpg"

						If orgnl_img_wdth_sz(img_i) > orgnl_img_hght_sz(img_i) Then ' 가로형
							img_frm_cd(img_i)         = "HRZ" ' 이미지형태코드 가로형
						ElseIf orgnl_img_wdth_sz(img_i) > orgnl_img_hght_sz(img_i) Then ' 세로형
							img_frm_cd(img_i)         = "VTC" ' 이미지형태코드 세로형
						Else ' 정사각형
							img_frm_cd(img_i)         = "SQR" ' 이미지형태코드 정사각형
						End If

						If orgnl_img_wdth_sz(img_i) <= 600 Then
							dsply_img_wdth_sz(img_i) = orgnl_img_wdth_sz(img_i)
							dsply_img_hght_sz(img_i) = orgnl_img_hght_sz(img_i)
						Else
							dsply_img_wdth_sz(img_i) = 600
							dsply_img_hght_sz(img_i) = CInt(orgnl_img_hght_sz(img_i) / (orgnl_img_wdth_sz(img_i) / 600))
						End If

						Call objImage.SaveasThumbnail(dsplyFolder & dsply_file_nm(img_i), dsply_img_wdth_sz(img_i), dsply_img_hght_sz(img_i), false, true)
						Call objImage.SetSourceFile(dsplyFolder & dsply_file_nm(img_i))

						dsply_img_wdth_sz(img_i)  = objImage.ImageWidth  ' 전시이미지가로크기
						dsply_img_hght_sz(img_i)  = objImage.ImageHeight ' 전시이미지세로크기
						dsply_file_nm(img_i)      = dsply_file_nm(img_i) ' 전시파일명
						dsply_file_sz(img_i)      = objImage.FileLen     ' 전시파일크기

						If orgnl_img_wdth_sz(img_i) <= 300 Then
							thmbnl_img_wdth_sz(img_i) = orgnl_img_wdth_sz(img_i)
							thmbnl_img_hght_sz(img_i) = orgnl_img_hght_sz(img_i)
						Else
							thmbnl_img_wdth_sz(img_i) = 300
							thmbnl_img_hght_sz(img_i) = CInt(orgnl_img_hght_sz(img_i) / (orgnl_img_wdth_sz(img_i) / 300))
						End If

						Call objImage.SaveasThumbnail(thmbnlFolder & thmbnl_file_nm(img_i), thmbnl_img_wdth_sz(img_i), thmbnl_img_hght_sz(img_i), false, true)
						Call objImage.SetSourceFile(thmbnlFolder & thmbnl_file_nm(img_i))

						thmbnl_img_wdth_sz(img_i) = objImage.ImageWidth   ' 썸네일이미지가로크기
						thmbnl_img_hght_sz(img_i) = objImage.ImageHeight  ' 썸네일이미지세로크기
						thmbnl_file_nm(img_i)     = thmbnl_file_nm(img_i) ' 썸네일파일명
						thmbnl_file_sz(img_i)     = objImage.FileLen      ' 썸네일파일크기
					End If
				Else
					msgonly item.FileName & " 은 이미지파일이 아닙니다."
				End If
			Else
				msgonly item.FileName & " 은 파일의 크기가 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘습니다."
			End If
		End If
	Next

	For j = 1 To img_i
		If img_file_name(j) <> "" Then
			new_seq = GetComSeq("" & tb_prefix & "_" & menu_type & "_attach")
			attach_num2 = attach_num2 + 1

			sql = ""
			sql = sql & " insert into " & tb_prefix & "_" & menu_type & "_attach( "
			sql = sql & "        attach_seq                        "
			sql = sql & "       ," & menu_type & "_seq             "
			sql = sql & "       ,attach_num                        "

			sql = sql & "       ,atch_file_se_cd                   "
			sql = sql & "       ,atch_rt_nm                        "
			sql = sql & "       ,file_extn_cd                      "
			sql = sql & "       ,file_mimetype_cd                  "
			sql = sql & "       ,file_name                         "
			sql = sql & "       ,file_sz                           "
			sql = sql & "       ,dwnld_cnt                         "
			sql = sql & "       ,orgnl_file_nm                     "
			sql = sql & "       ,orgnl_file_sz                     "
			sql = sql & "       ,orgnl_img_wdth_sz                 "
			sql = sql & "       ,orgnl_img_hght_sz                 "

			sql = sql & "       ,rprs_file_yn                      "
			sql = sql & "       ,img_frm_cd                        "
			sql = sql & "       ,dsply_file_nm                     "
			sql = sql & "       ,dsply_file_sz                     "
			sql = sql & "       ,dsply_img_wdth_sz                 "
			sql = sql & "       ,dsply_img_hght_sz                 "
			sql = sql & "       ,thmbnl_file_nm                    "
			sql = sql & "       ,thmbnl_file_sz                    "
			sql = sql & "       ,thmbnl_img_wdth_sz                "
			sql = sql & "       ,thmbnl_img_hght_sz                "

			sql = sql & "       ,user_id                           "
			sql = sql & "       ,reg_date                          "
			sql = sql & "       ,creid                             "
			sql = sql & "       ,credt                             "
			sql = sql & "      ) values(                           "
			sql = sql & "        '" & new_seq                 & "' "
			sql = sql & "       ,'" & com_seq                 & "' "
			sql = sql & "       ,'" & attach_num2             & "' "

			sql = sql & "       ,'" & atch_file_se_cd(j)      & "' "
			sql = sql & "       ,'" & atch_rt_nm(j)           & "' "
			sql = sql & "       ,'" & file_extn_cd(j)         & "' "
			sql = sql & "       ,'" & file_mimetype_cd(j)     & "' "
			sql = sql & "       ,'" & img_file_name(j)        & "' "
			sql = sql & "       ,'" & file_sz(j)              & "' "
			sql = sql & "       ,'" & dwnld_cnt(j)            & "' "
			sql = sql & "       ,'" & orgnl_file_nm(j)        & "' "
			sql = sql & "       ,'" & orgnl_file_sz(j)        & "' "
			sql = sql & "       ,'" & orgnl_img_wdth_sz(j)    & "' "
			sql = sql & "       ,'" & orgnl_img_hght_sz(j)    & "' "

			sql = sql & "       ,'" & rprs_file_yn(j)         & "' "
			sql = sql & "       ,'" & img_frm_cd(j)           & "' "
			sql = sql & "       ,'" & dsply_file_nm(j)        & "' "
			sql = sql & "       ,'" & dsply_file_sz(j)        & "' "
			sql = sql & "       ,'" & dsply_img_wdth_sz(j)    & "' "
			sql = sql & "       ,'" & dsply_img_hght_sz(j)    & "' "
			sql = sql & "       ,'" & thmbnl_file_nm(j)       & "' "
			sql = sql & "       ,'" & thmbnl_file_sz(j)       & "' "
			sql = sql & "       ,'" & thmbnl_img_wdth_sz(j)   & "' "
			sql = sql & "       ,'" & thmbnl_img_hght_sz(j)   & "' "

			sql = sql & "       ,'" & Session("user_id")      & "' "
			sql = sql & "       ,'" & Date()                  & "' "
			sql = sql & "       ,'" & Session("user_id")      & "' "
			sql = sql & "       ,getdate())                        "
			Conn.Execute(sql)
		End If
	Next

	data_i = 0
	For Each item In uploadform("data_file_name")
		If item <> "" Then
			IF item.FileLen <= uploadform.MaxFileLen Then
				If GetImgMimeTypeYN(item.MimeType) = "Y" Or GetDataMimeTypeYN(item.MimeType) = "Y" Then
					data_i = data_i + 1
					attach_num1 = attach_num1 + 1

					ReDim Preserve atch_file_se_cd(data_i)
					ReDim Preserve atch_rt_nm(data_i)
					ReDim Preserve file_extn_cd(data_i)
					ReDim Preserve file_mimetype_cd(data_i)
					ReDim Preserve data_file_name(data_i)
					ReDim Preserve file_sz(data_i)
					ReDim Preserve dwnld_cnt(data_i)
					ReDim Preserve orgnl_file_nm(data_i)
					ReDim Preserve orgnl_file_sz(data_i)
					ReDim Preserve orgnl_img_wdth_sz(data_i)
					ReDim Preserve orgnl_img_hght_sz(data_i)

					atch_file_se_cd(data_i)  = "DATA" ' 첨부파일구분코드 IMG,DATA
					atch_rt_nm(data_i)       = uploadFolder
					file_extn_cd(data_i)     = Right(item.FileName, Len(item.FileName) - InStrRev(item.FileName, "."))
					file_mimetype_cd(data_i) = item.MimeType ' 파일마임타입코드
					data_file_name(data_i)   = "DATA" & numc(Year(date), 4) & numc(Month(date), 2) & numc(Day(date), 2) & numc(Hour(Now), 2) & numc(Minute(Now), 2) & numc(Second(Now), 2) & numc(com_seq, 8) & numc(attach_num1, 3) & "." & file_extn_cd(data_i)
					Call item.SaveAs(data_file_name(data_i), False)
					data_file_name(data_i)   = item.LastSavedFileName
					file_sz(data_i)          = item.FileLen ' 파일크기
					dwnld_cnt(data_i)        = 0             ' 다운로드수
					orgnl_file_nm(data_i)    = item.FileName
					orgnl_file_sz(data_i)    = item.FileLen' 원본파일크기

					If True = objImage.SetSourceFile(uploadFolder & data_file_name(data_i)) Then
						orgnl_img_wdth_sz(data_i) = objImage.ImageWidth ' 원본이미지가로크기
						orgnl_img_hght_sz(data_i) = objImage.ImageHeight ' 원본이미지세로크기
					End If
				Else
					msgonly item.FileName & " 은 허용되지 않는 파일입니다."
				End If
			Else
				msgonly item.FileName & " 은 파일의 크기가 " & CInt(uploadform.MaxFileLen/1024/1014) & "MB가 넘습니다."
			End If
		End If
	Next

	For j = 1 To data_i
		If data_file_name(j) <> "" Then
			new_seq = GetComSeq("" & tb_prefix & "_" & menu_type & "_attach")
			attach_num2 = attach_num2 + 1

			sql = ""
			sql = sql & " insert into " & tb_prefix & "_" & menu_type & "_attach( "
			sql = sql & "        attach_seq                        "
			sql = sql & "       ," & menu_type & "_seq             "
			sql = sql & "       ,attach_num                        "

			sql = sql & "       ,atch_file_se_cd                   "
			sql = sql & "       ,atch_rt_nm                        "
			sql = sql & "       ,file_extn_cd                      "
			sql = sql & "       ,file_mimetype_cd                  "
			sql = sql & "       ,file_name                         "
			sql = sql & "       ,file_sz                           "
			sql = sql & "       ,dwnld_cnt                         "
			sql = sql & "       ,orgnl_file_nm                     "
			sql = sql & "       ,orgnl_file_sz                     "
			sql = sql & "       ,orgnl_img_wdth_sz                 "
			sql = sql & "       ,orgnl_img_hght_sz                 "

			sql = sql & "       ,user_id                           "
			sql = sql & "       ,reg_date                          "
			sql = sql & "       ,creid                             "
			sql = sql & "       ,credt                             "
			sql = sql & "      ) values(                           "
			sql = sql & "        '" & new_seq                 & "' "
			sql = sql & "       ,'" & com_seq                 & "' "
			sql = sql & "       ,'" & attach_num2             & "' "

			sql = sql & "       ,'" & atch_file_se_cd(j)      & "' "
			sql = sql & "       ,'" & atch_rt_nm(j)           & "' "
			sql = sql & "       ,'" & file_extn_cd(j)         & "' "
			sql = sql & "       ,'" & file_mimetype_cd(j)     & "' "
			sql = sql & "       ,'" & data_file_name(j)       & "' "
			sql = sql & "       ,'" & file_sz(j)              & "' "
			sql = sql & "       ,'" & dwnld_cnt(j)            & "' "
			sql = sql & "       ,'" & orgnl_file_nm(j)        & "' "
			sql = sql & "       ,'" & orgnl_file_sz(j)        & "' "
			sql = sql & "       ,'" & orgnl_img_wdth_sz(j)    & "' "
			sql = sql & "       ,'" & orgnl_img_hght_sz(j)    & "' "

			sql = sql & "       ,'" & Session("user_id")      & "' "
			sql = sql & "       ,'" & Date()                  & "' "
			sql = sql & "       ,'" & Session("user_id")      & "' "
			sql = sql & "       ,getdate())                        "
			Conn.Execute(sql)
		End If
	Next
%>

<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	uploadFolder = ConfigAttachedFileFolder & "album\"
	uploadform.DefaultPath = uploadFolder
	dsplyFolder  = ConfigAttachedFileFolder & "display\album\"
	thmbnlFolder = ConfigAttachedFileFolder & "thumbnail\album\"

	menu_seq  = uploadform("menu_seq")
	page_type = uploadform("page_type")
	page      = uploadform("page")
	sch_type  = uploadform("sch_type")
	sch_word  = uploadform("sch_word")

	album_seq = uploadform("album_seq")
	group_num = uploadform("group_num") ' 답글에 대한 원본 글
	level_num = uploadform("level_num")
	step_num = uploadform("step_num")
	menu_seq = uploadform("menu_seq")
	page_type = uploadform("page_type")
	subject = Replace(uploadform("subject"),"'"," & #39;")
	ir1 = Replace(uploadform("ir1"),"'"," & #39;")
	link = uploadform("link")
	If link = "http://" Then link = ""
	top_yn = uploadform("top_yn")

	For Each item In uploadform("file_name")
		If item <> "" Then
			IF item.FileLen > UploadForm.MaxFileLen Then
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

	new_seq = getSeq("cf_album")

	Set rs = server.createobject("adodb.recordset")

	i = 0
	For Each item In uploadform("file_name")
		If item <> "" Then
			'MimeType이 image/jpeg ,image/gif이 아닌경우 업로드 중단
			IF instr("image/jpeg/image/jpg,image/gif,image/png,image/bmp", MimeType) Then
				i = i + 1
				MimeType  = item.MimeType
				file_name = item.FileName

				file_extn_cd = right(file_name,len(file_name)-instr(file_name,"."))

				If i = "1" Then
					rprs_file_yn = "Y" ' 대표파일여부
				Else
					rprs_file_yn = "N" ' 대표파일여부
				End If

				file_sz            = item.FileLength ' 파일크기
				dwnld_cnt          = 0 ' 다운로드수
				atch_file_se_cd    =  ' 첨부파일구분코드
				file_mimetype_cd   = item.MimeType ' 파일마임타입코드
				orgnl_file_sz      = item.FileLength ' 원본파일크기

				item.Save(,False)
				file_name = item.LastSavedFileName

				Set objImage = server.CreateObject("DEXT.ImageProc")

				If True = objImage.SetSourceFile(uploadFolder & file_name) Then

					orgnl_img_wdth_sz  = objImage.ImageWidth ' 원본이미지가로크기
					orgnl_img_hght_sz  = objImage.ImageHeight ' 원본이미지세로크기

					If orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' 가로형
						img_frm_cd         = "HRZ" ' 이미지형태코드 가로형
					ElseIf orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' 세로형
						img_frm_cd         = "VTC" ' 이미지형태코드 세로형
					Else ' 정사각형
						img_frm_cd         = "SQR" ' 이미지형태코드 정사각형
					End If

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
				End If
			Else
				msgonly uploadform.FileName & " 은 이미지파일이 아닙니다."
			End If
		End If
	Next

	If group_num = "" Then ' 새글
		parent_seq = ""
		album_num = getNum("album", cafe_id, menu_seq)
		group_num = album_num
		level_num = 0
		step_num = 0
	Else ' 답글
		parent_seq = album_seq

		level_num = level_num + 1

		sql = ""
		sql = sql & " update cf_album "
		sql = sql & "    set step_num = step_num + 1 "
		sql = sql & "  where menu_seq = " & menu_seq  & " "
		sql = sql & "    and group_num = " & group_num  & " "
		sql = sql & "    and step_num > " & step_num  & " "
		Conn.execute sql

		step_num = step_num + 1
	End If

	sql = ""
	sql = sql & " insert into cf_album( "
	sql = sql & "        album_seq "
	sql = sql & "       ,parent_seq "
	sql = sql & "       ,group_num "
	sql = sql & "       ,level_num "
	sql = sql & "       ,step_num "
	sql = sql & "       ,album_num "
	sql = sql & "       ,cafe_id "
	sql = sql & "       ,menu_seq "
	sql = sql & "       ,agency "
	sql = sql & "       ,subject "
	sql = sql & "       ,contents "
	sql = sql & "       ,thumbnail "
	sql = sql & "       ,view_cnt "
	sql = sql & "       ,suggest_cnt "
	sql = sql & "       ,comment_cnt "
	sql = sql & "       ,link "
	sql = sql & "       ,top_yn "
	sql = sql & "       ,user_id "
	sql = sql & "       ,creid "
	sql = sql & "       ,credt "
	sql = sql & "      ) values ( "
	sql = sql & "        '" & new_seq & "' "
	sql = sql & "       ,'" & parent_seq & "' "
	sql = sql & "       ,'" & group_num & "' "
	sql = sql & "       ,'" & level_num & "' "
	sql = sql & "       ,'" & step_num & "' "
	sql = sql & "       ,'" & album_num & "' "
	sql = sql & "       ,'" & cafe_id & "' "
	sql = sql & "       ,'" & menu_seq & "' "
	sql = sql & "       ,'" & Session("agency") & "' "
	sql = sql & "       ,'" & subject & "' "
	sql = sql & "       ,'" & ir1 & "' "
	sql = sql & "       ,'" & thumbnail & "' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'0' "
	sql = sql & "       ,'" & link & "' "
	sql = sql & "       ,'" & top_yn & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,'" & Session("user_id") & "' "
	sql = sql & "       ,getdate())"
	Conn.Execute(sql)
	
	sql = ""
	sql = sql & " update cf_menu "
	sql = sql & "    set top_cnt = (select count(*) from cf_album where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
	sql = sql & "       ,last_date = getdate() "
	sql = sql & "       ,modid = '" & Session("user_id") & "' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	Conn.Execute(sql)

	sql = ""
	sql = sql & " delete "
	sql = sql & "   from cf_temp_album "
	sql = sql & "  where menu_seq = '" & menu_seq  & "' "
	sql = sql & "    and cafe_id = '" & cafe_id  & "' "
	sql = sql & "    and user_id = '" & user_id  & "' "
	Conn.Execute(sql)

	album_seq = new_seq

	For Each item In uploadform("file_name")
		If item <> "" Then
			file_name = item.LastSavedFileName

			new_seq = getSeq("cf_album_attach")

			sql = ""
			sql = sql & " insert into cf_album_attach( "
			sql = sql & "        attach_seq "
			sql = sql & "       ,album_seq "
			sql = sql & "       ,file_name "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) values( "
			sql = sql & "        '" & new_seq & "' "
			sql = sql & "       ,'" & album_seq & "' "
			sql = sql & "       ,'" & file_name & "' "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate()) "
			Conn.Execute(sql)
		End If
	Next

	Set UploadForm = Nothing

	If Err.Number = 0 Then
		conn.CommitTrans
		conn.Close
		Set conn = Nothing
%>
<script src="//code.jquery.com/jquery.min.js"></script>
<script>
	var cValue = "";
	var cDay = 1;
	var cName = "subject";
	var expire = new Date();
	expire.setDate(expire.getDate() + cDay);
	cookies = cName + '=' + escape(cValue) + '; path=/ '; // 한글 깨짐을 막기위해 escape(cValue)를 합니다.
	if (typeof cDay != 'undefined') cookies += ';expires=' + expire.toGMTString() + ';';
	document.cookie = cookies;

	alert("입력 되었습니다.");
	parent.location.href='album_list.asp?menu_seq=<%=menu_seq%>&page=<%=page%>&sch_type=<%=sch_type%>&sch_word=<%=sch_word%>';
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

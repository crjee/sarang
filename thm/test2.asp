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
'			file_extn_cd       = rs("file_extn_cd")      ' ����Ȯ�����ڵ�
'			rprs_file_yn       = rs("rprs_file_yn")      ' ��ǥ���Ͽ���
'			file_sz            = rs("file_sz")           ' ����ũ��
'			dwnld_cnt          = rs("dwnld_cnt")         ' �ٿ�ε��
'			atch_file_se_cd    = rs("atch_file_se_cd")   ' ÷�����ϱ����ڵ�
'			file_mimetype_cd   = rs("file_mimetype_cd")  ' ���ϸ���Ÿ���ڵ�
			orgnl_img_wdth_sz  = rs("orgnl_img_wdth_sz") ' �����̹�������ũ��
			orgnl_img_hght_sz  = rs("orgnl_img_hght_sz") ' �����̹�������ũ��
'			orgnl_file_sz      = rs("orgnl_file_sz")     ' ��������ũ��
'			img_frm_cd         = rs("img_frm_cd")        ' �̹��������ڵ� ���簢��

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
					Size = F.size              '// PRE ���� ������ ����
					Set F = Nothing

					dsply_img_wdth_sz  = objImage.ImageWidth ' �����̹�������ũ��
					dsply_img_hght_sz  = objImage.ImageHeight ' �����̹�������ũ��
					dsply_file_nm      = dsply_file_nm ' �������ϸ�
					dsply_file_sz      = Size ' ��������ũ��

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
					Size = F.size              '// PRE ���� ������ ����
					Set F = Nothing

					thmbnl_img_wdth_sz = objImage.ImageWidth ' ������̹�������ũ��
					thmbnl_img_hght_sz = objImage.ImageHeight ' ������̹�������ũ��
					thmbnl_file_nm     = thmbnl_file_nm ' ��������ϸ�
					thmbnl_file_sz     = Size ' ���������ũ��
					
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
	extime("test ����ð�")
%>

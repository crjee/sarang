<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set uploadform = Server.CreateObject("DEXT.FileUpload")
	Set objImage = server.CreateObject("DEXT.ImageProc")
	Set fso = CreateObject("Scripting.FileSystemObject")

	uploadFolder = ConfigAttachedFileFolder & "album\"

	sql = ""
	sql = sql & " select 'update ' + table_name + ' set credt = reg_date where (credt is null or credt = '''') and not (reg_date is null or reg_date = '''')' as updSql "
	sql = sql & "       ,'select * from ' + table_name + ' where (credt is null or credt = '''') and not (reg_date is null or reg_date = '''')' as selSql "
	sql = sql & "   from INFORMATION_SCHEMA.COLUMNS IC "
	sql = sql & "  where table_name like 'cf_%' "
	sql = sql & "    and COLUMN_NAME = 'reg_date' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
			updSql = rs("updSql")
			Conn.Execute(updSql)

			rs.MoveNext
		Loop
	End If
	rs.close
	extime("����Ͻ�ó�� ����ð�")

	sql = ""
	sql = sql & " select 'update cf_album_attach set attach_num = ''' + convert(varchar(10), ROW_NUMBER() over(partition by album_seq order by attach_num),1) + ''' where attach_seq = ' + convert(varchar(10), attach_seq,1) as updSql "
	sql = sql & "   from cf_album_attach                                                                                                                                                                                                "
	sql = sql & "  where attach_num is null                                                                                                                                                                                             "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
			updSql = rs("updSql")
			Conn.Execute(updSql)

			rs.MoveNext
		Loop
	End If
	rs.close
	extime("÷�μ���ó�� ����ð�")

	sql = ""
	sql = sql & " select ca.*                                                        "
	sql = sql & "       ,FORMAT(cast(credt as datetime), 'yyyyMMddHHmmss') credt_txt "
	sql = sql & "   from cf_album_attach ca                                          "
	sql = sql & "  where file_sz is null                                             "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
			attach_seq = rs("attach_seq")
			attach_num = rs("attach_num")
			file_name  = rs("file_name")
			credt_txt  = rs("credt_txt")

			If (fso.FileExists(uploadFolder & file_name)) Then
				If True = objImage.SetSourceFile(uploadFolder & file_name) Then
					Set F = fso.GetFile(uploadFolder & file_name)
					Size = F.size              '// PRE ���� ������ ����
					Set F = Nothing

					file_extn_cd       = objImage.ImageFormat ' ����Ȯ�����ڵ�
					If attach_num = "1" Then
					rprs_file_yn       = "Y" ' ��ǥ���Ͽ���
					Else
					rprs_file_yn       = "N" ' ��ǥ���Ͽ���
					End If
					file_sz            = Size ' ����ũ��
					dwnld_cnt          = 0 ' �ٿ�ε��
	'				atch_file_se_cd    =  ' ÷�����ϱ����ڵ�
'					file_mimetype_cd   = uploadform.MimeType ' ���ϸ���Ÿ���ڵ�
					orgnl_img_wdth_sz  = objImage.ImageWidth ' �����̹�������ũ��
					orgnl_img_hght_sz  = objImage.ImageHeight ' �����̹�������ũ��
					orgnl_file_sz      = Size ' ��������ũ��

					If orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' ������
						img_frm_cd         = "HRZ" ' �̹��������ڵ� ������
					ElseIf orgnl_img_wdth_sz > orgnl_img_hght_sz Then ' ������
						img_frm_cd         = "VTC" ' �̹��������ڵ� ������
					Else ' ���簢��
						img_frm_cd         = "SQR" ' �̹��������ڵ� ���簢��
					End If

					dsply_img_wdth_sz  = "" ' �����̹�������ũ��
					dsply_img_hght_sz  = "" ' �����̹�������ũ��
					dsply_file_nm      = "" ' �������ϸ�
					dsply_file_sz      = "" ' ��������ũ��
					thmbnl_img_wdth_sz = "" ' ������̹�������ũ��
					thmbnl_img_hght_sz = "" ' ������̹�������ũ��
					thmbnl_file_nm     = "" ' ��������ϸ�
					thmbnl_file_sz     = "" ' ���������ũ��

					sql = ""
					sql = sql & " update cf_album_attach                                 "
					sql = sql & "    set file_extn_cd      = '" & file_extn_cd      & "' "
					sql = sql & "       ,rprs_file_yn      = '" & rprs_file_yn      & "' "
					sql = sql & "       ,file_sz           = '" & file_sz           & "' "
					sql = sql & "       ,dwnld_cnt         = '" & dwnld_cnt         & "' "
					sql = sql & "       ,file_mimetype_cd  = '" & file_mimetype_cd  & "' "
					sql = sql & "       ,orgnl_img_wdth_sz = '" & orgnl_img_wdth_sz & "' "
					sql = sql & "       ,orgnl_img_hght_sz = '" & orgnl_img_hght_sz & "' "
					sql = sql & "       ,orgnl_file_sz     = '" & orgnl_file_sz     & "' "
					sql = sql & "       ,img_frm_cd        = '" & img_frm_cd        & "' "
					sql = sql & "  where attach_seq        = '" & attach_seq        & "' "
'					Response.write sql & "<br>"
					Conn.Execute(sql)
				End If
			Else
				Response.write uploadFolder & file_name & "<br>"
			End If

			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing

	extime("÷������ó�� ����ð�")
%>

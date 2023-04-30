<%
	Set acctRs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & "   with cd1                                                     "
	sql = sql & "     as (                                                       "
	sql = sql & "         select cmn_cd                                          "
	sql = sql & "               ,cd_nm                                           "
	sql = sql & "           from cf_code                                         "
	sql = sql & "          where up_cd_id = (select cd_id                        "
	sql = sql & "                              from cf_code                      "
	sql = sql & "                             where up_cd_id = 'CD0000000000'    "
	sql = sql & "                               and cmn_cd = 'img_file_extn_cd'  "
	sql = sql & "                           )                                    "
	sql = sql & "        )                                                       "
	sql = sql & " select stuff((select ', '+ cmn_cd                              "
	sql = sql & "                 from cd1                                       "
	sql = sql & "                  for xml path('')                              "
	sql = sql & "             ), 1, 1, '') as img_file_extn                      "
	acctRs.CursorType = 3
	acctRs.CursorLocation = 3
	acctRs.LockType = 3
	acctRs.Open SQL, conn

	If Not acctRs.eof Then
		img_file_extn = acctRs("img_file_extn")
	End If
	acctRs.close

	sql = ""
	sql = sql & "   with cd1                                                     "
	sql = sql & "     as (                                                       "
	sql = sql & "         select cmn_cd                                          "
	sql = sql & "               ,cd_nm                                           "
	sql = sql & "           from cf_code                                         "
	sql = sql & "          where up_cd_id = (select cd_id                        "
	sql = sql & "                              from cf_code                      "
	sql = sql & "                             where up_cd_id = 'CD0000000000'    "
	sql = sql & "                               and cmn_cd = 'data_file_extn_cd' "
	sql = sql & "                           )                                    "
	sql = sql & "        )                                                       "
	sql = sql & " select stuff((select ', '+ cmn_cd                              "
	sql = sql & "                 from cd1                                       "
	sql = sql & "                  for xml path('')                              "
	sql = sql & "             ), 1, 1, '') as data_file_extn                     "
	acctRs.CursorType = 3
	acctRs.CursorLocation = 3
	acctRs.LockType = 3
	acctRs.Open SQL, conn

	If Not acctRs.eof Then
		data_file_extn = acctRs("data_file_extn")
	End If
	acctRs.close

	If menu_type = "album" Or menu_type = "nsale" Then
%>
					<script>
						function addImgFile() {
							try{
								var imgFileCnt = Number($("#imgFileCnt").val());
								var imgFormCnt = Number($("#imgFormCnt").val());

								if ((imgFileCnt + imgFormCnt) < 10) {
									$("#imgFormCnt").val(++imgFormCnt) ;
									for (i=1;i<=imgFormCnt;i++) {
										eval("attcImgForm"+i+".style.display='block'")
									}
								}
							} catch(e) {
								alert(e)
							}
						}
						function delImgFile() {
							var imgFormCnt = Number($("#imgFormCnt").val());
							eval("attcImgForm"+imgFormCnt+".style.display='none'");
							$("#imgFormCnt").val(Number(imgFormCnt)-1);
							$("input[name=img_file_name]").eq(imgFormCnt-1).val("");
						}
					</script>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
								<th scope="row" class="add_files">
									이미지 파일
									<div class="dp_inline">
										<button type="button" class="btn btn_inp_add" onclick="addImgFile()"><em>추가</em></button>
										<button type="button" class="btn btn_inp_del" onclick="delImgFile()"><em>삭제</em></button>
									</div>
									<%=data_file_extn%>
								</th>
								<td>
									<ul>
<%
		If com_seq <> "" Then
			sql = ""
			sql = sql & "  with cd1                                                    "
			sql = sql & "    as (                                                      "
			sql = sql & "        select cmn_cd                                         "
			sql = sql & "              ,cd_nm                                          "
			sql = sql & "          from cf_code                                        "
			sql = sql & "         where up_cd_id = (select cd_id                       "
			sql = sql & "                             from cf_code                     "
			sql = sql & "                            where up_cd_id = 'CD0000000000'   "
			sql = sql & "                              and cmn_cd = 'img_file_extn_cd' "
			sql = sql & "                          )                                   "
			sql = sql & "       )                                                      "
			sql = sql & " select ca.*                                                  "
			sql = sql & "   from " & tb_prefix & "_" & menu_type & "_attach ca         "
			sql = sql & "  inner join cd1 on cd1.cmn_cd = ca.file_extn_cd              "
			sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "'             "
			acctRs.CursorType = 3
			acctRs.CursorLocation = 3
			acctRs.LockType = 3
			acctRs.Open SQL, conn
			imgFileCnt = acctRs.recordCount

			i = 1
			If Not acctRs.eof Then
				Do Until acctRs.eof
					attach_seq    = acctRs("attach_seq")
					file_name     = acctRs("file_name")
					orgnl_file_nm = acctRs("orgnl_file_nm")
%>
										<li class="" id="attachFile<%=i%>">
											<button type="button" class="btn btn_c_n btn_s" onclick="goFileDelete('<%=attach_seq%>', '<%=i%>')">삭제</button>
											<span class="posr"><em><%=orgnl_file_nm%></em></span>
										</li>
<%
					i = i + 1
					acctRs.MoveNext
				Loop
			End If
			acctRs.close
		End If

		For i = 1 To 10
%>
										<li class="stxt" id="attcImgForm<%=i%>" style="display:<%=if3(i=1,"block","none")%>">
											<input type="file" class="inp" name="img_file_name">
										</li>
<%
		Next
%>
									</ul>
								</td>
							</tr>
							<input type="hidden" id="imgFileCnt" name="imgFileCnt" value="<%=imgFileCnt%>">
							<input type="hidden" id="imgFormCnt" name="imgFormCnt" value="1">
						</tbody>
					</table>
					<p class="txt_point mt10">이미지 파일 : <%=img_file_extn%> 파일만 등록 가능합니다.</p>
<%
	End If
%>
					<script>
						function addDataFile() {
							try{
								var dataFileCnt = Number($("#dataFileCnt").val());
								var dataFormCnt = Number($("#dataFormCnt").val());

								if ((dataFileCnt + dataFormCnt) < 10) {
									$("#dataFormCnt").val(++dataFormCnt) ;
									for (i=1;i<=dataFormCnt;i++) {
										eval("attcDataForm"+i+".style.display='block'")
									}
								}
							} catch(e) {
								alert(e)
							}
						}
						function delDataFile() {
							var dataFormCnt = Number($("#dataFormCnt").val());
							eval("attcDataForm"+dataFormCnt+".style.display='none'");
							$("#dataFormCnt").val(Number(dataFormCnt)-1);
							$("input[name=data_file_name]").eq(dataFormCnt-1).val("");
						}
						function goFileDelete(attach_seq, delSeq) {
							//hiddenfrm.location.href = 'com_attach_del_exec.asp?menu_seq=<%=menu_seq%>&attach_seq=' + attach_seq + '&delSeq=' + delSeq;
							location.href = 'com_attach_del_exec.asp?menu_seq=<%=menu_seq%>&attach_seq=' + attach_seq + '&delSeq=' + delSeq;
						}
					</script>
					<table class="tb_input tb_fixed mt10">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row" class="add_files">
									자료 파일&nbsp;&nbsp;&nbsp;&nbsp;
									<div class="dp_inline">
										<button type="button" class="btn btn_inp_add" onclick="addDataFile()"><em>추가</em></button>
										<button type="button" class="btn btn_inp_del" onclick="delDataFile()"><em>삭제</em></button>
									</div>
									
								</th>
								<td>
									<ul>
<%
	If com_seq <> "" Then
		sql = ""
		sql = sql & "  with cd1                                                     "
		sql = sql & "    as (                                                       "
		sql = sql & "        select cmn_cd                                          "
		sql = sql & "              ,cd_nm                                           "
		sql = sql & "          from cf_code                                         "
		sql = sql & "         where up_cd_id in (select cd_id                       "
		sql = sql & "                             from cf_code                      "
		sql = sql & "                            where up_cd_id = 'CD0000000000'    "
		sql = sql & "                              and cmn_cd = 'img_file_extn_cd'  "
		sql = sql & "                               or cmn_cd = 'data_file_extn_cd' "
		sql = sql & "                          )                                    "
		sql = sql & "       )                                                       "
		sql = sql & " select ca.*                                                   "
		sql = sql & "   from " & tb_prefix & "_" & menu_type & "_attach ca          "
		sql = sql & "  inner join cd1 on cd1.cmn_cd = ca.file_extn_cd               "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "'              "
		acctRs.CursorType = 3
		acctRs.CursorLocation = 3
		acctRs.LockType = 3
		acctRs.Open SQL, conn
		dataFileCnt = acctRs.recordCount

		i = 1
		If Not acctRs.eof Then
			Do Until acctRs.eof
				attach_seq    = acctRs("attach_seq")
				file_name     = acctRs("file_name")
				orgnl_file_nm = acctRs("orgnl_file_nm")
%>
										<li class="" id="attachFile<%=i%>">
											<button type="button" class="btn btn_c_n btn_s" onclick="goFileDelete('<%=attach_seq%>', '<%=i%>')">삭제</button>
											<span class="posr"><em><%=orgnl_file_nm%></em></span>
										</li>
<%
				i = i + 1
				acctRs.MoveNext
			Loop
		End If
		acctRs.close
	End If

	For i = 1 To 10
%>
										<li class="stxt" id="attcDataForm<%=i%>" style="display:<%=if3(i=1,"block","none")%>">
											<input type="file" class="inp" name="data_file_name">
										</li>
<%
	Next
%>
									</ul>
								</td>
							</tr>
							<input type="hidden" id="dataFileCnt" name="dataFileCnt" value="<%=dataFileCnt%>">
							<input type="hidden" id="dataFormCnt" name="dataFormCnt" value="1">
						</tbody>
					</table>
					<p class="txt_point mt10">자료 파일 : <%=img_file_extn%>, <%=data_file_extn%> 파일만 등록 가능합니다.</p>
<%
	Set acctRs = Nothing
%>

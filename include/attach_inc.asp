							<tr>
								<script>
								function addAttach() {
									try{
										var fileCnt = Number($("#fileCnt").val());
										var formCnt = Number($("#formCnt").val());
										if (fileCnt + formCnt < 10) {
											$("#formCnt").val(++formCnt) ;
											for (i=1;i<=formCnt;i++) {
												eval("attachForm"+i+".style.display='block'")
											}
										}
									} catch(e) {
										alert(e)
									}
								}
								function delAttach() {
									var formCnt = Number($("#formCnt").val());
									eval("attachForm"+formCnt+".style.display='none'");
									$("#formCnt").val(Number(formCnt)-1);
								}
								</script>
								<th scope="row" class="add_files">
									첨부파일
									<div class="dp_inline">
										<button type="button" class="btn btn_inp_add" onclick="addAttach()"><em>추가</em></button>
										<button type="button" class="btn btn_inp_del" onclick="delAttach()"><em>삭제</em></button>
									</div>
								</th>
								<td>
									<ul>
<%
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_" & menu_type & "_attach "
	sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
	rs.Open Sql, conn, 3, 1
	fileCnt = rs.recordCount

	i = 1
	If Not rs.eof Then
		Do Until rs.eof
			attach_seq = rs("attach_seq")
			file_name  = rs("file_name")
%>
										<li class="stxt" id="attachFile<%=i%>">
											<input type="button" onclick="javascript: hiddenfrm.location.href='com_attach_exec.asp?menu_seq=<%=menu_seq%>&attach_seq=<%=attach_seq%>&delSeq=<%=i%>'" value="삭제"> <%=file_name%>
										</li>
<%
			i = i + 1
			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing

	For i = 1 To 10
%>
										<li class="stxt" id="attachForm<%=i%>" style="display:<%=if3(i=1,"block","none")%>">
											<input type="file" class="inp" name="file_name">
										</li>
<%
	Next
%>
									</ul>
								</td>
							</tr>
							<input type="hidden" id="fileCnt" name="fileCnt" value="<%=fileCnt%>">
							<input type="hidden" id="formCnt" name="formCnt" value="1">

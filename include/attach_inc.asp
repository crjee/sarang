							<tr>
								<script>
								function addAttach() {
									try{
										var attachCnt = Number($("#attachCnt").val());
										if (attachCnt <= 10) {
											$("#attachCnt").val(++attachCnt) ;
											for (i=2;i<attachCnt;i++) {
												eval("attachDiv"+i+".style.display='block'")
											}
										}
									} catch(e) {
										alert(e)
									}
								}
								function delAttach() {
									var attachCnt = $("#attachCnt").val();
									eval("attachDiv"+attachCnt+".style.display='none'");
									$("#attachCnt").val(Number(attachCnt)-1);
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

	i = 1
	If rs.eof Then
%>
										<li class="stxt" id="attachDiv<%=i%>">
											<input type="file" class="inp" name="file_name">
										</li>
<%
		i = i + 1
	Else
		Do Until rs.eof
			attach_seq = rs("attach_seq")
			file_name  = rs("file_name")
%>
										<li class="stxt" id="attachDiv<%=i%>">
											<input type="button" onclick="javascript:hiddenfrm.location.href='com_attach_exec.asp?menu_seq=<%=menu_seq%>&attach_seq=<%=attach_seq%>&ag=<%=i%>'" value="삭제"> <%=file_name%>
										</li>
<%
			i = i + 1
			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing

	For j = i To 10
%>
										<li class="stxt" id="attachDiv<%=j%>" style="display:none">
											<input type="file" class="inp" name="file_name">
										</li>
<%
	Next
%>
									</ul>
								</td>
							</tr>
							<input type="hidden" id="attachCnt" name="attachCnt" value="<%=i%>">

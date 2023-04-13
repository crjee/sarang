<%
	cafe_mb_level = getUserLevel(cafe_id)
	If toInt(reply_auth) <= toInt(cafe_mb_level) Then
		set rs = server.createobject("adodb.recordset")
		sql = ""
		sql = sql & " select cc.* "
		sql = sql & "       ,convert(varchar(10), cc.credt, 120) reg_date_txt "
		sql = sql & "       ,phone as tel_no "
		sql = sql & "   from cf_" & menu_type & "_comment cc "
		sql = sql & "   left outer join cf_member cm on cm.user_id = cc.user_id "
		sql = sql & "  where cc." & menu_type & "_seq = '" & com_seq & "' "
		sql = sql & "  order by cc.group_num desc, cc.step_num asc "
		rs.Open Sql, conn, 3, 1

		comment_cnt = rs.recordcount
%>
				<div class="bbs_add_cont">
					<div class="bbs_add_cont_head">
						<h4>댓글</h4><span class="count"><%=comment_cnt%></span>
						<div class="posR">
							<a href="#n" class="btn btn_s btn_c_a" onclick="javascript:goCommentWrite('');">댓글쓰기</a>
							<script>
								function goCommentWrite(comment_seq) {
									if (comment_seq != '') {
										document.comment_form.task.value = "ins";
										document.comment_form.comment_seq.value = comment_seq;
										eval("comment_div.style.display='block'");
									}else {
										document.comment_form.task.value = "ins";
										document.comment_form.comment_seq.value = '';
										eval("comment_div.style.display='block'");
									}
								}
							</script>
						</div>
					</div>
					<div class="bbs_add_cont_wrt" id="comment_div" style='display:none'>
						<form name="comment_form" method="post" action="com_comment_exec.asp" target="hiddenfrm">
							<input type="hidden" name="task">
							<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
							<input type="hidden" name="<%=menu_type%>_seq" value="<%=com_seq%>">
							<input type="hidden" name='comment_seq'>
							<input type="hidden" name="step_num">
							<input type="hidden" name="level_num">
							<input type="hidden" name="user_id" value="<%=session("user_id")%>">
							<input type="hidden" name="ipin" value="<%=ipin%>">
							<textarea name="comment" rows="" cols="" onKeyup="fc_chk_byte(this, 400, 'commentView')" required></textarea>
							<button type="submit" class="btn btn_c_s">등록</button>
							<p class="add_count"><span id="commentView" name="commentView">0</span>/400</p>
						</form>
					</div>
					<div class="bbs_add_cont_body">
<%
		Do Until rs.eof
%>
						<dl class="bac_box">
							<dt>
								<strong title="<%=rs("tel_no")%>">
<%
			If rs("level_num") > 0 Then
%>
									<img src="/cafe/img/rb.png" height="0" width="<%=rs("level_num")*10%>">
									<img src="/cafe/img/re.png">
<%
			End If
%>
									<%=rs("agency")%>
								</strong>
								<span class=""><%=rs("credt")%><%If CStr(rs("reg_date_txt")) = CStr(Date) then%>&nbsp;<img src="/cafe/skin/img/btn/new.png" /><%End if%></span>
								<span class="posR">
<%
			If session("user_id") = rs("user_id") Or cafe_ad_level = 10 Then
%>
									<!-- <a href="javascript:goCommentEdit('<%=rs("comment_seq")%>')" class="btn btn_s btn_c_a">수정</a> -->
									<a href="#n" class="btn btn_s btn_c_a" onclick="onEdit('<%=rs("comment_seq")%>')">수정</a>
<%
			End If

			If session("user_id") = rs("user_id") Or cafe_mb_level >= 6 Then
%>
									<a href="javascript:goCommentDel('<%=rs("comment_seq")%>')" class="btn btn_s btn_c_n">삭제</a>
									<script>
										function goCommentDel(comment_seq) {
											document.comment_form.task.value = "del";
											document.comment_form.comment_seq.value = comment_seq;
											document.comment_form.submit();
										}
									</script>
<%
			End If
			comment = rs("comment")
			comment = Replace(comment, vbcrlf, "<br>")
%>
								</span>
							</dt>
							<dd>
								<%=comment%>
							</dd>
						</dl>
<%
			rs.MoveNext
		Loop
		rs.close
		Set rs = nothing
%>
					</div>
				</div>
<%
	End If
%>

	<div class="lypp lypp_sarang lypp_add">
		<header class="lypp_head">
			<h2 class="h2">댓글 수정</h2>
			<span class="posR">
				<button type="button" class="btn btn_close"><em>닫기</em></button>
			</span>
		</header>
		<div class="adm_cont">
			<form id="form" name="form" method="post" action="com_comment_write_exec.asp" target="hiddenfrm">
				<input type="hidden" name="menu_type" value="<%=menu_type%>">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" id="comment_seq" name="comment_seq">
				<div class="tb tb_form_1">
					<table class="tb_input">
						<colgroup>
							<col class="w15">
							<col class="auto">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">댓글 수정</th>
								<td>
									<textarea id="comment" name="comment" rows="" cols="" onKeyup="fc_chk_byte(this, 400, 'commentEdit')" required></textarea>
									<p class="add_count"><span id="commentView" name="commentEdit">0</span>/400</p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box algC">
					<button type="submit" class="btn btn_c_a btn_n">확인</button>
					<button type="reset" class="btn btn_c_n btn_n">취소</button>
				</div>
			</form>
		</div>
	</div>
<script type="text/javascript">
	function onEdit(comment_seq) {
		$("#form")[0].reset();
		$("#comment_seq").val(comment_seq)
		var menu_type = "<%=menu_type%>"
		lyp('lypp_add');
		try {
			var strHtml = [];

			$.ajax({
				type: "POST",
				dataType: "json",
				url: "/cafe/skin/com_comment_view_ajax.asp",
				data: {"menu_type":menu_type,"comment_seq":comment_seq},
				success: function(xmlData) {
					if (xmlData.TotalCnt > 0) {
						for (i=0; i<xmlData.TotalCnt; i++) {
							//alert(xmlData.ResultList[i].banner_seq);
							$("#comment_seq").val(xmlData.ResultList[i].comment_seq);
							//alert(xmlData.ResultList[i].file_type);
							$("#comment").val(xmlData.ResultList[i].comment);
						}
					}
					else {
						alert("해당 댓글이 없습니다");
					}
				},
				complete : function() {
				},
				error : function(xmlData) {
					alert("ERROR");
				}
			});
		}
		catch (e) {
			alert(e);
		}
	}
</script>


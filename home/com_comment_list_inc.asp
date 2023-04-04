<%
	cafe_mb_level = getUserLevel(cafe_id)

	If toInt(reply_auth) <= toInt(cafe_mb_level) Then
		Set rs = server.createobject("adodb.recordset")
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
				<form name="open_form2" method="post">
					<input type="hidden" name="open_url">
					<input type="hidden" name="open_name" value="com_comment">
					<input type="hidden" name="open_specs" value="width=600,height=200,scrollbars=no">
				</form>
				<div class="bbs_add_cont">
					<div class="bbs_add_cont_head">
						<h4>���</h4><span class="count"><%=comment_cnt%></span>
						<div class="posR">
							<a href="#n" class="btn btn_s btn_c_a" onclick="javascript:goCommentWrite('');">��۾���</a>
							<script>
								function goCommentWrite(comment_seq){
									if(comment_seq != ''){
										document.comment_form.task.value = "ins";
										document.comment_form.comment_seq.value = comment_seq;
										eval("comment_div.style.display='block'");
									}else{
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
							<button type="submit" class="btn btn_c_s">���</button>
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
								<span class=""><%=rs("credt")%><%If CStr(rs("reg_date_txt")) = CStr(Date) then%>&nbsp;<img src="/home/img/btn/new.png" /><%End if%></span>
								<span class="posR">
<%
			If session("user_id") = rs("user_id") Or cafe_ad_level = 10 Then
%>
									<a href="javascript:goCommentEdit('<%=rs("comment_seq")%>')" class="btn btn_s btn_c_a">����</a>
									<script>
										function goCommentEdit(comment_seq){
											document.open_form2.action = "/win_open_exec.asp"
											document.open_form2.target = "hiddenfrm";
											document.open_form2.open_url.value = "/home/com_comment_write_p.asp?menu_seq=<%=menu_seq%>&comment_seq="+comment_seq;
											document.open_form2.submit();
										}
									</script>
<%
			End If

			If session("user_id") = rs("user_id") Or cafe_mb_level >= 6 Then
%>
									<a href="javascript:goCommentDel('<%=rs("comment_seq")%>')" class="btn btn_s btn_c_n">����</a>
									<script>
										function goCommentDel(comment_seq){
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
<script>

function fc_chk_byte(frm_nm, ari_max, cnt_view) { 
//	var frm = document.regForm;
	var ls_str = frm_nm.value; // �̺�Ʈ�� �Ͼ ��Ʈ���� value �� 
	var li_str_len = ls_str.length; // ��ü���� 

	// �����ʱ�ȭ 
	var li_max = ari_max; // ������ ���ڼ� ũ�� 
	var i = 0; // for���� ��� 
	var li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
	var li_len = 0; // substring�ϱ� ���ؼ� ��� 
	var ls_one_char = ""; // �ѱ��ھ� �˻��Ѵ� 
	var ls_str2 = ""; // ���ڼ��� �ʰ��ϸ� �����Ҽ� ������������ �����ش�. 

	for(i=0; i< li_str_len; i++) { 
	// �ѱ������� 
		ls_one_char = ls_str.charAt(i); 

		// �ѱ��̸� 2�� ���Ѵ�. 
		if (escape(ls_one_char).length > 4) { 
			li_byte += 2; 
		} 
		// �׹��� ���� 1�� ���Ѵ�. 
		else { 
			li_byte++; 
		} 

		// ��ü ũ�Ⱑ li_max�� ���������� 
		if(li_byte <= li_max) { 
			li_len = i + 1; 
		} 
	} 

	// ��ü���̸� �ʰ��ϸ� 
	if(li_byte > li_max) { 
		alert( li_max + "byte ���ڸ� �ʰ� �Է��Ҽ� �����ϴ�. \n �ʰ��� ������ �ڵ����� ���� �˴ϴ�. "); 
		ls_str2 = ls_str.substr(0, li_len);
		frm_nm.value = ls_str2; 

		li_str_len = ls_str2.length; // ��ü���� 
		li_byte = 0; // �ѱ��ϰ��� 2 �׹ܿ��� 1�� ���� 
		for(i=0; i< li_str_len; i++) { 
		// �ѱ������� 
			ls_one_char = ls_str2.charAt(i); 

			// �ѱ��̸� 2�� ���Ѵ�. 
			if (escape(ls_one_char).length > 4) { 
				li_byte += 2; 
			} 
			// �׹��� ���� 1�� ���Ѵ�. 
			else { 
				li_byte++; 
			} 
		} 
	} 
	if (cnt_view != ""){
		var inner_form = eval("document.all."+ cnt_view) 
		inner_form.innerHTML = li_byte ;		//frm.txta_Memo.value.length;
	}
//	frm_nm.focus(); 

} 
</script>

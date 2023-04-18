<%
	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '"&ipin&"' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '"&session("user_id")&"' "
	Conn.Execute(sql)
%>
									<script>
										function testCheck(poll_seq){
											var chckType = document.getElementsByName('ans'+poll_seq);
											var j = 0;
											for(i = 0; i < chckType.length; i++){
												if (chckType[i].checked == true){
													j++;
												}
											}
											if(j == 0){
												alert("설문을 선택하세요!");
												return false;
											}
											return true;
										}
										function setPoll(poll_seq,ans){
											var f = document.poll_form;
											f.poll_seq.value = poll_seq;
											f.ans.value = ans;
										}

										function goPoll(poll_seq){
											if(!testCheck(poll_seq)) return;
											var f = document.poll_form;
											f.target = "hiddenfrm");
											f.submit();
										}
									</script>
									<form name="poll_form" method="post" action="/cafe/skin/poll_exec.asp" target="hiddenfrm">
									<input type="hidden" name="poll_seq">
									<input type="hidden" name="ans">
									<li class=""><font class="orange4"><%=rs("subject")%></font><li>
									
<%
			If rs("sdate") <> "" And rs("edate") <> "" Then
%>
									<li class="">조사기간 : <%=rs("sdate")%> ~ <%=rs("edate")%><li>
<%
			End If
%>
									
<%
			For i = 1 To 10
				If rs("ques"&i) <> "" Then
%>
									<li class=""><input type="radio" name="ans<%=rs("poll_seq")%>" value="ans<%=i%>" onclick="setPoll(<%=rs("poll_seq")%>,this.value)"> <%=rs("ques"&i)%></li>
<%
				End If
			Next
%>
									</form>

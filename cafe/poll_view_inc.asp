<%
	ipin = getRndStr(10)
	sql = ""
	sql = sql & " update cf_member "
	sql = sql & "    set ipin = '"&ipin&"' "
	sql = sql & "       ,moddt = getdate() "
	sql = sql & "  where user_id = '"&session("user_id")&"' "
	Conn.Execute(sql)
%>
									<form name="poll_form" method="post" action="/cafe/poll_exec.asp" target="hiddenfrm">
									<input type="hidden" name="poll_seq">
									<input type="hidden" name="ans">
									<li class=""><font class="orange4"><%=subject%></font><li>
									<li class="">조사기간 : 
<%
			If sdate = "" And edate = "" Then
%>
										마감시까지
<%
			Else
				If sdate <> "" Then
%>
										<%=sdate%>
<%
				End If
%>
										<%=if3(sdate<>"" Or edate<>""," ~ ","")%>
<%
				If edate <> "" Then
%>
										<%=edate%>
<%
				End If
			End If

			For i = 1 To 10
				If centerRs("ques"&i) <> "" Then
%>
									<li class="">
<%
					If edate = "" Then edate = Date()

					If datediff("d", Date(), edate) >= 0 Then
%>
										<input type="radio" name="ans<%=centerRs("poll_seq")%>" value="ans<%=i%>" onclick="setPoll(<%=centerRs("poll_seq")%>,this.value)">
<%
					End If
%>
										<%=centerRs("ques"&i)%>
									</li>
<%
				End If
			Next
%>
									</form>
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

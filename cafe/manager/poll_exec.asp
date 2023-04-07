<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	task = Request("task")
	If task = "" Then task = "ins"
	poll_seq = Request("poll_seq")
	subject = Request("subject")
	ques01 = Request("ques01")
	ques02 = Request("ques02")
	ques03 = Request("ques03")
	ques04 = Request("ques04")
	ques05 = Request("ques05")
	ques06 = Request("ques06")
	ques07 = Request("ques07")
	ques08 = Request("ques08")
	ques09 = Request("ques09")
	ques10 = Request("ques10")
	count = Request("count")
	sdate = Request("sdate")
	edate = Request("edate")
	rprsv_cert_use_yn   = Request("rprsv_cert_use_yn")
	ddln_yn   = Request("ddln_yn")

	ques_cnt = 0
	Dim arrQ(10)
	If ques01 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques01
	If ques02 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques02
	If ques03 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques03
	If ques04 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques04
	If ques05 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques05
	If ques06 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques06
	If ques07 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques07
	If ques08 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques08
	If ques09 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques09
	If ques10 <> "" Then ques_cnt = ques_cnt + 1 : arrQ(ques_cnt) = ques10
	count = ques_cnt

	If task = "ddln" Then
		poll_seq = Request("poll_seq")

		sql = ""
		sql = sql & " update cf_poll "
		sql = sql & "    set ddln_yn = 'Y' "
		sql = sql & "       ,modid   = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt   = getdate() "
		sql = sql & "  where poll_seq = '" & poll_seq & "' "
		Conn.Execute(sql)
		Response.Write "<script>alert('마감되었습니다');parent.location = 'poll_list.asp'</script>"
		Response.end
	End If

	If task = "del" Then
		for i = 1 to Request("poll_seq").count
			poll_seq = Request("poll_seq")(i)

			sql = "delete from cf_poll where poll_seq = '" & poll_seq & "'"
			Conn.Execute(sql)
			sql = "delete from cf_poll_ans where poll_seq = '" & poll_seq & "'"
			Conn.Execute(sql)
		Next
		Response.Write "<script>alert('삭제되었습니다');parent.location = 'poll_list.asp'</script>"
		Response.end
	End If

	If task = "upd" Then
		sql = ""
		sql = sql & " update cf_poll "
		sql = sql & "    set subject = '" & subject & "' "
		sql = sql & "       ,ques1   = '" & arrQ(1) & "' "
		sql = sql & "       ,ques2   = '" & arrQ(2) & "' "
		sql = sql & "       ,ques3   = '" & arrQ(3) & "' "
		sql = sql & "       ,ques4   = '" & arrQ(4) & "' "
		sql = sql & "       ,ques5   = '" & arrQ(5) & "' "
		sql = sql & "       ,ques6   = '" & arrQ(6) & "' "
		sql = sql & "       ,ques7   = '" & arrQ(7) & "' "
		sql = sql & "       ,ques8   = '" & arrQ(8) & "' "
		sql = sql & "       ,ques9   = '" & arrQ(9) & "' "
		sql = sql & "       ,ques10  = '" & arrQ(10) & "' "
		sql = sql & "       ,count = '" & count & "' "
		sql = sql & "       ,sdate = '" & sdate & "' "
		sql = sql & "       ,edate = '" & edate & "' "
		sql = sql & "       ,rprsv_cert_use_yn = '" & rprsv_cert_use_yn & "' "
		sql = sql & "       ,modid   = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt   = getdate() "
		sql = sql & "  where poll_seq = '" & poll_seq & "' "
		Conn.Execute(sql)
		Response.Write "<script>alert('수정되었습니다');parent.location='poll_list.asp';window.close();</script>"
		Response.end
	End If

	If task="ins" And ques01 <>"" And ques02 <>"" Then

		new_seq = getSeq("cf_poll")

		sql = ""
		sql = sql & " insert into cf_poll( "
		sql = sql & "        poll_seq "
		sql = sql & "       ,subject "
		sql = sql & "       ,cafe_id "
		sql = sql & "       ,ques1 "
		sql = sql & "       ,ques2 "
		sql = sql & "       ,ques3 "
		sql = sql & "       ,ques4 "
		sql = sql & "       ,ques5 "
		sql = sql & "       ,ques6 "
		sql = sql & "       ,ques7 "
		sql = sql & "       ,ques8 "
		sql = sql & "       ,ques9 "
		sql = sql & "       ,ques10 "
		sql = sql & "       ,count "
		sql = sql & "       ,sdate "
		sql = sql & "       ,edate "
		sql = sql & "       ,rprsv_cert_use_yn "
		sql = sql & "       ,user_id "
		sql = sql & "       ,agency "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & new_seq & "' "
		sql = sql & "       ,'" & subject & "' "
		sql = sql & "       ,'" & cafe_id & "' "
		sql = sql & "       ,'" & arrQ(1) & "' "
		sql = sql & "       ,'" & arrQ(2) & "' "
		sql = sql & "       ,'" & arrQ(3) & "' "
		sql = sql & "       ,'" & arrQ(4) & "' "
		sql = sql & "       ,'" & arrQ(5) & "' "
		sql = sql & "       ,'" & arrQ(6) & "' "
		sql = sql & "       ,'" & arrQ(7) & "' "
		sql = sql & "       ,'" & arrQ(8) & "' "
		sql = sql & "       ,'" & arrQ(9) & "' "
		sql = sql & "       ,'" & arrQ(10) & "'"
		sql = sql & "       ,'" & count & "' "
		sql = sql & "       ,'" & sdate & "' "
		sql = sql & "       ,'" & edate & "' "
		sql = sql & "       ,'" & rprsv_cert_use_yn & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,'" & Session("agency") & "' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)

		sql = ""
		sql = sql & " insert into cf_poll_ans( "
		sql = sql & "        poll_seq "
		sql = sql & "       ,ans1 "
		sql = sql & "       ,ans2 "
		sql = sql & "       ,ans3 "
		sql = sql & "       ,ans4 "
		sql = sql & "       ,ans5 "
		sql = sql & "       ,ans6 "
		sql = sql & "       ,ans7 "
		sql = sql & "       ,ans8 "
		sql = sql & "       ,ans9 "
		sql = sql & "       ,ans10 "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & new_seq & "' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'0' "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)
		Response.Write "<script>alert('등록되었습니다');parent.location = 'poll_list.asp';window.close()</script>"
		Response.End
		
	End If
%>

<% ' If cafe_ad_level = "10" Then extime("center 실행시간") %>
			<nav id="nav_gnb" class="group_nav dsc_<%=Right(skin_idx, 1)%>">
				<div class="group_area">
					<div class="group_box">
						<p><strong><%=session("agency")%></strong>님 안녕하세요</p>
						<span class="icon"><%=user_level_str%></span>
					</div>
<%
	If cafe_mb_level = 10 Then
		cafe_type = getonevalue("cafe_type", "cf_cafe", "where cafe_id = '" & cafe_id & "'")

		If cafe_type = "C" Then
			cafe_type_nm = "사랑방"
		Else
			cafe_type_nm = "연합회"
		End If
%>
<%
	End If
%>
					<ul class="group_list">
						<li><em>회원수</em> <strong><%=FormatNumber(member_cnt,0)%></strong></li>
						<li><em>방문수</em> <strong><%=FormatNumber(visit_cnt,0)%></strong></li>
						<li><em>쪽지함</em> <strong><a href="/cafe/skin/memo_list.asp" class="orange3"><%=memo_cnt%>개</a></strong></li>
					</ul>
					<div class="search_box">
						<label for="">전체검색</label>
						<input type="text" id="" name="" placeholder="검색어를 입력하세요" class="" />
						<button type="button" class="f_awesome"><em>검색</em></button>
					</div>
					<button class="btn btn_c_s btn_n" type="button" onclick="javascripit:document.location.href='/cafe/manager/cafe_info_edit.asp'"><%=cafe_type_nm%> 관리</button>
					<a href="#n" class="btn btn_c_a btn_n ux_btn_wrt">카페글쓰기</a>
					<div class="wrt_group_box">
						<div class="btn_box">
							<a href="#n" class="">공지사항 글쓰기</a>
							<a href="#n" class="">공지사항 글쓰기</a>
							<a href="#n" class="">공지사항 글쓰기</a>
							<a href="#n" class="">공지사항 글쓰기</a>
						</div>
					</div>
				</div>
				<ul class="nav">
<%
	Set left_rs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select menu_type "
	sql = sql & "       ,menu_name "
	sql = sql & "       ,menu_seq "
	sql = sql & "       ,hidden_yn "
	sql = sql & "       ,case when last_date > DateAdd(day,-2,getdate()) then 1 else 0 end new_cnt "
	sql = sql & "   from cf_menu cm "
	sql = sql & "  where cafe_id = '" & cafe_id & "'"
	sql = sql & "    and menu_type <> 'poll' "
	If cafe_mb_level <> "10" Then
	sql = sql & "    and hidden_yn <> 'Y'"
	End If
	sql = sql & "  order by menu_num asc "
	left_rs.Open sql, conn, 3, 1

	Do Until left_rs.eof
		menu_type = left_rs("menu_type")
		menu_name = left_rs("menu_name")
		menu_seq  = left_rs("menu_seq")
		hidden_yn = left_rs("hidden_yn")
		new_cnt   = left_rs("new_cnt")
		menu_name = Replace(menu_name, " & amp;"," & ")

		If hidden_yn = "Y" Then
			If new_cnt = 0 Then
				slen = 7
			Else
				slen = 6
			End If
			
			If Len(Replace(menu_name,",","")) >= slen Then
				add_style = "height:30px;line-height:15px;padding-top:2px;"
			Else
				add_style = ""
			End If
		Else
			If new_cnt = 0 Then
				slen = 9
			Else
				slen = 8
			End If
		End If

		If menu_type = "group" Then
			group_cnt = group_cnt + 1
			If group_cnt > 2 Then group_cnt = 2
%>
					<li class="menu_tit"><%=menu_name%></li>
<%
		ElseIf menu_type = "division" Then
%>
					<li></li>
<%
		Else
			If menu_name ="-" Then
				menu_name_str = "<hr></hr>"
			Else
				menu_type = Trim(menu_type)

				If hidden_yn = "Y" then
					ms = "<font color=red>[숨김]</font>"
				Else
					ms = ""
				End If

				If instr("notice,board,news,pds,album,sale,job",menu_type) Then

					If new_cnt = 0 Then
						nc = ""
					Else
						nc = "<img src='/cafe/skin/img/btn/new.png' align='absmiddle'>"'[" & n("cnt") & "]"
					End if

					menu_name_str = "<a href='/cafe/skin/" & menu_type & "_list.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " " & nc & "</a>"

				ElseIf menu_type = "land" Then

					menu_name_str = "<a href='/cafe/skin/land_list.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

				ElseIf menu_type = "member" Then

					menu_name_str = "<a href='/cafe/skin/member_list.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

				ElseIf menu_type = "memo" Then

					menu_name_str = "<a href='/cafe/skin/memo_write.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

				Else

					menu_name_str = "<a href='/cafe/skin/page_view.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

				End if
			End If

			If CStr(request("menu_seq")) = CStr(menu_seq) then
%>
					<!-- <li style="<%=add_style%>background:url(/cafe/skin/img/left/ico_01.png) left no-repeat #ebebeb;"><%=menu_name_str%></li> -->
					<li class="current_link"><%=menu_name_str%></li>
<%
			Else
%>
					<li style="<%=add_style%>"><%=menu_name_str%></li>
<%
			End If
		End If

		left_rs.MoveNext
	Loop
	left_rs.close
	Set left_rs = nothing
'If session("user_id") = "crjee" Then extime("left 실행시간")
%>
				</ul>
			</nav>

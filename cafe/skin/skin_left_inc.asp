<%
'	OPTION Explicit
'	Dim cafe_id
'	Dim cafe_mb_level
'	Dim uploadUrl
'	Dim ConfigAttachedFileURL
'	Dim sql
'	Dim conn
'	Dim skin_idx
'	Dim user_level_str
'	Set Conn = Server.CreateObject("ADODB.Connection")
'	Conn.Open Application("db")
'	Dim member_cnt
'	Dim visit_cnt
'	Dim memo_cnt
%>
			<nav id="nav_gnb" class="group_nav dsc_<%=Right(skin_idx, 1)%>">
				<div class="group_area">
					<div class="group_box">
						<p><strong><%=session("agency")%></strong>님 안녕하세요</p>
						<span class="icon"><%=user_level_str%></span>
					</div>
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
<%
	Dim left_cafe_type
	Dim left_cafe_type_nm

	If cafe_mb_level = 10 Then
		left_cafe_type = getonevalue("cafe_type", "cf_cafe", "where cafe_id = '" & cafe_id & "'")

		If left_cafe_type = "C" Then
			left_cafe_type_nm = "사랑방"
		Else
			left_cafe_type_nm = "연합회"
		End If
	End If
%>
					<button class="btn btn_c_s btn_n" type="button" onclick="javascripit:document.location.href='/cafe/manager/cafe_info_edit.asp'"><%=left_cafe_type_nm%> 관리</button>
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
	Dim leftRs
	Dim left_menu_type
	Dim left_menu_name
	Dim left_menu_seq 
	Dim left_hidden_yn
	Dim left_new_cnt
	Dim left_slen
	Dim left_left_add_style
	Dim left_ms
	Dim left_mc

	Set leftRs = Server.CreateObject ("ADODB.Recordset")

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
	leftRs.Open sql, conn, 3, 1

	Do Until leftRs.eof
		left_menu_type = leftRs("menu_type")
		left_menu_name = leftRs("menu_name")
		left_menu_seq  = leftRs("menu_seq")
		left_hidden_yn = leftRs("hidden_yn")
		left_new_cnt   = leftRs("new_cnt")
		left_menu_name = Replace(left_menu_name, " & amp;"," & ")

		If left_hidden_yn = "Y" Then
			If left_new_cnt = 0 Then
				left_slen = 7
			Else
				left_slen = 6
			End If
			
			If Len(Replace(left_menu_name,",","")) >= left_slen Then
				left_add_style = "height:30px;line-height:15px;padding-top:2px;"
			Else
				left_add_style = ""
			End If
		Else
			If left_new_cnt = 0 Then
				left_slen = 9
			Else
				left_slen = 8
			End If
		End If

		If left_menu_type = "group" Then
			group_cnt = group_cnt + 1
			If group_cnt > 2 Then group_cnt = 2
%>
					<li class="menu_tit"><%=left_menu_name%></li>
<%
		ElseIf left_menu_type = "division" Then
%>
					<li></li>
<%
		Else
			If left_menu_name ="-" Then
				menu_name_str = "<hr></hr>"
			Else
				left_menu_type = Trim(left_menu_type)

				If left_hidden_yn = "Y" then
					left_ms = "<font color=red>[숨김]</font>"
				Else
					left_ms = ""
				End If

				If instr("notice,board,news,pds,album,sale,job", left_menu_type) Then
					If left_new_cnt = 0 Then
						left_nc = ""
					Else
						left_nc = "<img src='/cafe/skin/img/btn/new.png' align='absmiddle'>"'[" & n("cnt") & "]"
					End if

					left_menu_name_str = "<a href='/cafe/skin/" & left_menu_type & "_list.asp?menu_seq=" & left_menu_seq & "'>" & left_ms & " " & left_menu_name & " " & left_nc & "</a>"
				ElseIf left_menu_type = "land" Then
					left_menu_name_str = "<a href='/cafe/skin/land_list.asp?menu_seq=" & left_menu_seq & "'>" & left_ms & " " & left_menu_name & " </a>"
				ElseIf left_menu_type = "member" Then
					left_menu_name_str = "<a href='/cafe/skin/member_list.asp?menu_seq=" & left_menu_seq & "'>" & left_ms & " " & left_menu_name & " </a>"
				ElseIf left_menu_type = "memo" Then
					left_menu_name_str = "<a href='/cafe/skin/memo_write.asp?menu_seq=" & left_menu_seq & "'>" & left_ms & " " & left_menu_name & " </a>"
				Else
					left_menu_name_str = "<a href='/cafe/skin/page_view.asp?menu_seq=" & left_menu_seq & "'>" & left_ms & " " & left_menu_name & " </a>"
				End if
			End If

			If CStr(request("menu_seq")) = CStr(left_menu_seq) then
%>
					<!-- <li style="<%=left_add_style%>background:url(/cafe/skin/img/left/ico_01.png) left no-repeat #ebebeb;"><%=left_menu_name_str%></li> -->
					<li class="current_link"><%=left_menu_name_str%></li>
<%
			Else
%>
					<li style="<%=left_add_style%>"><%=left_menu_name_str%></li>
<%
			End If
		End If

		leftRs.MoveNext
	Loop
	leftRs.close
	Set leftRs = nothing
'If session("user_id") = "crjee" Then extime("left 실행시간")
%>
				</ul>
			</nav>

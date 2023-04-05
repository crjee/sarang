		<header id="header">
			<div class="header_inner">
				<div class="header_cont">
					<h1><a href="/home/main.asp"><img src="/common/img/common/logo.svg" alt="" /></a></h1>
					<div class="search_box">
						<label for="">전체검색</label>
						<input type="text" id="" name="" placeholder="검색어를 입력하세요" class="" />
						<button type="button" class="f_awesome"><em>검색</em></button>
					</div>
					<ul class="top_btn_box">
<%
	If Session("user_id") = "" Then
%>
						<li><a href="/login_form.asp">로그인</a></li>
						<li><a href="/home/agree_form.asp">회원가입</a></li>
<%
	Else
%>
						<li><a href="/logout_exec.asp">로그아웃</a></li>
<%
	End If
%>
<%
	If Session("cafe_ad_level") = "10" Or Session("mycafe") <> "" Then
%>
						<li><a href="/cafe/main.asp">사랑방</a></li>
<%
	End If
%>
					</ul>
				</div>
				<div class="header_banner">
<%
	uploadUrl = ConfigAttachedFileURL & "banner/"
	Set head_rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select top 6 *           "
	sql = sql & "   from cf_banner         "
	sql = sql & "  where cafe_id='root'    "
	sql = sql & "    and banner_type = 'T' "
	sql = sql & "    and open_yn = 'Y'     "
	sql = sql & "  order by banner_seq asc "
	head_rs.open Sql, conn, 3, 1
	i = 1
	Do Until head_rs.eof
		i = i + 1
		banner_seq     = head_rs("banner_seq")
		banner_num     = head_rs("banner_num")
		banner_type    = head_rs("banner_type")
		banner_subject = head_rs("subject")
		file_name      = head_rs("file_name")
		file_type      = head_rs("file_type")
		banner_height  = head_rs("banner_height")
		banner_width   = head_rs("banner_width")
		link           = head_rs("link")
		open_yn        = head_rs("open_yn")

		banner_width  =  160
		banner_height =  80

		If file_name <> "" then
%>
					<div class="banners">
<%
			If link <> "" Then
%>
						<a href="<%=link%>" target="_blank">
<%
			End If
%>
						<img src="<%=uploadUrl & file_name%>"/>
<%
			If link <> "" Then
%>
						</a>
<%
			End If
%>
					</div>
<%
		End If

		head_rs.MoveNext
	Loop
	head_rs.close
	Set head_rs = nothing
%>
<%
	For j = i To 7
%>
					<div class="banners"></div>
<%
	Next
%>
				</div>
			</div>
		</header>
		<nav id="nav_gnb">
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

		menu_type = Trim(menu_type)

		If hidden_yn = "Y" then
			ms = "<font color=red>[숨김]</font>"
		Else
			ms = ""
		End If

		If instr("notice,board,news,pds,album,sale,job,nsale,story",menu_type) Then

			If new_cnt = 0 Then
				nc = ""
			Else
				nc = "<img src='/cafe/skin/img/btn/new.png' align='absmiddle'>"'[" & n("cnt") & "]"
			End if

			menu_name_str = "<a href='/home/" & menu_type & "_list.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " " & nc & "</a>"

		ElseIf menu_type = "land" Then

			menu_name_str = "<a href='/home/land_list.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

		ElseIf menu_type = "member" Then

			menu_name_str = "<a href='/home/member_list.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

		ElseIf menu_type = "memo" Then

			menu_name_str = "<a href='/home/memo_write.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

		Else

			menu_name_str = "<a href='/home/page_view.asp?menu_seq=" & menu_seq & "'>" & ms & " " & menu_name & " </a>"

		End if

		If CStr(request("menu_seq")) = CStr(menu_seq) then
%>
				<li class="on"><%=menu_name_str%></li>
<%
		Else
%>
				<li><%=menu_name_str%></li>
<%
		End If
		left_rs.MoveNext
	Loop
	left_rs.close
	Set left_rs = nothing
%>
			</ul>
		</nav>

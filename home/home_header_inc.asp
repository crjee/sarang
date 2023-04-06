<%
'	OPTION Explicit
'	Dim cafe_id
'	Dim cafe_mb_level
'	Dim uploadUrl
'	Dim ConfigAttachedFileURL
'	Dim sql
'	Dim conn
'	Set Conn = Server.CreateObject("ADODB.Connection")
'	Conn.Open Application("db")
%>
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
	Dim headerRs
	Dim header_banner_seq    
	Dim header_banner_num    
	Dim header_banner_type   
	Dim header_banner_subject
	Dim header_file_name     
	Dim header_file_type     
	Dim header_banner_height 
	Dim header_banner_width  
	Dim header_link          
	Dim header_open_yn       
	Dim header_i
	Dim header_j

	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set headerRs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select top 6 *           "
	sql = sql & "   from cf_banner         "
	sql = sql & "  where cafe_id='root'    "
	sql = sql & "    and banner_type = 'T' "
	sql = sql & "    and open_yn = 'Y'     "
	sql = sql & "  order by banner_seq asc "
	headerRs.open Sql, conn, 3, 1

	header_i = 1
	Do Until headerRs.eof
		header_i = header_i + 1
		header_banner_seq     = headerRs("banner_seq")
		header_banner_num     = headerRs("banner_num")
		header_banner_type    = headerRs("banner_type")
		header_banner_subject = headerRs("subject")
		header_file_name      = headerRs("file_name")
		header_file_type      = headerRs("file_type")
		header_banner_height  = headerRs("banner_height")
		header_banner_width   = headerRs("banner_width")
		header_link           = headerRs("link")
		header_open_yn        = headerRs("open_yn")

		header_banner_width  =  160
		header_banner_height =  80

		If header_file_name <> "" then
%>
					<div class="banners">
<%
			If header_link <> "" Then
%>
						<a href="<%=header_link%>" target="_blank">
<%
			End If
%>
						<img src="<%=uploadUrl & header_file_name%>"/>
<%
			If header_link <> "" Then
%>
						</a>
<%
			End If
%>
					</div>
<%
		End If

		headerRs.MoveNext
	Loop
	headerRs.close

	For header_j = header_i To 7
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
	Dim header_menu_type
	Dim header_menu_name
	Dim header_menu_seq 
	Dim header_hidden_yn
	Dim header_new_cnt  
	Dim header_ms  
	Dim header_nc  

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
	headerRs.Open sql, conn, 3, 1

	Do Until headerRs.eof
		header_menu_type = headerRs("menu_type")
		header_menu_name = headerRs("menu_name")
		header_menu_seq  = headerRs("menu_seq")
		header_hidden_yn = headerRs("hidden_yn")
		header_new_cnt   = headerRs("new_cnt")
		header_menu_name = Replace(header_menu_name, " & amp;"," & ")

		header_menu_type = Trim(header_menu_type)

		If header_hidden_yn = "Y" then
			header_ms = "<font color=red>[숨김]</font>"
		Else
			header_ms = ""
		End If

		If instr("notice,board,news,pds,album,sale,job,nsale,story",header_menu_type) Then
			If header_new_cnt = 0 Then
				header_nc = ""
			Else
				header_nc = "<img src='/cafe/skin/img/btn/new.png' align='absmiddle'>"'[" & n("cnt") & "]"
			End if

			header_menu_name_str = "<a href='/home/" & header_menu_type & "_list.asp?menu_seq=" & header_menu_seq & "'>" & header_ms & " " & header_menu_name & " " & header_nc & "</a>"
		ElseIf header_menu_type = "land" Then
			header_menu_name_str = "<a href='/home/land_list.asp?menu_seq=" & header_menu_seq & "'>" & header_ms & " " & header_menu_name & " </a>"
		ElseIf header_menu_type = "member" Then
			header_menu_name_str = "<a href='/home/member_list.asp?menu_seq=" & header_menu_seq & "'>" & header_ms & " " & header_menu_name & " </a>"
		ElseIf header_menu_type = "memo" Then
			header_menu_name_str = "<a href='/home/memo_write.asp?menu_seq=" & header_menu_seq & "'>" & header_ms & " " & header_menu_name & " </a>"
		Else
			header_menu_name_str = "<a href='/home/page_view.asp?menu_seq=" & header_menu_seq & "'>" & header_ms & " " & header_menu_name & " </a>"
		End if

		If CStr(request("menu_seq")) = CStr(header_menu_seq) then
%>
				<li class="on"><%=header_menu_name_str%></li>
<%
		Else
%>
				<li><%=header_menu_name_str%></li>
<%
		End If
		headerRs.MoveNext
	Loop
	headerRs.close
	Set headerRs = nothing
%>
			</ul>
		</nav>

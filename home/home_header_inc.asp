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
	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set headerRs = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select top 1 *            "
	sql = sql & "       ,file_name          "
	sql = sql & "       ,link               "
	sql = sql & "   from cf_banner          "
	sql = sql & "  where cafe_id='root'     "
	sql = sql & "    and banner_type = 'LG' "
	sql = sql & "    and open_yn = 'Y'      "
	sql = sql & "  order by banner_num asc  "
	headerRs.open Sql, conn, 3, 1

	header_i = 1
	If Not headerRs.eof Then
		header_file_name = headerRs("file_name")
		header_link      = headerRs("link")
	End If
	headerRs.close
%>
		<header id="header">
			<div class="header_inner">
				<div class="header_cont">
					<h1><a href="/home"><img src="<%=uploadUrl & header_file_name%>" alt="" /></a></h1>
					<form name="cafe_search_form" id="cafe_search_form" method="post" action="/home/home_search_list.asp">
					<div class="search_box">
						<label for="">전체검색</label>
						<input type="text" id="sch_word" name="sch_word" placeholder="검색어를 입력하세요" class="" required />
						<button type="submit" class="f_awesome"><em>검색</em></button>
					</div>
					</form>
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
	Dim header_file_name
	Dim header_link
	Dim header_i
	Dim header_j

	uploadUrl = ConfigAttachedFileURL & "banner/"

	sql = ""
	sql = sql & " select top 7 *           "
	sql = sql & "       ,file_name         "
	sql = sql & "       ,link              "
	sql = sql & "   from cf_banner         "
	sql = sql & "  where cafe_id='root'    "
	sql = sql & "    and banner_type = 'T' "
	sql = sql & "    and open_yn = 'Y'     "
	sql = sql & "  order by banner_num asc "
	headerRs.open Sql, conn, 3, 1

	header_i = 1
	Do Until headerRs.eof
		header_i = header_i + 1
		header_file_name      = headerRs("file_name")
		header_link           = headerRs("link")

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

	sql = ""
	sql = sql & " select menu_type "
	sql = sql & "       ,menu_name "
	sql = sql & "       ,menu_seq "
	sql = sql & "   from cf_menu cm "
	sql = sql & "  where cafe_id = '" & cafe_id & "'"
	sql = sql & "    and menu_type <> 'poll' "
	sql = sql & "    and hidden_yn <> 'Y'"
	sql = sql & "  order by menu_num asc "
	headerRs.Open sql, conn, 3, 1

	Do Until headerRs.eof
		header_menu_type = headerRs("menu_type")
		header_menu_name = headerRs("menu_name")
		header_menu_seq  = headerRs("menu_seq")
		header_menu_name = Replace(header_menu_name, " & amp;"," & ")

		header_menu_type = Trim(header_menu_type)

		If instr("notice,board,news,pds,album,sale,job,nsale,story",header_menu_type) Then
			header_menu_name_str = "<a href='/home/" & header_menu_type & "_list.asp?menu_seq=" & header_menu_seq & "'>" & header_menu_name & "</a>"
		ElseIf header_menu_type = "land" Then
			header_menu_name_str = "<a href='/home/land_list.asp?menu_seq=" & header_menu_seq & "'>" & header_menu_name & " </a>"
		ElseIf header_menu_type = "member" Then
			header_menu_name_str = "<a href='/home/member_list.asp?menu_seq=" & header_menu_seq & "'>" & header_menu_name & " </a>"
		ElseIf header_menu_type = "memo" Then
			header_menu_name_str = "<a href='/home/memo_write.asp?menu_seq=" & header_menu_seq & "'>" & header_menu_name & " </a>"
		Else
			header_menu_name_str = "<a href='/home/page_view.asp?menu_seq=" & header_menu_seq & "'>" & header_menu_name & " </a>"
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
	Set headerRs = Nothing
%>
			</ul>
		</nav>

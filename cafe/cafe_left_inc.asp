<%
	If cafe_id = "" Then Response.End
%>
<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
%>
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
						<li><em>쪽지함</em> <strong><a href="/cafe/memo_list.asp" class="orange3" target="<%=session("svTarget")%>"><%=memo_cnt%>개</a></strong></li>
					</ul>
					<form name="cafe_search_form" id="cafe_search_form" method="post" action="/cafe/cafe_search_list.asp" target="<%=session("svTarget")%>">
					<div class="search_box">
						<label for="">전체검색</label>
						<input type="text" id="sch_word" name="sch_word" placeholder="검색어를 입력하세요" class="" required />
						<button type="submit" class="f_awesome"><em>검색</em></button>
					</div>
					</form>
<%
	Dim left_cafe_type
	Dim left_cafe_type_nm

	If cafe_mb_level = 10 Then
		left_cafe_type = GetOneValue("cafe_type", "cf_cafe", "where cafe_id = '" & cafe_id & "'")

		If left_cafe_type = "C" Then
			left_cafe_type_nm = "사랑방"
		Else
			left_cafe_type_nm = "연합회"
		End If
	End If
%>
					<button type="button" class="btn btn_c_s btn_n" onclick="javascripit:document.location.href='/cafe/manager/cafe_info_edit.asp'"><%=left_cafe_type_nm%> 관리</button>
					<button type="button" class="btn btn_c_a btn_n ux_btn_wrt">카페글쓰기</button>
					<div class="wrt_group_box">
						<div class="btn_box">
<%
	Set leftRs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select menu_type                                            "
	sql = sql & "       ,menu_name                                            "
	sql = sql & "       ,menu_seq                                             "
	sql = sql & "       ,hidden_yn                                            "
	sql = sql & "   from cf_menu                                              "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                          "
	sql = sql & "    and hidden_yn = 'N'                                      "
	sql = sql & "    and write_auth is not null                               "
	sql = sql & "    and write_auth <= '" & cafe_mb_level & "'                "
	sql = sql & "    and menu_type in ('album','board','job','sale','notice') "
	leftRs.Open sql, conn, 3, 1

	Do Until leftRs.eof
		left_menu_type = leftRs("menu_type")
		left_menu_name = leftRs("menu_name")
		left_menu_seq  = leftRs("menu_seq")
		left_hidden_yn = leftRs("hidden_yn")
		left_menu_name = Replace(left_menu_name, " & amp;"," & ")
%>
							<a href="/cafe/<%=left_menu_type%>_write.asp?menu_seq=<%=left_menu_seq%>" target="<%=session("svTarget")%>"><%=left_menu_name%></a>
<%
		leftRs.MoveNext
	Loop
	leftRs.close
%>
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
						left_nc = "<img src='/cafe/img/btn/new.png' align='absmiddle'>"'[" & n("cnt") & "]"
					End If

					left_menu_name_str = "<a href='/cafe/" & left_menu_type & "_list.asp?menu_seq=" & left_menu_seq & "' target='" & session("svTarget") & "'>" & left_ms & " " & left_menu_name & " " & left_nc & "</a>"
				ElseIf left_menu_type = "land" Then
					left_menu_name_str = "<a href='/cafe/land_list.asp?menu_seq="                   & left_menu_seq & "' target='" & session("svTarget") & "'>" & left_ms & " " & left_menu_name & " </a>"
				ElseIf left_menu_type = "member" Then
					left_menu_name_str = "<a href='/cafe/member_list.asp?menu_seq="                 & left_menu_seq & "' target='" & session("svTarget") & "'>" & left_ms & " " & left_menu_name & " </a>"
				ElseIf left_menu_type = "memo" Then
					left_menu_name_str = "<a href='/cafe/memo_write.asp?menu_seq="                  & left_menu_seq & "' target='" & session("svTarget") & "'>" & left_ms & " " & left_menu_name & " </a>"
				Else
					left_menu_name_str = "<a href='/cafe/page_view.asp?menu_seq="                   & left_menu_seq & "' target='" & session("svTarget") & "'>" & left_ms & " " & left_menu_name & " </a>"
				End If
			End If

			If CStr(request("menu_seq")) = CStr(left_menu_seq) then
%>
					<!-- <li style="<%=left_add_style%>background:url(/cafe/img/left/ico_01.png) left no-repeat #ebebeb;"><%=left_menu_name_str%></li> -->
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
	Set leftRs = Nothing
%>
					<li class="outline_zone">
						<ul>
							<%
								If cafe_id <> session("mycafe") Then
							%>
								<li><a href="/cafe/main.asp?cafe_id=<%=session("mycafe")%>"><img src="/cafe/img/left/left_goclub.gif" alt="사랑방 바로가기" /></a></li>
							<%
								End If
							%>
							<%
								union_id = GetOneValue("union_id","cf_cafe","where cafe_id = '"&cafe_id&"' ")
							
								If union_id <> "" Then
							%>
								<!--연합회 바로가기-->
								<li><a href="/cafe/main.asp?cafe_id=<%=union_id%>"><img src="/cafe/img/left/left_gounited.gif" alt="" /></a></li>
								<!--연합회 바로가기-->
							<%
								End If
							
								If cafe_ad_level = "10" Then
							%>
								<!--사랑방 바로가기-->
								<li>
									<select name="cafe_id" class="sel w100" title="사랑방" onchange="javascript:document.location.href='/cafe/main.asp?cafe_id='+this.value;">
										<option value="">사랑방 선택</option>
										<%=makecombo("cafe_id","cafe_name","","cf_cafe"," order by cafe_name asc",cafe_id)%>
									</select>
								</li>
								<!--사랑방 바로가기-->
							<%
								End If
							%>
							<li><a href="javascript:pop_win('/cafe/form/retsform.htm','retsform','670','820')"><img src="/cafe/form/images/leftm_contract.gif" alt="계약서 서식 다운받기" /></a></li>
							<script>
								function pop_win(url, winname, width, height, left, top)
									if( left>=0 || top>=0 ){
										window.open(url, winname, "left=" + left + ",top=" + top + ",fullscreen=no,titlebar=no,toolbar=no,directories=no,status=no,menubar=no,resizable=yes,width=" + width + ",height=" + height);
									} else {
										//window.open(url, winname, "left =" + (screen.availWidth-width)/2 + ",top=" + (screen.availHeight-height)/2 + ",fullscreen=no,titlebar=no,toolbar=no,directories=no,status=no,menubar=no,resizable=yes,width=" + width + ",height=" + height);
										var w_left = window.screenLeft;
										var w_width = document.body.clientWidth;
										var w_top = window.screenTop;
										var w_height = document.body.clientHeight;
										left = (w_width-width)/2+w_left/2;
										top = (w_height-height)/2+w_top/2;
								
										window.open(url, winname, "left =" + left + ",top=" + top + ",fullscreen=no,titlebar=no,toolbar=no,directories=no,status=no,menubar=no,resizable=yes,width=" + width + ",height=" + height);
									}
								}
							</script>
							<li class="leftbanner"><a href="http://www.iros.go.kr/" target="_blank"><img src="/uploads/banner/deongi.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="http://www.courtauction.go.kr/" target="_blank"><img src="/uploads/banner/useful_kyungmae.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="https://seereal.lh.or.kr/" target="_blank"><img src="/uploads/banner/onnara.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="http://www.realtyprice.kr/notice/town/searchPastYear.htm" target="_blank"><img src="/uploads/banner/siga.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="javascript:jiga_wind()"><img src="/uploads/banner/jiga.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="javascript:pop_ydsds()"><img src="/uploads/banner/useful_yangdo.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="https://hometax.go.kr/websquare/websquare.html?w2xPath=/ui/pp/index.xml" target="_blank"><img src="/uploads/banner/hometax.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="https://kras.go.kr:444" target="_blank"><img src="/uploads/banner/kras_go_kr.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="http://www.kar.or.kr/" target="_blank"><img src="/uploads/banner/kar_or_kr.gif" style="width:135px;" /></a></li>
							<li class="leftbanner"><a href="http://www.lak.or.kr" target="_blank"><img src="/uploads/banner/lak_or_kr.gif" style="width:135px;" /></a></li>
							<script>
								function jiga_wind()
								{
									var jiga_wind = window.open("http://club.re4u.co.kr/jiga.htm","jiga_wind","width=800, height=550");
									jiga_wind.focus();
								}//function jiga_wind
								
								function pop_ydsds()
								{
									var yangdo_win = window.open('http://kar.serve.co.kr/agency/kar/calculators/pop_cal.asp?page_type=kar','yangdo_win','width=1000,height=600,left=20,top=10,scrollbars=yes');
									yangdo_win.focus();
								}//function pop_ydsds
							</Script>
						</ul>
					</li>
				</ul>
			</nav>

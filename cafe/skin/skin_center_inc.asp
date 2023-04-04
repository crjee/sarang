<script src="//ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
<script type="text/javascript" src="/cafe/jquery.vticker-min.js"></script>
<script type="text/javascript">
	$(function(){
		try {
			$('#dv_rolling').vTicker({
				// 스크롤 속도(default: 700)
				speed: 1000,
				// 스크롤 사이의 대기시간(default: 4000)
				pause: 2000,
				// 스크롤 애니메이션
				animation: 'fade',
				// 마우스 over 일때 멈출 설정
				mousePause: true,
				// 한번에 보일 리스트수(default: 2)
				showItems: 5,
				// 스크롤 컨테이너 높이(default: 0)
				height: 0,
				// 아이템이 움직이는 방향, up/down (default: up)
				direction: 'up'
			});
		}
		catch (e){
		}
	});
</script>
<%
	'중간 처리
	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "       ,case when banner_type = 'C0' Then '800' "
	sql = sql & "             when banner_type = 'C1' Then '267' "
	sql = sql & "             when banner_type = 'C2' Then '266' "
	sql = sql & "             when banner_type = 'C3' Then '267' "
	sql = sql & "             end width "
	sql = sql & "       ,'170' as height "
	sql = sql & "   from cf_banner "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
	sql = sql & "    and open_yn = 'Y' "
	sql = sql & "    and banner_type like 'C%' "
	sql = sql & "  order by banner_type asc "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
%>
				<div class="visual_box">
<%
		Do Until rs.eof
			width  = rs("width")
			height = rs("height")
			banner_type = rs("banner_type")

			If rs("link") <> "" Then
%>
							<a href="<%=rs("link")%>" target="_blank">
<%
			End If
%>
								<img src="<%=uploadUrl & rs("file_name")%>" style="width:<%=width%>px ;height:<%=height%>px;"/>
<%
			If rs("link") <> "" Then
%>
							</a>
<%
			End If
%>
						</li>
<%
			rs.MoveNext
		Loop
%>
					</ul>
				</div>
<%
	End If
	rs.close
%>
				<div class="sub_frm_flex">
<%
	sql = ""
	sql = sql & " select menu_type                                           "
	sql = sql & "       ,menu_name                                           "
	sql = sql & "       ,page_type                                           "
	sql = sql & "       ,menu_seq                                            "
	sql = sql & "       ,home_num                                            "
	sql = sql & "       ,home_cnt                                            "
	sql = sql & "       ,top_cnt                                             "
	sql = sql & "       ,wide_yn                                             "
	sql = sql & "       ,list_type                                           "
	sql = sql & "   from cf_menu cm                                          "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                             "
	sql = sql & "    and home_num != 0                                       "
	sql = sql & "    and menu_type not in ('page','group','division','poll') " ' album, board, job, land, sale
	sql = sql & "  order by home_num asc                                     "
	rs.Open Sql, conn, 3, 1

	i = 0
	Do Until rs.eof
		i = i + 1
		menu_type = rs("menu_type")
		menu_name = rs("menu_name")
		page_type = rs("page_type")
		menu_seq  = rs("menu_seq")
		home_num  = rs("home_num")
		home_cnt  = rs("home_cnt")
		top_cnt   = rs("top_cnt")
		wide_yn   = rs("wide_yn")
		list_type = rs("list_type")

		' 와이드형 여부 sf_col_1 : 와이드, sf_col_2 : 2단
		' 홀수 짝수(왼쪽 오른쪽) sub_frm_a : 와이드전체, sub_frm_l : 2단
		If wide_yn = "Y" Then
			wide_class = "sf_col_1"
			odd_even_class = "sub_frm_a"
		Else
			wide_class = "sf_col_2"
			If odd_even_class = "" Or odd_even_class = "sub_frm_a" Or odd_even_class = "sub_frm_r" Then
				odd_even_class = "sub_frm_l"
			Else
				odd_even_class = "sub_frm_l"
			End If
		End If

		' 리스트 타입 latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드
		If list_type = "T" Then
			list_class = "latest_1"
		ElseIf list_type = "C" Then
			If odd_even_class = "sub_frm_l" Then
				list_class = "latest_2"
			Else
				list_class = "latest_2 latest_2_re"
			End If
		ElseIf list_type = "A" Then
			If wide_yn = "Y" Then
				list_class = "latest_3 latest_3_ori"
			Else
				list_class = "latest_3"
			End If
		Else
			list_class = "latest_1"
		End If

		If menu_type = "land" Then
			land_id = "dv_rolling"
			home_cnt = "100"
		Else
			land_id = ""
		End If
%>
					<div class="<%=odd_even_class%>"><!-- sub_frm_a : 와이드전체, sub_frm_l : 2단 -->
						<div class="latest_box">
							<header class="latest_box_head">
								<h4 class="h4"><%=menu_name%></h4>
								<span class="posR"><a href="/cafe/skin/<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>">more</a></span>
							</header>
							<div class="tb" id="<%=land_id%>">
								<ul class="<%=list_class%>"><!-- latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드 -->
<%
		sql = ""
		sql = sql & " select * "
		sql = sql & " from ( "
		sql = sql & " select 1 as seq "
		sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
		sql = sql & "       ,subject "
		sql = sql & "       ,comment_cnt "
		sql = sql & "       ," & menu_type  & "_seq "
		sql = sql & "       ,group_num "
		sql = sql & "       ,step_num "
		If menu_type = "land" Then
		sql = sql & "       ,land_url "
		End If
		sql = sql & "   from cf_" & menu_type  & " "
		If menu_type = "land" Or menu_type = "job" Then
		sql = sql & "  where 1 = 1 "
		Else
		sql = sql & "  where cafe_id  = '" & cafe_id  & "' "
		sql = sql & "    and menu_seq = '" & menu_seq  & "' "
		End If
		If menu_type = "job" Then
		sql = sql & "    and end_date >= '" & date  & "' "
		End If
		sql = sql & "    and step_num = 0 "
		sql = sql & "    and top_yn = 'Y' "
		sql = sql & "  union all "
		sql = sql & " select top " & home_cnt  & " "
		sql = sql & "        2 as seq "
		sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
		sql = sql & "       ,subject "
		sql = sql & "       ,comment_cnt "
		sql = sql & "       ," & menu_type  & "_seq "
		sql = sql & "       ,group_num "
		sql = sql & "       ,step_num "
		If menu_type = "land" Then
		sql = sql & "       ,land_url "
		End If
		sql = sql & "   from cf_" & menu_type  & " "
		If menu_type = "land" Or menu_type = "job" Then
		sql = sql & "  where 1 = 1 "
		Else
		sql = sql & "  where cafe_id  = '" & cafe_id  & "' "
		sql = sql & "    and menu_seq = '" & menu_seq  & "' "
		End If
		If menu_type = "job" Then
		sql = sql & "    and end_date >= '" & date  & "' "
		End If
		sql = sql & "    and step_num = 0 "
		sql = sql & "    and isnull(top_yn,'') <> 'Y' "
		If menu_type = "board" Then
		sql = sql & "  order by seq, group_num desc, step_num asc "
		Else
		sql = sql & "  order by seq, " & menu_type  & "_seq desc "
		End If
		sql = sql & " ) aa "
		If menu_type = "board" Then
		sql = sql & " order by seq, group_num desc, step_num asc "
		Else
		sql = sql & " order by seq, " & menu_type  & "_seq desc "
		End If

		rs2.Open Sql, conn, 3, 1

		If Not rs2.eof Then
			Do Until rs2.eof
				seq          = rs2("seq")
				credt_txt = rs2("credt_txt")
				subject      = rs2("subject")
				comment_cnt  = rs2("comment_cnt")
				If comment_cnt > 0 Then
					comment_txt = "(" & comment_cnt & ")"
				Else
					comment_txt = ""
				End If
				view_url = "/cafe/skin/" & menu_type & "_view.asp?" & menu_type & "_seq=" & rs2(menu_type & "_seq") & "&menu_seq=" & menu_seq
%>
									<li class="t_nowrap">
										<a href="<%=view_url%>"><span class="text">
<%
				If seq = "1" Then
%>
										<img src="/cafe/skin/img/inc/notice.png" align="absmiddle"/>
<%
				End If
%>
										<%=subject%><%=comment_txt%>
										</span></a>
										<span class="posr"><%=credt_txt%></span>
									</li>
<%
				i = i + 1
				rs2.MoveNext
			Loop
		Else
%>
									<li class="t_nowrap no_data">
									데이터가 없습니다.
									</li>
<%

		End If
		rs2.close
%>
								</ul>
							</div>
						</div>
					</div>
<%
		rs.MoveNext
	Loop
	rs.close
	Set rs = Nothing
%>
				</div>
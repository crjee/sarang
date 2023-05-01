<%
	If cafe_id <> "home" Then Response.End
%>
				<div class="main_frm_flex mff_block_1">
<%
	Set centerRs  = Server.CreateObject("ADODB.Recordset")
	Set centerRs2 = Server.CreateObject("ADODB.Recordset")
	Set centerRs3 = Server.CreateObject("ADODB.Recordset")
	Dim arrSecSeq(), arrSecNm()

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
	sql = sql & "       ,tab_use_yn                                          "
	sql = sql & "       ,all_tab_use_yn                                      "
	sql = sql & "       ,etc_tab_use_yn                                      "
	sql = sql & "   from cf_menu cm                                          "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                         "
	sql = sql & "    and home_num > 1                                        "
	sql = sql & "    and menu_type not in ('page','group','division','poll') " ' nsale, board, job, land, sale
	sql = sql & "  order by home_num asc                                     "
	centerRs.Open Sql, conn, 3, 1

	Do Until centerRs.eof
		menu_type      = centerRs("menu_type")
		menu_name      = centerRs("menu_name")
		page_type      = centerRs("page_type")
		menu_seq       = centerRs("menu_seq")
		home_num       = centerRs("home_num")
		home_cnt       = centerRs("home_cnt")
		top_cnt        = centerRs("top_cnt")
		wide_yn        = centerRs("wide_yn")
		list_type      = centerRs("list_type")
		tab_use_yn     = centerRs("tab_use_yn")
		all_tab_use_yn = centerRs("all_tab_use_yn")
		etc_tab_use_yn = centerRs("etc_tab_use_yn")

		' 와이드형 여부 sf_col_1 : 와이드, sf_col_2 : 2열
		' 홀수 짝수(왼쪽 오른쪽) main_frm_a : 와이드, main_frm_l : 2열
		If wide_yn = "Y" Then
			wide_class = "sf_col_1"
			odd_even_class = "main_frm_a"
		Else
			wide_class = "sf_col_2"
			If odd_even_class = "" Or odd_even_class = "main_frm_a" Or odd_even_class = "main_frm_r" Then
				odd_even_class = "main_frm_l"
			Else
				odd_even_class = "main_frm_l"
			End If
		End If

		' 리스트 타입 latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드
		If list_type = "T1" Then
			list_class = "latest_1"
		ElseIf list_type = "C1" Then
			If list_type = "C1" Then
				list_class = "latest_2"
			Else
				list_class = "latest_2 latest_2_re"
			End If
		ElseIf list_type = "A1" Then
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

		If home_cnt = "0" Then
			home_cnt = "5"
		End If
%>
					<div class="<%=odd_even_class%>"><!-- main_frm_a : 와이드, main_frm_l : 2열 -->
						<div class="latest_box">
							<header class="latest_box_head">
								<h4 class="h4"><%=menu_name%></h4>
<%
		If list_type = "A1" Then
%>
								<span class="ctr_box">
									<button type="button" id="btn_gs2_prev<%=menu_seq%>" class="btn_prev btn_gs2_prev"><em>이전</em></button>
									<button type="button" id="btn_gs2_next<%=menu_seq%>" class="btn_next btn_gs2_next"><em>다음</em></button>
								</span>
								<script>
									$(function(){
										$("#btn_gs2_prev<%=menu_seq%>").on("click",function(e){
try{
											e.preventDefault();
											$("#slide_2<%=menu_seq%>").slick("slickPrev");
}catch(e){alert(e)}
										});
										$("#btn_gs2_next<%=menu_seq%>").on("click",function(e){
											e.preventDefault();
											$("#slide_2<%=menu_seq%>").slick("slickNext");
										});
									});
								</script>
<%
		End If
%>
								<span class="posR"><a href="/home/<%=menu_type%>_list.asp?menu_seq=<%=menu_seq%>">more</a></span>
							</header>
							<div class="tb main_rolling" id="<%=land_id%>">
<%
		If tab_use_yn = "Y" Then ' 탭정보 확인
			sql = ""
			sql = sql & " select section_seq                   "
			sql = sql & "       ,section_nm                    "
			sql = sql & "       ,section_sn                    "
			sql = sql & "   from cf_menu_section               "
			sql = sql & "  where menu_seq = '" & menu_seq & "' "
			sql = sql & "    and use_yn = 'Y'                  "
			If all_tab_use_yn = "Y" Then
			sql = sql & "  union all                           "
			sql = sql & " select 0     as section_seq          "
			sql = sql & "       ,'전체' as section_nm           "
			sql = sql & "       ,0     as section_sn           "
			End If
			If etc_tab_use_yn = "Y" Then
			sql = sql & "  union all                           "
			sql = sql & " select 999999999 as section_seq      "
			sql = sql & "       ,'기타'     as section_nm       "
			sql = sql & "       ,999999999 as section_sn       "
			End If
			sql = sql & "  order by section_sn                 "
			centerRs2.open Sql, conn, 3, 1

			ReDim arrSecSeq(centerRs2.recordCount)
			ReDim arrSecNm(centerRs2.recordCount)

			If Not centerRs2.eof Then
%>
								<div class="slide_cate">
<%
				centerRs2_i = 1
				Do Until centerRs2.eof
					section_seq = centerRs2("section_seq")
					section_nm  = centerRs2("section_nm")

					arrSecSeq(centerRs2_i) = section_seq
					arrSecNm(centerRs2_i)  = section_nm
%>
									<a href="#tab_n_cont<%=menu_seq%>_<%=centerRs2_i%>" class="<%=if3(centerRs2_i=1,"on","")%>"><%=section_nm%></a>
<%
					centerRs2.MoveNext
					centerRs2_i = centerRs2_i + 1
				Loop
%>
								</div>
<%
			End If
			centerRs2.close
		Else
			ReDim arrSecSeq(1)
			ReDim arrSecNm(1)
		End If

		For for_i = 1 To UBound(arrSecSeq)
			sql = ""
			sql = sql & " select * "
			sql = sql & " from ( "
			sql = sql & " select 1 as seq "
			sql = sql & "       ,top_yn "
			sql = sql & "       ,reg_date "
			sql = sql & "       ,subject "
			sql = sql & "       ,comment_cnt "
			sql = sql & "       ," & menu_type & "_seq "
			sql = sql & "       ,group_num "
			sql = sql & "       ,step_num "
			If menu_type = "land" Then
			sql = sql & "       ,land_url "
			Else
			sql = sql & "       ,null land_url "
			End If
			If menu_type = "nsale" Then
			sql = sql & "       ,rect_notice_date  "
			sql = sql & "       ,mvin_date  "
			Else
			sql = sql & "       ,null rect_notice_date  "
			sql = sql & "       ,null mvin_date  "
			End If
			If menu_type = "land" Then
			sql = sql & "   from cf_" & menu_type  & " "
			Else
			sql = sql & "   from gi_" & menu_type  & " "
			End If
			If menu_type = "land" Or menu_type = "job" Then
			sql = sql & "  where 1 = 1 "
			Else
			sql = sql & "  where cafe_id  = '" & cafe_id  & "' "
			sql = sql & "    and menu_seq = '" & menu_seq  & "' "
			End If
			If menu_type = "job" Then
			sql = sql & "    and end_date >= '" & date  & "' "
			End If
			If arrSecSeq(for_i) = 0 Then
			ElseIf arrSecSeq(for_i) = 999999 Then
			sql = sql & "    and (section_seq = null or section_seq = '') "
			Else
			sql = sql & "    and section_seq = '" & arrSecSeq(for_i) & "' "
			End If
			sql = sql & "    and step_num = 0 "
			sql = sql & "    and top_yn = 'Y' "
			sql = sql & "  union all "
			sql = sql & " select top " & home_cnt  & " "
			sql = sql & "        2 as seq "
			sql = sql & "       ,top_yn "
			sql = sql & "       ,reg_date "
			sql = sql & "       ,subject "
			sql = sql & "       ,comment_cnt "
			sql = sql & "       ," & menu_type  & "_seq "
			sql = sql & "       ,group_num "
			sql = sql & "       ,step_num "
			If menu_type = "land" Then
			sql = sql & "       ,land_url "
			Else
			sql = sql & "       ,null land_url "
			End If
			If menu_type = "nsale" Then
			sql = sql & "       ,rect_notice_date  "
			sql = sql & "       ,mvin_date  "
			Else
			sql = sql & "       ,convert(varchar(10), credt, 120) as rect_notice_date  "
			sql = sql & "       ,null mvin_date  "
			End If
			If menu_type = "land" Then
			sql = sql & "   from cf_" & menu_type  & " "
			Else
			sql = sql & "   from gi_" & menu_type  & " "
			End If
			If menu_type = "land" Or menu_type = "job" Then
			sql = sql & "  where 1 = 1 "
			Else
			sql = sql & "  where cafe_id  = '" & cafe_id  & "' "
			sql = sql & "    and menu_seq = '" & menu_seq  & "' "
			End If
			If menu_type = "job" Then
			sql = sql & "    and end_date >= '" & Date & "' "
			End If
			If arrSecSeq(for_i) = 0 Then
			ElseIf arrSecSeq(for_i) = 999999 Then
			sql = sql & "    and (section_seq = null or section_seq = '') "
			Else
			sql = sql & "    and section_seq = '" & arrSecSeq(for_i) & "' "
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
			centerRs2.Open Sql, conn, 3, 1

			If tab_use_yn = "Y" Then ' 탭정보 확인
%>
								<div id="tab_n_cont<%=menu_seq%>_<%=for_i%>" class="tab_cont<%=if3(for_i=1," on","")%>"><!-- tab -->
<%
			End If

			If Not centerRs2.eof Then
				If list_type = "T1" Then
%>
								<ul class="<%=list_class%>"><!-- latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드 -->
<%
				ElseIf list_type = "C1" Then
%>
								<ul class="<%=list_class%>"><!-- latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드 -->
<%
				ElseIf list_type = "A1" Then
%>
								<div class="tb">
									<div id="slide_2<%=menu_seq%>" class="slide_2">
<%
				Else
%>
								<ul class="<%=list_class%>"><!-- latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드 -->
<%
				End If

				centerRs2_i = 1
				Do Until centerRs2.eof
					seq              = centerRs2("seq")
					top_yn           = centerRs2("top_yn")
					reg_date         = centerRs2("reg_date")
					subject          = centerRs2("subject")
					comment_cnt      = centerRs2("comment_cnt")
					rect_notice_date = centerRs2("rect_notice_date")
					mvin_date        = centerRs2("mvin_date")
					land_url         = centerRs2("land_url")
					com_seq          = centerRs2(menu_type & "_seq")

					If comment_cnt > 0 Then
						comment_txt = "(" & comment_cnt & ")"
					Else
						comment_txt = ""
					End If

					view_url = "/home/" & menu_type & "_view.asp?" & menu_type & "_seq=" & centerRs2(menu_type & "_seq") & "&menu_seq=" & menu_seq

					If list_type = "T1" Then
%>
									<li class="t_nowrap">
<%
						If menu_type = "land" Then
							view_url = "http://land.naver.com/" & land_url
%>
										<a href="<%=view_url%>" target="_blank"><span class="text" style="width:1000px;"><%=subject%></span></a>
<%
						Else
%>
										<a href="<%=view_url%>">
											<span class="text">
<%
							If top_yn = "Y" Then
%>
												<img src="/cafe/img/btn/btn_notice.png" />
<%
							End If
%>
												<%=subject%><%=comment_txt%>
											</span>
										</a>
										<span class="posr"><%=Left(reg_date, 10)%></span>
<%
						End If
%>
									</li>
<%
					ElseIf list_type = "C1" Then
%>
									<li>
<%
						thumbnailUrl = ConfigAttachedFileURL & "thumbnail/" & menu_type & "/"
						thumbnailPath = ConfigAttachedFileFolder & "thumbnail\" & menu_type & "\"

						sql = ""
						sql = sql & " select *                                         "
						sql = sql & "   from gi_" & menu_type & "_attach               "
						sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
						sql = sql & "    and rprs_file_yn = 'Y'                        "
						centerRs3.Open Sql, conn, 3, 1

						If Not centerRs3.EOF Then
							thmbnl_file_nm = centerRs3("thmbnl_file_nm")

							' 썸네일로 표시
							fileUrl = thumbnailUrl & thmbnl_file_nm
							filePath = thumbnailPath & thmbnl_file_nm
%>
										<span class="photos"><a href="<%=view_url%>"><img src="<%=fileUrl%>" alt="" /></a></span>
<%
						Else
%>
										<span class="photos"></span>
<%
						End If
						centerRs3.close
%>
										<a href="<%=view_url%>"><span class="text"><%=subject%></span></a>
										<span class="posr"><%=Left(reg_date, 10)%></span>
									</li>
<%
					ElseIf list_type = "A1" Then
						If (wide_yn = "Y" And centerRs2_i Mod 12 = 1) Or (wide_yn <> "Y" And centerRs2_i Mod 6 = 1) Then
							If centerRs2_i > 1 Then
%>
										</div>
<%
							End If
%>
										<div class="slide_in">
<%
						End If
%>
											<div class="c_wrap">
<%
						thumbnailUrl = ConfigAttachedFileURL & "thumbnail/" & menu_type & "/"
						thumbnailPath = ConfigAttachedFileFolder & "thumbnail\" & menu_type & "\"

						sql = ""
						sql = sql & " select *                                         "
						sql = sql & "   from gi_" & menu_type & "_attach               "
						sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "
						sql = sql & "    and rprs_file_yn = 'Y'                        "
						centerRs3.Open Sql, conn, 3, 1

						If Not centerRs3.EOF Then
							thmbnl_file_nm = centerRs3("thmbnl_file_nm")

							' 썸네일로 표시
							fileUrl = thumbnailUrl & thmbnl_file_nm
							filePath = thumbnailPath & thmbnl_file_nm
%>
												<span class="photos"><a href="<%=view_url%>"><img src="<%=fileUrl%>" border="0" /></a></span>
<%
						Else
%>
												<span class="photos"></span>
<%
						End If
						centerRs3.close
%>
												<a href="<%=view_url%>"><span class="text"><%=subject%></span></a>
												<span class="posr">
<%
						If menu_type = "nsale" Then
%>
													<span title="모집공고일"><%=rect_notice_date%></span> <%=if3(rect_notice_date<>"" Or mvin_date<>""," ㅣ ","")%> <span title="입주일"><%=mvin_date%></span>
<%
						Else
%>
													<span title="등록일"><%=rect_notice_date%></span></span>
<%
						End If
%>
												</span>
											</div>
<%
					Else
%>
									<li class="t_nowrap">
										<a href="<%=view_url%>"><span class="text"><%=subject%><%=comment_txt%></span></a>
										<span class="posr"><%=Left(reg_date, 10)%></span>
									</li>
<%
					End If
					centerRs2_i = centerRs2_i + 1
					centerRs2.MoveNext
				Loop

				If list_type = "T1" Then
%>
								</ul>
<%
				ElseIf list_type = "C1" Then
%>
								</ul>
<%
				ElseIf list_type = "A1" Then
%>
										</div>
									</div>
								</div>
<%
				Else
%>
								</ul>
<%
				End If
			Else
				If list_type = "T1" Then
%>
								<ul>
									<li class="t_nowrap no_data">
										데이터가 없습니다.
									</li>
								</ul>
<%
				ElseIf list_type = "C1" Then
%>
								<ul>
									<li class="t_nowrap no_data">
										데이터가 없습니다.
									</li>
								</ul>
<%
				ElseIf list_type = "A1" Then
%>
									<div class="nodata">
										<span class="txt"><%=arrSecNm(li)%> 데이터가 없습니다.</span>
									</div>
<%
				Else
%>
								<ul>
									<li class="t_nowrap no_data">
										데이터가 없습니다.
									</li>
								</ul>
<%
				End If
			End If

			If tab_use_yn = "Y" Then ' 탭정보 확인
%>
								</div><!-- tab -->
<%
			End If
			centerRs2.close
		Next
%>
							</div>
						</div>
					</div>
<%
		centerRs.MoveNext
	Loop
	centerRs.close

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_poll qp "
	sql = sql & "  where qp.cafe_id = '"&cafe_id&"' "
	sql = sql & "    and qp.ddln_yn = 'N' "
	sql = sql & "  order by poll_seq desc "
	centerRs.Open Sql, conn, 3, 1

	If Not centerRs.eof Then
		Do Until centerRs.eof
			poll_seq = centerRs("poll_seq")
			subject  = centerRs("subject")
			sdate    = centerRs("sdate")
			edate    = centerRs("edate")
%>
					<div class="sub_frm_l"><!-- sub_frm_a : 와이드, sub_frm_l : 2열 -->
						<div class="latest_box">
							<header class="latest_box_head">
								<h4 class="h4">설문조사</h4>
								<span class="posR">
<%
					If centerRs("edate") = "" Then edate = Date()

					If datediff("d", Date(), edate) >= 0 Then
%>
									<button type="button" class="btn btn_c_a btn_s" onclick="goPoll(<%=centerRs("poll_seq")%>)">투표하기</button>
<%
					End If
%>
									<button type="button" class="btn btn_c_a btn_s" onclick="window.open('/cafe/poll_result.asp?cafe_id=<%=cafe_id%>&poll_seq=<%=centerRs("poll_seq")%>&user_id=<%=session("user_id")%>&ipin=<%=ipin%>','result','width=500,height=500')">결과보기</button>
								</span>
							</header>
							<div class="tb main_rolling">
								<ul class="latest_1"><!-- latest_1 : 텍스트, latest_2 : 카드좌, latest_2 latest_2_re : 카드우, latest_3 : 앨범일반, latest_3 latest_3_ori : 앨범와이드 -->
<!--#include virtual="/cafe/poll_view_inc.asp"-->
								</ul>
							</div>
						</div>
					</div>
<%
			centerRs.MoveNext
		Loop
	End If
	centerRs.close
	Set centerRs = Nothing
%>
				</div>
				<script src="/common/js/jquery.vticker-min.js"></script>
				<script>
					$(function() {
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
						catch (e) {
						}
					});
				</script>

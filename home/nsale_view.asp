<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	checkCafePage(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>분양소식 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
<%
	page      = Request("page")
	pagesize  = Request("pagesize")
	sch_type  = Request("sch_type")
	sch_word  = Request("sch_word")
	all_yn    = Request("all_yn")

	nsale_seq = Request("nsale_seq")

	Call setViewCnt(menu_type, nsale_seq)

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cb.* "
	sql = sql & "       ,cm.phone as tel_no "
	sql = sql & "   from cf_nsale cb "
	sql = sql & "   left join cf_member cm on cm.user_id = cb.user_id "
	sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		subject                = rs("subject")
		open_yn                = rs("open_yn")
		nsale_rgn_cd        = rs("nsale_rgn_cd")
		nsale_addr             = rs("nsale_addr")
		cmpl_se_cd             = rs("cmpl_se_cd")
		nsale_stts_cd          = rs("nsale_stts_cd")
		rect_notice_date       = rs("rect_notice_date")
		frst_receipt_acpt_date = rs("frst_receipt_acpt_date")
		scnd_receipt_acpt_date = rs("scnd_receipt_acpt_date")
		prize_anc_date         = rs("prize_anc_date")
		cnt_st_date            = rs("cnt_st_date")
		cnt_ed_date            = rs("cnt_ed_date")
		resale_st_date         = rs("resale_st_date")
		resale_ed_date         = rs("resale_ed_date")
		mvin_date              = rs("mvin_date")
		mdl_house_addr         = rs("mdl_house_addr")
		contents               = rs("contents")
		creid                  = rs("creid")
		credt                  = rs("credt")
		modid                  = rs("modid")
		moddt                  = rs("moddt")
		cafe_id                = rs("cafe_id")
		nsale_seq              = rs("nsale_seq")
		top_yn                 = rs("top_yn")
		view_cnt               = rs("view_cnt")
		parent_seq             = rs("parent_seq")
		parent_del_yn          = rs("parent_del_yn")
		restoreid              = rs("restoreid")
		restoredt              = rs("restoredt")
		comment_cnt            = rs("comment_cnt")
		step_num               = rs("step_num")
		group_num              = rs("group_num")
		menu_seq               = rs("menu_seq")
		user_id                = rs("user_id")
		level_num              = rs("level_num")
		nsale_num              = rs("nsale_num")
	End If
%>
			<script>
				function goPrint() {
					var initBody;
					window.onbeforeprint = function() {
						initBody = document.body.innerHTML;
						document.body.innerHTML =  document.getElementById('print_area').innerHTML;
					};
					window.onafterprint = function() {
						document.body.innerHTML = initBody;
					};
					window.print();
				}

				function goList() {
					document.search_form.action = "/home/nsale_list.asp"
					document.search_form.submit();
				}
				function goReply() {
					document.search_form.action = "/home/nsale_reply.asp"
					document.search_form.submit();
				}
				function goModify() {
					try{
						document.search_form.action = "/home/nsale_modify.asp"
						document.search_form.submit();
					} catch(e) {
						alert(e)
					}
				}
				function goDelete() {
					document.search_form.action = "/home/com_waste_exec.asp"
					document.search_form.submit();
				}
				function goNotice() {
					document.search_form.action = "/home/com_top_exec.asp"
					document.search_form.submit();
				}
				function goSuggest() {
					document.search_form.action = "/home/com_suggest_exec.asp"
					document.search_form.submit();
				}
				function goMove() {
					document.open_form.action = "/win_open_exec.asp"
					document.open_form.target = "hiddenfrm";
					document.open_form.submit();
				}
			</script>
			<form name="open_form" method="post">
			<input type="hidden" name="open_url" value="/cafe/skin/com_move_edit_p.asp?com_seq=<%=nsale_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
			<input type="hidden" name="open_name" value="com_move">
			<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
			</form>
			<form name="search_form" method="post">
			<input type="hidden" name="sch_type" value="<%=sch_type%>">
			<input type="hidden" name="sch_word" value="<%=sch_word%>">
			<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
			<input type="hidden" name="all_yn" value="<%=all_yn%>">
			<input type="hidden" name="page" value="<%=page%>">
			<input type="hidden" name="pagesize" value="<%=pagesize%>">
			<input type="hidden" name="task">
			<input type="hidden" name="nsale_seq" value="<%=nsale_seq%>">
			<input type="hidden" name="com_seq" value="<%=nsale_seq%>">
			<input type="hidden" name="group_num" value="<%=rs("group_num")%>">
			<input type="hidden" name="level_num" value="<%=rs("level_num")%>">
			<input type="hidden" name="step_num" value="<%=rs("step_num")%>">
			</form>
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%> 내용보기</h2>
				</div>
				<div class="btn_box view_btn">
<%
	If cafe_mb_level > 6 Or rs("user_id") = session("user_id") Then
		If rs("step_num") = "0" Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="goModify()">수정</button>
<%
		End If
	End If
%>
<%
	write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & Request("menu_seq")  & "'")

	If toInt(write_auth) <= toInt(cafe_mb_level) Then
%>
					<button class="btn btn_c_n btn_n" type="button" onclick="location.href='/home/nsale_write.asp?menu_seq=<%=menu_seq%>'">글쓰기</button>
<%
	End If

	cd_expl_txt = getonevalue("CD_EXPL","sys_cd","where CD_NM = 'cmpl_se_cd' and CMN_CD = '" & cmpl_se_cd & "'")
%>
					<!-- <a href="#n" class="btn btn_c_n btn_n" onclick="goPrev()">이전글</a> -->
					<!-- <a href="#n" class="btn btn_c_n btn_n" onclick="goNext()">다음글</a> -->
					<a href="#n" class="btn btn_c_n btn_n" onclick="goList()">목록</a>
					<a href="#n" class="btn btn_c_a btn_n" onclick="goPrint()">인쇄</a>
				</div>
				<div class="view_head">
					<h3 class="h3"><span class="milestone">분양계획</span> [<%=cd_expl_txt%>]<%=subject%></h3>
					<div class="wrt_info_box posR">
						<ul>
							<li><span>작성자</span><strong><%=subject%></strong></li>
							<li><span>조회</span><strong><%=view_cnt%></strong></li>
							<li><span>추천</span><strong><%=view_cnt%></strong></li>
							<li><span>등록일시</span><strong><%=credt%></strong></li>
						</ul>
					</div>
					<div class="view_head_frame">
						<div class="view_head_photo">
							<div class="photo_box">
<%
	uploadUrl = ConfigAttachedFileURL & "nsale/"

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_nsale_attach "
	sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
	sql = sql & "  order by nsale_seq "
	rs2.Open Sql, conn, 3, 1

	If Not rs2.EOF Then
		Do Until rs2.EOF
%>
								<div><img src="<%=uploadUrl & rs2("file_name")%>" alt="" /></div>
<%
			rs2.MoveNext
		Loop
	End If
	rs2.close
%>
							</div>
							<script>
								$(".photo_box").slick({
									infinite : true,
									slidesToShow : 1,
									slidesToScroll : 1,
									variableWidth : false,
								});
							</script>
						</div>
						<div class="view_head_cont">
							<div class="tb">
								<table class="tb_fixed">
									<caption></caption>
									<colgroup>
										<col class="w20" />
										<col class="w30" />
										<col class="w20" />
										<col class="w30" />
									</colgroup>
									<tbody>
										<tr>
											<th scope="row">분양주소</th>
											<td colspan="3"><%=nsale_addr%></td>
										</tr>
										<tr>
											<th scope="row">모집공고일</th>
											<td><%=rect_notice_date%></td>
											<th rowspan="2" scope="row">청약접수일</th>
											<td>1순위 : <%=frst_receipt_acpt_date%></td>
										</tr>
										<tr>
											<th scope="row">당첨발표일</th>
											<td><%=prize_anc_date%></td>
											<td>2순위 : <%=scnd_receipt_acpt_date%></td>
										</tr>
										<tr>
											<th scope="row">계약기간</th>
											<td colspan="3"><%=cnt_st_date%> ~ <%=cnt_ed_date%></td>
										</tr>
										<tr>
											<th scope="row">전매기간</th>
											<td colspan="3"><%=resale_st_date%> ~ <%=resale_ed_date%></td>
										</tr>
										<tr>
											<th scope="row">입주일</th>
											<td colspan="3"><%=mvin_date%> ~</td>
										</tr>
										<tr>
											<th scope="row">모델하우스 위치</th>
											<td colspan="3"><%=mdl_house_addr%></td>
										</tr>
									</tbody>
								</table>
							</div>
						</div>
					</div>
				</div>
				<!-- 
				<div class="view_cont">
					<h4 class="f_awesome h4">단지 정보 상세 내용</h4>
					<div class="tb">
						<table class="tb_input tb_fixed">
							<colgroup>
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
								<col class="w110p">
								<col class="w_remainder">
							</colgroup>
							<tbody>
								<tr>
									<th scope="row">총세대수</th>
									<td>2,500</td>
									<th scope="row">총동수</th>
									<td>100</td>
									<th scope="row">총주차대수</th>
									<td>5,500</td>
									<th scope="row">가구당 주차수</th>
									<td>3</td>
								</tr>
								<tr>
									<th scope="row">최고/최저층</th>
									<td>35</td>
									<th scope="row">면적정보</th>
									<td>5,500</td>
									<th scope="row">건설사</th>
									<td>현대산업개발</td>
									<th scope="row">난방방식</th>
									<td>지역난방</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				 -->
				<div class="view_cont">
					<h4 class="f_awesome h4">입주자 모집공고</h4>
					<div class="tb">
						<%=contents%>
					</div>
				</div>
				
				<div class="btn_box">
					<a href="#n" class="btn btn_c_n btn_n">이전글</a>
					<a href="#n" class="btn btn_c_n btn_n">다음글</a>
					<a href="#n" class="btn btn_c_n btn_n">목록</a>
					<a href="#n" class="btn btn_c_a btn_n">인쇄</a>
				</div>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>
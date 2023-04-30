<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"

	Call CheckAdmin()

	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	com_seq = Request(menu_type & "_seq")
	Call CheckWasteExist(com_seq)

	pageUrl = "http://" & request.servervariables("HTTP_HOST") & request.servervariables("HTTP_URL")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>경인 홈</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
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
	home_sch  = Request("home_sch")

	nsale_seq = Request("nsale_seq")
	waset_yn  = "Y"

	Call SetViewCnt(menu_type, com_seq)

	page_move = Request("page_move")

	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	If page_move = "prev" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
		sql = sql & "       ,nsale_seq as prev_seq                                               "
		sql = sql & "   from gi_waste_nsale                                                      "
		sql = sql & "  where nsale_seq > '" & nsale_seq & "'                                     "
		sql = sql & "  order by group_num asc, step_num desc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			prev_seq = rs("prev_seq")
		End If
		rs.close
		nsale_seq = prev_seq
	ElseIf page_move = "next" Then
		sql = ""
		sql = sql & " select top 1                                                               "
		sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
		sql = sql & "       ,nsale_seq as next_seq                                               "
		sql = sql & "   from gi_waste_nsale                                                      "
		sql = sql & "  where nsale_seq < '" & nsale_seq & "'                                     "
		sql = sql & "  order by group_num desc, step_num asc                                     "
		' Response.write sql & "<br>"
		rs.Open Sql, conn, 3, 1

		If Not rs.eof Then
			next_seq = rs("next_seq")
		End If
		rs.close
		nsale_seq = next_seq
	End If
	' Response.write "page_move : " & page_move & "<br>"
	' Response.write "nsale_seq : " & nsale_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	prev_seq = ""
	next_seq = ""
	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num asc, step_num desc) as rownum "
	sql = sql & "       ,nsale_seq as prev_seq                                               "
	sql = sql & "   from gi_waste_nsale                                                      "
	sql = sql & "  where nsale_seq > '" & nsale_seq & "'                                     "
	sql = sql & "  order by group_num asc, step_num desc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		prev_seq = rs("prev_seq")
	End If
	rs.close

	sql = ""
	sql = sql & " select top 1                                                               "
	sql = sql & "        row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "       ,nsale_seq as next_seq                                               "
	sql = sql & "   from gi_waste_nsale                                                      "
	sql = sql & "  where nsale_seq < '" & nsale_seq & "'                                     "
	sql = sql & "  order by group_num desc, step_num asc                                     "
	' Response.write sql & "<br>"
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		next_seq = rs("next_seq")
	End If
	rs.close
	' Response.write "nsale_seq : " & nsale_seq & "<br>"
	' Response.write "prev_seq : " & prev_seq & "<br>"
	' Response.write "next_seq : " & next_seq & "<br>"

	sql = ""
	sql = sql & "  with cd1                                                      "
	sql = sql & "    as (                                                        "
	sql = sql & "        select section_seq                                      "
	sql = sql & "              ,section_nm                                       "
	sql = sql & "          from cf_menu_section                                  "
	sql = sql & "         where menu_seq = '" & menu_seq & "'                    "
	sql = sql & "       )                                                        "
	sql = sql & " ,     cd2                                                      "
	sql = sql & "    as (                                                        "
	sql = sql & "        select cmn_cd                                           "
	sql = sql & "              ,cd_nm                                            "
	sql = sql & "          from cf_code                                          "
	sql = sql & "         where up_cd_id = (select cd_id                         "
	sql = sql & "                                 from cf_code                   "
	sql = sql & "                                where up_cd_id = 'CD0000000000' "
	sql = sql & "                                  and cmn_cd = 'cmpl_se_cd'     "
	sql = sql & "                              )                                 "
	sql = sql & "       )                                                        "
	sql = sql & " select cb.* "
	sql = sql & "       ,cd1.section_nm as section_nm "
	sql = sql & "       ,cd2.cd_nm as cmpl_se_cd_txt "
	sql = sql & "   from gi_waste_nsale cb "
	sql = sql & "   left join cd1 on cd1.section_seq = cb.section_seq "
	sql = sql & "   left join cd2 on cd2.cmn_cd = cb.cmpl_se_cd "
	sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.eof Then
		subject                = rs("subject")
		open_yn                = rs("open_yn")
		section_seq            = rs("section_seq")
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
		delid                  = rs("delid")
		deldt                  = rs("deldt")
		comment_cnt            = rs("comment_cnt")
		step_num               = rs("step_num")
		group_num              = rs("group_num")
		menu_seq               = rs("menu_seq")
		user_id                = rs("user_id")
		level_num              = rs("level_num")
		nsale_num              = rs("nsale_num")
		section_nm             = rs("section_nm")
		cmpl_se_cd_txt         = rs("cmpl_se_cd_txt")
		suggest_cnt            = rs("suggest_cnt")

	End If
%>
				<form name="open_form" method="post">
				<input type="hidden" name="open_url" value="/cafe/com_move_edit_p.asp?com_seq=<%=nsale_seq%>&menu_seq=<%=menu_seq%>&cafe_id=<%=cafe_id%>">
				<input type="hidden" name="open_name" value="com_move">
				<input type="hidden" name="open_specs" value="width=340, height=310, left=150, top=150">
				</form>
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
				<input type="hidden" name="pagesize" value="<%=pagesize%>">
				<input type="hidden" name="sch_type" value="<%=sch_type%>">
				<input type="hidden" name="sch_word" value="<%=sch_word%>">
				<input type="hidden" name="self_yn" value="<%=self_yn%>">
				<input type="hidden" name="page_move" value="<%=page_move%>">
				<input type="hidden" name="task">

				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="nsale_seq" value="<%=nsale_seq%>">
				<input type="hidden" name="com_seq" value="<%=nsale_seq%>">

				<input type="hidden" name="group_num" value="<%=group_num%>">
				<input type="hidden" name="level_num" value="<%=level_num%>">
				<input type="hidden" name="step_num" value="<%=step_num%>">
				</form>
				<div class="cont_tit">
					<h2 class="h2"><font color="red">휴지통 <%=menu_name%> 내용보기</font></h2>
				</div>
 				<div class="btn_box view_btn">
					<button type="button" class="btn btn_c_n btn_n" onclick="godel()">복원</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
				</div>
				<div id="print_area"><!-- 프린트영역 추가 crjee -->
					<div class="view_head">
						<h3 class="h3"><span class="milestone">분양계획</span> [<%=cmpl_se_cd_txt%>]<%=subject%></h3>
						<div class="wrt_info_box posR">
							<ul>
								<li><span>글쓴이</span><strong><%=subject%></strong></li>
								<li><span>조회</span><strong><%=view_cnt%></strong></li>
								<li><span>추천</span><strong><%=suggest_cnt%></strong></li>
								<li><span>등록일시</span><strong><%=credt%></strong></li>
							</ul>
						</div>
					</div>
					<div class="wrt_file_box"><!-- 첨부파일영역 추가 crjee -->
<!--#include virtual="/include/attach_view_inc.asp"-->
						<div class="view_head_frame">
							<div class="view_head_photo">
								<div class="photo_box">
<%
	displayUrl = ConfigAttachedFileURL & "display/nsale/"

	sql = ""
	sql = sql & " select *                               "
	sql = sql & "   from gi_waste_nsale_attach           "
	sql = sql & "  where nsale_seq = '" & nsale_seq & "' "
	sql = sql & "    and atch_file_se_cd = 'IMG'         "
	sql = sql & "  order by attach_num                   "
	rs2.Open Sql, conn, 3, 1

	If Not rs2.EOF Then
		Do Until rs2.EOF
			dsply_file_nm = rs2("dsply_file_nm")

			fileUrl = displayUrl & dsply_file_nm
			filePath = displayUrl & dsply_file_nm
%>
								<div><img src="<%=fileUrl%>" alt="" /></div>
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
<%
	If tab_use_yn = "Y" Then
%>
											<tr>
												<th scope="row"><%=tab_nm%></th>
												<td colspan="3"><%=section_nm%></td>
											</tr>
<%
	End If
%>
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
												<td colspan="3"><%=cnt_st_date%> <%=if3(cnt_st_date<>"" Or cnt_ed_date<>""," ~ ","")%> <%=cnt_ed_date%></td>
											</tr>
											<tr>
												<th scope="row">전매기간</th>
												<td colspan="3"><%=resale_st_date%> <%=if3(resale_st_date<>"" Or resale_ed_date<>""," ~ ","")%> <%=resale_ed_date%></td>
											</tr>
											<tr>
												<th scope="row">입주일</th>
												<td colspan="3"><%=mvin_date%></td>
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
					<div class="view_cont">
						<h4 class="f_awesome h4">입주자 모집공고</h4>
						<div class="tb">
							<%=contents%>
						</div>
					</div>
				</div>
				<div class="btn_box">
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(prev_seq="","alert('처음 입니다.')","goPrev()")%>">이전글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(next_seq="","alert('마지막 입니다')","goNext()")%>">다음글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
					<button type="button" class="btn btn_c_a btn_n" onclick="goPrint()">인쇄</button>
				</div>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
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

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "nsale_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goList(sch) {
		if (sch == 'Y') {
			document.search_form.action = "home_search_list.asp";
		}
		else {
			document.search_form.action = "waste_nsale_list.asp";
		}
		document.search_form.submit();
	}
	function godel() {
		document.search_form.task.value = "del";
		document.search_form.action = "waste_com_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
	function goDelete() {
		document.search_form.task.value = "delete";
		document.search_form.action = "waste_com_exec.asp";
		//document.search_form.target = "hiddenfrm";
		document.search_form.submit();
	}
</script>
</html>

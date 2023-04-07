<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
	If Session("count") = "" then
		sql = ""
		sql = sql & " update cf_cafe "
		sql = sql & "    set visit_cnt = isnull(visit_cnt,0) + 1 "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		Conn.Execute(sql)
		Session("count") = "Y"
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="main">
			<div class="container">
				<div class="main_frm mf_block_1">
					<div class="main_frm_l">
						<div class="tab_box">
							<h2 class="h2 head"><em>부동산 이야기</em></h2>
							<ul class="tab_btns">
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cmn_cd                                               "
	sql = sql & "       ,cd_nm                                                "
	sql = sql & "   from cf_code                                              "
	sql = sql & "  where up_cd_id = (select cd_id                             "
	sql = sql & "                          from cf_code                       "
	sql = sql & "                         where up_cd_id = 'CD0000000000'     "
	sql = sql & "                           and cmn_cd = 'pst_rgn_se_cd'      "
	sql = sql & "                           and del_yn = 'N'                  "
	sql = sql & "                           and use_yn = 'Y'                  "
	sql = sql & "                       )                                     "
	sql = sql & "    and del_yn = 'N'                                         "
	sql = sql & "    and use_yn = 'Y'                                         "
	sql = sql & "  order by cd_sn                                             "
	rs.open Sql, conn, 3, 1
			Response.write sql

	i = 1
	If Not rs.eof Then
		Do Until rs.eof
			cmn_cd = rs("cmn_cd")
			cd_nm  = rs("cd_nm")
%>
								<li class="<%=if3(i=1,"on","")%>"><a href="#tab_cont<%=i%>"><em><%=cd_nm%></em></a></li>
<%
			rs.MoveNext
			i = i + 1
		Loop
	End If
%>
							</ul>
							<span class="posR"><a href="/home/story_list.asp">more</a></span>
						</div>
<%
	If Not rs.eof Then
		rs.Movefirst
		i = 1
		Do Until rs.eof
			cmn_cd = rs("cmn_cd")
			cd_nm  = rs("cd_nm")

			sql = ""
			sql = sql & " select top 5 * "
			sql = sql & " from ( "
			sql = sql & " select 1 as seq "
			sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
			sql = sql & "       ,subject "
			sql = sql & "       ,comment_cnt "
			sql = sql & "       ,story_seq "
			sql = sql & "       ,group_num "
			sql = sql & "       ,step_num "
			sql = sql & "   from cf_story "
			sql = sql & "  where cafe_id  = 'home' "
			sql = sql & "    and pst_rgn_se_cd = '" & cmn_cd & "' "
			sql = sql & "    and step_num = 0 "
			sql = sql & "    and top_yn = 'Y' "
			sql = sql & "  union all "
			sql = sql & " select top 5 "
			sql = sql & "        2 as seq "
			sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
			sql = sql & "       ,subject "
			sql = sql & "       ,comment_cnt "
			sql = sql & "       ,story_seq "
			sql = sql & "       ,group_num "
			sql = sql & "       ,step_num "
			sql = sql & "   from cf_story "
			sql = sql & "  where cafe_id  = 'home' "
			sql = sql & "    and pst_rgn_se_cd = '" & cmn_cd & "' "
			sql = sql & "    and step_num = 0 "
			sql = sql & "    and isnull(top_yn,'') <> 'Y' "
			sql = sql & "  order by seq, group_num desc, step_num asc "
			sql = sql & " ) aa "
			sql = sql & " order by seq, group_num desc, step_num asc "
			Response.write sql
			rs2.Open Sql, conn, 3, 1
%>
						<div id="tab_cont<%=i%>" class="tab_cont <%=if3(i=1,"on","")%>">
							<div class="latest_box">
<%
			If Not rs2.eof Then
%>
								<ul class="latest_1">
<%
				Do Until rs2.eof
					seq           = rs2("seq")
					credt_txt     = rs2("credt_txt")
					subject       = rs2("subject")
					comment_cnt   = rs2("comment_cnt")
					story_seq     = rs2("story_seq")
					pst_rgn_se_cd = rs2("story_seq")
					If comment_cnt > 0 Then
						comment_txt = "(" & comment_cnt & ")"
					Else
						comment_txt = ""
					End If
					view_url = "/home/story_view.asp?story_seq=" & story_seq & "&menu_seq=1951"
%>
									<li>
										<a href="<%=view_url%>"><span class="text"><%=subject%></span></a>
										<span class="posr"><%=credt_txt%></span>
									</li>
<%
					i = i + 1
					rs2.MoveNext
				Loop
%>
								</ul>
<%
			Else
%>
								<div class="nodata">
									<span class="txt">데이터가 없습니다.</span>
								</div>
<%
			End If
			rs2.close
%>
							</div>
						</div>
<%
			i = i + 1
			rs.MoveNext
		Loop
	End If
	rs.close
	Set rs = Nothing
%>
					</div>
					<div class="main_frm_r">
						<h2 class="hide">렛츠정보망</h2>
						<ul class="main_quick_box">
							<li><a href="#n"><span class="tit">렛츠 원격 A/S</span></a></li>
							<li><a href="#n"><span class="tit">렛츠 설치</span></a></li>
							<li><a href="#n"><span class="tit">렛츠 사용 설명서</span></a></li>
						</ul>
						<div class="main_banner main_banner_1"><a href="#n"><img src="/common/img/banner/main_banner_3.jpg" alt="" /></a></div>
					</div>
				</div>

				<div class="main_frm mf_block_2">
					<div class="main_frm_l">
						<div class="main_banner main_banner_2"><a href="#n"><img src="/common/img/banner/main_banner_1.jpg" alt="" /></a></div>
					</div>
					<div class="main_frm_r">
						<div class="main_banner main_banner_3"><a href="#n"><img src="/common/img/banner/main_banner_2.jpg" alt="" /></a></div>
					</div>
				</div>
<!--#include virtual="/home/home_center_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>

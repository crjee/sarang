<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
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
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
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
	Dim homeRs
	Dim homeRs2
	Set homeRs = Server.CreateObject ("ADODB.Recordset")
	Set homeRs2 = Server.CreateObject ("ADODB.Recordset")

	Dim home_i
	Dim home_j

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
	sql = sql & "                   )                                         "
	sql = sql & "    and del_yn = 'N'                                         "
	sql = sql & "    and use_yn = 'Y'                                         "
	sql = sql & "  order by cd_sn                                             "
	homeRs.open Sql, conn, 3, 1

	home_i = 0
	If Not homeRs.eof Then
		Do Until homeRs.eof
			home_i = home_i + 1
			cmn_cd = homeRs("cmn_cd")
			cd_nm  = homeRs("cd_nm")
%>
								<li class="<%=if3(home_i=1,"on","")%>"><a href="#tab_cont<%=home_i%>"><em><%=cd_nm%></em></a></li>
<%
			homeRs.MoveNext
		Loop
	End If
%>
							</ul>
							<span class="posR"><a href="/home/story_list.asp">more</a></span>
						</div>
<%
	If home_i > 0 Then
		home_j = 0
		homeRs.MoveFirst
		Do Until homeRs.eof
			home_j = home_j + 1
			cmn_cd = homeRs("cmn_cd")
			cd_nm  = homeRs("cd_nm")

			sql = ""
			sql = sql & " select top 5 * "
			sql = sql & " from ( "
			sql = sql & " select 1 as seq "
			sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
			sql = sql & "       ,subject "
			sql = sql & "       ,story_seq "
			sql = sql & "       ,group_num "
			sql = sql & "       ,step_num "
			sql = sql & "   from cf_story "
			sql = sql & "  where cafe_id  = 'home' "
			If home_j > 1 Then
			sql = sql & "    and pst_rgn_se_cd = '" & cmn_cd & "' "
			End If
			sql = sql & "    and step_num = 0 "
			sql = sql & "    and top_yn = 'Y' "
			sql = sql & "  union all "
			sql = sql & " select top 5 "
			sql = sql & "        2 as seq "
			sql = sql & "       ,convert(varchar(10), credt, 120) as credt_txt "
			sql = sql & "       ,subject "
			sql = sql & "       ,story_seq "
			sql = sql & "       ,group_num "
			sql = sql & "       ,step_num "
			sql = sql & "   from cf_story "
			sql = sql & "  where cafe_id  = 'home' "
			If home_j > 1 Then
			sql = sql & "    and pst_rgn_se_cd = '" & cmn_cd & "' "
			End If
			sql = sql & "    and step_num = 0 "
			sql = sql & "    and isnull(top_yn,'') <> 'Y' "
			sql = sql & "  order by seq, group_num desc, step_num asc "
			sql = sql & " ) aa "
			sql = sql & " order by seq, group_num desc, step_num asc "
			homeRs2.Open Sql, conn, 3, 1
%>
						<div id="tab_cont<%=home_j%>" class="tab_cont <%=if3(home_j=1,"on","")%>">
							<div class="latest_box">
<%
			If Not homeRs2.eof Then
%>
								<ul class="latest_1">
<%
				Do Until homeRs2.eof
					seq       = homeRs2("seq")
					credt_txt = homeRs2("credt_txt")
					subject   = homeRs2("subject")
					story_seq = homeRs2("story_seq")
					view_url = "/home/story_view.asp?story_seq=" & story_seq & "&menu_seq=1951"
%>
									<li>
										<a href="<%=view_url%>"><span class="text"><%=subject%></span></a>
										<span class="posr"><%=credt_txt%></span>
									</li>
<%
					homeRs2.MoveNext
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
			homeRs2.close
%>
							</div>
						</div>
<%
			homeRs.MoveNext
		Loop
	End If
	homeRs.close
%>
					</div>
					<div class="main_frm_r">
						<h2 class="hide">렛츠정보망</h2>
						<ul class="main_quick_box">
							<li><a href="#n"><span class="tit">렛츠 원격 A/S</span></a></li>
							<li><a href="#n"><span class="tit">렛츠 설치</span></a></li>
							<li><a href="#n"><span class="tit">렛츠 사용 설명서</span></a></li>
						</ul>
						<div class="main_banner main_banner_1">
<%
	Dim home_banner_type
	Dim home_file_name
	Dim home_link

	uploadUrl = ConfigAttachedFileURL & "banner/"

	sql = ""
	sql = sql & " select banner_type                       "
	sql = sql & "       ,file_name                         "
	sql = sql & "       ,link                              "
	sql = sql & "   from cf_banner                         "
	sql = sql & "  where cafe_id='root'                    "
	sql = sql & "    and banner_type in ('H1')             "
	sql = sql & "    and open_yn = 'Y'                     "
	sql = sql & "  order by banner_seq asc                 "
	homeRs.open Sql, conn, 3, 1

	home_i = 1
	If Not homeRs.eof Then
		Do Until homeRs.eof
			home_banner_type = homeRs("banner_type")
			home_file_name   = homeRs("file_name")
			home_link        = homeRs("link")

			If home_file_name <> "" then
				If home_link <> "" Then
%>
							<a href="<%=home_link%>" target="_blank">
<%
				End If
%>
								<img src="<%=uploadUrl & home_file_name%>"/>
<%
				If home_link <> "" Then
%>
							</a>
<%
				End If
			End If

			home_i = home_i + 1
			homeRs.MoveNext
		Loop
	End If
	homeRs.close

	For home_j = home_i To 1
%>
							배너모집1
<%
	Next
%>
						</div>
					</div>
				</div>

				<div class="main_frm mf_block_2">
<%
	sql = ""
	sql = sql & " select banner_type                       "
	sql = sql & "       ,file_name                         "
	sql = sql & "       ,link                              "
	sql = sql & "   from cf_banner                         "
	sql = sql & "  where cafe_id='root'                    "
	sql = sql & "    and banner_type in ('H2', 'H2')       "
	sql = sql & "    and open_yn = 'Y'                     "
	sql = sql & "  order by banner_seq asc                 "
	homeRs.open Sql, conn, 3, 1

	home_i = 1
	If Not homeRs.eof Then
		Do Until homeRs.eof
			home_banner_type = homeRs("banner_type")
			home_file_name   = homeRs("file_name")
			home_link        = homeRs("link")

			If home_file_name <> "" then
%>
					<div class="main_frm_<%=if3(home_i=1,"l","r")%>">
						<div class="main_banner main_banner_2">
<%
				If home_link <> "" Then
%>
							<a href="<%=home_link%>" target="_blank">
<%
				End If
%>
								<img src="<%=uploadUrl & home_file_name%>"/>
<%
				If home_link <> "" Then
%>
							</a>
<%
				End If
%>
						</div>
					</div>
<%
			End If

			home_i = home_i + 1
			homeRs.MoveNext
		Loop
	End If
	homeRs.close
	Set homeRs = Nothing
	Set homeRs2 = Nothing

	For home_j = home_i To 2
%>
					<div class="main_frm_<%=if3(home_j=1,"l","r")%>">
						<div class="main_banner main_banner_2">
							<a href="#">배너모집2</a>
						</div>
					</div>
<!-- 
					<div class="main_frm_<%=if3(home_j=1,"l","r")%>">
						<div class="nobanners"></div>
					</div>
 --><%
	Next
%>
				</div>
<!--#include virtual="/home/home_center_inc.asp"-->
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>

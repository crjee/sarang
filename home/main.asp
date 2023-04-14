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
<%
	Dim homeRs
	Set homeRs = Server.CreateObject ("ADODB.Recordset")

	Dim home_i
	Dim home_j

	sql = ""
	sql = sql & " select menu_type           "
	sql = sql & "       ,menu_name           "
	sql = sql & "       ,page_type           "
	sql = sql & "       ,menu_seq            "
	sql = sql & "       ,home_num            "
	sql = sql & "       ,home_cnt            "
	sql = sql & "       ,top_cnt             "
	sql = sql & "       ,wide_yn             "
	sql = sql & "       ,list_type           "
	sql = sql & "       ,tab_use_yn          "
	sql = sql & "   from cf_menu cm          "
	sql = sql & "  where cafe_id = 'home'    "
	sql = sql & "    and menu_type = 'story' "
	sql = sql & "  order by home_num asc     "
	homeRs.Open Sql, conn, 3, 1

	i = 0
	If Not homeRs.eof Then
		i = i + 1
		menu_type  = homeRs("menu_type")
		menu_name  = homeRs("menu_name")
		page_type  = homeRs("page_type")
		menu_seq   = homeRs("menu_seq")
		home_num   = homeRs("home_num")
		home_cnt   = homeRs("home_cnt")
		top_cnt    = homeRs("top_cnt")
		wide_yn    = homeRs("wide_yn")
		list_type  = homeRs("list_type")
		tab_use_yn = homeRs("tab_use_yn")
	End If
	homeRs.close

	If tab_use_yn = "Y" Then ' 탭정보 확인
		sql = ""
		sql = sql & " select section_seq                   "
		sql = sql & "       ,section_nm                    "
		sql = sql & "       ,section_sn                    "
		sql = sql & "   from cf_menu_section               "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		sql = sql & "    and use_yn = 'Y'                  "
		sql = sql & "  union all                           "
		sql = sql & " select null as section_seq           "
		sql = sql & "       ,'기타' as section_nm           "
		sql = sql & "       ,999999999 as section_nm       "
		sql = sql & "  order by section_sn                 "
		homeRs.open Sql, conn, 3, 1

		ReDim arrHomeLst(homeRs.recordCount+1)
		ReDim arrHomeRgn(homeRs.recordCount+1)

		home_i = 1
%>
						<div class="tab_box">
							<h2 class="h2 head"><em>부동산 이야기</em></h2>
							<ul class="tab_btns">
								<li class="<%=if3(home_i=1,"on","")%>"><a href="#tab_cont<%=home_i%>"><em>전체</em></a></li>
<%
		If Not homeRs.eof Then
			home_i = 2
			Do Until homeRs.eof
				section_seq = homeRs("section_seq")
				section_nm  = homeRs("section_nm")
				arrHomeLst(home_i) = section_seq
				arrHomeRgn(home_i) = section_nm
%>
								<li class="<%=if3(home_i=1,"on","")%>"><a href="#tab_cont<%=home_i%>"><em><%=section_nm%></em></a></li>
<%
				homeRs.MoveNext
				home_i = home_i + 1
			Loop
		End If
		homeRs.close
%>
							</ul>
							<span class="posR"><a href="/home/story_list.asp">more</a></span>
						</div>
<%
	Else
		ReDim arrHomeLst(1)
		ReDim arrHomeRgn(1)
%>
						<div class="latest_box">
							<header class="latest_box_head">
								<h4 class="h4">부동산 이야기</h4>
								<span class="posR"><a href="/home/land_list.asp?menu_seq=1953">more</a></span>
							</header>
						</div>
<%
	End If
%>
<%
	For home_i = 1 To UBound(arrHomeLst)
%>
						<div id="tab_cont<%=home_i%>" class="tab_cont <%=if3(home_i=1,"on","")%>">
							<div class="latest_box">
<%
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
		If arrHomeLst(home_i) <> "" Then
		sql = sql & "    and pst_rgn_se_cd = '" & arrHomeLst(home_i) & "' "
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
		If arrHomeLst(home_i) <> "" Then
		sql = sql & "    and pst_rgn_se_cd = '" & arrHomeLst(home_i) & "' "
		End If
		sql = sql & "    and step_num = 0 "
		sql = sql & "    and isnull(top_yn,'') <> 'Y' "
		sql = sql & "  order by seq, group_num desc, step_num asc "
		sql = sql & " ) aa "
		sql = sql & " order by seq, group_num desc, step_num asc "
		homeRs.Open Sql, conn, 3, 1

		If Not homeRs.eof Then
%>
								<ul class="latest_1">
<%
			Do Until homeRs.eof
				seq       = homeRs("seq")
				credt_txt = homeRs("credt_txt")
				subject   = homeRs("subject")
				story_seq = homeRs("story_seq")
				view_url = "/home/story_view.asp?story_seq=" & story_seq & "&menu_seq=1951"
%>
									<li>
										<a href="<%=view_url%>"><span class="text"><%=subject%></span></a>
										<span class="posr"><%=credt_txt%></span>
									</li>
<%
				homeRs.MoveNext
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
		homeRs.close
%>
							</div>
						</div>
<%
	Next
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
	sql = sql & " select banner_type           "
	sql = sql & "       ,file_name             "
	sql = sql & "       ,link                  "
	sql = sql & "   from cf_banner             "
	sql = sql & "  where cafe_id='root'        "
	sql = sql & "    and banner_type in ('H1') "
	sql = sql & "    and open_yn = 'Y'         "
	sql = sql & "  order by banner_seq asc     "
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
	Set homeRs = Nothing

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

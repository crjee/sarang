<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckReadAuth(cafe_id)
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="skin_type_1">
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
	<div id="wrap" class="group">
<!--#include virtual="/cafe/cafe_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/cafe_left_inc.asp"-->
<%
	End If
%>
<%
	section_seq = Request("section_seq")
	sch_type    = Request("sch_type")
	sch_word    = Request("sch_word")

	self_yn     = Request("self_yn")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	If section_seq = "0" Then
	ElseIf section_seq = "999999" Then
		secStr = "    and (section_seq = null or section_seq = '') "
	ElseIf section_seq <> "" Then
		secStr = "    and section_seq = '" & section_seq & "' "
	End If

	If sch_word <> "" Then
		If sch_type = "" Then
			schStr = " and (subject like '%" & sch_word & "%' or creid like '%" & sch_word & "%' or agency like '%" & sch_word & "%' or contents like '%" & sch_word & "%') "
		Else
			schStr = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		schStr = ""
	End If

	Set rs = Server.CreateObject("ADODB.Recordset")
	Set rs2 = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select count(album_seq) cnt                   "
	sql = sql & "   from cf_album cb                            "
	sql = sql & "  where cafe_id = '" & cafe_id & "'            "
	sql = sql & "    and menu_seq = '" & menu_seq & "'          "
	If self_yn = "Y" Then
	sql = sql & "    and user_id = '" & session("user_id") & "' "
	End If
	sql = sql & secStr
	sql = sql & schStr
	rs.Open sql, conn, 3, 1

	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs("cnt")
	End If
	rs.close

	' 전체 페이지 수 얻기
	If RecordCount/PageSize = Int(RecordCount/PageSize) Then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	sql = ""
	sql = sql & " select *                                                                           "
	sql = sql & "   from (select row_number() over( order by group_num desc, step_num asc) as rownum "
	sql = sql & "               ,*                                                                   "
	sql = sql & "           from cf_album ca "
	sql = sql & "          where cafe_id  = '" & cafe_id                                        & "' "
	sql = sql & "            and menu_seq = '" & menu_seq                                       & "' "
	If self_yn = "Y" Then
	sql = sql & "            and user_id  = '" & session("user_id")                             & "' "
	End If
	sql = sql & secStr
	sql = sql & schStr
	sql = sql & "        ) a                                                                         "
	sql = sql & "  where rownum between " &(page-1)*pagesize+1 & " and " &page*pagesize & "          "
	sql = sql & "  order by group_num desc, step_num asc                                             "
	rs.Open sql, conn, 3, 1
%>
			<div class="container" id="album">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
				<div class="">
					<div class="search_box clearBoth">
						<div class="floatL">
							총 <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>건의 게시물이 있습니다.
						</div>
						<div class="floatR">
							<form name="search_form" id="search_form" method="post">
							<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
							<input type="hidden" name="page" value="<%=page%>">
							<input type="hidden" name="album_seq">
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<span class="ml20">
							<input type="checkbox" id="self_yn" name="self_yn" class="inp_check" value="Y" <%=if3(self_yn="Y","checked","")%> onclick="goAll()" />
							<label for="self_yn"><em>본인등록</em></label>
						</span>
						<script>
							function goAll() {
								var f = document.search_form;
								f.action = "album_list.asp"
								f.page.value = 1;
								f.submit()
							}
						</script>
<%
	End If
%>
<%
	If cafe_ad_level = 10 Then
%>
							<button type="button" class="btn btn_c_a btn_s" onclick="goWaste('<%=session("ctTarget")%>')">휴지통</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
							<button type="button" class="btn btn_c_a btn_s" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
<%
	End If
%>
							<select id="sch_type" name="sch_type" class="sel w_auto">
								<option value="">전체</option>
								<option value="subject" <%=if3(sch_type="subject","selected","")%>>제목</option>
								<option value="agency" <%=if3(sch_type="agency","selected","")%>>글쓴이</option>
								<option value="contents" <%=if3(sch_type="contents","selected","")%>>내용</option>
							</select>
							<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w150p">
							<button type="button" class="btn btn_c_a btn_s" onclick="goSearch('<%=session("ctTarget")%>')">검색</button>
							<select id="pagesize" name="pagesize" class="sel w50p" onchange="goSearch('<%=session("ctTarget")%>')">
								<option value=""></option>
								<option value="20" <%=if3(pagesize="20","selected","")%>>20</option>
								<option value="30" <%=if3(pagesize="30","selected","")%>>30</option>
								<option value="40" <%=if3(pagesize="40","selected","")%>>40</option>
								<option value="50" <%=if3(pagesize="50","selected","")%>>50</option>
								<option value="100" <%=if3(pagesize="100","selected","")%>>100</option>
							</select>
							</form>
						</div>
					</div>
					<div class="tb">
						<div class="gallery gallery_t_1">
							<div class="gallery_inner_box">
<%
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	i = 1
	If Not rs.EOF Then
		Do Until rs.EOF
			album_seq      = rs("album_seq")
			album_num      = rs("album_num")
			group_num      = rs("group_num")
			step_num       = rs("step_num")
			level_num      = rs("level_num")
			menu_seq       = rs("menu_seq")
			cafe_id        = rs("cafe_id")
			agency         = rs("agency")
			top_yn         = rs("top_yn")
			pop_yn         = rs("pop_yn")
			section_seq    = rs("section_seq")
			subject        = rs("subject")
			contents       = rs("contents")
			link           = rs("link")
			user_id        = rs("user_id")
			reg_date       = rs("reg_date")
			view_cnt       = rs("view_cnt")
			comment_cnt    = rs("comment_cnt")
			suggest_cnt    = rs("suggest_cnt")
			suggest_info   = rs("suggest_info")
			parent_seq     = rs("parent_seq")
			parent_del_yn  = rs("parent_del_yn")
			move_album_num = rs("move_album_num")
			move_menu_seq  = rs("move_menu_seq")
			move_user_id   = rs("move_user_id")
			move_date      = rs("move_date")
			restoreid      = rs("restoreid")
			restoredt      = rs("restoredt")
			creid          = rs("creid")
			credt          = rs("credt")
			modid          = rs("modid")
			moddt          = rs("moddt")
%>
								<div class="c_wrap">
<%
			thumbnailUrl = ConfigAttachedFileURL & "thumbnail/album/"
			thumbnailPath = ConfigAttachedFileFolder & "thumbnail\album\"

			sql = ""
			sql = sql & " select *                               "
			sql = sql & "   from cf_album_attach                 "
			sql = sql & "  where album_seq = '" & album_seq & "' "
			sql = sql & "    and rprs_file_yn = 'Y'              "
			rs2.Open Sql, conn, 3, 1

			If Not rs2.eof Then
				thmbnl_file_nm = rs2("thmbnl_file_nm")

				' 썸네일로 표시
				fileUrl = thumbnailUrl & thmbnl_file_nm
				filePath = thumbnailPath & thmbnl_file_nm

				If (fso.FileExists(filePath)) Then
%>
									<span class="photos"><a href="javascript: goView('<%=album_seq%>','<%=session("ctTarget")%>')"><img src="<%=fileUrl%>" width="150" border="0" /></a></span>
<%
				Else
%>
									<span class="photos"></span>
<%
				End If
			Else
%>
									<span class="photos"></span>
<%
			End If
			rs2.close
%>
									<a href="javascript: goView('<%=album_seq%>','<%=session("ctTarget")%>')"><span class="text"><%=subject%>(<%=comment_cnt%>)
<%
			If CDate(DateAdd("d", 2, reg_date)) >= Date Then
%>
										<img src="/cafe/img/btn/new.png" />
<%
			End If
%>
									</span></a>
									<span class="posr"><span class="text">조회 <%=view_cnt%> ㅣ <%=Left(reg_date, 10)%></span></span>
									<span class="posr"><span class="text"><%=agency%></span></span>
								</div>
<%
			i = i + 1
			rs.MoveNext
		Loop
	Else
%>
								<div class="nodata">
									<span class="txt">등록된 글이 없습니다.</span>
								</div>
<%
	End If
	rs.close
	Set rs = Nothing
	Set rs2 = Nothing

	Set fso = Nothing
%>
							</div>
						</div>
					</div>
<!--#include virtual="/cafe/cafe_page_inc.asp"-->
<%
	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
					<div class="btn_box algR">
						<button type="button" class="btn btn_c_a btn_n" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
					</div>
<%
	End If
%>
				</div>
			</div>
<%
	If session("noFrame") = "Y" Or request("noFrame") = "Y" Then
%>
<!--#include virtual="/cafe/cafe_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/cafe_footer_inc.asp"-->
	</div>
<%
	End If
%>
</body>
<script>
	function MovePage(page, gvTarget) {
		var f = document.search_form;
		f.page.value = page;
		f.target = gvTarget;
		f.action = "/cafe/album_list.asp";
		f.submit();
	}

	function goView(album_seq, gvTarget) {
		var f = document.search_form;
		f.album_seq.value = album_seq;
		f.target = gvTarget;
		f.action = "/cafe/album_view.asp";
		f.submit();
	}

	function goWaste(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/waste_album_list.asp";
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.target = gvTarget;
		f.action = "/cafe/album_write.asp";
		f.submit();
	}

	function goSearch(gvTarget) {
		var f = document.search_form;
		f.page.value = 1;
		f.target = gvTarget;
		f.action = "/cafe/album_list.asp";
		f.submit();
	}

	function RsizeList(img, ww, hh, aL) {
		var tt = imgRsize(img, ww, hh);
		if (img.width > ww || img.height > hh) {

			// 가로나 세로크기가 제한크기보다 크면
			img.width = tt[0];
			// 크기조정
			img.height = tt[1];
		}
	}

	function imgRsize(img, rW, rH) {
		var iW = img.width;
		var iH = img.height;
		var g = new Array;
		if (iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
			g[0] = iW;
			g[1] = iH;
		}
		else {
			if (img.width > img.height) { // 원크기 가로가 세로보다 크면
				g[0] = rW;
				g[1] = Math.ceil(img.height * rW / img.width);
			}
			else if (img.width < img.height) { //원크기의 세로가 가로보다 크면
				g[0] = Math.ceil(img.width * rH / img.height);
				g[1] = rH;
			}
			else {
				g[0] = rW;
				g[1] = rH;
			}
			if (g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
				g[0] = rW;
				g[1] = Math.ceil(img.height * rW / img.width);
			}
			if (g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
				g[0] = Math.ceil(img.width * rH / img.height);
				g[1] = rH;
			}
		}

		g[2] = img.width; // 원사이즈 가로
		g[3] = img.height; // 원사이즈 세로

		return g;
	}
</script>
</html>

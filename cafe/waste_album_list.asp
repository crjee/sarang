<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckLogin()
	menu_seq = Request("menu_seq")
	Call CheckMenuSeq(cafe_id, menu_seq)
	Call CheckManager(cafe_id)
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
	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

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
	sql = sql & " select *                                          "
	sql = sql & "   from cf_waste_album                             "
	sql = sql & "  where cafe_id = '" & cafe_id & "'                "
	sql = sql & "    and menu_seq = '" & menu_seq & "'              "
	sql = sql & "    and level_num = 0                              "
	sql = sql & schStr
	sql = sql & "  order by group_num desc, step_num asc            "
	rs.Open Sql, conn, 3, 1

	RecordCount = 0 ' 자료가 없을때

	If Not rs.EOF Then
		RecordCount = rs.recordcount
	End If

	' 전체 페이지 수 얻기
	If RecordCount/PageSize = Int(RecordCount/PageSize) then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
		rs.AbsolutePage = page
		PageNum = rs.PageCount
	End If
%>
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2"><font color="red">휴지통 <%=menu_name%></font></h2>
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
		Do Until rs.EOF Or i > PageSize
			album_seq = rs("album_seq")
			subject   = rs("subject")
			album_num = rs("album_num")
			view_cnt  = rs("view_cnt")
			credt     = rs("credt")
			agency    = rs("agency")
			comment_cnt = rs("comment_cnt")
%>
								<div class="c_wrap">
<%
			thumbnailUrl = ConfigAttachedFileURL & "thumbnail/" & menu_type & "/"
			thumbnailPath = ConfigAttachedFileFolder & "thumbnail\" & menu_type & "\"

			sql = ""
			sql = sql & " select *                               "
			sql = sql & "   from cf_waste_album_attach           "
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
									<span class="photos"><a href="javascript: goView('<%=album_seq%>', '<%=session("ctTarget")%>')"><img src="<%=fileUrl%>" border="0" /></a></span>
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
									<a href="javascript: goView('<%=album_seq%>', '<%=session("ctTarget")%>')"><span class="text"><%=subject%>(<%=comment_cnt%>)
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
		f.action = "/cafe/waste_album_list.asp";
		f.target = gvTarget;
		f.submit();
	}

	function goWrite(gvTarget) {
		var f = document.search_form;
		f.action = "/cafe/album_write.asp"
		f.target = gvTarget;
		f.submit();
	}

	function goView(album_seq, gvTarget) {
		var f = document.search_form;
		f.album_seq.value = album_seq;
		f.action = "/cafe/waste_album_view.asp";
		f.target = gvTarget;
		f.submit();
	}

	function goSearch(gvTarget) {
		var f = document.search_form;
		f.page.value = 1;
		f.target = gvTarget;
		f.submit();

	}

	function goTab(section_seq, gvTarget) {
		var f = document.search_form;
		f.section_seq.value = section_seq;
		f.page.value = 1;
		f.target = gvTarget;
		f.submit();
	}
</script>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

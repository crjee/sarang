<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>사랑방 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>전체관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/admin/admin_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">배너관리</h2>
			</div>
			<div class="adm_cont">
				<div class="adm_menu_manage">
<%
	uploadUrl = ConfigAttachedFileURL & "banner/"

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cmn_cd                                         "
	sql = sql & "       ,cd_id                                          "
	sql = sql & "       ,cd_nm                                          "
	sql = sql & "   from cf_code                                        "
	sql = sql & "  where up_cd_id = (select cd_id                       "
	sql = sql & "                      from cf_code                     "
	sql = sql & "                     where up_cd_id = 'CD0000000000'   "
	sql = sql & "                       and cmn_cd = 'home_banner_type' "
	sql = sql & "                   )                                   "
	sql = sql & "  order by cd_sn                                       "
	Rs.open Sql, conn, 3, 1

	Do Until Rs.eof
		cmn_cd = Rs("cmn_cd")
		cd_id  = Rs("cd_id")
		cd_nm  = Rs("cd_nm")
		banner_type = cmn_cd

		sql = ""
		sql = sql & "  with cd1                                                    "
		sql = sql & "    as (                                                      "
		sql = sql & "        select cmn_cd                                         "
		sql = sql & "              ,cd_nm                                          "
		sql = sql & "          from cf_code                                        "
		sql = sql & "         where up_cd_id = (select cd_id                       "
		sql = sql & "                             from cf_code                     "
		sql = sql & "                            where up_cd_id = 'CD0000000000'   "
		sql = sql & "                              and cmn_cd = 'home_banner_type' "
		sql = sql & "                          )                                   "
		sql = sql & "       )                                                      "
		sql = sql & " ,     cd2                                                    "
		sql = sql & "    as (                                                      "
		sql = sql & "        select cmn_cd                                         "
		sql = sql & "              ,cd_nm                                          "
		sql = sql & "          from cf_code                                        "
		sql = sql & "         where up_cd_id = (select cd_id                       "
		sql = sql & "                             from cf_code                     "
		sql = sql & "                            where up_cd_id = 'CD0000000000'   "
		sql = sql & "                              and cmn_cd = 'open_yn'          "
		sql = sql & "                          )                                   "
		sql = sql & "       )                                                      "
		sql = sql & " select cb.*                                                  "
		sql = sql & "       ,cd1.cd_nm as banner_type_txt                          "
		sql = sql & "       ,cd2.cd_nm as open_yn_txt                              "
		sql = sql & "   from cf_banner cb                                          "
		sql = sql & "   left join cd1 on cd1.cmn_cd = cb.banner_type               "
		sql = sql & "   left join cd2 on cd2.cmn_cd = cb.open_yn                   "
		sql = sql & "  where cafe_id = 'root'                                      "
		sql = sql & "    and banner_type = '" & banner_type & "'                   "
		sql = sql & "  order by cb.banner_num asc                                  "
		rs2.CursorType = 3
		rs2.CursorLocation = 3
		rs2.LockType = 3
		rs2.Open SQL, conn
		rsCnt = rs2.recordcount
%>
				<form name="form<%=cd_nm%>" method="post" action="banner_num_exec.asp">
					<div class="btn_box algL mb10">
						<h3 class="h3"><%=cd_nm%></h3>
					</div>
<%
		If rsCnt > 1 Then
%>
					<div class="btn_box algL mb10">
						<button type="button" class="btn btn_c_a btn_s" onClick="rowMoveEvent<%=cmn_cd%>('up');" />▲</button>
						<button type="button" class="btn btn_c_a btn_s" onClick="rowMoveEvent<%=cmn_cd%>('down');" />▼</button>
						<button type="submit" class="btn btn_c_a btn_s">노출순서 저장</button>
					</div>
<%
		End If
%>
					<div class="tb tb_form_1">
						<table class="tb_fixed" id="">
							<colgroup>
								<col class="w5" />
								<col class="w5" />
								<col class="w10" />
								<col class="w_remainder" />
								<col class="w8" />
								<col class="w7" />
								<col class="w7" />
								<col class="w10" />
							</colgroup>
							<thead>
								<tr>
									<th scope="col">노출순서</th>
									<th scope="col">노출번호</th>
									<th scope="col">이미지</th>
									<th scope="col">제목/링크</th>
									<th scope="col">등록일</th>
									<th scope="col">구분</th>
									<th scope="col">공개여부</th>
									<th scope="col">설정</th>
								</tr>
							</thead>
							<tbody id="girlTbody<%=cmn_cd%>">
<%
		If Not Rs2.eof Then
			Do Until Rs2.eof
				banner_seq      = Rs2("banner_seq")
				cafe_id         = Rs2("cafe_id")
				banner_num      = Rs2("banner_num")
				banner_type     = Rs2("banner_type")
				file_name       = Rs2("file_name")
				banner_height   = Rs2("banner_height")
				banner_width    = Rs2("banner_width")
				subject         = Rs2("subject")
				link            = Rs2("link")
				open_yn         = Rs2("open_yn")
				reg_date        = Rs2("reg_date")
				creid           = Rs2("creid")
				credt           = Rs2("credt")
				modid           = Rs2("modid")
				moddt           = Rs2("moddt")
				file_type       = Rs2("file_type")
				banner_type_txt = Rs2("banner_type_txt")
				open_yn_txt     = Rs2("open_yn_txt")

				Select Case banner_type
					Case "T"
						width  = 0
						height = 0
					Case "C0"
						width  = 0
						height = 0
					Case "C1"
						width  = 0
						height = 0
					Case "C2"
						width  = 0
						height = 0
					Case "C3"
						width  = 0
						height = 0
					Case "R"
						width  = 0
						height = 0
					Case Else
						width  = 0
						height = 0
				End Select
%>
								<tr>
									<td class="algC">
										<input type="hidden" name="banner_seq" value="<%=banner_seq%>">
										<input type="radio" class="" id="chkRadio<%=cmn_cd%>" name="chkRadio<%=cmn_cd%>" onClick="checkeRowColorChange<%=cmn_cd%>(this);">
									</td>
									<td class="algC"><%=banner_num%></td>
									<td class="algC">
<%
				If file_type = "I" Then
					If link <> "" Then
%>
										<a href="<%=link%>" target="_blank">
<%
					End If
%>
											<img src="<%=uploadUrl & file_name%>" style="border:1px solid #dddddd;width:150px;">
<%
					If link <> "" Then
%>
										</a>
<%
					End If
				ElseIf file_type = "F" Then
					If link <> "" Then
%>
										<a href="<%=link%>" target="_blank">
<%
					End If
%>
											<embed src="<%=uploadUrl & file_name%>" style="border:1px solid #dddddd;width:<%=banner_width%>px ;height:<%=banner_height%>px;">
<%
					If link <> "" Then
%>
										</a>
<%
					End If
				End if
%>
									</td>
									<td class="algC"><%=subject%><br><%=link%></td>
									<td class="algC"><%=Left(credt,10)%></td>
									<td class="algC"><%=banner_type_txt%></td>
									<td class="algC"><%=open_yn_txt%></td>
									<td class="algC">
										<button type="button" class="btn btn_c_a btn_s btn_modi" onclick="onEdit('<%=banner_seq%>')">수정</button>
										<button type="button" class="btn btn_c_a btn_s" onclick="hiddenfrm.location.href='banner_del_exec.asp?task=del&banner_seq=<%=banner_seq%>'">삭제</button>
									</td>
								</tr>
<%
				Rs2.MoveNext
			Loop
%>
								<script type="text/javascript">
									function checkeRowColorChange<%=cmn_cd%>(obj) {
										var row = jQuery("#chkRadio<%=cmn_cd%>").index(obj);
									}
									function rowMoveEvent<%=cmn_cd%>(direction) {
										if(jQuery("#chkRadio<%=cmn_cd%>:checked").val()) {
											var row = jQuery("#chkRadio<%=cmn_cd%>:checked").parent().parent();
											var num = row.index();
											var max = <%=rsCnt%> - 1;	   // index는 0부터 시작하기에 -1을 해준다.
											//var max = (jQuery("#chkRadio<%=cmn_cd%>").length - 1);	   // index는 0부터 시작하기에 -1을 해준다.
											if(direction == "up") {
												if(num == 0) { 
													return false;
												} else {
													row.prev().before(row);
												}
											} else if(direction == "down") {
												if(num >= max) {
													return false;
												} else {
													row.next().after(row);
												}
											}
										} else {
										}
									}
								</script>
<%
		Else
%>
								<tr>
									<td class="algC" colspan="8">동록된 배너가 없습니다.</td>
								</tr>
<%
		End If
		Rs2.close
%>
							</tbody>
						</table>
					</div>
					<div class="btn_box algR">
						<button type="button" class="btn btn_c_a btn_n" onclick="onRegi('<%=banner_type%>')"><%=if3(banner_type="LG","로고등록","배너등록")%></button>
					</div>
				</form>
<%
		Rs.MoveNext
	Loop
	Rs.close
%>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	<!-- Banner 등록 : s -->
	<aside class="lypp lypp_adm_default lypp_adm_banner">
		<header class="lypp_head">
			<h2 class="h2">배너 <span id="regTitle"></span></h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>닫기</em></button></span>
		</header>
		<div class="adm_cont">
			<form method="post" id="regi_form" name="regi_form" action="banner_exec.asp" enctype="multipart/form-data" target="hiddenfrm">
			<input type="hidden" id="task" name="task" value="ins">
			<input type="hidden" id="banner_seq" name="banner_seq">
			<div class="tb">
				<table class="tb_input">
					<colgroup>
						<col class="w100p" />
						<col class="w_auto" />
					</colgroup>
					<tbody>
						<tr>
							<th scope="row">위치<em class="required">필수입력</em></th>
							<td>
								<select id="banner_type" name="banner_type" required class="sel w_auto">
									<option></option>
									<%=makeComboCD("home_banner_type", "")%>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">파일종류<em class="required">필수입력</em></th>
							<td>
								<select id="file_type" name="file_type" required class="sel w_auto">
									<option value="I">이미지</option>
								</select>
							</td>
						</tr>
						<tr>
							<th scope="row">제목<em class="required">필수입력</em></th>
							<td>
								<input type="text" id="subject" name="subject" maxlength="100" required class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">배너이미지</th>
							<td>
								<img id="file_img" name="file_img" style="width:150px">
							</td>
						</tr>
						<tr>
							<th scope="row">배너선택<em class="required">필수입력</em></th>
							<td>
								<input type="file" id="file_name" name="file_name" class="inp" required />
							</td>
						</tr>
						<tr>
							<th scope="row">배너크기<em class="required">필수입력</em></th>
							<td>
								<label for="">가로</label>
								<input type="text" id="banner_width" name="banner_width" value="0" required class="inp w100p" />

								<label for="">세로</label>
								<input type="text" id="banner_height" name="banner_height" value="0" required class="inp w100p" />
							</td>
						</tr>
						<tr>
							<th scope="row">배너링크</th>
							<td>
								<input type="text" id="link" name="link" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">공개여부<em class="required">필수입력</em></th>
							<td>
								<%=makeRadioCD("open_yn", "Y", "required")%>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button type="submit" id="submitBtn" class="btn btn_n">확인</button>
				<button type="reset" id="resetBtn" class="btn btn_n">취소</button>
			</div>
			</form>
		</div>
	</aside>
	<!-- //Banner 등록 : e -->
</body>
</html>

<script type="text/javascript">

	function readURL(input,obj) {
		if (input.files && input.files[0]) {
			var reader = new FileReader()

			reader.onload = function (e) {
				$(obj).attr('src', e.target.result)
			}

			reader.readAsDataURL(input.files[0])
		}
	}

	$("#file_name").change(function() {
		readURL(this,'#file_img')
	})

	$('#resetBtn').bind('click', function(e) {
		$("#file_img").attr('src', "")
	})

	function onRegi(banner_type) {
		$("#regi_form")[0].reset();
		$("#task").val("ins");
		$("#file_img").attr('src', "")
		$("#file_name").attr("required" , true);
		$("#banner_type").val(banner_type);
		document.getElementById("regTitle").innerText = "등록";
		lyp('lypp_adm_banner');
	}

	function onEdit(banner_seq) {
		$("#regi_form")[0].reset();
		$("#task").val("upd")
		$("#file_img").attr('src', "")
		$("#file_name").attr("required" , false);
		document.getElementById("regTitle").innerText = "수정";
		lyp('lypp_adm_banner');

		try {
			var strHtml = [];

			$.ajax({
				type: "POST",
				dataType: "json",
				url: "/cafe/manager/banner_view_ajax.asp",
				data: {"banner_seq":banner_seq},
				success: function(xmlData) {
					if (xmlData.TotalCnt > 0) {
						for (i=0; i<xmlData.TotalCnt; i++) {
							//alert(xmlData.ResultList[i].banner_seq);
							$("#banner_seq").val(xmlData.ResultList[i].banner_seq);
							//alert(xmlData.ResultList[i].file_type);
							$("#file_type").val(xmlData.ResultList[i].file_type);
							//alert(xmlData.ResultList[i].file_name);
							$("#file_img").attr('src', "<%=uploadUrl%>"+xmlData.ResultList[i].file_name)
							//$("#file_name").val(xmlData.ResultList[i].file_name);
							//alert(xmlData.ResultList[i].banner_type);
							$("#banner_type").val(xmlData.ResultList[i].banner_type);
							//alert(xmlData.ResultList[i].subject);
							$("#subject").val(xmlData.ResultList[i].subject);
							//alert(xmlData.ResultList[i].open_yn);
							if (xmlData.ResultList[i].open_yn == "Y")
							$("#open_yn_Y").prop('checked',true);
							if (xmlData.ResultList[i].open_yn == "N")
							$("#open_yn_N").prop('checked',true);
							//alert(xmlData.ResultList[i].link);
							$("#link").val(xmlData.ResultList[i].link);
							//alert(xmlData.ResultList[i].banner_width);
							$("#banner_width").val(xmlData.ResultList[i].banner_width);
							//alert(xmlData.ResultList[i].banner_height);
							$("#banner_height").val(xmlData.ResultList[i].banner_height);
						}
					}
					else {
						alert("해당 배너가 없습니다");
					}
				},
				complete : function() {
				},
				error : function(xmlData) {
					alert("ERROR");
				}
			});
		}
		catch (e) {
			alert(e);
		}
	}
</script>

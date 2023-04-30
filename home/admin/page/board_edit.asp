<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckAdmin()
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>메뉴 관리 : 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
<%
	menu_seq = Request("menu_seq")

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	rs.open Sql, conn, 3, 1

	If Not rs.eof Then
		menu_name      = rs("menu_name")
		page_type      = rs("page_type")
		menu_type      = rs("menu_type")
		home_cnt       = rs("home_cnt")
		hidden_yn      = rs("hidden_yn")
		write_auth     = rs("write_auth")
		reply_auth     = rs("reply_auth")
		read_auth      = rs("read_auth")
		editor_yn      = rs("editor_yn")
		daily_cnt      = rs("daily_cnt")
		inc_del_yn     = rs("inc_del_yn")
		list_info      = rs("list_info")
		tab_use_yn     = rs("tab_use_yn")
		tab_nm         = rs("tab_nm")
		all_tab_use_yn = rs("all_tab_use_yn")
		etc_tab_use_yn = rs("etc_tab_use_yn")
		cafe_cm_yn     = rs("cafe_cm_yn")
	End If
	rs.close
	Set rs = Nothing
%>
					<div class="adm_cont_tit">
						<h3 class="h3 mt20 mb10"><%=menu_name%> 설정</h3>
					</div>
					<form name="form" method="post" action="com_exec.asp">
					<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="menu_type" value="<%=menu_type%>">
					<div class="adm_cont">
						<div id="board" class="tb tb_form_1">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w15" />
									<col class="w35" />
									<col class="w15" />
									<col class="w35" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">이름</th>
										<td>
											<input type="text" id="menu_name" name="menu_name" value="<%=menu_name%>" class="inp">
										</td>
										<th scope="row">탭메뉴</th>
										<td>
											<ul>
												<li class="">
													<span class="">
														<input type="checkbox" id="tab_use_yn" name="tab_use_yn" value="Y" <%=if3(tab_use_yn = "Y","checked","") %> class="inp_check" />
														<label for="tab_use_yn"><em>사용</em></label>
													</span>
													<span class="">
														<input type="text" id="tab_nm" name="tab_nm" value="<%=tab_nm%>" alt="탭메뉴명" class="inp w200p">
													</span>
												</li>
												<li class="">
													<span class="">
														<input type="checkbox" id="all_tab_use_yn" name="all_tab_use_yn" value="Y" <%=if3(all_tab_use_yn = "Y","checked","") %> class="inp_check" />
														<label for="all_tab_use_yn" alt="전체탭사용여부"><em>전체</em></label>
													</span>
													<span class="">
														<input type="checkbox" id="etc_tab_use_yn" name="etc_tab_use_yn" value="Y" <%=if3(etc_tab_use_yn = "Y","checked","") %> class="inp_check" />
														<label for="etc_tab_use_yn" alt="기타탭사용여부"><em>기타</em></label>
													</span>
												</li>
											</ul>
										</td>
									</tr>
									<tr>
										<th scope="row">권한</th>
										<td>
											<ul>
												<li class="">
													<span class="head w80p">읽기</span>
													<span class="">
														<select id="read_auth" name="read_auth" class="sel w100p">
															<option value="-1">비회원</option>
															<%=GetMakeCDCombo("cafe_mb_level", read_auth)%>
														</select>
													</span>
												</li>
												<li class="">
													<span class="head w80p">쓰기</span>
													<span class="">
														<select id="write_auth" name="write_auth" class="sel w100p">
															<option value="-1">비회원</option>
															<%=GetMakeCDCombo("cafe_mb_level", write_auth)%>
														</select>
													</span>
												</li>
												<li class="">
													<span class="head w80p">답글</span>
													<span class="">
														<select id="reply_auth" name="reply_auth" class="sel w100p">
															<option value="-1">비회원</option>
															<%=GetMakeCDCombo("cafe_mb_level", reply_auth)%>
														</select>
													</span>
												</li>
											</ul>
										</td>
										<th rowspan="7" scope="row" class="add_files">탭메뉴 분류
											<div class="dp_inline">
												<button type="button" class="btn btn_inp_add" onclick="createItem()"><em>추가</em></button>
											</div>
										</th>
										<td rowspan="7" class="add_files">
											<!-- 게시판 분류 추가 : s -->
											<div id="itemBoxWrap">
<%
	Set row = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select *                             "
	sql = sql & "   from cf_menu_section               "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "
	sql = sql & "  order by section_sn asc             "
	row.Open Sql, conn, 3, 1

	i = 1
	If Not row.eof Then
		Do Until row.eof
			section_seq = row("section_seq")
			section_nm  = row("section_nm")
			use_yn      = row("use_yn")
%>
												<div class='itemBox'>
													<div>
														<span class='itemNum'><%=i%></span>
														<input type="hidden" name="section_seq" value="<%=section_seq%>">
														<span class="">
															<input type="text" name="section_nm" value="<%=section_nm%>" class="inp w_auto">
														</span>
														<span class="">
															<input type="checkbox" id="use_yn<%=i%>" name="use_yn<%=i%>" value="Y" class="inp_check" <%=if3(use_yn="Y","checked","")%> />
															<label for="use_yn<%=i%>"><em>사용</em></label>
														</span>
													</div>
												</div>
<%
			i = i + 1
			row.MoveNext
		Loop
	End If
	row.close
	Set row = Nothing
%>
											</div>
											<!-- 게시판 분류 추가 : e -->
										</td>
									</tr>
									<tr>
										<th scope="row">양식설정</th>
										<td>
<%
	Set form = Conn.Execute("select * from cf_com_form where menu_seq='" & menu_seq & "'")
	If Not form.eof Then
%>
											<input type="checkbox" id="frm" name="frm" class="inp_check" />
											<label for="frm"><em>질문양식 사용</em></label>
											<span class="ml10"><button type="button" class="btn btn_s btn_c_a" onclick="window.open('form_edit_p.asp?menu_seq=<%=Request("menu_seq")%>','form','width=700,height=700,scrollbars=yes');">양식수정</button></span>
<%
	Else
%>
											<span class="ml10"><button type="button" class="btn btn_s btn_c_a" onclick="window.open('form_edit_p.asp?menu_seq=<%=Request("menu_seq")%>','form','width=700,height=700,scrollbars=yes');">양식등록</button></span>
<%
	End If
%>
										</td>
									</tr>
									<tr>
										<th scope="row">메뉴감추기</th>
										<td>
											<input type="checkbox" id="hidden_yn" name="hidden_yn" value="Y" <%=if3(hidden_yn = "Y","checked","") %> class="inp_check" />
											<label for="hidden_yn"><em>감추기</em></label>
										</td>
									</tr>
									<tr>
										<th scope="row">쓰기형식</th>
										<td>
											<select id="editor_yn" name="editor_yn" class="sel w100p">
												<option value="Y" <%=if3(editor_yn = "Y","selected","") %>>에디터</option>
												<option value="N" <%=if3(editor_yn <> "Y","selected","") %>>텍스트</option>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">메인노출갯수</th>
										<td>
											<select id="home_cnt" name="home_cnt" class="sel w100p">
<%
	For i = 2 To 10
%>
												<option value="<%= i %>" <%=if3(home_cnt = i,"selected","") %>><%= i %>개</option>
<%
	Next
%>
											</select>
										</td>
									</tr>
									<tr>
										<th scope="row">1일 등록수</th>
										<td>
											<ul>
												<li class="">
													<select id="daily_cnt" name="daily_cnt" class="sel w100p">
														<option value="9999">설정안함</option>
														<option value='1' <%=If3(daily_cnt="1","selected","") %>>1</option>
														<option value='2' <%=If3(daily_cnt="2","selected","") %>>2</option>
														<option value='3' <%=If3(daily_cnt="3","selected","") %>>3</option>
													</select>
												</li>
												<li class="">
													<span class="">
														<input type="radio" id="inc_del_y" name="inc_del_yn" value="Y" <%=if3(inc_del_yn="Y","checked","") %> class="inp_radio" />
														<label for="inc_del_y"><em>삭제건 포함</em></label>
													</span>
												</li>
												<li class="">
													<span class="">
														<input type="radio" id="inc_del_n" name="inc_del_yn" value="N" <%=if3(inc_del_yn="N","checked","") %> class="inp_radio" />
														<label for="inc_del_n"><em>삭제건 미포함</em></label>
													</span>
												</li>
											</ul>
										</td>
									</tr>
										<th scope="row">사랑방 공유</th>
										<td>
											<span class="">
												<input type="radio" id="cafe_cm_y" name="cafe_cm_yn" value="Y" <%=if3(cafe_cm_yn="Y","checked","") %> class="inp_radio" />
												<label for="cafe_cm_y"><em>공유</em></label>
											</span>
											<span class="">
												<input type="radio" id="cafe_cm_n" name="cafe_cm_yn" value="N" <%=if3(cafe_cm_yn="N","checked","") %> class="inp_radio" />
												<label for="cafe_cm_n"><em>비공유</em></label>
											</span>
										</td>
									<tr>
									</tr>
									<tr>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="btn_box algR">
							<button type="submit" class="btn btn_c_a btn_n">저장</button>
							<button type="reset" class="btn btn_c_n btn_n">취소</button>
							<button type="button" class="btn btn_c_n btn_n" id="del">삭제</button>
						</div>
						</form>
					</div>
</body>
<style>
.itemBox {
    border:solid 1px black;
    width:280px;
    height:50px;
    padding:10px;
    margin-bottom:10px;
}
.itemBoxHighlight {
    border:solid 1px black;
    width:280px;
    height:50px;
    padding:10px;
    margin-bottom:10px;
    background-color:yellow;
}
.deleteBox {
    float:right;
    display:none;
    cursor:pointer;
}
</style>
<style>
#sortable { list-style-type: none; margin: 0; padding: 0; width: 280px; }
#sortable li { margin: 0 3px 3px 3px; padding: 0.4em; padding-left: 1.5em; font-size: 1.4em; height: 18px; }
#sortable li span { position: absolute; margin-left: -1.3em; }
</style>
<script src="https://code.jquery.com/jquery-1.12.4.min.js" ></script>
<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js" ></script>
<script>
	/** 아이템을 등록한다. */
	function submitItem() {
		if(!validateItem()) {
			return;
		}
		alert("등록");
	}

	/** 아이템 체크 */
	function validateItem() {
		var items = $("input[type='text'][name='item']");
		if(items.length == 0) {
			alert("작성된 아이템이 없습니다.");
			return false;
		}

		var flag = true;
		for(var i = 0; i < items.length; i++) {
			if($(items.get(i)).val().trim() == "") {
				flag = false;
				alert("내용을 입력하지 않은 항목이 있습니다.");
				break;
			}
		}

		return flag;
	}

	/** UI 설정 */
	$(function() {
		$("#itemBoxWrap").sortable({
			placeholder:"itemBoxHighlight",
			start: function(event, ui) {
				ui.item.data('start_pos', ui.item.index());
			},
			stop: function(event, ui) {
				var spos = ui.item.data('start_pos');
				var epos = ui.item.index();
					  reorder();
			}
		});
		//$("#itemBoxWrap").disableSelection();
		
		$( "#sortable" ).sortable();
		$( "#sortable" ).disableSelection();
	});

	/** 아이템 순서 조정 */
	function reorder() {
		$(".itemBox").each(function(i, box) {
			$(box).find(".itemNum").html(i + 1);
		});
	}

	/** 아이템 추가 */
	function createItem() {
		$(createBox())
		.appendTo("#itemBoxWrap")
		.hover(
			function() {
				$(this).css('backgroundColor', '#f9f9f5');
				$(this).find('.deleteBox').show();
			},
			function() {
				$(this).css('background', 'none');
				$(this).find('.deleteBox').hide();
			}
		)
			.append("<div class='deleteBox'>[삭제]</div>")
			.find(".deleteBox").click(function() {
			var valueCheck = false;
			$(this).parent().find('input').each(function() {
				if($(this).attr("name") != "type" && $(this).val() != '') {
					valueCheck = true;
				}
			});

			if(valueCheck) {
				var delCheck = confirm('입력하신 내용이 있습니다.\n삭제하시겠습니까?');
			}
			if(!valueCheck || delCheck == true) {
				$(this).parent().remove();
				reorder();
			}
		});
		// 숫자를 다시 붙인다.
		reorder();
	}

	/** 아이템 박스 작성 */
	function createBox() {
		var contents = "<div class='itemBox'>"
					 + "<div style='float:left;'>"
					 + "<span class='itemNum'></span> "
					 + "<input type='hidden' name='section_seq'>"
					 + "<input type='text' name='section_nm' class='inp w_auto'>"
					 + "</div>"
					 + "</div>";
		return contents;
	}

	$('#del').click(function() {
		msg="삭제하시겠습니까?"
		if (confirm(msg)) {
			document.location.href='../menu_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
</script>
</html>

<%
	'user_id
	'step_num
	If reply_auth <= cafe_mb_level Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goReply()">답글</button>
					<script>
						function goReply() {
							document.search_form.action = "<%=menu_type%>_reply.asp";
							document.search_form.target = "_self";
							document.search_form.submit();
						}
					</script>
<%
	End If

	If write_auth <= cafe_mb_level Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goWrite()">글쓰기</button>
					<script>
						function goWrite() {
							document.search_form.action = "<%=menu_type%>_write.asp"
							document.search_form.target = "_self";
							document.search_form.submit();
						}
					</script>
<%
	End If

	If cafe_ad_level = 10 Or (session("user_id") <> "" And user_id = session("user_id")) Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goModify()">수정</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goDelete()">삭제</button>
					<script>
						function goModify() {
							document.search_form.action = "<%=menu_type%>_modify.asp";
							document.search_form.target = "_self";
							document.search_form.submit();
						}

						function goDelete() {
							document.search_form.action = "com_waste_exec.asp";
							//document.search_form.target = "hiddenfrm";
							document.search_form.submit();
						}
					</script>
<%
	End If

	If cafe_ad_level = 10 And step_num = "0" Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goMove()">이동</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goTopMove()"><%=if3(top_yn="Y","상위글해제","상위글지정")%></button>
					<script>
						function goMove() {
							lyp('lypp_move');
						}

						function goTopMove() {
							document.search_form.action = "com_top_exec.asp"
							//document.search_form.target = "hiddenfrm";
							document.search_form.submit();
						}
					</script>
<%
	End If

	If session("user_id") <> "" Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goSuggest()">추천</button>
					<script>
						function goSuggest() {
							document.search_form.action = "com_suggest_exec.asp";
							//document.search_form.target = "hiddenfrm";
							document.search_form.submit();
						}
					</script>
<%
	End If
%>
<%
	If menu_type = "album" Then
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="onSlide()">슬라이드</button>
					<script>
						function onSlide() {
							Play();
							lyp('lypp_slide');
						}
					</script>
<%
	End If
%>
					<button type="button" class="btn btn_c_n btn_n" onclick="goPrint()">인쇄</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="onCopyUrl()">글주소복사</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="onCopySubject()">제목복사</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(prev_seq="","alert('처음 입니다.')","goPrev()")%>">이전글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="<%=if3(next_seq="","alert('마지막 입니다')","goNext()")%>">다음글</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="goList('<%=home_sch%>')">목록</button>
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

						function onCopyUrl() {
							try{
								if (window.clipboardData) {
										window.clipboardData.setData("text", "<%=pageUrl%>")
										alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
								}
								else if (window.navigator.clipboard) {
										window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
											alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
										});
								}
								else {
									temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
								}
							} catch(e) {
								alert(e)
							}
						}

						function onCopySubject() {
							try{
								str = document.getElementById("subject").innerText;
								if (window.clipboardData) {
										window.clipboardData.setData("text", str)
										alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
								}
								else if (window.navigator.clipboard) {
										window.navigator.clipboard.writeText(str).then(() => {
											alert("해당 제목이 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
										});
								}
								else {
									temp = prompt("해당 제목을 복사하십시오.", str);
								}
							} catch(e) {
								alert(e)
							}
						}

						function goPrev() {
							document.search_form.page_move.value = "prev"
							document.search_form.action = "<%=menu_type%>_view.asp"
							document.search_form.target = "_self";
							document.search_form.submit();
						}

						function goNext() {
							document.search_form.page_move.value = "next"
							document.search_form.action = "<%=menu_type%>_view.asp"
							document.search_form.target = "_self";
							document.search_form.submit();
						}

						function goList(sch) {
							if (sch == 'Y') {
								document.search_form.action = "cafe_search_list.asp";
							}
							else {
								document.search_form.action = "<%=menu_type%>_list.asp";
							}
							document.search_form.target = "_self";
							document.search_form.submit();
						}
					</script>

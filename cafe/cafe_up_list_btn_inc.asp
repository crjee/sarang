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
								f.action = "<%=menu_type%>_list.asp"
								f.page.value = 1;
								f.submit()
							}
						</script>
<%
	End If
%>
<%
	If cafe_mb_level = 10 Then
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goNotice('<%=session("ctTarget")%>')">전체공지</button>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWaste('<%=session("ctTarget")%>')">휴지통</button>
<%
	End If

	If write_auth <= cafe_mb_level Then ' 글쓰기 권한
%>
						<button type="button" class="btn btn_c_a btn_s" onclick="goWrite('<%=session("ctTarget")%>')">글쓰기</button>
<%
	End If
%>

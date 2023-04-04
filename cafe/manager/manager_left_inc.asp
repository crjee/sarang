<%
	checkManager(cafe_id)
%>
			<div class="adm_person">
				<div class="adm_person_box">
					<span>어서오세요! <%=session("kname")%>님</span>
				</div>
			</div>
			<ul class="adm_tree_menu side_menu_on">
				<li><a href="/" class="adm_tree_link">기본정보 관리</a>
					<ul class="adm_tree_s_menu">
						<li><a href="cafe_info_edit.asp">기본정보 관리</a></li>
						<li><a href="join_list.asp">가입정보/조건</a></li>
					</ul>
				</li>
				<li><a href="#n" class="adm_tree_link">사랑방 관리</a>
					<ul class="adm_tree_s_menu">
						<li><a href="menu_list.asp">메뉴 관리</a></li>
						<li><a href="popup_list.asp">팝업 관리</a></li>
						<li><a href="banner_list.asp">배너 관리</a></li>
						<li><a href="main_list.asp">메인 관리</a></li>
					</ul>
				</li>
				<li><a href="#n" class="adm_tree_link">회원 관리</a>
					<ul class="adm_tree_s_menu">
						<li><a href="member_list.asp">회원 목록</a></li>
					</ul>
				</li>
				<li><a href="#n" class="adm_tree_link">홈 설정</a>
					<ul class="adm_tree_s_menu">
						<li><a href="poll_list.asp">설문 관리</a></li>
						<!-- <li><a href="memo_form.asp">쪽지 보내기</a></li> -->
						<!-- <li><a href="manager_list.asp">스킨설정</a></li> -->
					</ul>
				</li>
			</ul>

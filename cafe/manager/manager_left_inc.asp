<%
	checkManager(cafe_id)
%>
			<div class="adm_person">
				<div class="adm_person_box">
					<span>�������! <%=session("kname")%>��</span>
				</div>
			</div>
			<ul class="adm_tree_menu side_menu_on">
				<li><a href="/" class="adm_tree_link">�⺻���� ����</a>
					<ul class="adm_tree_s_menu">
						<li><a href="cafe_info_edit.asp">�⺻���� ����</a></li>
						<li><a href="join_list.asp">��������/����</a></li>
					</ul>
				</li>
				<li><a href="#n" class="adm_tree_link">����� ����</a>
					<ul class="adm_tree_s_menu">
						<li><a href="menu_list.asp">�޴� ����</a></li>
						<li><a href="popup_list.asp">�˾� ����</a></li>
						<li><a href="banner_list.asp">��� ����</a></li>
						<li><a href="main_list.asp">���� ����</a></li>
					</ul>
				</li>
				<li><a href="#n" class="adm_tree_link">ȸ�� ����</a>
					<ul class="adm_tree_s_menu">
						<li><a href="member_list.asp">ȸ�� ���</a></li>
					</ul>
				</li>
				<li><a href="#n" class="adm_tree_link">Ȩ ����</a>
					<ul class="adm_tree_s_menu">
						<li><a href="poll_list.asp">���� ����</a></li>
						<!-- <li><a href="memo_form.asp">���� ������</a></li> -->
						<!-- <li><a href="manager_list.asp">��Ų����</a></li> -->
					</ul>
				</li>
			</ul>

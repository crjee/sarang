<%
	If cafe_id <> "home" Then Response.End
%>
		<footer id="footer">
			<div class="foot_inner foot_inner_ext">
				<ul class="foot_btn">
					<li><a href="/home/company.asp">회사소개</a></li>
					<li><a href="/home/guide.asp">이용약관</a></li>
					<li><a href="/home/privacy.asp">개인정보처리방침</a></li>
					<li><a href="/home/inquiry_write.asp">광고/제휴문의</a></li>
					<li><a href="/home/dmnddel_write.asp">게시중단요청</a></li>
				</ul>
			</div>
			<div class="foot_inner">
				<ul class="foot_info">
					<li><em class="hide">회사명</em>(주)경인네트워크</li>
					<li><em class="">대표자</em>윤종모</li>
					<li><em class="">사업자번호</em>122-81-82524</li>
					<li><em class="">통신판매업신고번호</em>제2010-인천계양-0223호</li>
				</ul>
				<p class="foot_address">
					Copyright &copy; 2004~<%=Year(Date)%> 경인네트워크. All rights reserved.
				</p>
			</div>
		</footer>
		<iframe name="hiddenfrm" id="hiddenfrm" style="border:1px;width:1000;"></iframe>

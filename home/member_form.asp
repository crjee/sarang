<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<%
	Const tb_prefix = "gi"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>경인 홈</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="sub">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2">회원가입</h2>
				</div>
				<form id="crtInfo" name="crtInfo" method="post" action="member_exec.asp" target="hiddenfrm">
				<div class="tb tb_form_1">
					<table class="tb_input">
						<colgroup>
							<col class="w15" />
							<col class="w35" />
							<col class="w15" />
							<col class="w35" />
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">아이디</th>
								<td colspan="3">
									<input type="hidden" value="N" name="member_check">
									<input type="text" id="user_id" name="user_id" class="inp" required onkeyup="member_find(this.value)">
								</td>
							</tr>
							<tr>
								<th scope="row">비밀번호</th>
								<td>
									<input type="password" id="userpw" name="userpw" class="inp" required />
								</td>
								<th scope="row">비밀번호 확인</th>
								<td>
									<input type="password" id="userpw_confirm" name="userpw_confirm" class="inp" required />
								</td>
							</tr>
							<tr>
								<th scope="row">한글이름</th>
								<td>
									<input type="text" id="kname" name="kname" class="inp" required />
								</td>
								<th scope="row">영문이름</th>
								<td>
									<input type="text" id="ename" name="ename" class="inp" />
								</td>
							</tr>
							<tr>
								<th scope="row">상호</th>
								<td>
									<input type="text" id="agency" name="agency" class="inp" required />
								</td>
								<th scope="row">허가번호</th>
								<td>
									<input type="text" id="license" name="license" class="inp" />
								</td>
							</tr>
							<tr>
								<th scope="row">성별</th>
								<td>
									<%=GetMakeCDRadio("sex", "", "")%>
								</td>
								<th scope="row">이메일</th>
								<td>
									<span class="dp_inline"><input type="text" id="email1" name="email1" class="inp w100p" required /></span>
									<span class="dp_inline">@</span>
									<span class="dp_inline"><input type="text" id="email2" name="email2" class="inp w100p" required /></span>
									<span class="dp_inline">
										<select id="n_hosts" name="n_hosts" class="sel w100p" onChange="setHost()">
											<option value="">직접입력</option>
											<%=GetMakeCDCombo("n_hosts", "")%>
										</select>
									</span>
								</td>
							</tr>
							<tr>
								<th scope="row">휴대폰번호</th>
								<td>
									<span class="dp_inline">
										<select id="mobile1" name="mobile1" class="sel w_remainder" required>
											<option value="">선택</option>
											<option value="010">010</option>
											<option value="011">011</option>
											<option value="016">016</option>
											<option value="017">017</option>
											<option value="018">018</option>
											<option value="019">019</option>
										</select>
									</span>
									<span class="dp_inline">-</span>
									<span class="dp_inline"><input type="text" id="mobile2" name="mobile2" class="inp w100p" required /></span>
									<span class="dp_inline">-</span>
									<span class="dp_inline"><input type="text" id="mobile3" name="mobile3" class="inp w100p" required /></span>
									
								</td>
								<th scope="row">전화번호</th>
								<td>
									<span class="dp_inline"><input type="text" id="phone" name="phone" class="inp w150p" required /></span>
									<span class="dp_inline ml10">내선번호 <input type="text" id="interphone" name="interphone" class="inp w100p" /></span>
								</td>
							</tr>
							<tr>
								<th scope="row">팩스번호</th>
								<td>
									<span class="dp_inline"><input type="text" id="fax" name="fax" class="inp w150p" /></span>
								</td>
								<th scope="row">우편번호</th>
								<td>
									<span class="dp_inline"><input type="text" id="zipcode" name="zipcode" class="inp w150p" required /></span>
								</td>
							</tr>
							<tr>
								<th scope="row">주소</th>
								<td>
									<input type="text" id="addr1" name="addr1" class="inp" required />
								</td>
								<th scope="row">상세주소</th>
								<td>
									<input type="text" id="addr2" name="addr2" class="inp" />
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box algC">
					<button type="submit" class="btn btn_n">확인</button>
					<button type="reset" class="btn btn_n">취소</button>
				</div>
				</form>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>

<!--#include virtual="/include/config_inc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<link href="/cafe/skin/css/table.css" rel="stylesheet" type="text/css" />
</head>
<body>


	<!--Contents-->

	<div id="LblockContainer">
		<div id="Content">

			<!--Left-->
<!--#include virtual="/cafe/supervisor/supervisor_left_inc.asp"-->
			<!--Left-->

			<!--Center-->
			<script>
				function Checkfm(f){
					if(f.cafe_check.value=='N'){
						alert('�ߺ��� ����� ���̵� �Դϴ�')
						return false
					}
				}

				function setHost(){
					var fo = document.crtInfo;
					fo.email2.value = crtInfo.n_hosts.value;
					fo.email2.readOnly = (fo.n_hosts.value ? true : false);
				}
			</script>
			<div id="LblockCenter">
				<form id="crtInfo" name="crtInfo" method="post" onSubmit="return Checkfm(this)" target="ifrm" action="member_write_exec.asp">
				<li class="title02">ȸ�����</li>
				<li>
					<div id="Banner_reInner">
						<table>
							<tr>
								<th class="gray">�����̵�</th>
								<td>
									<input type="hidden" value="N" name="member_check">
									<input type="text" class="w120_" name="user_id" onkeyup="member_find(this.value)" required>
									<span id="msg"></span>
								</td>
							</tr>
							<script>
							function member_find(user_id){
								ifrm.location.href='member_search.asp?user_id='+user_id
							}
							</script>
							<tr>
								<th class="gray">����й�ȣ</th>
								<td>
									<input type="password" class="w120_" name="userpw" required>
								</td>
							</tr>
							<tr>
								<th class="gray">����й�ȣ Ȯ��</th>
								<td>
									<input type="password" class="w120_" name="userpw_confirm" required>
								</td>
							</tr>
							<tr>
								<th class="gray">���ѱ��̸�</th>
								<td>
									<p><input type="text" class="w275_" name="kname" required></p>
								</td>
							</tr>
							<tr>
								<th class="gray">�������̸�</th>
								<td>
									<p><input type="text" class="w275_" name="ename"></p>
								</td>
							</tr>
							<tr>
								<th class="gray">����ȣ</th>
								<td>
									<p><input type="text" class="w275_" name="agency" required></p>
								</td>
							</tr>
							<tr>
								<th class="gray">���㰡��ȣ</th>
								<td>
									<p><input type="text" class="w275_" name="license"></p>
								</td>
							</tr>
							<tr>
								<th class="gray">������</th>
								<td class="selectContainer">
									<input type="radio" name="sex" value="��" required>�� &nbsp;&nbsp;
									<input type="radio" name="sex" value="��" required>��
								</td>
							</tr>
							<tr class="bline_">
								<th class="gray">��email</th>
								<td class="pt10">
									<input type="text" class="w120_" name="email1" required>
									<span class="blit_">@</span>
									<input type="text" class="w120_" name="email2" required>
									<select class="w120_" onChange="setHost()" name="n_hosts">
										<option value="">�����Է�</option>
										<option value="chol.com">chol.com</option>
										<option value="dreamwiz.com">dreamwiz.com</option>
										<option value="empal.com">empal.com</option>
										<option value="gmail.com">gmail.com</option>
										<option value="hanafos.com">hanafos.com</option>
										<option value="hanmail.net">hanmail.net</option>
										<option value="hotmail.com">hotmail.com</option>
										<option value="korea.com">korea.com</option>
										<option value="lycos.co.kr">lycos.co.kr</option>
										<option value="nate.com">nate.com</option>
										<option value="naver.com">naver.com</option>
										<option value="paran.com">paran.com</option>
										<option value="yahoo.co.kr">yahoo.co.kr</option>
									</select>
								</td>
							</tr>
							<tr class="bline_">
								<th class="gray">���޴��� ��ȣ</th>
								<td class="pt10">
									<select class="w60_" name="mobile1" required>
										<option>����</option>
										<option value="010">010</option>
										<option value="011">011</option>
										<option value="016">016</option>
										<option value="017">017</option>
										<option value="018">018</option>
										<option value="019">019</option>
									</select>
									<span class="blit_">-</span>
									<input type="text" style="width:40px" name="mobile2" required>
									<span class="blit_">-</span>
									<input type="text" style="width:40px" name="mobile3" required>
								</td>
							</tr>
							<tr>
								<th class="gray">����ȭ��ȣ</th>
								<td>
									<input type="text" class="w120_" name="phone" required> ������ȣ<input type="text" class="w120_" name="interphone">
								</td>
							</tr>
							<tr>
								<th class="gray">���ѽ���ȣ</th>
								<td>
									<input required type="text" class="w120_" name="fax">
								</td>
							</tr>
							<tr>
								<th class="gray">���ּ�</th>
								<td>
									�����ȣ : <input type="text" class="w70_" name="zipcode" required><br>
									�ּ�    : <input type="text" style="width:400px" name="addr1" required><br>
									���ּ� : <input type="text" style="width:400px" name="addr2">
								</td>
							</tr>
							<tr class="bline_">
								<th class="gray">�������</th>
								<td>
									<select name="cafe_id">
										<option value=""></option>
<%
	Set cafe = Conn.Execute("select * from cf_cafe order by cafe_name")
	Do Until cafe.eof
%>
										<option value="<%=cafe("cafe_id")%>"><%=cafe("cafe_name")%></option>
<%
		cafe.MoveNext
	Loop
%>
									</select>
									<select name="cafe_mb_level">
										<option value="">��޼���</option>
										<option value="1" <% If cafe_mb_level=1 Then Response.Write "selected" %>>��ȸ��</option>
										<option value="2" <% If cafe_mb_level=2 Then Response.Write "selected" %>>��ȸ��</option>
										<option value="10" <% If cafe_mb_level=10 Then Response.Write "selected" %>>���������</option>
									</select>
								</td>
							</tr>
						</table>
					</div>
				</li>
				<li class="center">
					<br>
					<button class="btn_2txt_sel" type="submit">Ȯ��</button>
				</li>
				</form>
			<br>
			<br>
			</div>
			<!--Center-->
			<iframe id="ifrm" name="ifrm" style="display:none"></iframe>
		</div>
	</div>
	<!--Contents-->

</body>
</html>
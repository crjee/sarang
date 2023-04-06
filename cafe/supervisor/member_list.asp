<!--#include virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	sch_type = Request("sch_type")
	sch_word = Request("sch_word")
	If sch_type <> "" And sch_word <> "" Then
		If sch_type = "all" Then
			kword = " where (cc.cafe_name like '%" & sch_word & "%' or mb.agency like '%" & sch_word & "%' or mb.phone like '%" & sch_word & "%' or mb.user_id like '%" & sch_word & "%' or mb.kname like '%" & sch_word & "%') "
		Else
			kword = " where " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End If

	sql =       ""
	sql = sql & " select  "
	sql = sql & "        mb.user_id "
	sql = sql & "       ,mb.kname "
	sql = sql & "       ,mb.agency "
	sql = sql & "       ,mb.phone "
	sql = sql & "       ,mb.email "
	sql = sql & "       ,mb.stat mstat "
	sql = sql & "       ,mb.picture "
	sql = sql & "       ,cm.cafe_id "
	sql = sql & "       ,cm.cafe_mb_level "
	sql = sql & "       ,um.union_mb_level"
	sql = sql & "       ,cm.stat cstat "
	sql = sql & "       ,cc.cafe_name "
	sql = sql & "       ,cc.union_id "
	sql = sql & "       ,cu.cafe_name as union_name "
	sql = sql & "       ,(select count(*) from cf_board where user_id = mb.user_id) post_cnt "
	sql = sql & "   from cf_member mb "
	sql = sql & "   left outer join cf_cafe_member cm on cm.user_id = mb.user_id "
	sql = sql & "   left outer join cf_cafe cc on cc.cafe_id = cm.cafe_id "
	sql = sql & "   left outer join cf_cafe cu on cu.cafe_id = cc.union_id "
	sql = sql & "   left outer join cf_union_manager um on um.user_id = mb.user_id and um.union_id = cu.cafe_id "
	sql = sql & kword
	sql = sql & " order by kname "

	Set rs = Server.CreateObject ("ADODB.Recordset")
	rs.open Sql, conn, 3, 1

	rs.pagesize = pagesize
	RecordCount = 0 ' �ڷᰡ ������
	If Not rs.EOF Then
		RecordCount = rs.recordcount
	End If

	' ��ü ������ �� ���
	If RecordCount/pagesize = Int(RecordCount/pagesize) Then
		PageCount = Int(RecordCount / pagesize)
	Else
		PageCount = Int(RecordCount / pagesize) + 1
	End If

	If Not (rs.EOF And rs.BOF) Then
		rs.AbsolutePage = page
		PageNum = rs.PageCount
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>ȸ�� ���� > ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS ����<sub>��ü����</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/supervisor/supervisor_left_inc.asp"-->
		</nav>
			<script>
				function testCheck() {
					try {
						var chckType = document.getElementsByName('chk_user');
						var j = 0;
						for (i = 0; i < chckType.length; i++) {
							if (chckType[i].checked == true) {
								j++;
							}
						}

						if (j == 0) {
							alert("ȸ���� �����ϼ���!");
							return false;
						}
						return true;
					}
					catch (e) {
						alert(e);
					}
				}

				function goLevel() {
					try {
						if (!testCheck()) return;
						var f = document.form;
						f.action="member_level_exec.asp";
						f.submit();
					}
					catch (e) {
						alert(e);
					}
				}

				function goActivity1() {
					try {
						if (!testCheck()) return;
						var f = document.form;
						f.action="member_activity1_exec.asp"
						f.submit();
					}
					catch (e) {
						alert(e);
					}
				}

				function goActivity2() {
					try {
						if (!testCheck()) return;
						var f = document.form;
						f.action="member_activity2_exec.asp"
						f.submit();
					}
					catch (e) {
						alert(e);
					}
				}

				function setColor(i) {
					try {
						document.getElementById("sp_"+i).innerText = "�����";
						document.getElementById("tr_"+i).style.background = "#ffffcc";
					}
					catch (e) {
						alert(e);
					}
				}

				function MovePage(page) {
					try {
						var f = document.search_form;
						f.page.value = page;
						f.submit();
					}
					catch (e) {
						alert(e);
					}
				}

				function goSearch() {
					try {
						var f = document.search_form;
						f.page.value = 1;
						f.submit();
					}
					catch (e) {
						alert(e);
					}
				}

				function Rsize(img, ww, hh, aL) {
					var tt = imgRsize(img, ww, hh);
					if (img.width > ww || img.height > hh) {

						// ���γ� ����ũ�Ⱑ ����ũ�⺸�� ũ��
						img.width = tt[0];
						// ũ������
						img.height = tt[1];
						img.alt = "Ŭ���Ͻø� �����̹����� ���Ǽ��ֽ��ϴ�.";

						if (aL) {
							// �ڵ���ũ on
							img.onclick = function() {
								wT = Math.ceil((screen.width - tt[2])/2.6);
								// Ŭ���̾�Ʈ �߾ӿ� �̹�����ġ.
								wL = Math.ceil((screen.height - tt[3])/2.6);
								var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
								var doc = mm.document;
								try{
									doc.body.style.margin = 0;
									// ��������
									doc.body.style.cursor = "hand";
									doc.title = "�����̹���";
								}
								catch(err) {
								}
								finally {
								}

							}
							img.style.cursor = "hand";
						}
					}
					else {
							img.onclick = function() {
								alert("�����̹����� ���� �̹����Դϴ�.");
							}
					}
				}

				function imgRsize(img, rW, rH) {
					var iW = img.width;
					var iH = img.height;
					var g = new Array;
					if (iW < rW && iH < rH) { // ���μ��ΰ� ����� ������ ���� ���
						g[0] = iW;
						g[1] = iH;
					}
					else {
						if (img.width > img.height) { // ��ũ�� ���ΰ� ���κ��� ũ��
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						else if (img.width < img.height) { //��ũ���� ���ΰ� ���κ��� ũ��
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
						else {
							g[0] = rW;
							g[1] = rH;
						}
						if (g[0] > rW) { // ������ ���ΰ��� ��� ���κ��� ũ��
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						if (g[1] > rH) { // ������ ���ΰ��� ��� ���ΰ����κ��� ũ��
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
					}

					g[2] = img.width; // �������� ����
					g[3] = img.height; // �������� ����

					return g;
				}
			</script>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">ȸ�� ����</h2>
			</div>
			<div class="adm_cont">
				<div class="status_box clearBoth">
					<span class="floatL">�� ȸ�� <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>��</span>
					<span class="floatR">
						<input type="checkbox" checked="checked" class="inp_check" /><label for="t1"><em class="hide">����</em></label>
						���õ� ȸ����
						<button type="button" class="btn btn_c_s btn_s" onclick="goLevel()">��޼��� ����</button>
						<button type="button" class="btn btn_c_s btn_s" onclick="goActivity1()">��ü ���� �Ǵ� Ȱ��</button>
						<button type="button" class="btn btn_c_s btn_s" onclick="goActivity2()">����� ���� �Ǵ� Ȱ��</button>
						�մϴ�.
					</span>
				</div>
				<div class="search_box clearBoth">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
					<div class="floatL">
						<select name="sch_type" class="sel w100p">
							<option value="all">��ü</option>
							<option value="mb.agency" <%=if3(sch_type="mb.agency","selected","")%>>��ȣ</option>
							<option value="mb.phone" <%=if3(sch_type="mb.phone","selected","")%>>��ȭ��ȣ</option>
							<option value="mb.user_id" <%=if3(sch_type="mb.user_id","selected","")%>>���̵�</option>
							<option value="mb.kname" <%=if3(sch_type="mb.kname","selected","")%>>�̸�</option>
							<option value="cc.cafe_name" <%=if3(sch_type="cc.cafe_name","selected","")%>>�����</option>
						</select>
						<input class="inp w300p" type="text" name="sch_word" value="<%=sch_word%>" onkeyDown='javascript:{if (event.keyCode==13) goSearch();}'>
						<button class="btn btn_c_a btn_s" type="button" onclick="goSearch()">�˻�</button>
					</div>
					<div class="floatR">
						<span class="mr5">��¼�</span>
						<select class="sel w100p" id="pagesize" name="pagesize" onchange="goSearch()">
							<option value=""></option>
							<option value="20" <%=if3(pagesize="20","selected","")%>>20</option>
							<option value="50" <%=if3(pagesize="50","selected","")%>>50</option>
							<option value="100" <%=if3(pagesize="100","selected","")%>>100</option>
						</select>
					</div>
				</form>
				</div>
				<div class="tb tb_form_1">
				<form name="form" method="post" target="hiddenfrm">
					<table>
						<colgroup>
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"><input type="checkbox" id="" name="" class="inp_check" /><label for=""><em class="hide">��ü����</em></label></th>
								<th scope="col">����(���̵�)</th>
								<th scope="col">��ȣ</th>
								<th scope="col">��ȭ��ȣ</th>
								<th scope="col">�����ȸ�����</th>
								<th scope="col">����ȸ�����</th>
								<th scope="col">��ü����</th>
								<th scope="col">��������</th>
								<th scope="col">�̸���</th>
								<th scope="col">��Ʈ����</th>
								<th scope="col">�Խñ�</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1
	uploadUrl = ConfigAttachedFileURL & "picture/"
	If Not rs.EOF Then
		Do Until rs.EOF OR i > rs.pagesize
			user_id   = rs("user_id")
			kname     = rs("kname")
			agency    = rs("agency")
			phone     = rs("phone")
			email     = rs("email")
			mstat     = rs("mstat")
			cstat     = rs("cstat")
			cafe_id   = rs("cafe_id")
			cafe_name = rs("cafe_name")
			cafe_mb_level = rs("cafe_mb_level")
			post_cnt  = rs("post_cnt")
			picture   = rs("picture")
			union_id  = rs("union_id")
			union_name  = rs("union_name")
			union_mb_level = rs("union_mb_level")
%>
							<tr id="tr_<%=i%>">
								<td class="algC"><input type="checkbox" id="chk_user" name="chk_user" value="<%=user_id%>" /><label for=""><em class="hide">����</em></label></th>
								<td class="algC"><%=kname%>(<a href="/ex2.asp?userid=<%=user_id%>"><%=user_id%></a>)</td>
								<td class="algC"><%=agency%>
<%
			If picture <> "" Then
%>
									<img src="<%=uploadUrl & picture%>" id="profile" name="profile" onLoad="Rsize(this, 20, 20, 1)" style="cursor:hand;border:1px solid #e5e5e5;" title="�߰����һ���">
<%
			End If
%>
								</td>
								<td class="algC"><%=phone%></td>
								<td class="algC">
									<select name="cafe_id_<%=user_id%>" class="sel w_auto" onchange="setColor('<%=i%>')">
										<option value=""></option>
<%
			sql = ""
			sql = sql & " select * "
			sql = sql & "   from cf_cafe "
			sql = sql & "  order by cafe_name"
			rs2.open Sql, conn, 3, 1

			Do Until rs2.eof
%>
												<option value="<%=rs2("cafe_id")%>" <%=if3(rs2("cafe_id")=cafe_id,"selected","") %>><%=rs2("cafe_name")%></option>
<%
				rs2.MoveNext
			Loop
			rs2.close
%>
									</select>
									&nbsp;
									<select name="cafe_mb_level_<%=user_id%>" class="sel w_auto" onchange="setColor('<%=i%>')">
										<option value="">��޼���</option>
										<option value="1" <%=if3(cafe_mb_level=1,"selected","") %>>��ȸ��</option>
										<option value="2" <%=if3(cafe_mb_level=2,"selected","") %>>��ȸ��</option>
										<option value="10" <%=if3(cafe_mb_level=10,"selected","") %>>���������</option>
									</select>
									<span id="sp_<%=i%>">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
								</td>
								<td class="algC">
									<input type="hidden" name="union_id_<%=user_id%>" value="<%=union_id%>">
									<%=union_name%>
<%
			If union_id <> "" And cafe_mb_level > 1 Then
%>
									&nbsp;
									<select name="union_mb_level_<%=user_id%>" class="sel w_auto" onchange="setColor('<%=i%>')">
										<option value="">��ȸ��</option>
										<option value="10" <%=if3(union_mb_level=10,"selected","") %>>����ȸ����</option>
									</select>
<%
			Else
%>
									<input type="hidden" name="union_mb_level_<%=user_id%>" value="<%=union_mb_level%>">
<%
			End If
%>
								</td>
								<td class="algC">
<%
							If Trim(mstat)="Y" Then
								Response.Write "<font color='blue'>Ȱ��</font>"
							Else
								Response.Write "<font color='red'>Ȱ������</font>"
							End If
%>
								</td>
								<td class="algC">
<%
							If Trim(cstat)="Y" Then
								Response.Write "<font color='blue'>Ȱ��</font>"
							Else
								Response.Write "<font color='red'>Ȱ������</font>"
							End If
%>
								</td>
								<td class="algC"><%=email%></td>
								<td class="algC">
<%
			sql = ""
			sql = sql & " select * "
			sql = sql & "   from cf_admin "
			sql = sql & "  where user_id = '" & user_id & "' "
			rs2.open Sql, conn, 3, 1

			rlink = "member_root_exec.asp?user_id="&user_id
			If Not rs2.eof Then
%>
											<button type="button" class="btn btn_c_s btn_s" onclick="hiddenfrm.location.href='member_root_exec.asp?user_id=<%=user_id&%>'">�������</button>
											<a target="ifrm" href="member_root_exec.asp?user_id=<%=user_id&%>" class="btn btn-danger btn-xs" style="height:18px;">�������</a>
<%
			Else
%>
											<button type="button" class="btn btn_c_s btn_s" onclick="hiddenfrm.location.href='member_root_exec.asp?user_id=<%=user_id&%>'">�����ֱ�</button>
											<a target="ifrm" href="member_root_exec.asp?user_id=<%=user_id&%>" class="btn btn-info btn-xs" style="height:18px;">�����ֱ�</a>
<%
			End If
			rs2.close
%>
								</td>
								<td class="algC"><%=post_cnt%></td>
							</tr>
<%
			i = i + 1
			rs.MoveNext
		Loop
	End If
%>
						</tbody>
					</table>
				</div>
				<div class="btn_box algR">
					<a href="#n" class="btn btn_c_a btn_n" onclick="lyp('lypp_adm_member')">ȸ�����</a>
					<a href="#n" class="btn btn_c_n btn_n">����</a>
				</div>
				</form>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<!-- ȸ�� ��� : s -->
	<script>
		function Checkfm(f) {
			if (f.cafe_check.value=='N') {
				alert('�ߺ��� ����� ���̵� �Դϴ�')
				return false
			}
		}

		function setHost() {
			var fo = document.crtInfo;
			fo.email2.value = crtInfo.n_hosts.value;
			fo.email2.readOnly = (fo.n_hosts.value ? true : false);
		}

		function member_find(user_id) {
			hiddenfrm.location.href = 'member_find_exec.asp?user_id='+user_id
		}
	</script>
	<aside class="lypp lypp_adm_default lypp_adm_member">
		<header class="lypp_head">
			<h2 class="h2">ȸ�� ���</h2>
			<span class="posR"><button type="button" class="btn btn_close"><em>�ݱ�</em></button></span>
		</header>
		<div class="adm_cont">
			<form id="crtInfo" name="crtInfo" method="post" action="member_write_exec.asp" target="hiddenfrm" onSubmit="return Checkfm(this)">
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
							<th scope="row">���̵�</th>
							<td colspan="3">
								<input type="hidden" value="N" name="member_check">
								<input type="text" id="user_id" name="user_id" class="inp" required onkeyup="member_find(this.value)">
							</td>
						</tr>
						<tr>
							<th scope="row">��й�ȣ</th>
							<td>
								<input type="password" id="userpw" name="userpw" class="inp" required />
							</td>
							<th scope="row">��й�ȣ Ȯ��</th>
							<td>
								<input type="password" id="userpw_confirm" name="userpw_confirm" class="inp" required />
							</td>
						</tr>
						<tr>
							<th scope="row">�ѱ��̸�</th>
							<td>
								<input type="text" id="kname" name="kname" class="inp" required />
							</td>
							<th scope="row">�����̸�</th>
							<td>
								<input type="text" id="ename" name="ename" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">��ȣ</th>
							<td>
								<input type="text" id="agency" name="agency" class="inp" required />
							</td>
							<th scope="row">�㰡��ȣ</th>
							<td>
								<input type="text" id="license" name="license" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">����</th>
							<td>
								<input type="radio" id="sex" name="sex" value="��" class="inp_radio" required />
								<label for="sex"><em>��</em></label>

								<input type="radio" id="sex" name="sex" value="��" class="inp_radio" required />
								<label for="sex"><em>��</em></label>
							</td>
							<th scope="row">�̸���</th>
							<td>
								<span class="dp_inline"><input type="text" id="email1" name="email1" class="inp w100p" required /></span>
								<span class="dp_inline">@</span>
								<span class="dp_inline"><input type="text" id="email2" name="email2" class="inp w100p" required /></span>
								<span class="dp_inline">
									<select id="n_hosts" name="n_hosts" class="sel w100p" onChange="setHost()">
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
								</span>
							</td>
						</tr>
						<tr>
							<th scope="row">�޴�����ȣ</th>
							<td>
								<span class="dp_inline">
									<select id="mobile1" name="mobile1" class="sel w_remainder" required>
										<option value="">����</option>
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
							<th scope="row">��ȭ��ȣ</th>
							<td>
								<span class="dp_inline"><input type="text" id="phone" name="phone" class="inp w150p" required /></span>
								<span class="dp_inline ml10">������ȣ <input type="text" id="interphone" name="interphone" class="inp w100p" /></span>
							</td>
						</tr>
						<tr>
							<th scope="row">�ѽ���ȣ</th>
							<td>
								<span class="dp_inline"><input type="text" id="fax" name="fax" class="inp w150p" /></span>
							</td>
							<th scope="row">�����ȣ</th>
							<td>
								<span class="dp_inline"><input type="text" id="zipcode" name="zipcode" class="inp w150p" required /></span>
							</td>
						</tr>
						<tr>
							<th scope="row">�ּ�</th>
							<td>
								<input type="text" id="addr1" name="addr1" class="inp" required />
							</td>
							<th scope="row">���ּ�</th>
							<td>
								<input type="text" id="addr2" name="addr2" class="inp" />
							</td>
						</tr>
						<tr>
							<th scope="row">�����</th>
							<td colspan="3">
								<span class="dp_inline">
									<select id="cafe_id" name="cafe_id" class="sel w_remainder">
										<option value="">����</option>
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
									</select>
								</span>
								<span class="dp_inline">
									<select id="cafe_mb_level" name="cafe_mb_level" class="sel w_remainder">
										<option value="">��޼���</option>
										<option value="1" <%=if3(cafe_mb_level=1,"selected","") %>>��ȸ��</option>
										<option value="2" <%=if3(cafe_mb_level=2,"selected","") %>>��ȸ��</option>
										<option value="10" <%=if3(cafe_mb_level=10,"selected","") %>>���������</option>
									</select>
								</span>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="btn_box algC">
				<button type="submit" class="btn btn_n">Ȯ��</button>
				<button type="reset" class="btn btn_n">���</button>
			</div>
			</form>
		</div>
	</aside>
	<!-- //ȸ�� ��� : e -->
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	</body>
</html>

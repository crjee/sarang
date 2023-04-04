<!--#include virtual="/include/config_inc.asp"-->
<%
	checkManager(cafe_id)

	list_info = Request("list_info")
	If list_info = "" Then
		list_info = "agency,kname,phone,mobile,fax"
	End If

	pagesize = Request("pagesize")
	If pagesize = "" Then pagesize = 20

	page = Request("page")
	If page = "" Then page = 1

	sch_type = Request("sch_type")
	sch_word = Request("sch_word")

	If sch_word <> "" Then
		If sch_type = "all" Then
			kword = " and mi.agency like '%" & sch_word & "%' or mi.kname like '%" & sch_word & "%' or mi.phone like '%" & sch_word & "%' "
		Else
			kword = " and " & sch_type & " like '%" & sch_word & "%' "
		End If
	Else
		kword = ""
	End If

	Set row = Server.CreateObject ("ADODB.Recordset")

	sql = ""
	sql = sql & " select cm.user_id "
	sql = sql & "       ,mi.user_id "
	sql = sql & "       ,mi.kname "
	sql = sql & "       ,mi.email "
	sql = sql & "       ,mi.agency "
	sql = sql & "       ,mi.mobile "
	sql = sql & "       ,mi.phone "
	sql = sql & "       ,mi.fax "
	sql = sql & "       ,mi.interphone "
	sql = sql & "       ,mi.license "
	sql = sql & "       ,mi.addr1 "
	sql = sql & "       ,mi.addr2 "
	sql = sql & "       ,mi.picture "
	sql = sql & "       ,cm.cafe_id "
	sql = sql & "       ,cm.cafe_mb_level "
	sql = sql & "       ,cm.stat "
	sql = sql & "       ,cm.stdate "
	sql = sql & "       ,case cm.cafe_mb_level when '1' Then '��ȸ��' "
	sql = sql & "                              when '2' Then '��ȸ��' "
	sql = sql & "                              when '3' Then '���ȸ��' "
	sql = sql & "                              when '4' Then 'Ư��ȸ��' "
	sql = sql & "                              when '5' Then '���' "
	sql = sql & "                              when '10' Then '���������' "
	sql = sql & "                              Else '������' end ulevel_txt"
	sql = sql & "       ,(select count(*) from cf_board where user_id = mi.user_id) post_cnt "
	sql = sql & "   from cf_cafe cf "
	sql = sql & "  inner join cf_cafe_member cm on cm.cafe_id = cf.cafe_id "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id "
'	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.cafe_id = cm.cafe_id and mi.stat = 'Y' "
	sql = sql & "  where (cf.cafe_id = '" & cafe_id & "' or cf.union_id = '" & cafe_id & "') "
	sql = sql & kword
	sql = sql & "  order by mi.agency "

	row.Open Sql, conn, 3, 1

	row.PageSize = PageSize
	RecordCount = 0 ' �ڷᰡ ������
	If Not row.EOF Then
		RecordCount = row.recordcount
	End If

	' ��ü ������ �� ���
	If RecordCount/PageSize = Int(RecordCount/PageSize) Then
		PageCount = Int(RecordCount / PageSize)
	Else
		PageCount = Int(RecordCount / PageSize) + 1
	End If

	If Not (row.EOF And row.BOF) Then
		row.AbsolutePage = page
		PageNum = row.PageCount
	End If
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>ȸ��/��� ���� : ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS ����<sub>����� ����</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">ȸ��/��� ����</h2>
			</div>
			<div class="adm_cont">
				<div class="status_box clearBoth">
					<span class="floatL">�� ȸ�� <strong class="f_weight_m f_skyblue"><%=FormatNumber(RecordCount,0)%></strong>��</span>
					<span class="floatR">
					<form name="form2" method="post" target="hiddenfrm">
						<input type="checkbox" id="t1" name="" checked="checked" disabled="disabled" /><label for="t1"><em class="hide">����</em></label>
						���õ� ȸ����
						<select id="mb_level" name="mb_level" class="sel w100p">
							<option value="1">��ȸ��</option>
							<option value="2">��ȸ��</option>
						</select>
						<button type="button" class="btn btn_c_s btn_s" onclick="goLevel()">��޼��� ����</button>
						<button type="button" class="btn btn_c_s btn_s" onclick="goActivity()">Ȱ������ �Ǵ� Ȱ��</button>
					</form>
					</span>
				</div>
				<div class="search_box clearBoth">
				<form name="search_form" method="post">
				<input type="hidden" name="page" value="<%=page%>">
					<div class="floatL">
						<span class="">
							<input type="checkbox" id="list_info" name="list_info" value="agency" <%=if3(InStr(list_info, "agency")>0,"checked","")%> />
							<label for=""><em>��ȣ</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="kname" <%=if3(InStr(list_info, "kname")>0,"checked","")%> />
							<label for=""><em>��ǥ�ڸ�</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="picture" <%=if3(InStr(list_info, "picture")>0,"checked","")%> />
							<label for=""><em>��ǥ�ڻ���</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="license" <%=if3(InStr(list_info, "license")>0,"checked","")%> />
							<label for=""><em>�㰡��ȣ</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="phone" <%=if3(InStr(list_info, "phone")>0,"checked","")%> />
							<label for=""><em>��ȭ��ȣ</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="mobile" <%=if3(InStr(list_info, "mobile")>0,"checked","")%> />
							<label for=""><em>�ڵ�����ȣ</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="fax" <%=if3(InStr(list_info, "fax")>0,"checked","")%> />
							<label for=""><em>�ѽ�</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="interphone" <%=if3(InStr(list_info, "interphone")>0,"checked","")%> />
							<label for=""><em>������ȣ</em></label>
						</span>
						<span class="ml10">
							<input type="checkbox" id="list_info" name="list_info" value="addr" <%=if3(InStr(list_info, "addr")>0,"checked","")%> />
							<label for=""><em>�ּ�</em></label>
						</span>
					</div>
					<div class="floatR">
						<select id="sch_type" name="sch_type" class="sel w100p">
							<option value="all">��ü</option>
							<option value="agency" <%=if3(sch_type="agency","selected","")%>>���Ҹ�</option>
							<option value="kname" <%=if3(sch_type="kname","selected","")%>>ȸ����</option>
							<option value="phone" <%=if3(sch_type="phone","selected","")%>>��ȭ��ȣ</option>
						</select>
						<input type="text" id="sch_word" name="sch_word" value="<%=sch_word%>" class="inp w300p" />
						<button class="btn btn_c_a btn_s" type="button" onclick="goSearch()">�˻�</button>
						<span class="ml20 mr5">��¼�</span>
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
					<input type="hidden" id="cafe_mb_level" name="cafe_mb_level">
					<table>
						<colgroup>
							<col class="" />
<%If InStr(list_info, "agency") Then%>                                <col class="" /><%End If%>
<%If InStr(list_info, "kname") Or InStr(list_info, "picture") Then%>  <col class="" /><%End If%>
<%If InStr(list_info, "license") Then%>                               <col class="" /><%End If%>
<%If InStr(list_info, "phone") Then%>                                 <col class="" /><%End If%>
<%If InStr(list_info, "mobile") Then%>                                <col class="" /><%End If%>
<%If InStr(list_info, "fax") Then%>                                   <col class="" /><%End If%>
<%If InStr(list_info, "interp") Then%>                                <col class="" /><%End If%>
							<col class="" />
							<col class="" />
							<col class="" />
							<col class="" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col"></th>
<%If InStr(list_info, "agency") Then%>                                <th scope="col">��ȣ</th><%End If%>
<%If InStr(list_info, "kname") Or InStr(list_info, "picture") Then%>  <th scope="col">��ǥ��</th><%End If%>
<%If InStr(list_info, "license") Then%>                               <th scope="col">�㰡��ȣ</th><%End If%>
<%If InStr(list_info, "phone") Then%>                                 <th scope="col">��ȭ��ȣ</th><%End If%>
<%If InStr(list_info, "mobile") Then%>                                <th scope="col">�ڵ�����ȣ</th><%End If%>
<%If InStr(list_info, "fax") Then%>                                   <th scope="col">�ѽ�</th><%End If%>
<%If InStr(list_info, "interp") Then%>                                <th scope="col">����</th><%End If%>
								<th scope="col">ȸ�����</th>
								<th scope="col">������</th>
								<th scope="col">����</th>
								<th scope="col">�Խñ�</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1
	uploadUrl = ConfigAttachedFileURL & "picture/"
	If Not row.EOF Then
		Do Until row.EOF OR i > row.PageSize
			Set ml = Conn.Execute("select * from cf_cafe_member cm,cf_member mi where cm.cafe_id='" & cafe_id & "' and cm.user_id='" & row("user_id") & "' and cm.user_id=mi.user_id")

			user_id    = row("user_id")
			kname      = row("kname")
			email      = row("email")
			agency     = row("agency")
			mobile     = row("mobile")
			phone      = row("phone")
			fax        = row("fax")
			interphone = row("interphone")
			license    = row("license")
			picture    = row("picture")
			addr1      = row("addr1")
			addr2      = row("addr2")
			email      = row("email")
			stat       = row("stat")
			stdate     = row("stdate")
			cafe_id    = row("cafe_id")
			cafe_mb_level = row("cafe_mb_level")
			ulevel_txt = row("ulevel_txt")
			post_cnt   = row("post_cnt")

			cols = 4
%>
								<td class="algC" sch_typepan="<%=sch_type%>">
<%
			If ulevel_txt = "���������" Then
%>
								<input type="checkbox" disabled="disabled">
<%
			Else
%>
								<input type="checkbox" id="user_id" name="user_id" value="<%=user_id%>">
								<input type="hidden" id="stat" name="stat" value="<%=stat%>">
<%
			End If
%>
								</td>
<%
			If InStr(list_info, "agency") Then
				cols = cols + 1
%>
								<td class="algC"><%=agency%>
<%
				If picture <> "" Then
%>
									<img src="<%=uploadUrl & picture%>" id="profile" name="profile" onLoad="Rsize(this, 20, 20, 1)" style="cursor:hand;border:1px solid #e5e5e5;" title="�߰����һ���">
<%
				End If
%>
								</td>
<%
			End If

			If InStr(list_info, "kname") Then
				cols = cols + 1
%>
								<td class="algC"><%=kname%></td>
<%
			End If

			If InStr(list_info, "license") Then
				cols = cols + 1
%>
								<td class="algC"><%=license%></td>
<%
			End If

			If InStr(list_info, "phone") Then
				cols = cols + 1
%>
								<td class="algC"><%=phone%></td>
<%
			End If

			If InStr(list_info, "mobile") Then
				cols = cols + 1
%>
								<td class="algC"><%=mobile%></td>
<%
			End If

			If InStr(list_info, "fax") Then
				cols = cols + 1
%>
								<td class="algC"><%=fax%></td>
<%
			End If

			If InStr(list_info, "interp") Then
				cols = cols + 1
%>
								<td class="algC"><%=interphone%></td>
<%
			End If
%>
								<td class="algC"><%=ulevel_txt%></td>
								<td class="algC"><%=left(stdate,10)%></td>
								<td class="algC">
<%
			If stat = "N" Then
%>
									<font color='red'>Ȱ������</font>
<%
			Else
%>
									<font color='blue'>Ȱ��</font>
<%
			End If
%>
								</td>
								<td class="algC"><%=post_cnt%></td>
							</tr>
<%
			If InStr(list_info, "addr") Then
%>
							</tr><td class="algC" colspan="<%=cols%>"><%=addr1%> <%=addr2%></td><tr>
<%
			End If
%>
<%
			i = i + 1
			row.MoveNext
		Loop
	End If
	row.close
	Set row = Nothing
%>
						</tbody>
					</table>
				</form>
				</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
</body>
</html>

	<script>
		function testCheck(){
			var chckType = document.getElementsByName('user_id');
			var j = 0;
			for(i = 0; i < chckType.length; i++){
				if (chckType[i].checked == true){
					j++;
				}
			}

			if(j == 0){
				alert("ȸ���� �����ϼ���!");
				return false;
			}
			return true;
		}
		function goLevel(){
			if(!testCheck()) return;
			var f = document.form;
			var f2 = document.form2;
			f.cafe_mb_level.value = f2.cafe_mb_level.value
			f.action="member_level_exec.asp"
			f.submit()
		}
		function goActivity(){
			if(!testCheck()) return;
			var f = document.form;
			f.action="member_activity_exec.asp"
			f.submit()
		}

		function MovePage(page){
			document.search_form.page.value = page;
			document.search_form.submit();
		}

		function goSearch(){
			try {
				var f = document.search_form;
				f.page.value = 1;
				f.submit();
			}
			catch (e){
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

				if(aL){
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
			Else {
					img.onclick = function(){
						alert("�����̹����� ���� �̹����Դϴ�.");
					}
			}
		}

		function imgRsize(img, rW, rH){
			var iW = img.width;
			var iH = img.height;
			var g = new Array;
			if(iW < rW && iH < rH) { // ���μ��ΰ� ����� ������ ���� ���
				g[0] = iW;
				g[1] = iH;
			}
			Else {
				if(img.width > img.height) { // ��ũ�� ���ΰ� ���κ��� ũ��
					g[0] = rW;
					g[1] = Math.ceil(img.height * rW / img.width);
				}
				Else if(img.width < img.height) { //��ũ���� ���ΰ� ���κ��� ũ��
					g[0] = Math.ceil(img.width * rH / img.height);
					g[1] = rH;
				}
				Else {
					g[0] = rW;
					g[1] = rH;
				}
				if(g[0] > rW) { // ������ ���ΰ��� ��� ���κ��� ũ��
					g[0] = rW;
					g[1] = Math.ceil(img.height * rW / img.width);
				}
				if(g[1] > rH) { // ������ ���ΰ��� ��� ���ΰ����κ��� ũ��
					g[0] = Math.ceil(img.width * rH / img.height);
					g[1] = rH;
				}
			}

			g[2] = img.width; // �������� ����
			g[3] = img.height; // �������� ����

			return g;
		}
	</script>

<!--#include virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>��Ų-1 : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<body class="skin_type_1">
	<div id="wrap" class="group">
<!--#include virtual="/cafe/skin/skin_header_inc.asp"-->
		<main id="main" class="sub">
<!--#include virtual="/cafe/skin/skin_left_inc.asp"-->
			<div class="container">
<%
	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select "
	sql = sql & "        mb.* "
	sql = sql & "       ,cm.cafe_id "
	sql = sql & "       ,cm.cafe_mb_level "
	sql = sql & "       ,um.union_mb_level"
	sql = sql & "       ,cm.stat cstat "
	sql = sql & "       ,cc.cafe_name "
	sql = sql & "       ,cc.union_id "
	sql = sql & "       ,cu.cafe_name as union_name "
	sql = sql & "   from cf_member mb "
	sql = sql & "   left outer join cf_cafe_member cm on cm.user_id = mb.user_id "
	sql = sql & "   left outer join cf_cafe cc on cc.cafe_id = cm.cafe_id "
	sql = sql & "   left outer join cf_cafe cu on cu.cafe_id = cc.union_id "
	sql = sql & "   left outer join cf_union_manager um on um.user_id = mb.user_id and um.union_id = cu.cafe_id "
	sql = sql & "  where mb.user_id = '" & session("user_id")  & "' "
	rs.Open Sql, conn, 3, 1

	If Not rs.EOF Then
		user_id         = rs("user_id")
		user_pw         = rs("user_pw")
		kname           = rs("kname")
		ename           = rs("ename")
		agency          = rs("agency")
		license         = rs("license")
		birth           = rs("birth")
		sex             = rs("sex")
		email           = rs("email")
		mobile          = rs("mobile")
		phone           = rs("phone")
		interphone      = rs("interphone")
		fax             = rs("fax")
		erec            = rs("erec")
		mrec            = rs("mrec")
		zipcode         = rs("zipcode")
		addr1           = rs("addr1")
		addr2           = rs("addr2")
		stat            = rs("stat")
		cafe_id         = rs("cafe_id")
		mlevel          = rs("mlevel")
		creid           = rs("creid")
		credt           = rs("credt")
		modid           = rs("modid")
		moddt           = rs("moddt")
		ipin            = rs("ipin")
		memo_receive_yn = rs("memo_receive_yn")
		picture         = rs("picture")

		cafe_id         = rs("cafe_id")
		cafe_mb_level   = rs("cafe_mb_level")
		union_mb_level  = rs("union_mb_level")
		cstat           = rs("cstat")
		cafe_name       = rs("cafe_name")
		union_id        = rs("union_id")
		union_name      = rs("union_name")

		If isnull(cafe_id       ) Then cafe_id         = ""
		If isnull(cafe_mb_level ) Then cafe_mb_level   = ""
		If isnull(union_mb_level) Then union_mb_level  = ""
		If isnull(cstat         ) Then cstat           = ""
		If isnull(cafe_name     ) Then cafe_name       = ""
		If isnull(union_id      ) Then union_id        = ""
		If isnull(union_name    ) Then union_name      = ""
	End If
	rs.close

	Select Case cafe_mb_level
		Case "1" cafe_mb_level_txt = "��ȸ��"
		Case "2" cafe_mb_level_txt = "��ȸ��"
		Case "10" cafe_mb_level_txt = "���������"
	End Select
	
	If isnull(union_mb_level) Then union_mb_level = ""
		Select Case union_mb_level
			Case "" union_mb_level_txt = "��ȸ��"
			Case "10" union_mb_level_txt = "����ȸ����"
		End Select
%>
				<form name="form" method="post" action="my_info_exec.asp" enctype="multipart/form-data">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" name="temp" value="Y">
				<div class="cont_tit">
					<h2 class="h2">���� ����</h2>
				</div>
				<div class="tb">
					<table class="tb_input tb_fixed">
						<colgroup>
							<col class="w200p">
							<col class="w_remainder">
							<col class="w200p">
							<col class="w_remainder">
						</colgroup>
						<tbody>
							<tr>
								<th scope="row">����</th>
								<td colspan="3">
									<%=kname%>
								</td>
							</tr>
							<tr>
								<th scope="row">�߰����Ҹ�</th>
								<td>
									<%=agency%>
								</td>
								<th scope="row">�㰡��ȣ</th>
								<td>
									<%=license%>
								</td>
							</tr>
							<tr>
								<th scope="row">��������</th>
								<td>
									<input type="radio" class="radio3" name="memo_receive_yn" value="Y" <%=if3(memo_receive_yn="Y","checked","")%>>��� &nbsp; &nbsp;
									<input type="radio" class="radio3" name="memo_receive_yn" value="N" <%=if3(memo_receive_yn="N","checked","")%>>����
								</td>
								<th scope="row">�޴���</th>
								<td>
									<%=mobile%>
								</td>
							</tr>
							<tr>
								<th scope="row">����ó</th>
								<td>
									<%=phone%><%=if3(interphone="","","(" & interphone & ")")%>
								</td>
								<th scope="row">�ѽ�</th>
								<td>
									<%=fax%>
								</td>
							</tr>
							<tr>
								<th scope="row">�ּ�</th>
								<td colspan="3">
									<%=addr1%> <%=addr2%>
								</td>
							</tr>
							<tr>
								<th scope="row">�����</th>
								<td>
									<a href="/cafe/main.asp?cafe_id=<%=cafe_id%>"><%=cafe_name%><%=if3(cafe_id="","","(" & cafe_mb_level_txt & ")")%></a>
								</td>
								<th scope="row">����ȸ</th>
								<td>
									<a href="/cafe/main.asp?cafe_id=<%=union_id%>"><%=union_name%><%=if3(union_id="","","(" & union_mb_level_txt & ")")%></a>
								</td>
							</tr>
							<tr>
								<th scope="row">�߰����һ���</th>
								<td colspan="3">
									<div class="photo">
<%
	uploadUrl = ConfigAttachedFileURL & "picture/"
	If picture <> "" Then
%>
										<img src="<%=uploadUrl & picture%>" id="profile" name="profile" title="�߰����һ���">
<%
	Else
%>
										<img id="profile" name="profile" style="width:132px;height:132px">
<%
	End If
%>
									</div>
									<button type="button" id="deleteBtn" class="btn_long" onclick="javascript:picture_del()">���� ����</button>
									<button type="button" id="enrollBtn" class="btn_long">���� ���</button>
									<input type="file" name="picture" id="picture" style="display:none">
									<input type="hidden" name="del" id="del">
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n">���</button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='board_list.asp?menu_seq=<%=menu_seq%>'"><em>���</em></button>
				</div>
				</form>
			</div>
<!--#include virtual="/cafe/skin/skin_right_inc.asp"-->
		</main>
<!--#include virtual="/cafe/skin/skin_footer_inc.asp"-->
	</div>
</body>
</html>


<script src="http://code.jquery.com/jquery-latest.min.js"></script>
<script>
	$('#enrollBtn').bind('click', function(e) {
		$('#picture').click()
	})

	$(window).load(function(){
		function readURL(input,obj) {
			if (input.files && input.files[0]) {
				var reader = new FileReader()

				reader.onload = function (e) {
					$(obj).attr('src', e.target.result)
				}

				reader.readAsDataURL(input.files[0])
			}
		}

		$("#picture").change(function(){
			readURL(this,'#profile')
		})
	})

	function picture_del(){
		document.all.profile.src='';
		document.all.picture.value = '';
		document.all.del.value = 'Y';
	}
</script>
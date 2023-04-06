<!--#include virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�޴� ���� : ������</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<body>
<%
	menu_seq = Request("menu_seq")

	cnt = getonevalue("count(*)","cf_page","where cafe_id = '" & cafe_id & "'")
	If cnt = 0 Then
		sql = ""
		sql = sql & " insert into cf_page( "
		sql = sql & "        cafe_id "
		sql = sql & "       ,regulation "
		sql = sql & "       ,introduction "
		sql = sql & "       ,greetings "
		sql = sql & "       ,roster "
		sql = sql & "       ,organogram "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & cafe_id & "' "
		sql = sql & "       ,null "
		sql = sql & "       ,null "
		sql = sql & "       ,null "
		sql = sql & "       ,null "
		sql = sql & "       ,null "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)
	End If
	
	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_menu cm "
	sql = sql & "   inner join cf_page cs on cs.cafe_id = cm.cafe_id "
	sql = sql & "  where menu_seq = '" & menu_seq & "' "

	Set rs = Conn.Execute(sql)
	If Not rs.eof Then
		menu_name = rs("menu_name")
		page_type = rs("page_type")
		menu_type = rs("menu_type")
		home_cnt  = rs("home_cnt")
		hidden_yn = rs("hidden_yn")
		doc       = rs("doc")

		regulation   = rs("regulation")
		introduction = rs("introduction")
		greetings    = rs("greetings")
		roster       = rs("roster")
		organogram   = rs("organogram")
		picture      = rs("picture")
	End If
	rs.close

	If isnull(page_type) Then page_type = ""
%>
					<div class="adm_cont_tit">
						<h4 class="h3 mt20 mb10"><%=menu_name%> ����</h4>
					</div>
					<form name="form" method="post" enctype="multipart/form-data" onsubmit="return submitContents(this)">
					<input type="hidden" name="cafe_id" value="<%=cafe_id%>">
					<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
					<input type="hidden" name="menu_type" value="<%=menu_type%>">
					<input type="hidden" name="page_type" value="<%=page_type%>">
					<div class="adm_cont">
						<div id="board" class="tb tb_form_1">
							<table class="tb_input tb_fixed">
								<colgroup>
									<col class="w120p" />
									<col class="w_remainder" />
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">�̸�</th>
										<td>
											<input type="text" id="menu_name" name="menu_name" value="<%=menu_name%>" class="inp">
										</td>
									</tr>
									<tr>
										<th scope="row">�޴����߱�</th>
										<td>
											<input type="checkbox" id="hidden_yn" name="hidden_yn" value="Y" <%=if3(hidden_yn = "Y","checked","") %> class="" />
											<label for=""><em>���߱�</em></label>
										</td>
									</tr>
<%
	If page_type = "1" Then
%>
									<tr>
										<th scope="row"><%=menu_name%></th>
										<td>
											<textarea name="ir1" id="ir1" style="width:630px;height:200px; display:none;"><%=regulation%></textarea>
										</td>
									</tr>
<%
	ElseIf page_type = "2" Then
%>
									<tr>
										<th scope="row">�Ұ���</th>
										<td>
											<textarea name="ir1" id="ir1" style="width:630px;height:200px; display:none;"><%=introduction%></textarea>
										</td>
									</tr>
									<tr>
										<th scope="row">ȸ�����</th>
										<td>
<%
		If picture <> "" Then
%>
											<input type="button" onclick="javascript:hiddenfrm.location.href='picture_exec.asp'" value="����"> <%=picture%>
<%
		Else
%>
											<input type="file" id="picture" name="picture" class="inp" />
<%
		End if
%>
										</td>
									</tr>
									<tr>
										<th scope="row">ȸ���λ縻</th>
										<td>
											<textarea name="ir12" id="ir12" style="width:820px;height:500px; display:none;"><%=greetings%></textarea>
										</td>
									</tr>
<%
	ElseIf page_type = "4" Then
%>
									<tr>
										<th scope="row"><%=menu_name%></th>
										<td>
											<textarea name="ir1" id="ir1" style="width:630px;height:200px; display:none;"><%=roster%></textarea>
										</td>
									</tr>
<%
	ElseIf page_type = "5" Then
%>
									<tr>
										<th scope="row"><%=menu_name%></th>
										<td>
											<textarea name="ir1" id="ir1" style="width:630px;height:200px; display:none;"><%=organogram%></textarea>
										</td>
									</tr>
<%
	End if
%>
								</tbody>
							</table>
						</div>
						<div class="btn_box algR">
							<button type="submit" class="btn btn_c_a btn_n">����</button>
							<button type="reset" class="btn btn_c_n btn_n">���</button>
							<button type="button" class="btn btn_c_n btn_n" id="del">����</button>
						</div>
						</form>
						<script>
						</script>
					</div>
	<iframe id="hiddenfrm" name="hiddenfrm" style="display:none"></iframe>
	</body>
</html>
<script LANGUAGE="JavaScript">
<!--
	$('#del').click(function() {
		msg="�����Ͻðڽ��ϱ�?"
		if (confirm(msg)) {
			document.location.href='../menu_del_exec.asp?menu_seq=<%=menu_seq%>';
		}
	})
//-->
</script>
<script>
<%
	If page_type = "" Then
%>
	function submitContents(elClickedObj) {
		try {
			elClickedObj.action = "page_exec.asp"
			elClickedObj.form.submit()
		} catch(e) {}
	}
<%
	Else
%>
	var oEditors = [];

	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "ir1",
		sSkinURI: "/smart/SmartEditor2Skin.html",
		htParams : {
			bUseToolbar : true,				// ���� ��� ���� (true:���/ false:������� ����)
			bUseVerticalResizer : true,		// �Է�â ũ�� ������ ��� ���� (true:���/ false:������� ����)
			bUseModeChanger : true,			// ��� ��(Editor | HTML | TEXT) ��� ���� (true:���/ false:������� ����)
			//aAdditionalFontList : aAdditionalFontSet,		// �߰� �۲� ���
			fOnBeforeUnload : function() {
				//alert("�Ϸ�!")
			}
		}, //boolean
		fOnAppLoad : function() {
			//���� �ڵ�
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
		},
		fCreator: "createSEditor2"
	})

<%
		If page_type = 2 Then
%>
	nhn.husky.EZCreator.createInIFrame({
		oAppRef: oEditors,
		elPlaceHolder: "ir12",
		sSkinURI: "/smart/SmartEditor2Skin.html",
		htParams : {
			bUseToolbar : true,				// ���� ��� ���� (true:���/ false:������� ����)
			bUseVerticalResizer : true,		// �Է�â ũ�� ������ ��� ���� (true:���/ false:������� ����)
			bUseModeChanger : true,			// ��� ��(Editor | HTML | TEXT) ��� ���� (true:���/ false:������� ����)
			//aAdditionalFontList : aAdditionalFontSet,		// �߰� �۲� ���
			fOnBeforeUnload : function() {
				//alert("�Ϸ�!")
			}
		}, //boolean
		fOnAppLoad : function() {
			//���� �ڵ�
			//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
		},
		fCreator: "createSEditor2"
	})
<%
		End If
%>

	function submitContents(elClickedObj) {
		oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])	// �������� ������ textarea�� ����˴ϴ�.
<%
		If page_type = 2 then
%>
		oEditors.getById["ir12"].exec("UPDATE_CONTENTS_FIELD", [])	// �������� ������ textarea�� ����˴ϴ�.
<%
		End If
%>
		// �������� ���뿡 ���� �� ������ �̰����� document.getElementById("ir1").value�� �̿��ؼ� ó���ϸ� �˴ϴ�.

		try {
			elClickedObj.action = "page_exec.asp"
			elClickedObj.form.submit()
		} catch(e) {}
	}
<%
	End If
%>
</script>

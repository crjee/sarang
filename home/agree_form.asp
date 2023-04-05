<%
	freePage = True
%>
<!--#include virtual="/include/config_inc.asp"-->
<%
	cafe_id = "home"
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="euc-kr">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>�ε����̾߱� : GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/sticky.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body>
	<div id="wrap">
<!--#include virtual="/home/home_header_inc.asp"-->
		<main id="main" class="sub">
			<div class="container">
				<div class="cont_tit">
					<h2 class="h2">ȸ������ �������</h2>
				</div>
				<form name="form" method="post" onsubmit="return submitContents(this)">
				<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
				<input type="hidden" id="attachCnt" name="attachCnt" value="1">
				<input type="hidden" name="temp" value="Y">
				<div class="view_cont">
					<h4 class="f_awesome h4">�̿���</h4>
					<div class="tb">
						<textarea rows="" cols="" readonly="readonly" class="textarea mt10">
<%
	Set fso = CreateObject("Scripting.FileSystemObject")
	If (fso.FileExists(ConfigPath & "�̿���.txt")) Then
		Set file = fso.OpenTextFile(ConfigPath & "�̿���.txt", 1, True)
		file_str = file.ReadAll
		file.Close
		Set file = Nothing
	End If
%>
							<%=file_str%>
						</textarea>
					</div>
					<span class="">
						<input type="radio" id="agree1_y" name="agree1_yn" value="Y" class="checkbox" required />
						<label for="agree1_y"><em>�����մϴ�.</em></label>
						<input type="radio" id="agree1_n" name="agree1_yn" value="N" class="checkbox" required />
						<label for="agree1_n"><em>�������� �ʽ��ϴ�</em></label>
					</span>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">�������� ��޹�ħ</h4>
					<div class="tb">
						<textarea rows="" cols="" readonly="readonly" class="textarea mt10">
<%
	If (fso.FileExists(ConfigPath & "����������޹�ħ.txt")) Then
		Set file = fso.OpenTextFile(ConfigPath & "����������޹�ħ.txt", 1, True)
		file_str = file.ReadAll
		file.Close
		Set file = Nothing
	End If
%>
							<%=file_str%>
						</textarea>
					</div>
					<span class="">
						<input type="radio" id="agree2_y" name="agree2_yn" value="Y" class="checkbox" required />
						<label for="agree2_y"><em>�����մϴ�.</em></label>
						<input type="radio" id="agree2_n" name="agree2_yn" value="N" class="checkbox" required />
						<label for="agree2_n"><em>�������� �ʽ��ϴ�</em></label>
					</span>
				</div>
				<div class="view_cont">
					<h4 class="f_awesome h4">��ġ��ݼ��� �̿�ǰ�</h4>
					<div class="tb">
						<textarea rows="" cols="" readonly="readonly" class="textarea mt10">
<%
	If (fso.FileExists(ConfigPath & "��ġ�����̿���.txt")) Then
		Set file = fso.OpenTextFile(ConfigPath & "��ġ�����̿���.txt", 1, True)
		file_str = file.ReadAll
		file.Close
		Set file = Nothing
	End If
	Set fso = Nothing
%>
							<%=file_str%>
						</textarea>
					</div>
					<span class="">
						<input type="radio" id="agree3_y" name="agree3_yn" value="Y" class="checkbox" required />
						<label for="agree3_y"><em>�����մϴ�.</em></label>
						<input type="radio" id="agree3_n" name="agree3_yn" value="N" class="checkbox" required />
						<label for="agree3_n"><em>�������� �ʽ��ϴ�</em></label>
					</span>
				</div>
				<div class="view_cont">
					<span class="">
						<input type="checkbox" id="agree_all" name="agree_all" value="Y" class="checkbox" />
						<label for="agree_all"><em>��� �����մϴ�.</em></label>
					</span>
				</div>
				<div class="btn_box">
					<button type="submit" class="btn btn_c_a btn_n"><em>Ȯ��</em></button>
					<button type="button" class="btn btn_c_n btn_n" onclick="location.href='/'"><em>���</em></button>
				</div>
				</form>
			</div>
<!--#include virtual="/home/home_right_inc.asp"-->
		</main>
<!--#include virtual="/home/home_footer_inc.asp"-->
	</div>
</body>
</html>
<script>
	$("#agree_all").on("click", function() {
		try{
			var radios = $(":radio[value='Y']");
			for(var i = 0; i < radios.length; i++) {
				var $this = $(radios[i]);
				$this.prop("checked", $("#agree_all").prop("checked"));
			}
		} catch(e) {alert(e)}
	});

	function submitContents(elClickedObj) {
		var radios = $(":radio[value='Y']");
		for(var i = 0; i < radios.length; i++) {
			var $this = $(radios[i]);
			if(!$this.is(":checked")) {
				alert('�ݵ�� �����ؾ� �մϴ�.');
				$this.focus();
				return false;
			}
		}
		try {
			elClickedObj.action = "member_form.asp";
			elClickedObj.submit()
		} catch(e) {alert(e)}
	}
</script>
<!--#include virtual="/include/config_inc.asp"-->
<%
	menu_seq = Request("menu_seq")
	Set rs = Conn.Execute("select * from cf_com_form where menu_seq='" & menu_seq & "'")
	If rs.eof Then
		sql = ""
		sql = sql & " insert into cf_com_form( "
		sql = sql & "        menu_seq "
		sql = sql & "       ,form "
		sql = sql & "       ,creid "
		sql = sql & "       ,credt "
		sql = sql & "      ) values( "
		sql = sql & "        '" & menu_seq & "' "
		sql = sql & "       ,null "
		sql = sql & "       ,'" & Session("user_id") & "' "
		sql = sql & "       ,getdate())"
		Conn.Execute(sql)
	Else
		form = rs("form")
	End If
%>
<html>
<head>
<link href="/css/bootstrap.min.css" rel="stylesheet">
<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="euc-kr"></script>
</head>
<body>

<script>
function docInsert(num){
	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);
	var sHTML = document.all("board_template_"+num).value;
	oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
}
</script>

<a href="javascript:" onclick="docInsert(1)">���1</a> | <a href="javascript:" onclick="docInsert(2)">���2</a> | <a href="javascript:" onclick="docInsert(3)">���3</a>
<form name="form" method="post" onsubmit="return submitContents(this)">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<textarea name="ir1" id="ir1" style="width:100%;height:590px;display:none;" onkeyup="setCookie('ir1',this.value,1)">
<%=form%>
</textarea>
<div style="text-align:center;padding:5px;">
	<input type="submit" class="btn btn-primary" value="��ĵ��">
	<input type="button" class="btn btn-default" value="â�ݱ�" onclick="window.close();">
</div>
</form>
<!-- ���_1 -->
<textarea id="board_template_1" style="display:none;">
<blockquote>
	<h1 style="color:#c84205; font-family:verdana; margin:0;">Hi</h1>
	<p style="width:450px; color:#bababa; font-size:10pt; margin:0;">----------------------------------------------------------------</p>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="text-align:left; color:#999; font-size:9pt; font-family:����,gulim;">
	<colgroup>
		<col width="100" /><col />
	</colgroup>
	<tr style="height:30px;">
		<th>- �̸�</th>
		<td style="color:#666;">�����</td>
	</tr>
	<tr style="height:30px;">
		<th>- ����</th>
		<td style="color:#666;">30 ��</td>
	</tr>
	<tr style="height:30px;">
		<th>- ����</th>
		<td style="color:#666;">�������</td>
	</tr>
	<tr style="height:30px;">
		<th>- ����ó</th>
		<td style="color:#666;">02-1544-0580</td>
	</tr>
	<tr style="height:30px;">
		<th>- �ְ���</th>
		<td style="color:#666;">����� ���ʱ� ���ʵ� 1357-10 īī��</td>
	</tr>
	<tr style="height:30px;">
		<th>- ����ī�޶�</th>
		<td style="color:#666;">canon350d, fuji finefix, ��Ź���̽���, sx-70</td>
	</tr>
	</table>
	<div style="width:420px; margin-top:10px; background-color:#eee; padding:15px; height:90px; color:#666; font-size:8pt; line-height:160%;">
		<b>�ȳ��ϼ���~!</b><br />
		������°� ���������� ������ ���� ������ ������ ���� ȫ�浿�Դϴ�.<br />
		������ �̷п� ���� ���� �˰�, ����, �����ϰ� �; ����濡 �����߽��ϴ�.<br />
		������ �̰����� ���� �ٴϸ鼭 �������� �ø��״� ������ּ���.<br /><br />
		�����ϰ� �ݰ����ϴ�~!!
	</div>
	<div style="width:450px; margin-top:5px;">
		<img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/tem_img01.jpg" width="450" height="300" border="0" />
	</div>
	<p style="width:450px; color:#666; font-size:10px; font-family:verdana; font-weight:bold; text-align:right; margin:0; padding-top:2px;">
		Canon350D / <span style="color:#ff0000;">cafe SUKARA</span>
	</p>
	<p style="width:450px; color:#bababa; font-size:10pt; margin:0; overflow:hidden; height:12px;">----------------------------------------------------------------</p>
</blockquote>
</textarea>

<!-- ���_2 -->
<textarea id="board_template_2" style="display:none;">
<blockquote>
	<h1 style="font-family:verdana; margin:0; color:#666;">ORDER</h1>
	<p style="width:583px; font-size:11pt; margin:5px 0; border-top:1px solid #666; height:1px; overflow:hidden;"></p>
	<h4 style="margin:15px 0 10px; font-size:10pt; color:#666;">�ֹ��� ����</h4>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="color:#666; font-size:9pt; font-family:����,gulim;">
	<colgroup>
		<col width="110" /><col />
	</colgroup>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> �̸�</td>
		<td style="color:#666;">�����</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> �����̸�</td>
		<td style="color:#666;">Kim Daum</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> �����г���</td>
		<td style="color:#666;">belle</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> �����ȣ</td>
		<td style="color:#666;">471-898</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ������ּ�</td>
		<td style="color:#666;">����� ���ʱ� ���ʵ� 1357-10 īī��</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ����ó</td>
		<td style="color:#666;">02-1544-0580</td>
	</tr>
	</table>
	<p style="width:583px; font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p>
	<h4 style="margin:20px 0 10px; font-size:10pt; color:#666;">�ֹ�����</h4>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="color:#666; font-size:9pt; font-family:����,gulim;">
	<colgroup>
		<col width="110" /><col />
	</colgroup>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ��ǰ�̸�</td>
		<td style="color:#666;">lkea BESTA Bench (beech)</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ���θ��ּ�</td>
		<td style="color:#666;">http://www.ikea.com</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ������/�뷮</td>
		<td style="color:#666;">-</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ����/����</td>
		<td style="color:#666;">beech / 1��</td>
	</tr>
	<tr style="height:10px;"><td></td></tr>
	<tr>
		<td style="vertical-align:top;"><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> ��Ÿ����</td>
		<td style="color:#666; vertical-align:top;">������ �������մϴ�.<br/><br/>���̺� ��︮�� ���� ��ǰ�� ������ �ּ���~~~</td>
	</tr>
	</table>
	<p style="width:583px; font-size:11pt; margin:20px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p>
	<h4 style="margin:15px 0 10px; font-size:10pt; color:#666;">÷�� �̹���</h4>
	<div style="width:583px; text-align:center;">
		<img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/tem_img02.gif" width="583" height="112" alt="" />
	</div>
	<p style="width:583px; font-size:11pt; margin:5px 0; border-top:1px solid #666; height:1px; overflow:hidden;"></p>
	<div style="width:583px; text-align:center; font-family:verdana; font-size:8pt; color:#666;"><b>THANK YOU</b></div>
</blockquote>
</textarea>

<!-- ���_3 -->
<textarea id="board_template_3" style="display:none;">
<blockquote>
	<div style="width:664px; background:#e76048; padding:15px;">
		<h1 style="margin:0; font-family:arial; font-weight:bold;"><span style="color:#000;">20Q</span><span style="color:#fff;">20A</span></h1>
		<p style="margin:5px 0 0; font-size:8pt;">����ִ� ������ �亯���� ���ο� ���ؼ� �˾ƺ��ô�!</p>
	</div>
	<table cellpadding="0" cellspacing="0" border="0" width="664" style="margin-top:10px; color:#666; font-size:9pt; font-family:����,gulim;">
	<colgroup>
		<col width="200" style="text-align:right; padding-right:20px; color:#c84205;" /><col style="color:#666;" />
	</colgroup>
	<tr style="height:30px;">
		<th>�̸�/����/���� ?</th>
		<td>�����/28/����</td>
	</tr>
	<tr style="height:30px;">
		<th>���� �������� ?</th>
		<td>����� ���ʱ�</td>
	</tr>
	<tr style="height:30px;">
		<th>���� �ϴ��� ?</th>
		<td>�������̳�</td>
	</tr>
	<tr style="height:30px;">
		<th>�����ϴ� �ֿϵ��� ?</th>
		<td>����� _ȥ�ڵ� �߳�Ƽ� ���� ����� �ʿ䰡 �����ϱ�.</td>
	</tr>
	<tr style="height:30px;">
		<th>�λ��� �¿�� ?</th>
		<td>�����ϴ´�� �̷������.</td>
	</tr>
	<tr>
		<th><p style="font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p></th>
		<td></td>
	</tr>
	<tr style="height:30px;">
		<th>�ζǿ� ��÷�ȴٸ� ?</th>
		<td>���� ����GTI�Ѵ� �̾Ƴ��� ������ �غ�����...</td>
	</tr>
	<tr style="height:30px;">
		<th>���������� �Ѵٸ� ?</th>
		<td>��!�ڸ� �ݵ��ص� �λ��� �޶��δٴµ�...</td>
	</tr>
	<tr style="height:30px;">
		<th>�ٽ� �¾�ٸ� ?</th>
		<td>�� �� �ڽŰ��ְ� ��ƺ�����...</td>
	</tr>
	<tr style="height:30px;">
		<th>���� �ְ��� �ҿ��� ?</th>
		<td>���� ������ �����°�. ����;;</td>
	</tr>
	<tr style="height:30px;">
		<th>���� �ְ��� ������ ?</th>
		<td>���ɿ� �� ������ ����...</td>
	</tr>
	<tr>
		<th><p style="font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p></th>
		<td></td>
	</tr>
	<tr style="height:30px;">
		<th>�����ð����� ?</th>
		<td>��Ʈ�� ���� ��ǰ�����.</td>
	</tr>
	<tr style="height:30px;">
		<th>�ϰ���� ���� ?</th>
		<td>��Ʈ�� ����� ������ �۾��� �����</td>
	</tr>
	<tr style="height:30px;">
		<th>�����ϴ� �丮�� ?</th>
		<td>������� ���İ�Ƽ</td>
	</tr>
	<tr style="height:30px;">
		<th>�����ϴ� ����� ?</th>
		<td>����...�ѹ��� ������ʹ�.</td>
	</tr>
	<tr style="height:30px;">
		<th>�����ϴ� å�� ?</th>
		<td>������ �̵忡 ������ å�� �ɵ巷~</td>
	</tr>
	<tr>
		<th><p style="font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p></th>
		<td></td>
	</tr>
	<tr style="height:30px;">
		<th>������ �ֵ� ���ɻ�� ?</th>
		<td>LOST�� �ḻ</td>
	</tr>
	<tr style="height:30px;">
		<th>�ڽ��� ���´ٸ� ?</th>
		<td>�ֱ������� ���� ������ �Ƶ�</td>
	</tr>
	<tr style="height:30px;">
		<th>����1ȣ ?</th>
		<td>ä����!! ���� ��</td>
	</tr>
	<tr style="height:30px;">
		<th>Ÿ��ĸ���� �ְ���� ������ ?</th>
		<td>������ ����</td>
	</tr>
	<tr style="height:30px;">
		<th>�ļտ��� ����� �������� ?</th>
		<td>�ڱⰡ �ϰ���� ���� �ϸ鼭 ���, �׳��̿� ������ ������ ������ ��Ŷ�</td>
	</tr>
	</table>
	<p style="width:664px; font-size:11pt; margin:10px 0; border-top:3px solid #e76048; height:3px; overflow:hidden;"></p>
</blockquote>
</textarea>

<textarea id="yield_noti_template" name="noti_template" style="display:none;">
<div style="padding: 5px 10px 10px 10px">
	<h3 style="font: bold 14px ����, dotum; color: #6273e8; padding: 0; margin: 0;">����� �絵 ����</h3>
	<div style="font: normal 12px ����, gulim, tahoma, sans-serif; line-height: 1.6; padding-top: 5px;">
		�ȳ��ϼ���? ����������Դϴ�.<br />
		�������� �������� ���� �Ʒ��� ���� ������� �絵�Ϸ��� �մϴ�.<br />
		�絵 ��, <strong>�ּ� 15�ϰ� �ش� ����</strong>�� ���� ȸ�� �����в� �絵���� ������ �ȳ��ص帰 ��,<br />
		�Ʒ� ��¥�� �絵ó�� �� �����Դϴ�.<br /><br/>
		<div style="background: #f9f9f9; padding: 10px;">
		<ol>
			<li><strong>�絵 ������:</strong> $YIELDDT<br /><br /></li>
			<li><strong>�絵���� ȸ�� ����</strong><br />
				<div style="padding-left: 10px; line-height: 1.6;">
				<strong>- �г��� (ID):</strong> �ܿ�Ǯ�� ($DAUMID)<br /><br />
				</div>
			</li>
			<li><strong>�絵 ����: </strong>&nbsp;	</li>
		</ol>
		</div>
			</div>
</div>
</textarea>

<textarea id="close_noti_template" name="noti_template" style="display:none;">
<div style="padding: 5px 10px 10px 10px">
	<h3 style="font: bold 14px ����, dotum; color: #6273e8; padding: 0; margin: 0;">����� ��� ����</h3>
	<div style="font: normal 12px ����, gulim, tahoma, sans-serif; line-height: 1.6; padding-top: 5px;">
		�ȳ��ϼ���? ����������Դϴ�.<br />
		�������� �������� ���� ������� ����Ϸ��� �մϴ�.<br />
		<br />
		�ʿ��Ͻ� �ڷᰡ ������  ��� ������ ���� �̸� ������ �ּ���.	<br /><br/>

		<div style="background: #f9f9f9; padding: 10px;">
		<ul>
			<li><strong>��� ������:</strong> $CLOSEDT ����</li>
		</ul>
		</div>
			</div>
</div>
</textarea>

<textarea id="delegation_noti_template" name="noti_template" style="display:none;">
    <div style="padding: 5px 10px 10px 10px">
        <h3 style="font: bold 14px ����, dotum; color: #6273e8; padding: 0; margin: 0;">����� ���� ����</h3>
        <div style="font: normal 12px ����, gulim, tahoma, sans-serif; line-height: 1.6; padding-top: 5px;" id="delegationContent">
            �ȳ��ϼ���? �� ��������Ⱑ 3���� �̻� �����Ͽ� �������� ����� ������ �Ұ����ϴٰ� �Ǵ�,<br />
            �Ʒ� �����ϴ� ������ ���� ������������� ���ӹ޾� ������� ��� �������� �մϴ�. <br />
            ���� ��, �ּ� 15�ϰ� �ش� ������ ���� ȸ�� �����в� ���� ���� ������ �ȳ��ص帰 �� ��/�� ��ǥ�� ��ġ�� �˴ϴ�. <br />
            �̶� ��ü ��ǥ �� ��� ���� ������ 60% �̻��� ��� �Ʒ� ��¥�� ����ó���˴ϴ�.<br />
            <br />
            ��ǥ�� ����� ��� ���� ���䰡 ����ǹǷ�, <br />
            ��ǥ���� �� ���� ����ó���� �ٹ��� �������� 7~10�� ���� �ʾ��� �� �ֽ��ϴ�.<br />
            <br />
            (* �ݴ� ������ 40% �̻��� ��� �ش� ���Ӱ��� ����ǿ��� �̿뿡 ���� ��Ź�帳�ϴ�.)<br />
            <br /><br/>

            <div style="background: #f9f9f9; padding: 10px;">
                <ul>
                    <li><strong>���� ������:</strong> </li>
                    <li><strong>���ӹ��� ȸ�� ����</strong><br />
                        <div style="padding-left: 10px; line-height: 1.6;">
                            <strong>- �г��� (ID):</strong>  ()<br />
                            <strong>- ����� ������/�湮�� ��:</strong><br />
                            <strong>- �ۼ��� ��/�ۼ���� :</strong><br /><br />
                        </div>
                    </li>
                    <li><strong>���ӹް��� �ϴ� ����:</strong>	</li>
                </ul>
            </div>
            <br />
            <img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/img_vote.gif" type="poll" id="delegationPoll" />
	</div>
</div>
</textarea>
</body>
</html>


<script>
var oEditors = [];

// �߰� �۲� ���
//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];

nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "ir1",
	sSkinURI: "/smart/SmartEditor2Skin.html",
	htParams : {
		bUseToolbar : true,				// ���� ��� ���� (true:���/ false:������� ����)
		bUseVerticalResizer : true,		// �Է�â ũ�� ������ ��� ���� (true:���/ false:������� ����)
		bUseModeChanger : true,			// ��� ��(Editor | HTML | TEXT) ��� ���� (true:���/ false:������� ����)
		//aAdditionalFontList : aAdditionalFontSet,		// �߰� �۲� ���
		fOnBeforeUnload : function(){
			//alert("�Ϸ�!")
		}
	}, //boolean
	fOnAppLoad : function(){
		//���� �ڵ�
		//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
	},
	fCreator: "createSEditor2"
})



function submitContents(elClickedObj) {
	oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
	try {
		elClickedObj.action = "form_exec.asp";
		elClickedObj.form.submit()

	} catch(e) {}

}

</script>

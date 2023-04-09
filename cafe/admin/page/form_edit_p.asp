<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
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
<script type="text/javascript" src="/smart/js/HuskyEZCreator.js" charset="utf-8"></script>
</head>
<body>

<script>
function docInsert(num) {
	oEditors.getById["ir1"].exec("SET_CONTENTS", [""]);
	var sHTML = document.all("board_template_"+num).value;
	oEditors.getById["ir1"].exec("PASTE_HTML", [sHTML]);
}
</script>

<a href="javascript:" onclick="docInsert(1)">양식1</a> | <a href="javascript:" onclick="docInsert(2)">양식2</a> | <a href="javascript:" onclick="docInsert(3)">양식3</a>
<form name="form" method="post" onsubmit="return submitContents(this)">
<input type="hidden" name="menu_seq" value="<%=menu_seq%>">
<textarea name="ir1" id="ir1" style="width:100%;height:590px;display:none;" onkeyup="setCookie('ir1',this.value,1)">
<%=form%>
</textarea>
<div style="text-align:center;padding:5px;">
	<input type="submit" class="btn btn-primary" value="약식등록">
	<input type="button" class="btn btn-default" value="창닫기" onclick="window.close();">
</div>
</form>
<!-- 양식_1 -->
<textarea id="board_template_1" style="display:none;">
<blockquote>
	<h1 style="color:#c84205; font-family:verdana; margin:0;">Hi</h1>
	<p style="width:450px; color:#bababa; font-size:10pt; margin:0;">----------------------------------------------------------------</p>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="text-align:left; color:#999; font-size:9pt; font-family:굴림,gulim;">
	<colgroup>
		<col width="100" /><col />
	</colgroup>
	<tr style="height:30px;">
		<th>- 이름</th>
		<td style="color:#666;">김다음</td>
	</tr>
	<tr style="height:30px;">
		<th>- 나이</th>
		<td style="color:#666;">30 세</td>
	</tr>
	<tr style="height:30px;">
		<th>- 별명</th>
		<td style="color:#666;">원더우먼</td>
	</tr>
	<tr style="height:30px;">
		<th>- 연락처</th>
		<td style="color:#666;">02-1544-0580</td>
	</tr>
	<tr style="height:30px;">
		<th>- 주거지</th>
		<td style="color:#666;">서울시 서초구 서초동 1357-10 카카오</td>
	</tr>
	<tr style="height:30px;">
		<th>- 보유카메라</th>
		<td style="color:#666;">canon350d, fuji finefix, 펜탁스미슈퍼, sx-70</td>
	</tr>
	</table>
	<div style="width:420px; margin-top:10px; background-color:#eee; padding:15px; height:90px; color:#666; font-size:8pt; line-height:160%;">
		<b>안녕하세요~!</b><br />
		사진찍는건 좋아하지만 사진에 대한 지식이 많지는 않은 홍길동입니다.<br />
		사진의 이론에 대해 많이 알고, 배우고, 공유하고 싶어서 사랑방에 가입했습니다.<br />
		앞으로 이곳저곳 많이 다니면서 많은사진 올릴테니 기대해주세요.<br /><br />
		감사하고 반갑습니다~!!
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

<!-- 양식_2 -->
<textarea id="board_template_2" style="display:none;">
<blockquote>
	<h1 style="font-family:verdana; margin:0; color:#666;">ORDER</h1>
	<p style="width:583px; font-size:11pt; margin:5px 0; border-top:1px solid #666; height:1px; overflow:hidden;"></p>
	<h4 style="margin:15px 0 10px; font-size:10pt; color:#666;">주문자 정보</h4>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="color:#666; font-size:9pt; font-family:굴림,gulim;">
	<colgroup>
		<col width="110" /><col />
	</colgroup>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 이름</td>
		<td style="color:#666;">김다음</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 영문이름</td>
		<td style="color:#666;">Kim Daum</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 사랑방닉네임</td>
		<td style="color:#666;">belle</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 우편번호</td>
		<td style="color:#666;">471-898</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 배송지주소</td>
		<td style="color:#666;">서울시 서초구 서초동 1357-10 카카오</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout01.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 연락처</td>
		<td style="color:#666;">02-1544-0580</td>
	</tr>
	</table>
	<p style="width:583px; font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p>
	<h4 style="margin:20px 0 10px; font-size:10pt; color:#666;">주문내역</h4>
	<table cellpadding="0" cellspacing="0" border="0" width="100%" style="color:#666; font-size:9pt; font-family:굴림,gulim;">
	<colgroup>
		<col width="110" /><col />
	</colgroup>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 제품이름</td>
		<td style="color:#666;">lkea BESTA Bench (beech)</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 쇼핑몰주소</td>
		<td style="color:#666;">http://www.ikea.com</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 사이즈/용량</td>
		<td style="color:#666;">-</td>
	</tr>
	<tr style="height:30px;">
		<td><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 색상/수량</td>
		<td style="color:#666;">beech / 1개</td>
	</tr>
	<tr style="height:10px;"><td></td></tr>
	<tr>
		<td style="vertical-align:top;"><img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/blt_layout02.gif" width="6" height="6" alt="" style="margin-bottom:2px;" /> 기타문의</td>
		<td style="color:#666; vertical-align:top;">바퀴는 미포함합니다.<br/><br/>테이블에 어울리는 예쁜 소품들 선물로 주세요~~~</td>
	</tr>
	</table>
	<p style="width:583px; font-size:11pt; margin:20px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p>
	<h4 style="margin:15px 0 10px; font-size:10pt; color:#666;">첨부 이미지</h4>
	<div style="width:583px; text-align:center;">
		<img src="http://i1.daumcdn.net/cafeimg/cf_img2/bbs2/tem_img02.gif" width="583" height="112" alt="" />
	</div>
	<p style="width:583px; font-size:11pt; margin:5px 0; border-top:1px solid #666; height:1px; overflow:hidden;"></p>
	<div style="width:583px; text-align:center; font-family:verdana; font-size:8pt; color:#666;"><b>THANK YOU</b></div>
</blockquote>
</textarea>

<!-- 양식_3 -->
<textarea id="board_template_3" style="display:none;">
<blockquote>
	<div style="width:664px; background:#e76048; padding:15px;">
		<h1 style="margin:0; font-family:arial; font-weight:bold;"><span style="color:#000;">20Q</span><span style="color:#fff;">20A</span></h1>
		<p style="margin:5px 0 0; font-size:8pt;">재미있는 질문과 답변으로 서로에 대해서 알아봅시다!</p>
	</div>
	<table cellpadding="0" cellspacing="0" border="0" width="664" style="margin-top:10px; color:#666; font-size:9pt; font-family:굴림,gulim;">
	<colgroup>
		<col width="200" style="text-align:right; padding-right:20px; color:#c84205;" /><col style="color:#666;" />
	</colgroup>
	<tr style="height:30px;">
		<th>이름/나이/성별 ?</th>
		<td>김다음/28/여자</td>
	</tr>
	<tr style="height:30px;">
		<th>현재 거주지역 ?</th>
		<td>서울시 서초구</td>
	</tr>
	<tr style="height:30px;">
		<th>현재 하는일 ?</th>
		<td>웹디자이너</td>
	</tr>
	<tr style="height:30px;">
		<th>좋아하는 애완동물 ?</th>
		<td>고양이 _혼자도 잘놀아서 굳이 놀아줄 필요가 없으니깐.</td>
	</tr>
	<tr style="height:30px;">
		<th>인생의 좌우명 ?</th>
		<td>생각하는대로 이루어진다.</td>
	</tr>
	<tr>
		<th><p style="font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p></th>
		<td></td>
	</tr>
	<tr style="height:30px;">
		<th>로또에 당첨된다면 ?</th>
		<td>먼저 골프GTI한대 뽑아놓고 생각을 해봐야지...</td>
	</tr>
	<tr style="height:30px;">
		<th>성형수술을 한다면 ?</th>
		<td>코!코만 반듯해도 인상이 달라보인다는데...</td>
	</tr>
	<tr style="height:30px;">
		<th>다시 태어난다면 ?</th>
		<td>좀 더 자신감있게 살아봐야지...</td>
	</tr>
	<tr style="height:30px;">
		<th>지금 최고의 소원은 ?</th>
		<td>살이 저절로 빠지는것. ㅎㅎ;;</td>
	</tr>
	<tr style="height:30px;">
		<th>지금 최고의 걱정은 ?</th>
		<td>점심에 뭘 먹으러 갈까...</td>
	</tr>
	<tr>
		<th><p style="font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p></th>
		<td></td>
	</tr>
	<tr style="height:30px;">
		<th>여유시간에는 ?</th>
		<td>펠트로 작은 소품만들기.</td>
	</tr>
	<tr style="height:30px;">
		<th>하고싶은 일은 ?</th>
		<td>퀼트를 배워서 나만의 작업실 만들기</td>
	</tr>
	<tr style="height:30px;">
		<th>좋아하는 요리는 ?</th>
		<td>까르보나라 스파게티</td>
	</tr>
	<tr style="height:30px;">
		<th>좋아하는 나라는 ?</th>
		<td>영국...한번쯤 가보고싶다.</td>
	</tr>
	<tr style="height:30px;">
		<th>좋아하는 책은 ?</th>
		<td>요즘은 미드에 빠져서 책은 심드렁~</td>
	</tr>
	<tr>
		<th><p style="font-size:11pt; margin:10px 0; border-top:1px dotted #666; height:1px; overflow:hidden;"></p></th>
		<td></td>
	</tr>
	<tr style="height:30px;">
		<th>요즘의 주된 관심사는 ?</th>
		<td>LOST의 결말</td>
	</tr>
	<tr style="height:30px;">
		<th>자식을 낳는다면 ?</th>
		<td>애교스러운 딸과 듬직한 아들</td>
	</tr>
	<tr style="height:30px;">
		<th>보물1호 ?</th>
		<td>채은이!! 나의 딸</td>
	</tr>
	<tr style="height:30px;">
		<th>타임캡슐에 넣고싶은 물건은 ?</th>
		<td>가족들 사진</td>
	</tr>
	<tr style="height:30px;">
		<th>후손에게 남기고 싶은말은 ?</th>
		<td>자기가 하고싶은 일을 하면서 살고, 그나이에 할일이 있으니 열심히 살거라</td>
	</tr>
	</table>
	<p style="width:664px; font-size:11pt; margin:10px 0; border-top:3px solid #e76048; height:3px; overflow:hidden;"></p>
</blockquote>
</textarea>

<textarea id="yield_noti_template" name="noti_template" style="display:none;">
<div style="padding: 5px 10px 10px 10px">
	<h3 style="font: bold 14px 돋움, dotum; color: #6273e8; padding: 0; margin: 0;">사랑방 양도 공지</h3>
	<div style="font: normal 12px 굴림, gulim, tahoma, sans-serif; line-height: 1.6; padding-top: 5px;">
		안녕하세요? 사랑방지기입니다.<br />
		개인적인 사정으로 인해 아래와 같이 사랑방을 양도하려고 합니다.<br />
		양도 전, <strong>최소 15일간 해당 공지</strong>를 통해 회원 여러분께 양도관련 내용을 안내해드린 후,<br />
		아래 날짜에 양도처리 될 예정입니다.<br /><br/>
		<div style="background: #f9f9f9; padding: 10px;">
		<ol>
			<li><strong>양도 예정일:</strong> $YIELDDT<br /><br /></li>
			<li><strong>양도받을 회원 정보</strong><br />
				<div style="padding-left: 10px; line-height: 1.6;">
				<strong>- 닉네임 (ID):</strong> 겨울풀잎 ($DAUMID)<br /><br />
				</div>
			</li>
			<li><strong>양도 사유: </strong>&nbsp;	</li>
		</ol>
		</div>
			</div>
</div>
</textarea>

<textarea id="close_noti_template" name="noti_template" style="display:none;">
<div style="padding: 5px 10px 10px 10px">
	<h3 style="font: bold 14px 돋움, dotum; color: #6273e8; padding: 0; margin: 0;">사랑방 폐쇄 공지</h3>
	<div style="font: normal 12px 굴림, gulim, tahoma, sans-serif; line-height: 1.6; padding-top: 5px;">
		안녕하세요? 사랑방지기입니다.<br />
		개인적인 사정으로 인해 사랑방을 폐쇄하려고 합니다.<br />
		<br />
		필요하신 자료가 있으면  폐쇄 예정일 전에 미리 저장해 주세요.	<br /><br/>

		<div style="background: #f9f9f9; padding: 10px;">
		<ul>
			<li><strong>폐쇄 예정일:</strong> $CLOSEDT 이후</li>
		</ul>
		</div>
			</div>
</div>
</textarea>

<textarea id="delegation_noti_template" name="noti_template" style="display:none;">
    <div style="padding: 5px 10px 10px 10px">
        <h3 style="font: bold 14px 돋움, dotum; color: #6273e8; padding: 0; margin: 0;">사랑방 위임 공지</h3>
        <div style="font: normal 12px 굴림, gulim, tahoma, sans-serif; line-height: 1.6; padding-top: 5px;" id="delegationContent">
            안녕하세요? 현 사랑방지기가 3개월 이상 부재하여 정상적인 사랑방 지속이 불가능하다고 판단,<br />
            아래 기재하는 사유와 같이 사랑방지기직을 위임받아 사랑방을 운영해 나가고자 합니다. <br />
            위임 전, 최소 15일간 해당 공지를 통해 회원 여러분께 위임 관련 내용을 안내해드린 뒤 찬/반 투표를 거치게 됩니다. <br />
            이때 전체 투표 수 대비 찬성 비율이 60% 이상일 경우 아래 날짜에 위임처리됩니다.<br />
            <br />
            투표가 가결될 경우 최종 검토가 진행되므로, <br />
            투표종료 후 실제 위임처리는 근무일 기준으로 7~10일 정도 늦어질 수 있습니다.<br />
            <br />
            (* 반대 비율이 40% 이상일 경우 해당 위임건은 무산되오니 이용에 참고 부탁드립니다.)<br />
            <br /><br/>

            <div style="background: #f9f9f9; padding: 10px;">
                <ul>
                    <li><strong>위임 예정일:</strong> </li>
                    <li><strong>위임받을 회원 정보</strong><br />
                        <div style="padding-left: 10px; line-height: 1.6;">
                            <strong>- 닉네임 (ID):</strong>  ()<br />
                            <strong>- 사랑방 가입일/방문일 수:</strong><br />
                            <strong>- 작성글 수/작성댓글 :</strong><br /><br />
                        </div>
                    </li>
                    <li><strong>위임받고자 하는 사유:</strong>	</li>
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

// 추가 글꼴 목록
//var aAdditionalFontSet = [["MS UI Gothic", "MS UI Gothic"], ["Comic Sans MS", "Comic Sans MS"],["TEST","TEST"]];

nhn.husky.EZCreator.createInIFrame({
	oAppRef: oEditors,
	elPlaceHolder: "ir1",
	sSkinURI: "/smart/SmartEditor2Skin.html",
	htParams : {
		bUseToolbar : true,				// 툴바 사용 여부 (true:사용/ false:사용하지 않음)
		bUseVerticalResizer : true,		// 입력창 크기 조절바 사용 여부 (true:사용/ false:사용하지 않음)
		bUseModeChanger : true,			// 모드 탭(Editor | HTML | TEXT) 사용 여부 (true:사용/ false:사용하지 않음)
		//aAdditionalFontList : aAdditionalFontSet,		// 추가 글꼴 목록
		fOnBeforeUnload : function() {
			//alert("완료!")
		}
	}, //boolean
	fOnAppLoad : function() {
		//예제 코드
		//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
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

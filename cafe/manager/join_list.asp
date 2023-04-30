<%@Language="VBScript" CODEPAGE="65001" %>
<%
	Const tb_prefix = "cf"
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call CheckManager(cafe_id)
%>
<%
	If Request("user")<>"" Then
		sql = ""
		sql = sql & " update cf_cafe_member "
		sql = sql & "    set stat = 'Y' "
		sql = sql & "       ,cafe_mb_level = '1' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "' "
		sql = sql & "    and user_id = '" & Request("user") & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " update cf_cafe_member "
		sql = sql & "    set stat = 'Y' "
		sql = sql & "       ,cafe_mb_level = '1' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where user_id = '" & Request("user") & "' "
		Conn.Execute(sql)

		Response.Write "<script>parent.location = 'join_list.asp'</script>"
		Response.end
	End If

	Reg_level = Request.Form("reg_level")

	If reg_level<>"" Then
		sql = ""
		sql = sql & " update cf_cafe "
		sql = sql & "    set reg_level = '" & reg_level & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where cafe_id = '" & cafe_id & "'"
		Conn.Execute(sql)

		msgonly "저장 되었습니다."
	End If

	Set conf = Conn.Execute("select * from cf_cafe where cafe_id = '" & cafe_id & "'")
%>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>기본정보 관리 : 사랑방 관리</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>사랑방 관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/manager/manager_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">가입정보/조건</h2>
			</div>
			<div class="adm_cont">
				<form method="post">
				<div class="status_box clearBoth">
					<span class="floatL">
						<span class="f_weight_b mr10">가입등급설정 :</span>
						사랑방 회원가입 시
						<select id="reg_level" name="reg_level" class="sel w100p">
							<%=GetMakeCDCombo("reg_level", reg_level)%>
						</select>
						으로 자동 등급 설정합니다.
						<button type="submit" class="btn btn_c_s btn_s">확인</button>
					</span>
					<span class="floatR">
					</span>
				</div>
				</form>
				<div class="tb tb_form_1">
					<table>
						<colgroup>
							<col class="w20" span="5" />
						</colgroup>
						<thead>
							<tr>
								<th scope="col">번호</th>
								<th scope="col">이름(상호)</th>
								<th scope="col">전화번호</th>
								<th scope="col">소재지</th>
								<th scope="col">상태</th>
							</tr>
						</thead>
						<tbody>
<%
	i = 1

	Set rs = Server.CreateObject("ADODB.Recordset")

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_cafe_member cm "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.stat = 'Y' "
	sql = sql & "  where cm.cafe_id = '" & cafe_id & "' "
	sql = sql & "    and cm.stat = 'Y' "
	sql = sql & "    and cm.cafe_mb_level = '1' "
	rs.Open sql, conn, 3, 1

	If Not rs.eof Then
		Do Until rs.eof
%>
							<tr>
								<td class="algC"><%=i%></td>
								<td class="algC"><%=rs("kname") & " (" & rs("agency") & ")" %></td>
								<td class="algC"><%=rs("mobile")%></td>
								<td class="algC"><%=rs("addr1")%> <%=rs("addr2")%></td>
								<td class="algC"><input type="button" value="가입승인" onclick="ifrm.location.href='join_exec.asp?user_id=<%=rs("user_id")%>'"></td>
							</tr>
<%
			i = i + 1
			rs.MoveNext
		Loop
	Else
%>
							<tr>
								<td class="algC" colspan="5">가입신청한 회원이 없습니다.</td>
							</tr>
<%
	End If
	rs.close
	Set rs = Nothing
%>
						</tbody>
					</table>
				</div>
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
</body>
</html>
<%
If session("cafe_ad_level") = "10" And session("skin_id") = "skin_01" Then extime("실행시간") 
%>

<%@Language="VBScript" CODEPAGE="65001" %>
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>회원 관리 > 관리자</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
</head>
<body class="sa">
	<div id="wrap">
		<header id="adm_head">
			<h1><a href="/">RETS 경인<sub>전체관리</sub></a></h1>
		</header>
		<nav id="adm_nav">
<!--#include virtual="/cafe/admin/admin_left_inc.asp"-->
		</nav>
		<main id="adm_body">
			<div class="adm_page_tit">
				<h2 class="h2">게시글 중단 요청</h2>
			</div>
			<div class="adm_cont">
				<div class="search_box">
					<select id="" name="" class="sel w100p">
						<option value="">기간선택</option>
					</select>
					<select id="" name="" class="sel w100p">
						<option value="">제목</option>
					</select>
					<input type="text" id="" name="" class="inp w300p" />
					<button type="button" class="btn btn_c_a btn_s">검색</button>
				</div>
				<div class="tb tb_form_1">
					<table>
						<colgroup>
							<col class="w5" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
							<col class="w_auto" />
							<col class="w10" />
							<col class="w10" />
							<col class="w10" />
						</colgroup>
						<thead>
<%
	i = 1
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
							<tr>
								<th scope="col">번호</th>
								<th scope="col">요청구분</th>
								<th scope="col">이름/소속단체명</th>
								<th scope="col">휴대폰</th>
								<th scope="col">이메일주소</th>
								<th scope="col">제목</th>
								<th scope="col">첨부파일</th>
								<th scope="col">요청일</th>
								<th scope="col">처리</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td class="algC">10</td>
								<td class="algC">개인</td>
								<td class="algC">주식회사 활빈당</td>
								<td class="algC">010-0000-0000</td>
								<td class="algC">hong123@gmail.com</td>
								<td><a href="#n">게시글 중단 요청합니다.</a></td>
								<td class="algC"><button type="button" class="btn f_awesome btn_file"><em>첨부파일</em></button></td>
								<td class="algC">2022-04-13</td>
								<td class="algC">
									<select id="" name="" class="sel w100">
										<option value="">선택</option>
										<option value="">완료</option>
										<option value="">보류</option>
									</select>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
<!--#include virtual="/cafe/skin/skin_page_inc.asp"-->
			</div>
		</main>
		<footer id="adm_foot"></footer>
	</div>
</body>
</html>

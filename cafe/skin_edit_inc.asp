<%
	If cafe_id = "" Then Response.End
%>
<%
	Set setting_rs = Server.CreateObject("ADODB.Recordset")
	Set rs = Server.CreateObject("ADODB.Recordset")

	If skin_id = "" Then skin_id = session("skin_id")
	Select Case skin_id
		Case "skin_01"
			skin_idx = ""
		Case "skin_02"
			skin_idx = "2"
		Case "skin_03"
			skin_idx = "3"
	End Select

	sql = ""
	sql = sql & " select * "
	sql = sql & "   from cf_skin "
	sql = sql & "  where cafe_id = '" & cafe_id & "' "
'	sql = sql & "    and skin_id = '" & skin_id & "' "
	setting_rs.Open Sql, conn, 3, 1

	If Not setting_rs.eof Then
		cafe_id             = setting_rs("cafe_id")
		If skin_id = "" then skin_id = setting_rs("skin_id")
		skin_left_id        = setting_rs("skin_left_id")
		skin_left_color01   = setting_rs("skin_left_color01")
		skin_left_color02   = setting_rs("skin_left_color02")
		skin_left_color03   = setting_rs("skin_left_color03")
		skin_left_font01    = setting_rs("skin_left_font01")
		skin_center_id      = setting_rs("skin_center_id")
		skin_center_color01 = setting_rs("skin_center_color01")
		skin_center_color02 = setting_rs("skin_center_color02")
		skin_center_font01  = setting_rs("skin_center_font01")
		skin_center_font02  = setting_rs("skin_center_font02")
		skin_body_id        = setting_rs("skin_body_id")
		skin_body_color01   = setting_rs("skin_body_color01")
		creid               = setting_rs("creid")
		credt               = setting_rs("credt")
		modid               = setting_rs("modid")
		moddt               = setting_rs("moddt")
	End If
	setting_rs.close
	Set setting_rs = Nothing
%>
	<form name="skin_form" method="post" action="/cafe/skin_exec.asp">
	<input type="hidden" name="skin_id" value="skin_03">
	<input type="hidden" name="skin_left_id" value="">
	<input type="hidden" name="skin_left_color01" value="">
	<input type="hidden" name="skin_left_color02" value="">
	<input type="hidden" name="skin_left_color03" value="">
	<input type="hidden" name="skin_left_font01" value=", ">
	<input type="hidden" name="skin_center_id" value="02">
	<input type="hidden" name="skin_center_color01" value="#ef3300">
	<input type="hidden" name="skin_center_color02" value="#efd9d2">
	<input type="hidden" name="skin_center_font01" value=", ">
	<input type="hidden" name="skin_center_font02" value=", ">
	<input type="hidden" name="skin_body_id" value="">
	<input type="hidden" name="skin_body_color01" value="">
	<!-- 꾸미기 : s -->
	<aside id="decorate">
		<div class="inner">
			<h2>꾸미기 설정<button type="button" class="btn_decorate_close">닫기</button></h2>
			<dl class="deco_dl">
				<!-- 크기 변경 : s -->
				<dt><button type="button" class="btn_setting">크기</button></dt>
				<dd>
					<div class="flex-box">
						<div class="item-box">
							<input type="radio" id="boxModel_1" name="boxModel" data-tmp-code="wrapSize_full" class="inp_radio" checked />
							<label for="boxModel_1" class="screen-1"><em>전체화면</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="boxModel_2" name="boxModel" data-tmp-code="wrapSize_comp" class="inp_radio" />
							<label for="boxModel_2" class="screen-2"><em>콤팩트화면</em></label>
						</div>
					</div>
					<ul class="list_type list_type_triple wrapSize_comp-box" style="display:none">
						<li><input type="radio" id="boxAlign_1" name="boxAlign" data-tmp-code="wrapAlign_center" class="inp_radio" checked /><label for="boxAlign_1"><em>가운데정렬</em></label></li>
						<li><input type="radio" id="boxAlign_2" name="boxAlign" data-tmp-code="wrapAlign_left" class="inp_radio" /><label for="boxAlign_2"><em>좌측정렬</em></label></li>
					</ul>
				</dd>
				<!-- 크기 변경 : e -->

				<!-- 좌측메뉴 스킨 변경 : s -->
				<dt><button type="button" class="btn_setting">좌측디자인</button></dt>
				<dd>
					<div class="flex-box">
						<div class="item-box">
							<input type="radio" id="skin_none" name="skin" data-skin-code="dsc_none" class="inp_radio" checked />
							<label for="skin_none" class="skin-default"><em>미적용</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_1" name="skin" data-skin-code="dsc_1" class="inp_radio" />
							<label for="skin_1" class="skin-1"><em>스킨 1번</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_2" name="skin" data-skin-code="dsc_2" class="inp_radio" />
							<label for="skin_2" class="skin-2"><em>스킨 2번</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_3" name="skin" data-skin-code="dsc_3" class="inp_radio" />
							<label for="skin_3" class="skin-3"><em>스킨 3번</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_4" name="skin" data-skin-code="dsc_4" class="inp_radio" />
							<label for="skin_4" class="skin-4"><em>스킨 4번</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_5" name="skin" data-skin-code="dsc_5" class="inp_radio" />
							<label for="skin_5" class="skin-5"><em>스킨 5번</em></label>
						</div>
					</div>
				</dd>
				<!-- 좌측메뉴 스킨 변경 : e -->

				<!-- 전체 배경 색상 : s -->
				<dt><button type="button" class="btn_setting">전체 배경 색상</button></dt>
				<dd>
					<ul class="list_type list_type_multi">
						<li><input type="radio" id="bg_none" name="bg" data-color-bg="bg_none" class="inp_radio" checked /><label for="bg_none"><span class="colorSample__none"></span><em class="">없음</em></label></li>
						<li><input type="radio" id="bg_1" name="bg" data-color-bg="bg_1" class="inp_radio" /><label for="bg_1"><span class="colorSample bg_1"></span><em class="bgt">배경 2번</em></label></li>
						<li><input type="radio" id="bg_2" name="bg" data-color-bg="bg_2" class="inp_radio" /><label for="bg_2"><span class="colorSample bg_2"></span><em class="bgt">배경 3번</em></label></li>
						<li><input type="radio" id="bg_3" name="bg" data-color-bg="bg_3" class="inp_radio" /><label for="bg_3"><span class="colorSample bg_3"></span><em class="bgt">배경 4번</em></label></li>
						<li><input type="radio" id="bg_4" name="bg" data-color-bg="bg_4" class="inp_radio" /><label for="bg_4"><span class="colorSample bg_4"></span><em class="bgt">배경 5번</em></label></li>
						<li><input type="radio" id="bg_5" name="bg" data-color-bg="bg_5" class="inp_radio" /><label for="bg_5"><span class="colorSample bg_5"></span><em class="bgt">배경 6번</em></label></li>
					</ul>
				</dd>
				<!-- 전체 배경 색상 : e -->

				<dt><button type="button" class="btn_setting">상단 색상</button></dt>
				<dd>
					<ul class="list_type list_type_multi">
						<li><input type="radio" id="bgT_none" name="bgT" data-color-bgTop="bgT_none" class="inp_radio" checked /><label for="bgT_none"><span class="colorSample__none"></span><em class="">없음</em></label></li>
						<li><input type="radio" id="bgT_1" name="bgT" data-color-bgTop="bgTop_1" class="inp_radio" /><label for="bgT_1"><span class="colorSample bgTop_1"></span><em class="bgt">상단 2번</em></label></li>
						<li><input type="radio" id="bgT_2" name="bgT" data-color-bgTop="bgTop_2" class="inp_radio" /><label for="bgT_2"><span class="colorSample bgTop_2"></span><em class="bgt">상단 3번</em></label></li>
						<li><input type="radio" id="bgT_3" name="bgT" data-color-bgTop="bgTop_3" class="inp_radio" /><label for="bgT_3"><span class="colorSample bgTop_3"></span><em class="bgt">상단 4번</em></label></li>
						<li><input type="radio" id="bgT_4" name="bgT" data-color-bgTop="bgTop_4" class="inp_radio" /><label for="bgT_4"><span class="colorSample bgTop_4"></span><em class="bgt">상단 5번</em></label></li>
						<li><input type="radio" id="bgT_5" name="bgT" data-color-bgTop="bgTop_5" class="inp_radio" /><label for="bgT_5"><span class="colorSample bgTop_5"></span><em class="bgt">상단 6번</em></label></li>
					</ul>
				</dd>
				<dt><button type="button" class="btn_setting">좌측 색상</button></dt>
				<dd>
					<ul class="list_type list_type_multi">
						<li>
							<input type="radio" id="bgL_none" name="bgL" data-color-left="bgL_none" class="inp_radio" checked /><label for="bgL_none"><span class="colorSample__none"></span><em class="">없음</em></label>
						</li>
						<li>
							<input type="radio" id="bgL_1" name="bgL" data-color-left="bgL_1" class="inp_radio" />
							<label for="bgL_1"><span class="colorSample2 bgL_1_s"></span><em class="bgt">좌측 2번</em></label>
						</li>
						<li><input type="radio" id="bgL_2" name="bgL" data-color-left="bgL_2" class="inp_radio" /><label for="bgL_2"><span class="colorSample2 bgL_2_s"></span><em class="bgt">좌측 3번</em></label></li>
						<li><input type="radio" id="bgL_3" name="bgL" data-color-left="bgL_3" class="inp_radio" /><label for="bgL_3"><span class="colorSample2 bgL_3_s"></span><em class="bgt">좌측 4번</em></label></li>
						<li><input type="radio" id="bgL_4" name="bgL" data-color-left="bgL_4" class="inp_radio" /><label for="bgL_4"><span class="colorSample2 bgL_4_s"></span><em class="bgt">좌측 5번</em></label></li>
						<li><input type="radio" id="bgL_5" name="bgL" data-color-left="bgL_5" class="inp_radio" /><label for="bgL_5"><span class="colorSample2 bgL_5_s"></span><em class="bgt">좌측 6번</em></label></li>
					</ul>
				</dd>
				<dt><button type="button" class="btn_setting">최신글 색상</button></dt>
				<dd>
					<div class="choice_box">
						<ul class="choice_list">
							<li>
								<span class="head">1.최시글제목</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
							<li>
								<span class="head">2.최시글제목</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
							<li>
								<span class="head">3.최시글제목</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
							<li>
								<span class="head">4.최시글제목</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
							<li>
								<span class="head">5.최시글제목</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
							<li>
								<span class="head">6.최시글제목</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
						</ul>
						<ul class="choice_list">
							<li>
								<span class="head">타이틀</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
							<li>
								<span class="head">게시글</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">기본</option>
								</select>
							</li>
						</ul>
					</div>
					<ul class="list_type list_type_multi">
						<li>
							<input type="radio" id="latestColor_1_1" name="latestColor" data-color-latest="latest_1_1" class="inp_radio" checked />
							<label for="latestColor_1_1"><span class="ico-rect latestColor_1_1">1번</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_2" name="latestColor" data-color-latest="latest_1_2" class="inp_radio" />
							<label for="latestColor_1_2"><span class="ico-rect latestColor_1_2">2번</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_3" name="latestColor" data-color-latest="latest_2_1" class="inp_radio" />
							<label for="latestColor_1_3"><span class="ico-rect latestColor_1_3">3번</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_4" name="latestColor" data-color-latest="latest_2_2" class="inp_radio" />
							<label for="latestColor_1_4"><span class="ico-rect latestColor_1_4">4번</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_5" name="latestColor" data-color-latest="latest_3_1" class="inp_radio" />
							<label for="latestColor_1_5"><span class="ico-rect latestColor_1_5">5번</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_6" name="latestColor" data-color-latest="latest_3_2" class="inp_radio" />
							<label for="latestColor_1_6"><span class="ico-rect latestColor_1_6">6번</span></label>
						</li>
					</ul>
				</dd>
			</dl>
			<div class="btn_box">
				<button type="button" class="btn btn_s btn_c_n">닫기</button>
				<button type="button" class="btn btn_s btn_c_a">저장</button>
				<button type="button" class="btn btn_s">원래대로</button>
			</div>
		</div>
	</aside>
	</form>
	<!-- 꾸미기 : e -->

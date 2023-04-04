<%
	Set setting_rs = Server.CreateObject ("ADODB.Recordset")
	Set rs = Server.CreateObject ("ADODB.Recordset")

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
	<form name="skin_form" method="post" action="/cafe/skin/skin_exec.asp">
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
	<!-- �ٹ̱� : s -->
	<aside id="decorate">
		<div class="inner">
			<h2>�ٹ̱� ����<button type="button" class="btn_decorate_close">�ݱ�</button></h2>
			<dl class="deco_dl">
				<!-- ũ�� ���� : s -->
				<dt><button type="button" class="btn_setting">ũ��</button></dt>
				<dd>
					<div class="flex-box">
						<div class="item-box">
							<input type="radio" id="boxModel_1" name="boxModel" data-tmp-code="wrapSize_full" class="inp_radio" checked />
							<label for="boxModel_1" class="screen-1"><em>��üȭ��</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="boxModel_2" name="boxModel" data-tmp-code="wrapSize_comp" class="inp_radio" />
							<label for="boxModel_2" class="screen-2"><em>����Ʈȭ��</em></label>
						</div>
					</div>
					<ul class="list_type list_type_triple wrapSize_comp-box" style="display:none">
						<li><input type="radio" id="boxAlign_1" name="boxAlign" data-tmp-code="wrapAlign_center" class="inp_radio" checked /><label for="boxAlign_1"><em>�������</em></label></li>
						<li><input type="radio" id="boxAlign_2" name="boxAlign" data-tmp-code="wrapAlign_left" class="inp_radio" /><label for="boxAlign_2"><em>��������</em></label></li>
					</ul>
				</dd>
				<!-- ũ�� ���� : e -->

				<!-- �����޴� ��Ų ���� : s -->
				<dt><button type="button" class="btn_setting">����������</button></dt>
				<dd>
					<div class="flex-box">
						<div class="item-box">
							<input type="radio" id="skin_none" name="skin" data-skin-code="dsc_none" class="inp_radio" checked />
							<label for="skin_none" class="skin-default"><em>������</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_1" name="skin" data-skin-code="dsc_1" class="inp_radio" />
							<label for="skin_1" class="skin-1"><em>��Ų 1��</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_2" name="skin" data-skin-code="dsc_2" class="inp_radio" />
							<label for="skin_2" class="skin-2"><em>��Ų 2��</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_3" name="skin" data-skin-code="dsc_3" class="inp_radio" />
							<label for="skin_3" class="skin-3"><em>��Ų 3��</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_4" name="skin" data-skin-code="dsc_4" class="inp_radio" />
							<label for="skin_4" class="skin-4"><em>��Ų 4��</em></label>
						</div>
						<div class="item-box">
							<input type="radio" id="skin_5" name="skin" data-skin-code="dsc_5" class="inp_radio" />
							<label for="skin_5" class="skin-5"><em>��Ų 5��</em></label>
						</div>
					</div>
				</dd>
				<!-- �����޴� ��Ų ���� : e -->

				<!-- ��ü ��� ���� : s -->
				<dt><button type="button" class="btn_setting">��ü ��� ����</button></dt>
				<dd>
					<ul class="list_type list_type_multi">
						<li><input type="radio" id="bg_none" name="bg" data-color-bg="bg_none" class="inp_radio" checked /><label for="bg_none"><span class="colorSample__none"></span><em class="">����</em></label></li>
						<li><input type="radio" id="bg_1" name="bg" data-color-bg="bg_1" class="inp_radio" /><label for="bg_1"><span class="colorSample bg_1"></span><em class="bgt">��� 2��</em></label></li>
						<li><input type="radio" id="bg_2" name="bg" data-color-bg="bg_2" class="inp_radio" /><label for="bg_2"><span class="colorSample bg_2"></span><em class="bgt">��� 3��</em></label></li>
						<li><input type="radio" id="bg_3" name="bg" data-color-bg="bg_3" class="inp_radio" /><label for="bg_3"><span class="colorSample bg_3"></span><em class="bgt">��� 4��</em></label></li>
						<li><input type="radio" id="bg_4" name="bg" data-color-bg="bg_4" class="inp_radio" /><label for="bg_4"><span class="colorSample bg_4"></span><em class="bgt">��� 5��</em></label></li>
						<li><input type="radio" id="bg_5" name="bg" data-color-bg="bg_5" class="inp_radio" /><label for="bg_5"><span class="colorSample bg_5"></span><em class="bgt">��� 6��</em></label></li>
					</ul>
				</dd>
				<!-- ��ü ��� ���� : e -->

				<dt><button type="button" class="btn_setting">��� ����</button></dt>
				<dd>
					<ul class="list_type list_type_multi">
						<li><input type="radio" id="bgT_none" name="bgT" data-color-bgTop="bgT_none" class="inp_radio" checked /><label for="bgT_none"><span class="colorSample__none"></span><em class="">����</em></label></li>
						<li><input type="radio" id="bgT_1" name="bgT" data-color-bgTop="bgTop_1" class="inp_radio" /><label for="bgT_1"><span class="colorSample bgTop_1"></span><em class="bgt">��� 2��</em></label></li>
						<li><input type="radio" id="bgT_2" name="bgT" data-color-bgTop="bgTop_2" class="inp_radio" /><label for="bgT_2"><span class="colorSample bgTop_2"></span><em class="bgt">��� 3��</em></label></li>
						<li><input type="radio" id="bgT_3" name="bgT" data-color-bgTop="bgTop_3" class="inp_radio" /><label for="bgT_3"><span class="colorSample bgTop_3"></span><em class="bgt">��� 4��</em></label></li>
						<li><input type="radio" id="bgT_4" name="bgT" data-color-bgTop="bgTop_4" class="inp_radio" /><label for="bgT_4"><span class="colorSample bgTop_4"></span><em class="bgt">��� 5��</em></label></li>
						<li><input type="radio" id="bgT_5" name="bgT" data-color-bgTop="bgTop_5" class="inp_radio" /><label for="bgT_5"><span class="colorSample bgTop_5"></span><em class="bgt">��� 6��</em></label></li>
					</ul>
				</dd>
				<dt><button type="button" class="btn_setting">���� ����</button></dt>
				<dd>
					<ul class="list_type list_type_multi">
						<li>
							<input type="radio" id="bgL_none" name="bgL" data-color-left="bgL_none" class="inp_radio" checked /><label for="bgL_none"><span class="colorSample__none"></span><em class="">����</em></label>
						</li>
						<li>
							<input type="radio" id="bgL_1" name="bgL" data-color-left="bgL_1" class="inp_radio" />
							<label for="bgL_1"><span class="colorSample2 bgL_1_s"></span><em class="bgt">���� 2��</em></label>
						</li>
						<li><input type="radio" id="bgL_2" name="bgL" data-color-left="bgL_2" class="inp_radio" /><label for="bgL_2"><span class="colorSample2 bgL_2_s"></span><em class="bgt">���� 3��</em></label></li>
						<li><input type="radio" id="bgL_3" name="bgL" data-color-left="bgL_3" class="inp_radio" /><label for="bgL_3"><span class="colorSample2 bgL_3_s"></span><em class="bgt">���� 4��</em></label></li>
						<li><input type="radio" id="bgL_4" name="bgL" data-color-left="bgL_4" class="inp_radio" /><label for="bgL_4"><span class="colorSample2 bgL_4_s"></span><em class="bgt">���� 5��</em></label></li>
						<li><input type="radio" id="bgL_5" name="bgL" data-color-left="bgL_5" class="inp_radio" /><label for="bgL_5"><span class="colorSample2 bgL_5_s"></span><em class="bgt">���� 6��</em></label></li>
					</ul>
				</dd>
				<dt><button type="button" class="btn_setting">�ֽű� ����</button></dt>
				<dd>
					<div class="choice_box">
						<ul class="choice_list">
							<li>
								<span class="head">1.�ֽñ�����</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
							<li>
								<span class="head">2.�ֽñ�����</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
							<li>
								<span class="head">3.�ֽñ�����</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
							<li>
								<span class="head">4.�ֽñ�����</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
							<li>
								<span class="head">5.�ֽñ�����</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
							<li>
								<span class="head">6.�ֽñ�����</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
						</ul>
						<ul class="choice_list">
							<li>
								<span class="head">Ÿ��Ʋ</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
							<li>
								<span class="head">�Խñ�</span>
								<select id="" name="" class="sel w_remainder">
									<option value="">�⺻</option>
								</select>
							</li>
						</ul>
					</div>
					<ul class="list_type list_type_multi">
						<li>
							<input type="radio" id="latestColor_1_1" name="latestColor" data-color-latest="latest_1_1" class="inp_radio" checked />
							<label for="latestColor_1_1"><span class="ico-rect latestColor_1_1">1��</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_2" name="latestColor" data-color-latest="latest_1_2" class="inp_radio" />
							<label for="latestColor_1_2"><span class="ico-rect latestColor_1_2">2��</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_3" name="latestColor" data-color-latest="latest_2_1" class="inp_radio" />
							<label for="latestColor_1_3"><span class="ico-rect latestColor_1_3">3��</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_4" name="latestColor" data-color-latest="latest_2_2" class="inp_radio" />
							<label for="latestColor_1_4"><span class="ico-rect latestColor_1_4">4��</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_5" name="latestColor" data-color-latest="latest_3_1" class="inp_radio" />
							<label for="latestColor_1_5"><span class="ico-rect latestColor_1_5">5��</span></label>
						</li>
						<li>
							<input type="radio" id="latestColor_1_6" name="latestColor" data-color-latest="latest_3_2" class="inp_radio" />
							<label for="latestColor_1_6"><span class="ico-rect latestColor_1_6">6��</span></label>
						</li>
					</ul>
				</dd>
			</dl>
			<div class="btn_box">
				<button type="button" class="btn btn_s btn_c_n">�ݱ�</button>
				<button type="button" class="btn btn_s btn_c_a">����</button>
				<button type="button" class="btn btn_s">�������</button>
			</div>
		</div>
	</aside>
	</form>
	<!-- �ٹ̱� : e -->

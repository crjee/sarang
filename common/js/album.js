// list
				function MovePage(page, gvTarget) {
					var f = document.search_form;
					f.page.value = page;
					f.target = gvTarget;
					f.action = "/cafe/skin/album_list.asp";
					f.submit();
				}

				function goView(album_seq, gvTarget) {
					var f = document.search_form;
					f.album_seq.value = album_seq;
					f.target = gvTarget;
					f.action = "/cafe/skin/album_view.asp";
					f.submit();
				}

				function goSearch(gvTarget) {
					var f = document.search_form;
					f.page.value = 1;
					f.target = gvTarget;
					f.action = "/cafe/skin/album_list.asp";
					f.submit();
				}

				function RsizeList(img, ww, hh, aL) {
					var tt = imgRsize(img, ww, hh);
					if (img.width > ww || img.height > hh) {

						// ���γ� ����ũ�Ⱑ ����ũ�⺸�� ũ��
						img.width = tt[0];
						// ũ������
						img.height = tt[1];
					}
				}

				function imgRsize(img, rW, rH) {
					var iW = img.width;
					var iH = img.height;
					var g = new Array;
					if (iW < rW && iH < rH) { // ���μ��ΰ� ����� ������ ���� ���
						g[0] = iW;
						g[1] = iH;
					}
					else {
						if (img.width > img.height) { // ��ũ�� ���ΰ� ���κ��� ũ��
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						else if (img.width < img.height) { //��ũ���� ���ΰ� ���κ��� ũ��
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
						else {
							g[0] = rW;
							g[1] = rH;
						}
						if (g[0] > rW) { // ������ ���ΰ��� ��� ���κ��� ũ��
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						if (g[1] > rH) { // ������ ���ΰ��� ��� ���ΰ����κ��� ũ��
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
					}

					g[2] = img.width; // �������� ����
					g[3] = img.height; // �������� ����

					return g;
				}
// write, modify
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
							var f = document.form;
							if (f.temp.value == "Y" && f.subject.value != "")
							{
								oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
								f.action = "album_temp_exec.asp";
								f.temp.value = "N";
								f.target = "hiddenfrm";
								f.submit();
								alert("�ۼ����� ������ �ӽ÷� ����Ǿ����ϴ�.");
							}
						}
					}, //boolean
					fOnAppLoad : function() {
						//���� �ڵ�
						//oEditors.getById["ir1"].exec("PASTE_HTML", ["�ε��� �Ϸ�� �Ŀ� ������ ���ԵǴ� text�Դϴ�."])
					},
					fCreator: "createSEditor2"
				})

				function submitContents(elClickedObj, url, tmp) {
					oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
					try {
						elClickedObj.action = url;
//						elClickedObj.temp.value = tmp;
						elClickedObj.target = "hiddenfrm";
						elClickedObj.submit()
					} catch(e) {alert(e)}
				}

// slide
	g_fPlayMode = 0;
	g_iimg = 0;
	g_imax = 0;
	g_mimg = 1;
	g_ImageTable = new Array();

	function ChangeImage(fFwd) {
		if (fFwd) {
			if (++g_iimg == g_imax)
				g_iimg = 1;
		}
		else {
			if (g_iimg > 1)
				g_iimg--;
		}
		Update();
	}

	function Update() {
		document.all._Ath_Slide.src = g_ImageTable[g_iimg][0];
		if (g_iimg == g_mimg)
		{
			alert("�����̵� ������ �̹��� �Դϴ�.");
			g_fPlayMode = !g_fPlayMode;
			btnPrev.disabled = btnPlay.disabled = btnNext.disabled = false;
		}
	}

	function Play() {
		if (!g_fPlayMode) g_fPlayMode = !g_fPlayMode;
		if (g_fPlayMode)
		{
			btnPrev.disabled = btnPlay.disabled = btnNext.disabled = true;
			Next();
		}
	}

	function Stop() {
		if (g_fPlayMode) g_fPlayMode = !g_fPlayMode;
		btnPrev.disabled = btnPlay.disabled = btnNext.disabled = false;
	}

	function OnImgLoad() {
		if (g_fPlayMode)
		{
			if (g_iimg != g_mimg)
				window.setTimeout("Tick()", g_dwTimeOutSec * 1000);
		}
	}

	function Tick() {
		if (g_fPlayMode)
			Next();
	}

	function Prev() {
		ChangeImage(false);
	}

	function Next() {
		ChangeImage(true);
	}

	function main() {
//		Update();
	}

	function RsizeView(img, ww, hh, aL) {
		var tt = imgRsize(img, ww, hh);
		if (img.width > ww || img.height > hh) {

			// ���γ� ����ũ�Ⱑ ����ũ�⺸�� ũ��
			img.width = tt[0];
			// ũ������
			img.height = tt[1];
			img.alt = "Ŭ���Ͻø� �����̹����� ���Ǽ��ֽ��ϴ�.";

			if (aL) {
				// �ڵ���ũ on
				img.onclick = function() {
					wT = Math.ceil((screen.width - tt[2])/2.6);
					// Ŭ���̾�Ʈ �߾ӿ� �̹�����ġ.
					wL = Math.ceil((screen.height - tt[3])/2.6);
					var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
					var mm = window.open(img.src, "mm");
					var doc = mm.document;
					doc.body.style.margin = 0;
					// ��������
					doc.body.style.cursor = "hand";
					doc.title = "�����̹���";
				}
				img.style.cursor = "hand";
			}
		}
		else {
				img.onclick = function() {
					alert("�����̹����� ���� �̹����Դϴ�.");
				}
		}
	}

// view
					function Rsize(img, ww, hh, aL) {
						var tt = imgRsize(img, ww, hh);
						if (img.width > ww || img.height > hh) {

							// ���γ� ����ũ�Ⱑ ����ũ�⺸�� ũ��
							img.width = tt[0];
							// ũ������
							img.height = tt[1];
							img.alt = "Ŭ���Ͻø� �����̹����� ���Ǽ��ֽ��ϴ�.";

							if (aL) {
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
						else {
								img.onclick = function() {
									alert("�����̹����� ���� �̹����Դϴ�.");
								}
						}
					}

					function goPrint() {
						var initBody;
						window.onbeforeprint = function() {
							initBody = document.body.innerHTML;
							document.body.innerHTML =  document.getElementById('CenterContents').innerHTML;
						};
						window.onafterprint = function() {
							document.body.innerHTML = initBody;
						};
						window.print();
					}

					function goList() {
						document.search_form.action = "/cafe/skin/album_list.asp";
						document.search_form.target = gvTarget;
						document.search_form.submit();
					}

					function goReply() {
						document.search_form.action = "/cafe/skin/album_reply.asp";
						document.search_form.target = gvTarget;
						document.search_form.submit();
					}

					function goModify() {
						document.search_form.action = "/cafe/skin/album_modify.asp";
						document.search_form.target = gvTarget;
						document.search_form.submit();
					}

					function goDelete() {
						document.search_form.action = "/cafe/skin/com_waste_exec.asp";
						document.search_form.target = "hiddenfrm";
						document.search_form.submit();
					}

					function goSuggest() {
						document.search_form.action = "/cafe/skin/com_suggest_exec.asp";
						document.search_form.target = "hiddenfrm";
						document.search_form.submit();
					}

					function goSlide(arr_image, uploadUrl) {
						sl_list = arr_image;
						sl_arr = sl_list.split(":");
						for (var i = 0; i < sl_arr.length; i++) {
							g_ImageTable[g_mimg++] = new Array(uploadUrl + sl_arr[i], "");
						}
						g_imax = g_mimg--;

						g_dwTimeOutSec = 3;

						window.onload = Play;

						Update();
						lyp('lypp_slide');

					}

					function copyUrl() {
						try{
							if (window.clipboardData) {
									window.clipboardData.setData("Text", "<%=pageUrl%>")
									alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
							}
							else if (window.navigator.clipboard) {
									window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
										alert("�ش� ���ּҰ� ���� �Ǿ����ϴ�. Ctrl + v �Ͻø� �ٿ� �ֱⰡ �����մϴ�.");
									});
							}
							else {
								temp = prompt("�ش� ���ּҸ� �����Ͻʽÿ�.", "<%=pageUrl%>");
							}
						} catch(e) {
							alert(e)
						}
					}


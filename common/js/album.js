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

						// 가로나 세로크기가 제한크기보다 크면
						img.width = tt[0];
						// 크기조정
						img.height = tt[1];
					}
				}

				function imgRsize(img, rW, rH) {
					var iW = img.width;
					var iH = img.height;
					var g = new Array;
					if (iW < rW && iH < rH) { // 가로세로가 축소할 값보다 작을 경우
						g[0] = iW;
						g[1] = iH;
					}
					else {
						if (img.width > img.height) { // 원크기 가로가 세로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						else if (img.width < img.height) { //원크기의 세로가 가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
						else {
							g[0] = rW;
							g[1] = rH;
						}
						if (g[0] > rW) { // 구해진 가로값이 축소 가로보다 크면
							g[0] = rW;
							g[1] = Math.ceil(img.height * rW / img.width);
						}
						if (g[1] > rH) { // 구해진 세로값이 축소 세로값가로보다 크면
							g[0] = Math.ceil(img.width * rH / img.height);
							g[1] = rH;
						}
					}

					g[2] = img.width; // 원사이즈 가로
					g[3] = img.height; // 원사이즈 세로

					return g;
				}
// write, modify
				var oEditors = [];

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
							var f = document.form;
							if (f.temp.value == "Y" && f.subject.value != "")
							{
								oEditors.getById["ir1"].exec("UPDATE_CONTENTS_FIELD", [])
								f.action = "album_temp_exec.asp";
								f.temp.value = "N";
								f.target = "hiddenfrm";
								f.submit();
								alert("작성중인 내용이 임시로 저장되었습니다.");
							}
						}
					}, //boolean
					fOnAppLoad : function() {
						//예제 코드
						//oEditors.getById["ir1"].exec("PASTE_HTML", ["로딩이 완료된 후에 본문에 삽입되는 text입니다."])
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
			alert("슬라이드 마지막 이미지 입니다.");
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

			// 가로나 세로크기가 제한크기보다 크면
			img.width = tt[0];
			// 크기조정
			img.height = tt[1];
			img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

			if (aL) {
				// 자동링크 on
				img.onclick = function() {
					wT = Math.ceil((screen.width - tt[2])/2.6);
					// 클라이언트 중앙에 이미지위치.
					wL = Math.ceil((screen.height - tt[3])/2.6);
					var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
					var mm = window.open(img.src, "mm");
					var doc = mm.document;
					doc.body.style.margin = 0;
					// 마진제거
					doc.body.style.cursor = "hand";
					doc.title = "원본이미지";
				}
				img.style.cursor = "hand";
			}
		}
		else {
				img.onclick = function() {
					alert("현재이미지가 원본 이미지입니다.");
				}
		}
	}

// view
					function Rsize(img, ww, hh, aL) {
						var tt = imgRsize(img, ww, hh);
						if (img.width > ww || img.height > hh) {

							// 가로나 세로크기가 제한크기보다 크면
							img.width = tt[0];
							// 크기조정
							img.height = tt[1];
							img.alt = "클릭하시면 원본이미지를 보실수있습니다.";

							if (aL) {
								// 자동링크 on
								img.onclick = function() {
									wT = Math.ceil((screen.width - tt[2])/2.6);
									// 클라이언트 중앙에 이미지위치.
									wL = Math.ceil((screen.height - tt[3])/2.6);
									var mm = window.open(img.src, "mm", 'width='+tt[2]+',height='+tt[3]+',top='+wT+',left='+wL);
									var doc = mm.document;
									try{
										doc.body.style.margin = 0;
										// 마진제거
										doc.body.style.cursor = "hand";
										doc.title = "원본이미지";
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
									alert("현재이미지가 원본 이미지입니다.");
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
									alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
							}
							else if (window.navigator.clipboard) {
									window.navigator.clipboard.writeText("<%=pageUrl%>").then(() => {
										alert("해당 글주소가 복사 되었습니다. Ctrl + v 하시면 붙여 넣기가 가능합니다.");
									});
							}
							else {
								temp = prompt("해당 글주소를 복사하십시오.", "<%=pageUrl%>");
							}
						} catch(e) {
							alert(e)
						}
					}


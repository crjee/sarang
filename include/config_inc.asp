<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
%>
<%
	StartTime=Timer()
	Dim Conn

	Dim user_id
	Dim cafe_id
	Dim menu_seq
	menu_seq = Request("menu_seq")
	Dim menu_type
	Dim menu_name
	Dim editor_yn
	Dim write_auth
	Dim reply_auth
	Dim read_auth
	Dim cafe_mb_level
	Dim cafe_ad_level
	Dim tab_use_yn
	Dim tab_nm
	Dim all_tab_use_yn
	Dim etc_tab_use_yn

	Dim daily_cnt
	Dim write_cnt
	Dim inc_del_yn
	Dim list_info
	Dim uploadform

	'################ Database설정 #################
	Function DBOpen()
		Set Conn = Server.CreateObject("ADODB.Connection")
		Conn.Open Application("db")
	End Function

	Function DBClose()
		Conn.Close()
		Set Conn = Nothing
	End Function

	'################ Upload Component 설정 #################
	'Dext와 사이트갤럭시만 지원하며, 이외의 Upload Component사용시에는 소스를 수정하셔야 합니다.
	'DEXT Upload Component 사용시 : DEXT
	'Site Galaxy 사용시 : SITE

	ConfigComponent = "DEXT"

	'################ 웹사이트 주소 설정 #################
	ConfigURL = "http://" & Request.ServerVariables("HTTP_HOST") & "/"

	'################ 첨부파일이 저장된 URL 설정  #################
	ConfigAttachedFileURL = "http://gisarangbang.krei.co.kr/uploads/"
	ConfigAttachedFileURL = "http://localhost/uploads/" ' crjee 수정
	ConfigAttachedFileURL = ConfigURL & "uploads/"
	ConfigEditorFileURL = ConfigURL & "/smart/uploads/"  ' crjee 수정
	'################ 웹사이트 루트 절대경로 설정 #################
	ConfigPath = Server.MapPath("\") & "\"

	'################ 첨부파일이 저장될 절대경로 설정 (쓰기권한이 설정되어 있어야 합니다) #################
	ConfigAttachedFileFolder = ConfigPath & "uploads\"
	ConfigEditorFileFolder = ConfigPath & "smart\upload\"
	ConfigAttachedFileFolder = "D:\경인네트웍스\dev\uploads\" ' crjee 수정
	ConfigEditorFileFolder = "D:\경인네트웍스\dev\smart\upload\" ' crjee 수정

	'################ 파일업로드를 위한 임시 저장공간 경로 설정(절대경로) #################
	ConfigTempFolder = ConfigAttachedFileFolder & "TEMP\"

	DBopen()

	If Request("cafe_id") <> "" Then
		Session("cafe_id") = Request("cafe_id")
	End If

	If Session("cafe_id") <> "" Then
		cafe_id = Session("cafe_id")
	End If

	If Not(s_pop = "Y" Or freePage) Then
'		Call CheckLogin()
	End If

	If s_pop <> "Y" And cafe_id <> "" Then
		Call CheckCafeMember(cafe_id)
	End If

	cafe_ad_level = Session("cafe_ad_level")

	Sub CheckCafeMember(cafe_id)
		Call CheckLogin()

		If GetUserLevel(cafe_id) = 0 Then
			If isnull(Session("mycafe")) Or Session("mycafe") <> cafe_id Then
				Response.Write "<script>alert('비회원은 접근권한이 없습니다');history.back()</script>"
				Response.End
			Else
				Response.Write "<script>alert('활동정지 회원은 접근권한이 없습니다');history.back()</script>"
				Response.End
			End If
		End If
	End Sub

	Sub CheckLogin()
		If s_pop <> "Y" And Session("user_id") = "" Then
			Response.Write "<script>"
			Response.Write "	if (confirm('로그인 후 이용 가능합니다.\n로그인 페이지로 이동하시겠습니까?')) {"
			Response.Write "		top.location.href = '/login_form.asp';"
			Response.Write "	}"
			Response.Write "	else {"
			Response.Write "		top.location.href='/';"
			Response.Write "	}"
			Response.Write "</script>"
			Response.End
		End If
	End Sub

	Sub CheckMenuSeq(ByVal cafe_id, ByVal menu_seq)
		Set funcRs = server.createobject("adodb.recordset")
		fnSql = ""
		fnSql = fnSql & " select * "
		fnSql = fnSql & "       ,isnull(daily_cnt,9999) as daily_cnt "
		fnSql = fnSql & "   from cf_menu "
		fnSql = fnSql & "  where menu_seq = '" & menu_seq & "' "
		fnSql = fnSql & "    and cafe_id  = '" & cafe_id  & "' "
		funcRs.Open fnSql, Conn, 3, 1

		If funcRs.Eof Then
			Response.write "CheckMenuSeq<br>" & fnSql
			msggo "정상적인 사용이 아닙니다.(No seq)",""
		Else
			menu_type      = funcRs("menu_type")
			menu_name      = funcRs("menu_name")
			editor_yn      = funcRs("editor_yn")
			write_auth     = funcRs("write_auth")
			reply_auth     = funcRs("reply_auth")
			read_auth      = funcRs("read_auth")
			daily_cnt      = funcRs("daily_cnt")
			inc_del_yn     = funcRs("inc_del_yn")
			list_info      = funcRs("list_info")
			tab_use_yn     = funcRs("tab_use_yn")
			tab_nm         = funcRs("tab_nm")
			all_tab_use_yn = funcRs("all_tab_use_yn")
			etc_tab_use_yn = funcRs("etc_tab_use_yn")
		End If
		funcRs.close
		Set funcRs = Nothing
	End Sub

	Sub CheckDataExist(ByVal com_seq)
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select * "
		fnSql = fnSql & "   from " & tb_prefix & "_" & menu_type & " "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		funcRs.Open fnSql, conn, 3, 1

		If funcRs.eof Then
			msggo "정상적인 사용이 아닙니다.(No data)",""
		Else
			user_id = funcRs("user_id")
		End If
		funcRs.close
		Set funcRs = Nothing
	End Sub

	Sub CheckWasteExist(ByVal com_seq)
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select * "
		fnSql = fnSql & "   from " & tb_prefix & "_waste_" & menu_type & " "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		funcRs.Open fnSql, conn, 3, 1

		If funcRs.eof Then
			msggo "정상적인 사용이 아닙니다.(No data)",""
		Else
			user_id = funcRs("user_id")
		End If
		funcRs.close
		Set funcRs = Nothing
	End Sub

	Sub CheckReadAuth(ByVal cafe_id)
		cafe_mb_level = GetUserLevel(cafe_id)
		read_auth = GetOneValue("read_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If read_auth <> "-1" Then
			Call CheckLogin()

			If GetToInt(read_auth) > GetToInt(cafe_mb_level) Then
				msggo "읽기 권한이 없습니다.(No authority)",""
			End If
		End If
	End Sub
	
	Sub CheckWriteAuth(ByVal cafe_id)
		cafe_mb_level = GetUserLevel(cafe_id)
		write_auth = GetOneValue("write_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If write_auth <> "-1" Then
			Call CheckLogin()

			If GetToInt(write_auth) > GetToInt(cafe_mb_level) Then
				msggo "등록 권한이 없습니다.(No authority)",""
			End If
		End If
	End Sub
	
	Sub CheckModifyAuth(ByVal cafe_id)
		cafe_mb_level = GetUserLevel(cafe_id)
		write_auth = GetOneValue("write_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If write_auth <> "-1" Then
			Call CheckLogin()

			If GetToInt(cafe_mb_level) < 10 And session("user_id") <> user_id then
				msggo "수정 권한이 없습니다.(No authority)",""
			End If
		End If
	End Sub
	
	Sub CheckReplyAuth(ByVal cafe_id)
		cafe_mb_level = GetUserLevel(cafe_id)
		reply_auth = GetOneValue("reply_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If reply_auth <> "-1" Then
			Call CheckLogin()

			If GetToInt(reply_auth) > GetToInt(cafe_mb_level) Then
				msggo "답글 권한이 없습니다.(No authority)",""
			End If
		End If
	End Sub
	
	Sub CheckDailyCount(ByVal cafe_id)
		Set funcRs = server.createobject("adodb.recordset")

		If daily_cnt < "9999" Then
			If inc_del_yn = "N" Then
				fnSql = ""
				fnSql = fnSql & " select count(menu_seq) as write_cnt                      "
				fnSql = fnSql & "   from " & tb_prefix & "_" & menu_type & "               "
				fnSql = fnSql & "  where menu_seq = '"& Request("menu_seq")           & "' "
				fnSql = fnSql & "    and cafe_id  = '"& cafe_id                       & "' "
				fnSql = fnSql & "    and agency   = '"& session("agency")             & "' "
				fnSql = fnSql & "    and convert(varchar(10), credt, 120) = '" & Date & "' "
				fnRs.Open fnSql, conn, 3, 1
				write_cnt = fnRs("write_cnt")
				fnRs.close
			Else
				fnSql = ""
				fnSql = fnSql & " select count(wl.menu_seq) as write_cnt                      "
				fnSql = fnSql & "   from cf_write_log wl                                      "
				fnSql = fnSql & "   left join cf_member cm on cm.user_id = wl.user_id         "
				fnSql = fnSql & "  where wl.menu_seq = '"& Request("menu_seq")           & "' "
				fnSql = fnSql & "    and wl.cafe_id  = '"& cafe_id                       & "' "
				fnSql = fnSql & "    and cm.agency   = '"& session("agency")             & "' "
				fnSql = fnSql & "    and convert(varchar(10), wl.credt, 120) = '" & Date & "' "
				fnRs.Open fnSql, conn, 3, 1
				write_cnt = fnRs("write_cnt")
				fnRs.close
			End If

			If CInt(write_cnt) >= CInt(daily_cnt) Then
				Response.Write "<script>alert('1일 등록 갯수 " & daily_cnt & "개를 초과 하였습니다');history.back()</script>"
				Response.End
			End If
		End If

		Set funcRs = Nothing
	End Sub

	Sub CheckManager(cafe_id)
		Call CheckLogin()

		cafe_mb_level = GetUserLevel(cafe_id)
		If cafe_mb_level = "" Or cafe_mb_level < 10 Then
			Response.Write "<script>alert('접근권한이 없습니다(" & cafe_mb_level & ").');history.back();</script>"
			Response.End
		End If
	End Sub

	Sub checkAdmin()
		Call CheckLogin()

		If Session("cafe_ad_level") = "" Or Session("cafe_ad_level") < 10 Then
			Response.Write "<script>alert('접근권한이 없습니다.');history.back();</script>"
			Response.End
		End If
	End Sub

	Sub CheckMemoSendAuth(ByVal cafe_id)
		Call CheckLogin()

		cafe_mb_level = GetUserLevel(cafe_id)
		If cafe_mb_level < 2 Then
			Response.Write "<script>alert('쪽지를 보내려면 정회원부터 가능합니다');history.back();</script>"
			Response.End
		End If
	End Sub

	Sub SetViewCnt(ByVal menu_type, ByVal com_seq)
		chkDup = GetComSeqCookieYN(menu_type, com_seq)
		If chkDup = "N" Then
			fnSql = ""
			fnSql = fnSql & " update " & tb_prefix & "_" & menu_type & " "
			fnSql = fnSql & "    set view_cnt = isnull(view_cnt,0) + 1 "
			fnSql = fnSql & "       ,modid = '" & Session("user_id") & "' "
			fnSql = fnSql & "       ,moddt = getdate() "
			fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq & "' "
			Conn.Execute(fnSql)
		End If
	End Sub

	Sub CheckMultipart()
		If InStr(1, Request.ServerVariables("HTTP_CONTENT_TYPE"), "multipart/form-data") = 0 then
			msgend "정상적인 사용이 아닙니다.(No Multipart)"
		End If
	End Sub

'/*----------------------------------------------------------------*/
'/*----- 실행시간표시
'/*----------------------------------------------------------------*/
	Sub extime(msg)
		response.write msg  & " : " & FormatNumber(Timer()-StartTime,5) & " (초)<br>"
	End Sub

	Function GetUserLevel(cafe_id)
		cafe_mb_level = -1

		If Session("cafe_ad_level") = 10 Then
			cafe_mb_level = 10
		Else
			Set fnRs = server.createobject("adodb.recordset")
			fnSql = ""
			fnSql = fnSql & " select cafe_mb_level                          "
			fnSql = fnSql & "   from cf_cafe_member                         "
			fnSql = fnSql & "  where cafe_id = '" & cafe_id & "'            "
			fnSql = fnSql & "    and user_id = '" & session("user_id") & "' "
			fnRs.Open fnSql, Conn, 1

			If Not fnRs.eof Then ' 내 사랑방
				cafe_mb_level = fnRs("cafe_mb_level")
				fnRs.close
			Else
				fnRs.close

				fnSql = ""
				fnSql = fnSql & " select cm.cafe_mb_level "
				fnSql = fnSql & "       ,um.union_mb_level "
				fnSql = fnSql & "   from cf_cafe cf "
				fnSql = fnSql & "  inner join cf_cafe_member cm on cm.cafe_id = cf.cafe_id "
				fnSql = fnSql & "   left outer join cf_union_manager um on um.union_id = cf.union_id and um.user_id = cm.user_id "
				fnSql = fnSql & "  where cf.union_id = '" & cafe_id & "' "
				fnSql = fnSql & "    and cm.user_id = '" & session("user_id") & "' "
				fnSql = fnSql & "    and cm.stat = 'Y' "
				fnRs.Open fnSql, Conn, 1

				If Not fnRs.eof Then ' 내 연합회
					cafe_mb_level = fnRs("cafe_mb_level")
					union_mb_level = fnRs("union_mb_level")

					If isnull(union_mb_level) Then union_mb_level = ""
					If GetToInt(cafe_mb_level) < GetToInt(union_mb_level) Then cafe_mb_level = union_mb_level
				End If

				fnRs.close
			End If
			Set fnRs = Nothing
		End If
		GetUserLevel = GetToInt(cafe_mb_level)
	End Function

	Function GetComSeq(seq_name)
		fnSql = ""
		fnSql = fnSql & "  merge into cf_seq tbl "
		fnSql = fnSql & "  using (select '" & seq_name & "' as col) src "
		fnSql = fnSql & "     on (tbl.seq_name = src.col) "
		fnSql = fnSql & "   when matched Then "
		fnSql = fnSql & " update Set seq_value = isnull(seq_value,0) + 1 "
		fnSql = fnSql & "           ,modid = '" & Session("user_id")  & "' "
		fnSql = fnSql & "           ,moddt = getdate() "
		fnSql = fnSql & "   when not matched Then "
		fnSql = fnSql & " insert (seq_name "
		fnSql = fnSql & "        ,seq_value "
		fnSql = fnSql & "        ,creid "
		fnSql = fnSql & "        ,credt "
		fnSql = fnSql & "        )   "
		fnSql = fnSql & " values ('" & seq_name  & "' "
		fnSql = fnSql & "        ,1 "
		fnSql = fnSql & "        ,'" & Session("user_id")  & "' "
		fnSql = fnSql & "        ,getdate() "
		fnSql = fnSql & "        ); "

		Conn.execute fnSql

		GetComSeq = GetOneValue("seq_value","cf_seq","where seq_name = '" & seq_name & "'")
	End Function

	Function GetComNum(ByVal menu_type, ByVal cafe_id, ByVal menu_seq)
		GetComNum = GetOneValue("isnull(max(" & menu_type & "_num)+1,1)","" & tb_prefix & "_" & menu_type,"where cafe_id = '" & cafe_id & "' and menu_seq = '" & menu_seq & "'")
	End Function

	Function GetComSeqCookieYN(ByVal menu_type, ByVal com_seq)
		dim dupChk
		dim readCookies
		dim i
		dupChk = "N"

		readCookies = Request.Cookies("menu_type")

		Response.Cookies("menu_type") = menu_type
		Response.Cookies("menu_type").Path = "/"
		Response.Cookies("menu_type").Expires = Date + 1
		arrRead = split(readCookies, ",")
		For i = 1 To UBound(arrRead)
			If Not (com_seq = "" Or Trim(arrRead(i)) = "") Then
'msgonly com_seq & " = " & Trim(arrRead(i))
				If (com_seq) = (Trim(arrRead(i))) Then
					dupChk = "Y"
				End If
			End If
		Next

		If dupChk = True Then
			Response.Cookies("menu_type") = readCookies
		Else
			Response.Cookies("menu_type") = readCookies & "," & com_seq
		End If
		GetComSeqCookieYN = dupChk
	End Function

	Function GetImgMimeTypeYN(MimeType)
		Set funcRs = server.createobject("adodb.recordset")
		fnSql = ""
		fnSql = fnSql & " select cmn_cd                                          "
		fnSql = fnSql & "       ,cd_nm                                           "
		fnSql = fnSql & "   from cf_code                                         "
		fnSql = fnSql & "  where up_cd_id = (select cd_id                        "
		fnSql = fnSql & "                      from cf_code                      "
		fnSql = fnSql & "                     where up_cd_id = 'CD0000000000'    "
		fnSql = fnSql & "                       and cmn_cd = 'img_file_extn_cd'  "
		fnSql = fnSql & "                   )                                    "
		fnSql = fnSql & "    and cd_expl like '%" & MimeType & "%'               "
		funcRs.Open fnSql, Conn, 1

		ok = "Y"
		If funcRs.eof Then
			ok = "N"
		End If
		funcRs.close

		GetImgMimeTypeYN = ok
	End Function

	Function GetDataMimeTypeYN(MimeType)
		Set funcRs = server.createobject("adodb.recordset")
		fnSql = ""
		fnSql = fnSql & " select cmn_cd                                          "
		fnSql = fnSql & "       ,cd_nm                                           "
		fnSql = fnSql & "   from cf_code                                         "
		fnSql = fnSql & "  where up_cd_id = (select cd_id                        "
		fnSql = fnSql & "                      from cf_code                      "
		fnSql = fnSql & "                     where up_cd_id = 'CD0000000000'    "
		fnSql = fnSql & "                       and cmn_cd = 'data_file_extn_cd' "
		fnSql = fnSql & "                   )                                    "
		fnSql = fnSql & "    and cd_expl like '%" & MimeType & "%'               "
		funcRs.Open fnSql, Conn, 1

		ok = "Y"
		If funcRs.eof Then
			ok = "N"
		End If
		funcRs.close

		GetDataMimeTypeYN = ok
	End Function

	Function GetPageUrl(ByVal menu_type, ByVal menu_seq, ByVal com_seq)
		httpHost = request.servervariables("HTTP_HOST")
		httpUrl  = request.servervariables("HTTP_URL")

		If InStr(httpUrl, "?") Then
			httpUrl = Left(httpUrl, InStr(httpUrl, "?") - 1)
		End If

		GetPageUrl = "http://" & httpHost & httpUrl & "?menu_seq=" & menu_seq & "&" & menu_type & "_seq=" & com_seq
	End Function

	Function GetToInt(str)
		If isnull(str) Or isempty(str) Or Trim(str) = "" Then
			GetToInt = 0
		Else
			GetToInt = CInt(str)
		End If
	End Function
'/*----------------------------------------------------------------*/
'/*----- 코드관리가 되는것들의 콤보박스 생성
'/*----------------------------------------------------------------*/

	Function GetCodeName(ByVal cmn, ByVal cd)
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select cmn_cd                                           "
		fnSql = fnSql & "       ,cd_nm                                            "
		fnSql = fnSql & "   from cf_code                                          "
		fnSql = fnSql & "  where up_cd_id = (select cd_id                         "
		fnSql = fnSql & "                          from cf_code                   "
		fnSql = fnSql & "                         where up_cd_id = 'CD0000000000' "
		fnSql = fnSql & "                           and cmn_cd = '" & cmn & "'    "
		fnSql = fnSql & "                           and del_yn = 'N'              "
		fnSql = fnSql & "                           and use_yn = 'Y'              "
		fnSql = fnSql & "                       )                                 "
		fnSql = fnSql & "    and cmn_cd = '" & cd & "'                            "
		fnSql = fnSql & "    and del_yn = 'N'                                     "
		fnSql = fnSql & "    and use_yn = 'Y'                                     "
		fnSql = fnSql & "  order by cd_sn                                         "
		funcRs.Open fnSql, Conn, 1

		If Not funcRs.eof Then
			cmn_cd = funcRs("cmn_cd")
			cd_nm  = funcRs("cd_nm")
		End If
		funcRs.close

		GetCodeName = cd_nm
	End Function

	Function GetMakeCDCombo(ByVal cmn, ByVal sel)
		Dim fnSql
		Dim funcRs
		Dim strCombo
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select cmn_cd                                           "
		fnSql = fnSql & "       ,cd_nm                                            "
		fnSql = fnSql & "   from cf_code                                          "
		fnSql = fnSql & "  where up_cd_id = (select cd_id                         "
		fnSql = fnSql & "                          from cf_code                   "
		fnSql = fnSql & "                         where up_cd_id = 'CD0000000000' "
		fnSql = fnSql & "                           and cmn_cd = '" & cmn & "'    "
		fnSql = fnSql & "                           and del_yn = 'N'              "
		fnSql = fnSql & "                           and use_yn = 'Y'              "
		fnSql = fnSql & "                       )                                 "
		fnSql = fnSql & "    and del_yn = 'N'                                     "
		fnSql = fnSql & "    and use_yn = 'Y'                                     "
		fnSql = fnSql & "  order by cd_sn                                         "
		funcRs.Open fnSql, Conn, 1

		strCombo = vbCrLf

		Do Until funcRs.eof
			cmn_cd = funcRs("cmn_cd")
			cd_nm  = funcRs("cd_nm")

			strCombo = strCombo & "									"
			strCombo = strCombo & "<option value='" & cmn_cd & "' " & if3(cmn_cd=cstr(sel), "selected", "") & ">" & cd_nm & "</option>" & vbCrLf

			funcRs.Movenext
		Loop

		funcRs.close

		GetMakeCDCombo = strCombo
	End Function

	Function GetMakeCDRadio(ByVal cmn, ByVal sel, ByVal req)
		Dim fnSql
		Dim funcRs
		Dim strRadio
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select cmn_cd                                           "
		fnSql = fnSql & "       ,cd_nm                                            "
		fnSql = fnSql & "   from cf_code                                          "
		fnSql = fnSql & "  where up_cd_id = (select cd_id                         "
		fnSql = fnSql & "                          from cf_code                   "
		fnSql = fnSql & "                         where up_cd_id = 'CD0000000000' "
		fnSql = fnSql & "                           and cmn_cd = '" & cmn & "'    "
		fnSql = fnSql & "                           and del_yn = 'N'              "
		fnSql = fnSql & "                           and use_yn = 'Y'              "
		fnSql = fnSql & "                   )                                     "
		fnSql = fnSql & "    and del_yn = 'N'                                     "
		fnSql = fnSql & "    and use_yn = 'Y'                                     "
		fnSql = fnSql & "  order by cd_sn                                         "
		funcRs.Open fnSql, Conn, 1

		strRadio = vbCrLf

		i = 1
		Do Until funcRs.eof
			cmn_cd = funcRs("cmn_cd")
			cd_nm  = funcRs("cd_nm")

			strRadio = strRadio & "									"
			strRadio = strRadio & "<span class=''>" & vbCrLf
			strRadio = strRadio & "										"
			strRadio = strRadio & "<input type='radio' id='" & cmn & "_" & cmn_cd & "' name='" & cmn & "' value='" & cmn_cd & "' class='inp_radio' " & if3(cmn_cd=cstr(sel), "checked ", "") & if3(req<>"" And i=1, " required", "") & "/>" & vbCrLf
			strRadio = strRadio & "										"
			strRadio = strRadio & "<label for='" & cmn & "_" & cmn_cd & "'><em>" & cd_nm & "</em></label>" & vbCrLf
			strRadio = strRadio & "									"
			strRadio = strRadio & "</span>" & vbCrLf

			i = i + 1
			funcRs.Movenext
		Loop

		funcRs.close

		GetMakeCDRadio = strRadio
	End Function

	Function GetMakeCDCheckBox(ByVal cmn, ByVal sel, ByVal req, ByVal tIdx)
		Dim fnSql
		Dim funcRs
		Dim strCheckBox
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select cmn_cd                                           "
		fnSql = fnSql & "       ,cd_nm                                            "
		fnSql = fnSql & "   from cf_code                                          "
		fnSql = fnSql & "  where up_cd_id = (select cd_id                         "
		fnSql = fnSql & "                          from cf_code                   "
		fnSql = fnSql & "                         where up_cd_id = 'CD0000000000' "
		fnSql = fnSql & "                           and cmn_cd = '" & cmn & "'    "
		fnSql = fnSql & "                           and del_yn = 'N'              "
		fnSql = fnSql & "                           and use_yn = 'Y'              "
		fnSql = fnSql & "                   )                                     "
		fnSql = fnSql & "    and del_yn = 'N'                                     "
		fnSql = fnSql & "    and use_yn = 'Y'                                     "
		fnSql = fnSql & "  order by cd_sn                                         "
		funcRs.Open fnSql, Conn, 1

		strCheckBox = vbCrLf

		Do Until funcRs.eof
			cmn_cd = funcRs("cmn_cd")
			cd_nm  = funcRs("cd_nm")

			strCheckBox = strCheckBox & "									"
			strCheckBox = strCheckBox & "<span class=''>" & vbCrLf
			strCheckBox = strCheckBox & "										"
			strCheckBox = strCheckBox & "<input type='checkbox' id='" & cmn & "_" & cmn_cd & "' name='" & cmn & "' value='" & cmn_cd & "' class='inp_check' " & if3(instr(cstr(sel), cmn_cd) > 0, " checked", "") & if3(req="", "", " required") & if3(tIdx="", "", " tabidex='" & tIdx & "'") & "/>" & vbCrLf
			strCheckBox = strCheckBox & "										"
			strCheckBox = strCheckBox & "<label for='" & cmn & "_" & cmn_cd & "'><em>" & cd_nm & "</em></label>" & vbCrLf
			strCheckBox = strCheckBox & "									"
			strCheckBox = strCheckBox & "</span>" & vbCrLf

			funcRs.Movenext
		Loop

		funcRs.close

		GetMakeCDCheckBox = strCheckBox
	End Function

	Function GetMakeSectionTag(ByVal tag, ByVal snm, ByVal sel, ByVal req)
		Dim fnSql
		Dim funcRs
		Dim strRadio
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = ""
		fnSql = fnSql & " select section_seq                   "
		fnSql = fnSql & "       ,section_nm                    "
		fnSql = fnSql & "       ,section_sn                    "
		fnSql = fnSql & "   from cf_menu_section               "
		fnSql = fnSql & "  where menu_seq = '" & menu_seq & "' "
		fnSql = fnSql & "    and use_yn = 'Y'                  "
		fnSql = fnSql & "  order by section_sn                 "
		funcRs.open fnSql, conn, 3, 1

		strSection = vbCrLf

		Do Until funcRs.eof
			section_seq = funcRs("section_seq")
			section_nm  = funcRs("section_nm")
			section_sn  = funcRs("section_sn")

			Select Case tag
			Case "R"
				strSection = strSection & "									"
				strSection = strSection & "<span class=''>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<input type='radio' id='section_sn_" & section_sn & "' name='" & snm & "' value='" & section_seq & "' class='inp_radio' " & if3(CStr(section_seq)=CStr(sel), "checked ", "") & if3(req="", "", " required") & "/>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<label for='section_sn_" & section_sn & "'><em>" & section_nm & "</em></label>" & vbCrLf
				strSection = strSection & "									"
				strSection = strSection & "</span>" & vbCrLf
			Case "S"
				strSection = strSection & "									"
				strSection = strSection & "<option value='" & section_seq & "' " & if3(CStr(section_seq)=CStr(sel), "selected", "") & ">" & section_nm & "</option>" & vbCrLf
			Case "C"
				strSection = strSection & "									"
				strSection = strSection & "<span class=''>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<input type='checkbox' id='section_sn_" & section_sn & "' name='" & snm & "' value='" & section_seq & "' class='inp_check' " & if3(InStr(CStr(sel), CStr(section_seq)) > 0, " checked", "") & if3(req="", "", " required") & if3(tIdx="", "", " tabidex='" & tIdx & "'") & "/>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<label for='section_sn_" & section_sn & "'><em>" & section_nm & "</em></label>" & vbCrLf
				strSection = strSection & "									"
				strSection = strSection & "</span>" & vbCrLf
			Case "V"
			End Select

			funcRs.Movenext
		Loop

		funcRs.close

		GetMakeSectionTag = strSection
	End Function

	Function makeCombo(field1,field2,opt,table,refstr,sovalue)
		Dim fnSql
		Dim funcRs
		Dim strCombo
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		fnSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open fnSql, Conn, 1

		strCombo = vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = funcRs(1)
			If isnull(sovalue) Then sovalue = ""
			If cstr(a) = cstr(sovalue) Then
				If opt <> "" Then a = funcRs(2)
			strCombo = strCombo & "						<option value='" &a& "' selected>" &b& "</option>" &vbCrLf
			Else
				If opt <> "" Then a = funcRs(2)
			strCombo = strCombo & "						<option value='" &a& "'>" &b& "</option>" &vbCrLf
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeCombo = strCombo
	End Function

	Function makeFont(inFont)
		strFont ="굴림,궁서,돋움,바탕,새굴림,휴먼둥근헤드라인,휴먼매직체,휴먼모음T,휴먼아미,휴먼엑스포,휴먼옛체,휴먼편지,HY견고딕,HY견명조,HY궁서B,HY그래픽M,HY목각파임B,HY신명조,HY얕은샘물M,HY엽서M,HY중고딕,HY헤드라인"

		arrFont = Split(strFont, ",")

		strCombo = strCombo & "<option></option>" &vbCrLf
		For i = 1 To ubound(arrFont)
			If cstr(inFont) = cstr(arrFont(i)) Then
			strCombo = strCombo & "<option value='" &arrFont(i)& "' selected>" &arrFont(i)& "</option>" &vbCrLf
			Else
			strCombo = strCombo & "<option value='" &arrFont(i)& "'>" &arrFont(i)& "</option>" &vbCrLf
			End If
		Next

		makeFont = strCombo
	End Function

'/*----------------------------------------------------------------*/
'/*----- 코드관리가 되는것들의 라디오버튼 생성
'/*----------------------------------------------------------------*/
	Function makeRadio(func,tagname,cndt,tagtitle,field1,field2,opt,table,refstr,sovalue,read)
		Dim fnSql
		Dim funcRs
		Dim strRadio
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		fnSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open fnSql, Conn, 1
		strRadio = vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = trim(funcRs(1))
			If isnull(sovalue) Then sovalue = ""
			If cstr(a) = cstr(sovalue) Then
				If func = "" Then
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked " & read & ">" &b& " & nbsp;" &vbCrLf
				Else
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked onclick=""" & func & """ " & read & ">" &b& " & nbsp;" &vbCrLf
				End If
			Else
				If func = "" Then
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' " & read & ">" &b& " & nbsp;" &vbCrLf
				Else
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' onclick=""" & func & """ " & read & ">" &b& " & nbsp;" &vbCrLf
				End If
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeRadio = strRadio
	End Function

'/*----------------------------------------------------------------*/
'/*----- 코드관리가 되는것들의 체크박스 생성
'/*----------------------------------------------------------------*/
	Function makeCheckBox(width,func,tagname,cndt,tagtitle,field1,field2,opt,table,refstr,sovalue)
		Dim fnSql
		Dim funcRs
		Dim strCheckBox
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		fnSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open fnSql, Conn, 1
		strCheckBox = vbCrLf

'		strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='CheckBox' value='checkbox' name='allchk' title='" & tagtitle & "' style='border-color:#F2F2F2;'  onclick=""allChk('" & tagname & "',this.checked)"">전체&nbsp;</span>" &vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = funcRs(1)
			If isnull(sovalue) Then sovalue = ""
			If instr(sovalue, a) > 0 Then
				If func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			Else
				If func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;'>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeCheckBox = strCheckBox
	End Function
	Function makeCheckBox2(width,func,tagname,cndt,tagtitle,field1,field2,opt,table,refstr,sovalue)
		Dim fnSql
		Dim funcRs
		Dim strCheckBox
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		fnSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open fnSql, Conn, 1
		strCheckBox = vbCrLf

'		strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='CheckBox' value='checkbox' name='allchk' title='" & tagtitle & "' style='border-color:#F2F2F2;'  onclick=""allChk('" & tagname & "',this.checked)"">전체&nbsp;</span>" &vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = funcRs(1)
			If isnull(sovalue) Then sovalue = "0"
			If IsAuth(sovalue, 2 ^ a) Then
				If func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			Else
				If func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;'>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeCheckBox2 = strCheckBox
	End Function
'/*-------------------------------------------------------------*/
'/*----- Request 값들
'/*-------------------------------------------------------------*/
	Sub GetRequest()
		response.write "<hr>"
		response.write "넘어온 쿼리 콜렉션 값"
		response.write "<hr>"

		For Each item In request.querystring
			For i = 1 To request.querystring(item).count
				response.write "<br>"
				response.write item & " = " & request.querystring(item)(i)
			Next
		Next
		response.write "<hr>"
		response.write "넘어온 폼 콜렉션 값"
		response.write "<hr>"

		For Each item In request.form
			For i = 1 To request.form(item).count
				response.write "<br>"
				response.write item & "=" & request.form(item)(i)
			Next
		Next
	End Sub

	Sub fReval()
		response.write "<hr>"
		response.write "넘어온 쿼리 콜렉션 값"
		response.write "<hr>"

		For Each item In request.querystring
			For i = 1 To request.querystring(item).count
				response.write "<br>"
				response.write item & " = " & request.querystring(item)(i)
			Next
		Next
		response.write "<hr>"
		response.write "넘어온 폼 콜렉션 값"
		response.write "<hr>"

		For Each item In uploadform
			For i = 1 To uploadform(item).count
				response.write "<br>"
				response.write item & "=" & uploadform(item)(i)
			Next
		Next
	End Sub


'/*-------------------------------------------------------------*/
'/*-----	한 데이타 가져오기
'/*-------------------------------------------------------------*/
	Function GetOneValue(field,table,refstr)
		Dim fnSql
		Dim funcRs

		Set funcRs = server.createobject("adodb.recordset")
		fnSql = "select " & field & " from " & table & " " & refstr
		funcRs.open fnSql, conn, 1, 1

		If funcRs.eof Then
			GetOneValue = ""
		Else
			GetOneValue = Trim(funcRs(0))
			If isnull(GetOneValue) Then GetOneValue = ""
		End If
		funcRs.close
	End Function
'/*-------------------------------------------------------------*/
'/*-----	메시지 보이기
'/*-------------------------------------------------------------*/
	Sub MsgOnly(str)
		Response.write "<script LANGUAGE=JAVAscript>" & vbcrlf
		Response.write "alert(""\n" & str  & """)" & vbcrlf
		Response.write "</script>" & vbcrlf
	End Sub
	Sub MsgEnd(str)
		Response.write "<script LANGUAGE=JAVAscript>" & vbcrlf
		Response.write "alert(""\n" & str  & """)" & vbcrlf
		Response.write "</script>" & vbcrlf
		Response.End
	End Sub
	Sub MsgGo(str,url)
		Response.write "<script LANGUAGE=JAVAscript>" & vbcrlf
		If str <> "" Then
		Response.write "alert(""\n" & str  & """)" & vbcrlf
		End If
		If url = "" Then
			Response.write "history.back(-1);" & vbcrlf
		elseif url = "close" Then
			Response.write "self.close();" & vbcrlf
		elseif url = "reload" Then
			Response.write "self.reload()" & vbcrlf
		elseif url = "preload" Then
			Response.write "parent.location.reload();" & vbcrlf
		Else
			Response.write "location.href=""" & url & """;" & vbcrlf
		End If
		Response.write "</script>" & vbcrlf
		Response.End
	End Sub

'/*-------------------------------------------------------------*/
'/*-----	숫자를 임의의 자릿수로 0 추가해서 출력
'/*-------------------------------------------------------------*/
	Function numc(val, c_len)
		Dim i, temp, t_len

		If val <> "" Then temp = cstr(val)
		t_len = len(temp)
		If c_len > t_len Then
			For i = 1 To (c_len - t_len)
				temp = "0" & temp
			Next
		End If
		numc = CStr(temp)
	End Function

	Function if3(var, tvalue, fvalue)
		If (var = true) Then
			if3 = tvalue
		Else
			if3 = fvalue
		End If
	End Function

	Function rmid(val, c_len, a_str)
		If val <> "" Then temp = cstr(val)

		If len(temp) > c_len Then
			rmid = mid(temp, 1, c_len) & a_str
		Else
			rmid = temp
		End If
	End Function

	'지정길이로 랜덤 숫자 만들기 (최대 15자리)
	Function getRndNum(ByVal rLen)
		If rLen > 15 Then rLen = 15

		Dim idx, rndSeed, rndSeed2
		rndSeed = ""
		rndSeed2 = "1"

		For idx = 1 To rLen
			rndSeed = rndSeed  & "1"
			rndSeed2 = rndSeed2  & "0"
		Next

		rndSeed = Int(rndSeed)
		rndSeed2 = Int(rndSeed2)

		Randomize
		getRndNum = Int(Rnd(rndSeed)*rndSeed2)
	End Function

	'지정길이로 랜덤 문자 만들기
	Function getRndStr(rLen)
		Dim rtnStr

		Randomize
		For idx = 1 To rLen
			rtnStr = rtnStr & Chr(Int(2*Rnd)*32 + Int((90-65+1)*Rnd + 65))
		Next

		getRndStr = rtnStr
	End Function

	Dim arr_comment_seq()
	Dim arr_seq()
	Sub ExecDeleteComment(menu_type, com_seq)
		Set funcRs = server.createobject("adodb.recordset")

		' 모든 댓글 조회
		fnSql = ""
		fnSql = fnSql & " with tree_query  as (                                                                                                            "
		fnSql = fnSql & "   select                                                                                                                         "
		fnSql = fnSql & "          comment_seq                                                                                                                     "
		fnSql = fnSql & "        , parent_seq                                                                                                              "
		fnSql = fnSql & "        , comment                                                                                                                 "
		fnSql = fnSql & "        , convert(varchar(255), comment_seq) sort                                                                                         "
		fnSql = fnSql & "        , convert(varchar(2000), comment) depth_fullname                                                                          "
		fnSql = fnSql & "     from " & tb_prefix & "_" & menu_type & "_comment                                                                                                        "
		fnSql = fnSql & "     where comment_seq = " & com_seq & "                                                                                                          "
		fnSql = fnSql & "     union all                                                                                                                    "
		fnSql = fnSql & "     select                                                                                                                       "
		fnSql = fnSql & "           b.comment_seq                                                                                                                  "
		fnSql = fnSql & "         , b.parent_seq                                                                                                           "
		fnSql = fnSql & "         , b.comment                                                                                                              "
		fnSql = fnSql & "         , convert(varchar(255), convert(nvarchar,c.sort) + ' > ' +  convert(varchar(255), b.comment_seq)) sort                           "
		fnSql = fnSql & "         , convert(varchar(2000), convert(nvarchar,c.depth_fullname) + ' > ' +  convert(varchar(2000), b.comment)) depth_fullname "
		fnSql = fnSql & "     from  " & tb_prefix & "_" & menu_type & "_comment b, tree_query c                                                                               "
		fnSql = fnSql & "     where b.parent_seq = c.comment_seq                                                                                                   "
		fnSql = fnSql & " )                                                                                                                                "
		fnSql = fnSql & " select *                                                                                                                         "
		fnSql = fnSql & "   from " & tb_prefix & "_" & menu_type & "_comment                                                                                                  "
		fnSql = fnSql & "  where comment_seq In (                                                                                                    "
		fnSql = fnSql & " select comment_seq from tree_query)                                                                                                      "

		fnSql = ""
		fnSql = fnSql & "   select " & menu_type & "_seq         "
		fnSql = fnSql & "         ,comment_seq               "
		fnSql = fnSql & "         ,comment                   "
		fnSql = fnSql & "     from " & tb_prefix & "_" & menu_type & "_comment  "
		fnSql = fnSql & "    where comment_seq = " & com_seq & " "
		funcRs.Open fnSql, conn, 1

		i = 0
		If Not funcRs.eof Then
			Do Until funcRs.eof
				i = i + 1
				ReDim Preserve arr_comment_seq(i)
				arr_comment_seq(i) = funcRs("comment_seq")
				ReDim Preserve arr_seq(i)
				arr_seq(i) = funcRs(menu_type & "_seq")

				funcRs.MoveNext
			Loop
		End If
		funcRs.close

		For j = 1 To i
			fnSql = ""
			fnSql = fnSql & " delete " & tb_prefix & "_" & menu_type & "_comment "
			fnSql = fnSql & "  where comment_seq = '" & arr_comment_seq(j) & "' "
			Conn.Execute(fnSql)

			fnSql = ""
			fnSql = fnSql & " update " & tb_prefix & "_" & menu_type & " "
			fnSql = fnSql & "    Set comment_cnt = (select count(*) from " & tb_prefix & "_" & menu_type & "_comment where " & menu_type & "_seq = '" & arr_seq(i) & "') "
			fnSql = fnSql & "       ,modid = '" & Session("user_id") & "' "
			fnSql = fnSql & "       ,moddt = getdate() "
			fnSql = fnSql & "  where " & menu_type & "_seq = " & arr_seq(i) & " "
			Conn.Execute(fnSql)
		Next
	End Sub

	Sub ExecWasteContent(menu_type, com_seq)
		' 모든 첨부 삭제
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_" & menu_type & "_attach                "
		fnSql = fnSql & "    Set restoreid = '" & session("user_id")   & "' "
		fnSql = fnSql & "       ,restoredt = getdate()                      "
		fnSql = fnSql & "       ,modid     = '" & Session("user_id")   & "' "
		fnSql = fnSql & "       ,moddt     = getdate()                      "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		fnSql = ""
		fnSql = fnSql & " insert into " & tb_prefix & "_waste_" & menu_type & "_attach     "
		fnSql = fnSql & " select *                                          "
		fnSql = fnSql & "   from " & tb_prefix & "_" & menu_type & "_attach                "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_" & menu_type & "_attach                "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 모든 댓글 삭제
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_" & menu_type & "_comment               "
		fnSql = fnSql & "    Set restoreid = '" & session("user_id")   & "' "
		fnSql = fnSql & "       ,restoredt = getdate()                      "
		fnSql = fnSql & "       ,modid     = '" & Session("user_id")   & "' "
		fnSql = fnSql & "       ,moddt     = getdate()                      "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		fnSql = ""
		fnSql = fnSql & " insert into " & tb_prefix & "_waste_" & menu_type & "_comment    "
		fnSql = fnSql & " select *                                          "
		fnSql = fnSql & "   from " & tb_prefix & "_" & menu_type & "_comment               "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_" & menu_type & "_comment               "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 부모글 삭제 업데이트
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_" & menu_type & "                         "
		fnSql = fnSql & "    Set parent_del_yn = 'Y'                          "
		fnSql = fnSql & "       ,modid         = '" & Session("user_id") & "' "
		fnSql = fnSql & "       ,moddt         = getdate()                    "
		fnSql = fnSql & "  where parent_seq = '" & com_seq  & "'              "
		Conn.Execute(fnSql)

		' 본글 삭제
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_" & menu_type & "                       "
		fnSql = fnSql & "    Set restoreid = '" & session("user_id")   & "' "
		fnSql = fnSql & "       ,restoredt = getdate()                      "
		fnSql = fnSql & "       ,modid     = '" & Session("user_id")   & "' "
		fnSql = fnSql & "       ,moddt     = getdate()                      "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		fnSql = ""
		fnSql = fnSql & " insert into " & tb_prefix & "_waste_" & menu_type & "            "
		fnSql = fnSql & " select *                                          "
		fnSql = fnSql & "   from " & tb_prefix & "_" & menu_type & "                       "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_" & menu_type & "                       "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 공지글 수 업데이트
		fnSql = ""
		fnSql = fnSql & " update cf_menu                                                                                                          "
		fnSql = fnSql & "    Set top_cnt   = (select count(*) from " & tb_prefix & "_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y')     "
		fnSql = fnSql & "       ,last_date = (select isnull(max(credt), getdate()) from " & tb_prefix & "_" & menu_type & " where menu_seq = '" & menu_seq & "') "
		fnSql = fnSql & "       ,modid     = '" & Session("user_id") & "'                                                                         "
		fnSql = fnSql & "       ,moddt     = getdate()                                                                                            "
		fnSql = fnSql & "  where menu_seq  = '" & menu_seq & "'                                                                                   "
		Conn.Execute(fnSql)
	End Sub

	Sub ExecRestoreContent(menu_type, com_seq)
		' 모든 첨부 복원
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_waste_" & menu_type & "_attach          "
		fnSql = fnSql & "    Set delid = '" & session("user_id")       & "' "
		fnSql = fnSql & "       ,deldt = getdate()                          "
		fnSql = fnSql & "       ,modid = '" & Session("user_id")       & "' "
		fnSql = fnSql & "       ,moddt = getdate()                          "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)
		fnSql = ""
		fnSql = fnSql & " insert into " & tb_prefix & "_" & menu_type & "_attach           "
		fnSql = fnSql & " select *                                          "
		fnSql = fnSql & "   from " & tb_prefix & "_waste_" & menu_type & "_attach          "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)
		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_waste_" & menu_type & "_attach          "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 부모글 삭제 업데이트
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_" & menu_type                        & "  "
		fnSql = fnSql & "    Set parent_del_yn = 'N'                          "
		fnSql = fnSql & "       ,modid         = '" & Session("user_id") & "' "
		fnSql = fnSql & "       ,moddt         = getdate()                    "
		fnSql = fnSql & "  where parent_seq    = '" & com_seq            & "' "
		Conn.Execute(fnSql)

		' 본글 복원
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_waste_" & menu_type                & "  "
		fnSql = fnSql & "    Set delid = '" & session("user_id")       & "' "
		fnSql = fnSql & "       ,deldt = getdate()                          "
		fnSql = fnSql & "       ,modid = '" & Session("user_id")       & "' "
		fnSql = fnSql & "       ,moddt = getdate()                          "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)
		fnSql = ""
		fnSql = fnSql & " insert into " & tb_prefix & "_" & menu_type & "                  "
		fnSql = fnSql & " select *                                          "
		fnSql = fnSql & "   from " & tb_prefix & "_waste_" & menu_type & "                 "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)
		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_waste_" & menu_type & "                 "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 모든 댓글 복원
		fnSql = ""
		fnSql = fnSql & " update " & tb_prefix & "_waste_" & menu_type & "_comment         "
		fnSql = fnSql & "    Set delid = '" & session("user_id")       & "' "
		fnSql = fnSql & "       ,deldt = getdate()                          "
		fnSql = fnSql & "       ,modid = '" & Session("user_id")       & "' "
		fnSql = fnSql & "       ,moddt = getdate()                          "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)
		fnSql = ""
		fnSql = fnSql & " insert into " & tb_prefix & "_" & menu_type & "_comment         "
		fnSql = fnSql & " select *                                         "
		fnSql = fnSql & "   from " & tb_prefix & "_waste_" & menu_type & "_comment        "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq & "' "
		Conn.Execute(fnSql)
		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_waste_" & menu_type & "_comment         "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 공지글 수 업데이트
		fnSql = ""
		fnSql = fnSql & " update cf_menu                                                                                                          "
		fnSql = fnSql & "    Set top_cnt   = (select count(*) from " & tb_prefix & "_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y')     "
		fnSql = fnSql & "       ,last_date = (select isnull(max(credt), getdate()) from " & tb_prefix & "_" & menu_type & " where menu_seq = '" & menu_seq & "') "
		fnSql = fnSql & "       ,modid     = '" & Session("user_id") & "'                                                                         "
		fnSql = fnSql & "       ,moddt     = getdate()                                                                                            "
		fnSql = fnSql & "  where menu_seq  = '" & menu_seq & "'                                                                                   "
		Conn.Execute(fnSql)
	End Sub

	Dim arrAttachFile()
	Dim arrDisplayFile()
	Dim arrThmbnlFile()
	Sub ExecDeleteContent(menu_type, com_seq)
		ReDim Preserve arrAttachFile(0)
		ReDim Preserve arrDisplayFile(0)
		ReDim Preserve arrThmbnlFile(0)

		Set funcRs = server.createobject("adodb.recordset")

		fnSql = ""
		fnSql = fnSql & " select file_name                                        "
		fnSql = fnSql & "       ,dsply_file_nm                                    "
		fnSql = fnSql & "       ,thmbnl_file_nm                                   "
		fnSql = fnSql & "   from " & tb_prefix & "_waste_" & menu_type & "_attach "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "'       "
		funcRs.Open fnSql, conn, 1

		i = 0
		If Not funcRs.eof Then
			Do Until funcRs.eof
				i = i + 1
				ReDim Preserve arrAttachFile(i)
				ReDim Preserve arrDisplayFile(i)
				ReDim Preserve arrThmbnlFile(i)
				arrAttachFile(i)  = funcRs("file_name")
				arrDisplayFile(i) = funcRs("dsply_file_nm")
				arrThmbnlFile(i)  = funcRs("thmbnl_file_nm")
				funcRs.MoveNext
			Loop
		End If
		funcRs.close

		' 모든 첨부 삭제
		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_waste_" & menu_type & "_attach "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 모든 댓글 삭제
		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_waste_" & menu_type & "_comment "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)

		' 본글 삭제
		fnSql = ""
		fnSql = fnSql & " delete " & tb_prefix & "_waste_" & menu_type & " "
		fnSql = fnSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(fnSql)
	End Sub

	Sub delete_attach(file)
		Set fso = CreateObject("Scripting.FileSystemObject")

		If (fso.FileExists(file)) Then
			fso.DeleteFile(file)
		End If

		Set fso = Nothing
	End Sub

	Function to_date_dot(date_str)
		If Len(date_str) > 10 Then
			date_str = Left(date_str,10)
		End If

		date_str = Replace(date_str,"-",".")

		to_date_dot = date_str
	End Function
	
	Function getImgYN(path)
		Set objImage = server.CreateObject("DEXT.ImageProc")

		If true = objImage.SetSourceFile(path) Then
			getImgYN = "Y"
		Else
			getImgYN = "N"
		End If

		Set objImage = Nothing
	End Function
%>



<%
	Response.CharSet="utf-8"
	Session.codepage="65001"
	Response.codepage="65001"
	Response.ContentType="text/html;charset=utf-8"
%>
<%
	StartTime=Timer()
	Dim Conn

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

	Dim daily_cnt
	Dim write_cnt
	Dim inc_del_yn
	Dim list_info
	Dim tab_use_yn
	Dim tab_nm

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

	Dim user_id : user_id = Session("user_id")

	cafe_ad_level = Session("cafe_ad_level")

	Function getUserLevel(cafe_id)

		cafe_mb_level = "0"

		If Session("cafe_ad_level") = "10" Then
			cafe_mb_level = "10"
		Else
			Set fn_rs = server.createobject("adodb.recordset")
			funcSql = ""
			funcSql = funcSql & " select cafe_mb_level "
			funcSql = funcSql & "   from cf_cafe_member cm "
			funcSql = funcSql & "  where cm.cafe_id = '" & cafe_id & "' "
			funcSql = funcSql & "    and cm.user_id = '" & session("user_id") & "' "
			fn_rs.Open funcSql, Conn, 1

			If Not fn_rs.eof Then ' 내 사랑방
				cafe_mb_level = fn_rs("cafe_mb_level")
				fn_rs.close
			Else
				fn_rs.close

				funcSql = ""
				funcSql = funcSql & " select cm.cafe_mb_level "
				funcSql = funcSql & "       ,um.union_mb_level "
				funcSql = funcSql & "   from cf_cafe cf "
				funcSql = funcSql & "  inner join cf_cafe_member cm on cm.cafe_id = cf.cafe_id "
				funcSql = funcSql & "   left outer join cf_union_manager um on um.union_id = cf.union_id and um.user_id = cm.user_id "
				funcSql = funcSql & "  where cf.union_id = '" & cafe_id & "' "
				funcSql = funcSql & "    and cm.user_id = '" & session("user_id") & "' "
				funcSql = funcSql & "    and cm.stat = 'Y' "
				fn_rs.Open funcSql, Conn, 1

				If Not fn_rs.eof Then ' 내 연합회
					cafe_mb_level = fn_rs("cafe_mb_level")
					union_mb_level = fn_rs("union_mb_level")

					If isnull(union_mb_level) Then union_mb_level = ""
					If toInt(cafe_mb_level) < toInt(union_mb_level) Then cafe_mb_level = union_mb_level
				End If

				fn_rs.close
			End If
			Set fn_rs = Nothing
		End If
		'msgonly toInt(cafe_mb_level)
		getUserLevel = toInt(cafe_mb_level)
	End Function

	Function getSeq(seq_name)

		funcSql = ""
		funcSql = funcSql & "  merge into cf_seq tbl "
		funcSql = funcSql & "  using (select '" & seq_name & "' as col) src "
		funcSql = funcSql & "     on (tbl.seq_name = src.col) "
		funcSql = funcSql & "   when matched Then "
		funcSql = funcSql & " update Set seq_value = isnull(seq_value,0) + 1 "
		funcSql = funcSql & "           ,modid = '" & Session("user_id")  & "' "
		funcSql = funcSql & "           ,moddt = getdate() "
		funcSql = funcSql & "   when not matched Then "
		funcSql = funcSql & " insert (seq_name "
		funcSql = funcSql & "        ,seq_value "
		funcSql = funcSql & "        ,creid "
		funcSql = funcSql & "        ,credt "
		funcSql = funcSql & "        )   "
		funcSql = funcSql & " values ('" & seq_name  & "' "
		funcSql = funcSql & "        ,1 "
		funcSql = funcSql & "        ,'" & Session("user_id")  & "' "
		funcSql = funcSql & "        ,getdate() "
		funcSql = funcSql & "        ); "

		Conn.execute funcSql

		getSeq = getonevalue("seq_value","cf_seq","where seq_name = '" & seq_name & "'")

	End Function

	Function getNum(menu_type, cafe_id, menu_seq)

		getNum = getonevalue("isnull(max(" & menu_type & "_num)+1,1)","cf_" & menu_type,"where cafe_id = '" & cafe_id & "' and menu_seq = '" & menu_seq & "'")

	End Function

	If Not(s_pop = "Y" Or freePage) Then
		Call checkLogin()
	End If
	
	Sub checkLogin()
		If s_pop <> "Y" And Session("user_id") = "" Then
			Response.Write "<script>alert('로그인이 필요합니다.');top.location.href='/end_message_view.asp'</script>"
			Response.End
		End If
	End Sub

	If s_pop <> "Y" And cafe_id <> "" Then
		Call checkMember(cafe_id)
	End If

	Sub checkCafePage(ByVal cafe_id)
		Set funcRs = server.createobject("adodb.recordset")
		funcSql = ""
		funcSql = funcSql & " select * "
		funcSql = funcSql & "       ,isnull(daily_cnt,9999) as daily_cnt "
		funcSql = funcSql & "   from cf_menu "
		funcSql = funcSql & "  where menu_seq = '" & menu_seq & "' "
		funcSql = funcSql & "    and cafe_id  = '" & cafe_id  & "' "
		funcRs.Open funcSql, Conn, 3, 1

		If funcRs.Eof Then
			msggo "정상적인 사용이 아닙니다.",""
		Else
			menu_type  = funcRs("menu_type")
			menu_name  = funcRs("menu_name")
			editor_yn  = funcRs("editor_yn")
			write_auth = funcRs("write_auth")
			reply_auth = funcRs("reply_auth")
			read_auth  = funcRs("read_auth")
			daily_cnt  = funcRs("daily_cnt")
			inc_del_yn = funcRs("inc_del_yn")
			list_info  = funcRs("list_info")
			tab_use_yn = funcRs("tab_use_yn")
			tab_nm     = funcRs("tab_nm")
		End If
		funcRs.close
		Set funcRs = Nothing
	End Sub

	Sub checkCafePageUpload(ByVal cafe_id)
		menu_seq = uploadform("menu_seq")

		Set funcRs = server.createobject("adodb.recordset")
		funcSql = ""
		funcSql = funcSql & " select * "
		funcSql = funcSql & "       ,isnull(daily_cnt,9999) as daily_cnt "
		funcSql = funcSql & "   from cf_menu "
		funcSql = funcSql & "  where menu_seq = '" & menu_seq & "' "
		funcSql = funcSql & "    and cafe_id  = '" & cafe_id  & "' "
		funcRs.Open funcSql, Conn, 3, 1

		If funcRs.Eof Then
			msggo "정상적인 사용이 아닙니다.",""
		Else
			menu_type  = funcRs("menu_type")
			menu_name  = funcRs("menu_name")
			editor_yn  = funcRs("editor_yn")
			write_auth = funcRs("write_auth")
			reply_auth = funcRs("reply_auth")
			read_auth  = funcRs("read_auth")
			daily_cnt  = funcRs("daily_cnt")
			inc_del_yn = funcRs("inc_del_yn")
			list_info  = funcRs("list_info")
		End If
		funcRs.close
		Set funcRs = Nothing
	End Sub
	
	Sub checkReadAuth(ByVal cafe_id)
		cafe_mb_level = getUserLevel(cafe_id)
		read_auth = getonevalue("read_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If toInt(read_auth) > toInt(cafe_mb_level) Then
			Response.Write "<script>alert('읽기 권한이없습니다');history.back()</script>"
			Response.End
		End If
	End Sub
	
	Sub checkWriteAuth(ByVal cafe_id)
		cafe_mb_level = getUserLevel(cafe_id)
		write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If toInt(write_auth) > toInt(cafe_mb_level) Then
			Response.Write "<script>alert('쓰기 권한이없습니다');history.back()</script>"
			Response.End
		End If
	End Sub
	
	Sub checkModifyAuth(ByVal cafe_id)
		cafe_mb_level = getUserLevel(cafe_id)
		write_auth = getonevalue("write_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If toInt(write_auth) > toInt(cafe_mb_level) Then
			Response.Write "<script>alert('수정 권한이없습니다');history.back()</script>"
			Response.End
		End If
	End Sub
	
	Sub checkReplyAuth(ByVal cafe_id)
		cafe_mb_level = getUserLevel(cafe_id)
		reply_auth = getonevalue("reply_auth","cf_menu","where menu_seq = '" & menu_seq & "'")

		If toInt(reply_auth) > toInt(cafe_mb_level) Then
			Response.Write "<script>alert('답변 권한이없습니다');history.back()</script>"
			Response.End
		End If
	End Sub
	
	Sub checkDailyCount(ByVal cafe_id)
		Set funcRs = server.createobject("adodb.recordset")

		If daily_cnt < "9999" Then
			If inc_del_yn = "N" Then
				funcSql = ""
				funcSql = funcSql & " select count(menu_seq) as write_cnt "
				funcSql = funcSql & "   from cf_board "
				funcSql = funcSql & "  where menu_seq = '" & menu_seq  & "' "
				funcSql = funcSql & "    and cafe_id = '" & cafe_id  & "' "
				funcSql = funcSql & "    and agency = '" & session("agency")  & "' "
				funcSql = funcSql & "    and convert(varchar(10), credt, 120) = '" & date & "' "
				funcRs.Open funcSql, conn, 3, 1
				write_cnt = funcRs("write_cnt")
				funcRs.close
			Else
				funcSql = ""
				funcSql = funcSql & " select count(wl.menu_seq) as write_cnt "
				funcSql = funcSql & "   from cf_write_log wl "
				funcSql = funcSql & "   left join cf_member cm on cm.user_id = wl.user_id "
				funcSql = funcSql & "  where wl.menu_seq = '" & menu_seq  & "' "
				funcSql = funcSql & "    and wl.cafe_id = '" & cafe_id  & "' "
				funcSql = funcSql & "    and cm.agency = '" & session("agency")  & "' "
				funcSql = funcSql & "    and convert(varchar(10), wl.credt, 120) = '" & date & "' "
				funcRs.Open funcSql, conn, 3, 1
				write_cnt = funcRs("write_cnt")
				funcRs.close
			End If

			If cint(write_cnt) >= cint(daily_cnt) Then
				Response.Write "<script>alert('1일 등록 갯수 " & daily_cnt & "개를 초과 하였습니다');history.back()</script>"
				Response.End
			End If
		End If

		Set funcRs = Nothing
	End Sub

	Sub checkMemoSendAuth(ByVal cafe_id)
		cafe_mb_level = getUserLevel(cafe_id)
		If cafe_mb_level < 2 Then
			Response.Write "<script>alert('쪽지를 보내려면 정회원부터 가능합니다');history.back();</script>"
			Response.End
		End If
	End Sub

	Sub checkMember(cafe_id)
		If getUserLevel(cafe_id) = 0 Then
			If isnull(Session("mycafe")) Or Session("mycafe") <> cafe_id Then
				Response.Write "<script>alert('비회원은 접근권한이 없습니다');history.back()</script>"
				Response.End
			Else
				Response.Write "<script>alert('활동정지 회원은 접근권한이 없습니다');history.back()</script>"
				Response.End
			End If
		End If
	End Sub

	Sub checkManager(cafe_id)
		cafe_mb_level = getUserLevel(cafe_id)
		If isnull(cafe_mb_level) Or cafe_mb_level < 10 Then
			Response.Write "<script>alert('접근권한이 없습니다(" & cafe_mb_level & ").');history.back();</script>"
			Response.End
		End If
	End Sub

	Sub checkAdmin()
		If isnull(Session("cafe_ad_level")) Or Session("cafe_ad_level") < "10" Then
			Response.Write "<script>alert('접근권한이 없습니다.');history.back();</script>"
			Response.End
		End If
	End Sub

	Sub setViewCnt(ByVal menu_type, ByVal com_seq)
		If Session("view_seq") <> com_seq Then
			funcSql = ""
			funcSql = funcSql & " update cf_" & menu_type & " "
			funcSql = funcSql & "    Set view_cnt = isnull(view_cnt,0) + 1 "
			funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
			funcSql = funcSql & "       ,moddt = getdate() "
			funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq & "' "

			Conn.Execute(funcSql)
			Session("view_seq") = com_seq
		End If
	End Sub
	
'/*----------------------------------------------------------------*/
'/*----- 실행시간표시
'/*----------------------------------------------------------------*/
	Sub extime(msg)
		response.write msg  & " : " & FormatNumber(Timer()-StartTime,5) & " (초)<br>"
	End Sub

	Function toInt(str)
		If isnull(str) Or isempty(str) Or Trim(str) = "" Then
			toInt = 0
		Else
			toInt = CInt(str)
		End If
	End Function
'/*----------------------------------------------------------------*/
'/*----- 코드관리가 되는것들의 콤보박스 생성
'/*----------------------------------------------------------------*/

	Function getCodeName(ByVal cmn, ByVal cd)
		Set funcRs = server.createobject("adodb.recordset")

		funcSql = ""
		funcSql = funcSql & " select cmn_cd                                           "
		funcSql = funcSql & "       ,cd_nm                                            "
		funcSql = funcSql & "   from cf_code                                          "
		funcSql = funcSql & "  where up_cd_id = (select cd_id                         "
		funcSql = funcSql & "                          from cf_code                   "
		funcSql = funcSql & "                         where up_cd_id = 'CD0000000000' "
		funcSql = funcSql & "                           and cmn_cd = '" & cmn & "'    "
		funcSql = funcSql & "                           and del_yn = 'N'              "
		funcSql = funcSql & "                           and use_yn = 'Y'              "
		funcSql = funcSql & "                       )                                 "
		funcSql = funcSql & "    and cmn_cd = '" & cd & "'                            "
		funcSql = funcSql & "    and del_yn = 'N'                                     "
		funcSql = funcSql & "    and use_yn = 'Y'                                     "
		funcSql = funcSql & "  order by cd_sn                                         "
		funcRs.Open funcSql, Conn, 1

		If Not funcRs.eof Then
			cmn_cd = funcRs("cmn_cd")
			cd_nm  = funcRs("cd_nm")
		End If
		funcRs.close

		getCodeName =cd_nm
	End Function

	Function makeComboCD(ByVal cmn, ByVal sel)
		Dim funcSql
		Dim funcRs
		Dim strCombo
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		funcSql = ""
		funcSql = funcSql & " select cmn_cd                                           "
		funcSql = funcSql & "       ,cd_nm                                            "
		funcSql = funcSql & "   from cf_code                                          "
		funcSql = funcSql & "  where up_cd_id = (select cd_id                         "
		funcSql = funcSql & "                          from cf_code                   "
		funcSql = funcSql & "                         where up_cd_id = 'CD0000000000' "
		funcSql = funcSql & "                           and cmn_cd = '" & cmn & "'    "
		funcSql = funcSql & "                           and del_yn = 'N'              "
		funcSql = funcSql & "                           and use_yn = 'Y'              "
		funcSql = funcSql & "                       )                                 "
		funcSql = funcSql & "    and del_yn = 'N'                                     "
		funcSql = funcSql & "    and use_yn = 'Y'                                     "
		funcSql = funcSql & "  order by cd_sn                                         "
		funcRs.Open funcSql, Conn, 1

		strCombo = vbCrLf

		Do Until funcRs.eof
			cmn_cd = funcRs("cmn_cd")
			cd_nm  = funcRs("cd_nm")

			strCombo = strCombo & "									"
			strCombo = strCombo & "<option value='" & cmn_cd & "' " & if3(cmn_cd=cstr(sel), "selected", "") & ">" & cd_nm & "</option>" & vbCrLf

			funcRs.Movenext
		Loop

		funcRs.close

		makeComboCD = strCombo
	End Function

	Function makeRadioCD(ByVal cmn, ByVal sel, ByVal req)
		Dim funcSql
		Dim funcRs
		Dim strRadio
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		funcSql = ""
		funcSql = funcSql & " select cmn_cd                                           "
		funcSql = funcSql & "       ,cd_nm                                            "
		funcSql = funcSql & "   from cf_code                                          "
		funcSql = funcSql & "  where up_cd_id = (select cd_id                         "
		funcSql = funcSql & "                          from cf_code                   "
		funcSql = funcSql & "                         where up_cd_id = 'CD0000000000' "
		funcSql = funcSql & "                           and cmn_cd = '" & cmn & "'    "
		funcSql = funcSql & "                           and del_yn = 'N'              "
		funcSql = funcSql & "                           and use_yn = 'Y'              "
		funcSql = funcSql & "                   )                                     "
		funcSql = funcSql & "    and del_yn = 'N'                                     "
		funcSql = funcSql & "    and use_yn = 'Y'                                     "
		funcSql = funcSql & "  order by cd_sn                                         "
		funcRs.Open funcSql, Conn, 1

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

		makeRadioCD = strRadio
	End Function

	Function makeCheckBoxCD(ByVal cmn, ByVal sel, ByVal req, ByVal tIdx)
		Dim funcSql
		Dim funcRs
		Dim strCheckBox
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		funcSql = ""
		funcSql = funcSql & " select cmn_cd                                           "
		funcSql = funcSql & "       ,cd_nm                                            "
		funcSql = funcSql & "   from cf_code                                          "
		funcSql = funcSql & "  where up_cd_id = (select cd_id                         "
		funcSql = funcSql & "                          from cf_code                   "
		funcSql = funcSql & "                         where up_cd_id = 'CD0000000000' "
		funcSql = funcSql & "                           and cmn_cd = '" & cmn & "'    "
		funcSql = funcSql & "                           and del_yn = 'N'              "
		funcSql = funcSql & "                           and use_yn = 'Y'              "
		funcSql = funcSql & "                   )                                     "
		funcSql = funcSql & "    and del_yn = 'N'                                     "
		funcSql = funcSql & "    and use_yn = 'Y'                                     "
		funcSql = funcSql & "  order by cd_sn                                         "
		funcRs.Open funcSql, Conn, 1

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

		makeCheckBoxCD = strCheckBox
	End Function

	Function makeSection(ByVal tag, ByVal snm, ByVal sel, ByVal req)
		Dim funcSql
		Dim funcRs
		Dim strRadio
		Dim a,b

		If IsNull(sel) Then sel = ""
		Set funcRs = server.createobject("adodb.recordset")

		funcSql = ""
		funcSql = ""
		funcSql = funcSql & " select section_seq                   "
		funcSql = funcSql & "       ,section_nm                    "
		funcSql = funcSql & "       ,section_sn                    "
		funcSql = funcSql & "   from cf_menu_section               "
		funcSql = funcSql & "  where menu_seq = '" & menu_seq & "' "
		funcSql = funcSql & "    and use_yn = 'Y'                  "
		funcSql = funcSql & "  order by section_sn                 "
		funcRs.open funcSql, conn, 3, 1

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
				strSection = strSection & "<input type='radio' id='section_sn_" & section_sn & "' name='" & snm & "' value='" & section_seq & "' class='inp_radio' " & if3(section_seq=cstr(sel), "checked ", "") & if3(req="", "", " required") & "/>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<label for='section_sn_" & section_sn & "'><em>" & section_nm & "</em></label>" & vbCrLf
				strSection = strSection & "									"
				strSection = strSection & "</span>" & vbCrLf
			Case "S"
				strSection = strSection & "									"
				strSection = strSection & "<option value='" & section_seq & "' " & if3(section_seq=cstr(sel), "selected", "") & ">" & section_nm & "</option>" & vbCrLf
			Case "C"
				strSection = strSection & "									"
				strSection = strSection & "<span class=''>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<input type='checkbox' id='section_sn_" & section_sn & "' name='" & snm & "' value='" & section_seq & "' class='inp_check' " & if3(instr(cstr(sel), section_seq) > 0, " checked", "") & if3(req="", "", " required") & if3(tIdx="", "", " tabidex='" & tIdx & "'") & "/>" & vbCrLf
				strSection = strSection & "										"
				strSection = strSection & "<label for='section_sn_" & section_sn & "'><em>" & section_nm & "</em></label>" & vbCrLf
				strSection = strSection & "									"
				strSection = strSection & "</span>" & vbCrLf
			Case "V"
			End Select

			funcRs.Movenext
		Loop

		funcRs.close

		makeSection = strSection
	End Function

	Function makeCombo(field1,field2,opt,table,refstr,sovalue)
		Dim funcSql
		Dim funcRs
		Dim strCombo
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSql, Conn, 1

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
		Dim funcSql
		Dim funcRs
		Dim strRadio
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSql, Conn, 1
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
		Dim funcSql
		Dim funcRs
		Dim strCheckBox
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSql, Conn, 1
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
		Dim funcSql
		Dim funcRs
		Dim strCheckBox
		Dim a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSql = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSql, Conn, 1
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
	Sub Reval()
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
	Function getonevalue(field,table,refstr)
		Dim funcSql
		Dim funcRs

		Set funcRs = server.createobject("adodb.recordset")
		funcSql = "select " & field & " from " & table & " " & refstr

		funcRs.open funcSql, conn, 1, 1

		If funcRs.eof Then
			getonevalue = ""
		Else
			getonevalue = Trim(funcRs(0))
			If isnull(getonevalue) Then getonevalue = ""
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
	Sub del_comment(menu_type, com_seq)

		Set funcRs = server.createobject("adodb.recordset")

		' 모든 댓글 조회
		funcSql = ""
		funcSql = funcSql & " with tree_query  as (                                                                                                            "
		funcSql = funcSql & "   select                                                                                                                         "
		funcSql = funcSql & "          comment_seq                                                                                                                     "
		funcSql = funcSql & "        , parent_seq                                                                                                              "
		funcSql = funcSql & "        , comment                                                                                                                 "
		funcSql = funcSql & "        , convert(varchar(255), comment_seq) sort                                                                                         "
		funcSql = funcSql & "        , convert(varchar(2000), comment) depth_fullname                                                                          "
		funcSql = funcSql & "     from cf_" & menu_type & "_comment                                                                                                        "
		funcSql = funcSql & "     where comment_seq = " & com_seq & "                                                                                                          "
		funcSql = funcSql & "     union all                                                                                                                    "
		funcSql = funcSql & "     select                                                                                                                       "
		funcSql = funcSql & "           b.comment_seq                                                                                                                  "
		funcSql = funcSql & "         , b.parent_seq                                                                                                           "
		funcSql = funcSql & "         , b.comment                                                                                                              "
		funcSql = funcSql & "         , convert(varchar(255), convert(nvarchar,c.sort) + ' > ' +  convert(varchar(255), b.comment_seq)) sort                           "
		funcSql = funcSql & "         , convert(varchar(2000), convert(nvarchar,c.depth_fullname) + ' > ' +  convert(varchar(2000), b.comment)) depth_fullname "
		funcSql = funcSql & "     from  cf_" & menu_type & "_comment b, tree_query c                                                                               "
		funcSql = funcSql & "     where b.parent_seq = c.comment_seq                                                                                                   "
		funcSql = funcSql & " )                                                                                                                                "
		funcSql = funcSql & " select *                                                                                                                         "
		funcSql = funcSql & "   from cf_" & menu_type & "_comment                                                                                                  "
		funcSql = funcSql & "  where comment_seq In (                                                                                                    "
		funcSql = funcSql & " select comment_seq from tree_query)                                                                                                      "

		funcSql = ""
		funcSql = funcSql & "   select " & menu_type & "_seq         "
		funcSql = funcSql & "         ,comment_seq               "
		funcSql = funcSql & "         ,comment                   "
		funcSql = funcSql & "     from cf_" & menu_type & "_comment  "
		funcSql = funcSql & "    where comment_seq = " & com_seq & " "
		Response.write funcSql
		funcRs.Open funcSql, conn, 1

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
			funcSql = ""
			funcSql = funcSql & " delete cf_" & menu_type & "_comment "
			funcSql = funcSql & "  where comment_seq = '" & arr_comment_seq(j) & "' "
			Conn.Execute(funcSql)

			funcSql = ""
			funcSql = funcSql & " update cf_" & menu_type & " "
			funcSql = funcSql & "    Set comment_cnt = (select count(*) from cf_" & menu_type & "_comment where " & menu_type & "_seq = '" & arr_seq(i) & "') "
			funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
			funcSql = funcSql & "       ,moddt = getdate() "
			funcSql = funcSql & "  where " & menu_type & "_seq = " & arr_seq(i) & " "
			Conn.Execute(funcSql)
		Next

	End Sub

	Sub waste_content(menu_type, com_seq)

		' 모든 첨부 삭제
		funcSql = ""
		funcSql = funcSql & " update cf_" & menu_type & "_attach "
		funcSql = funcSql & "    Set restoreid = '" & session("user_id") & "' "
		funcSql = funcSql & "       ,restoredt = getdate() "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		funcSql = ""
		funcSql = funcSql & " insert into cf_waste_" & menu_type & "_attach "
		funcSql = funcSql & " select * "
		funcSql = funcSql & "   from cf_" & menu_type & "_attach "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
Response.write funcSql
		Conn.Execute(funcSql)

		funcSql = ""
		funcSql = funcSql & " delete cf_" & menu_type & "_attach "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 모든 댓글 삭제
		funcSql = ""
		funcSql = funcSql & " update cf_" & menu_type & "_comment "
		funcSql = funcSql & "    Set restoreid = '" & session("user_id") & "' "
		funcSql = funcSql & "       ,restoredt = getdate() "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		funcSql = ""
		funcSql = funcSql & " insert into cf_waste_" & menu_type & "_comment "
		funcSql = funcSql & " select * "
		funcSql = funcSql & "   from cf_" & menu_type & "_comment "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		funcSql = ""
		funcSql = funcSql & " delete cf_" & menu_type & "_comment "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 부모글 삭제 업데이트
		funcSql = ""
		funcSql = funcSql & " update cf_" & menu_type & " "
		funcSql = funcSql & "    Set parent_del_yn = 'Y' "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where parent_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 본글 삭제
		funcSql = ""
		funcSql = funcSql & " update cf_" & menu_type & " "
		funcSql = funcSql & "    Set restoreid = '" & session("user_id") & "' "
		funcSql = funcSql & "       ,restoredt = getdate() "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		funcSql = ""
		funcSql = funcSql & " insert into cf_waste_" & menu_type & "  "
		funcSql = funcSql & " select *  "
		funcSql = funcSql & "   from cf_" & menu_type & "  "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		funcSql = ""
		funcSql = funcSql & " delete cf_" & menu_type & "  "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 공지글 수 업데이트
		funcSql = ""
		funcSql = funcSql & " update cf_menu "
		funcSql = funcSql & "    Set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
		funcSql = funcSql & "       ,last_date = (select max(credt) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "') "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where menu_seq = '" & menu_seq & "' "
		Conn.Execute(funcSql)

	End Sub

	Sub restore_content(menu_type, com_seq)

		' 모든 첨부 복원
		funcSql = ""
		funcSql = funcSql & " update cf_waste_" & menu_type & "_attach "
		funcSql = funcSql & "    Set delid = '" & session("user_id") & "' "
		funcSql = funcSql & "       ,deldt = getdate() "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)
		funcSql = ""
		funcSql = funcSql & " insert into cf_" & menu_type & "_attach "
		funcSql = funcSql & " select * "
		funcSql = funcSql & "   from cf_waste_" & menu_type & "_attach "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)
		funcSql = ""
		funcSql = funcSql & " delete cf_waste_" & menu_type & "_attach "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 부모글 삭제 업데이트
		funcSql = ""
		funcSql = funcSql & " update cf_" & menu_type & " "
		funcSql = funcSql & "    Set parent_del_yn = 'N' "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where parent_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 본글 복원
		funcSql = ""
		funcSql = funcSql & " update cf_waste_" & menu_type & " "
		funcSql = funcSql & "    Set delid = '" & session("user_id") & "' "
		funcSql = funcSql & "       ,deldt = getdate() "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)
		funcSql = ""
		funcSql = funcSql & " insert into cf_" & menu_type & " "
		funcSql = funcSql & " select * "
		funcSql = funcSql & "   from cf_waste_" & menu_type & " "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)
		funcSql = ""
		funcSql = funcSql & " delete cf_waste_" & menu_type & " "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 모든 댓글 복원
		funcSql = ""
		funcSql = funcSql & " update cf_waste_" & menu_type & "_comment "
		funcSql = funcSql & "    Set delid = '" & session("user_id") & "' "
		funcSql = funcSql & "       ,deldt = getdate() "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)
		funcSql = ""
		funcSql = funcSql & " insert into cf_" & menu_type & "_comment "
		funcSql = funcSql & " select * "
		funcSql = funcSql & "   from cf_waste_" & menu_type & "_comment "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)
		funcSql = ""
		funcSql = funcSql & " delete cf_waste_" & menu_type & "_comment "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 공지글 수 업데이트
		funcSql = ""
		funcSql = funcSql & " update cf_menu "
		funcSql = funcSql & "    Set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
		funcSql = funcSql & "       ,last_date = (select max(credt) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "') "
		funcSql = funcSql & "       ,modid = '" & Session("user_id") & "' "
		funcSql = funcSql & "       ,moddt = getdate() "
		funcSql = funcSql & "  where menu_seq = '" & menu_seq & "' "
		Conn.Execute(funcSql)

	End Sub

	Dim attach_file()
	ReDim attach_file(1)
	Sub delete_content(menu_type, com_seq)

		Set funcRs = server.createobject("adodb.recordset")

		funcSql = ""
		funcSql = funcSql & " select file_name "
		funcSql = funcSql & "   from cf_waste_" & menu_type & "_attach "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		funcRs.Open funcSql, conn, 1

		i = 0
		If Not funcRs.eof Then
			Do Until funcRs.eof
				i = i + 1
				ReDim Preserve attach_file(i)
				attach_file(i) = funcRs("file_name")
				funcRs.MoveNext
			Loop
		End If
		funcRs.close

		' 모든 첨부 삭제
		funcSql = ""
		funcSql = funcSql & " delete cf_waste_" & menu_type & "_attach "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 모든 댓글 삭제
		funcSql = ""
		funcSql = funcSql & " delete cf_waste_" & menu_type & "_comment "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

		' 본글 삭제
		funcSql = ""
		funcSql = funcSql & " delete cf_waste_" & menu_type & " "
		funcSql = funcSql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(funcSql)

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
		Set objImage = nothing
	End Function
%>



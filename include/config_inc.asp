<%
	Response.ContentType="text/HTML"
	Response.Charset="euc-kr"
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
	'################ 웹사이트 루트 절대경로 설정 #################
	ConfigPath = Server.MapPath("\") & "\"

	'################ 첨부파일이 저장될 절대경로 설정 (쓰기권한이 설정되어 있어야 합니다) #################
	ConfigAttachedFileFolder = ConfigPath & "uploads\"
	ConfigAttachedFileFolder = "D:\경인네트웍스\dev\uploads\" ' crjee 수정

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
			sql = ""
			sql = sql & " select cafe_mb_level "
			sql = sql & "   from cf_cafe_member cm "
			sql = sql & "  where cm.cafe_id = '" & cafe_id & "' "
			sql = sql & "    and cm.user_id = '" & session("user_id") & "' "
			fn_rs.Open sql, Conn, 1

			If Not fn_rs.eof Then ' 내 사랑방
				cafe_mb_level = fn_rs("cafe_mb_level")
				fn_rs.close
			Else
				fn_rs.close

				sql = ""
				sql = sql & " select cm.cafe_mb_level "
				sql = sql & "       ,um.union_mb_level "
				sql = sql & "   from cf_cafe cf "
				sql = sql & "  inner join cf_cafe_member cm on cm.cafe_id = cf.cafe_id "
				sql = sql & "   left outer join cf_union_manager um on um.union_id = cf.union_id and um.user_id = cm.user_id "
				sql = sql & "  where cf.union_id = '" & cafe_id & "' "
				sql = sql & "    and cm.user_id = '" & session("user_id") & "' "
				sql = sql & "    and cm.stat = 'Y' "
				fn_rs.Open sql, Conn, 1

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

		sql = ""
		sql = sql & "  merge into cf_seq tbl "
		sql = sql & "  using (select '" & seq_name & "' as col) src "
		sql = sql & "     on (tbl.seq_name = src.col) "
		sql = sql & "   when matched Then "
		sql = sql & " update Set seq_value = isnull(seq_value,0) + 1 "
		sql = sql & "           ,modid = '" & Session("user_id")  & "' "
		sql = sql & "           ,moddt = getdate() "
		sql = sql & "   when not matched Then "
		sql = sql & " insert (seq_name "
		sql = sql & "        ,seq_value "
		sql = sql & "        ,creid "
		sql = sql & "        ,credt "
		sql = sql & "        )   "
		sql = sql & " values ('" & seq_name  & "' "
		sql = sql & "        ,1 "
		sql = sql & "        ,'" & Session("user_id")  & "' "
		sql = sql & "        ,getdate() "
		sql = sql & "        ); "

		Conn.execute sql

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
			Response.Write "<script>alert('로그인이 필요합니다.');location.href='/end_message_view.asp'</script>"
			Response.End
		End If
	End Sub

	If s_pop <> "Y" And cafe_id <> "" Then
		Call checkMember(cafe_id)
	End If

	Sub checkCafePage(ByVal cafe_id)
		If menu_seq = "" Then
			On Error Resume Next
			Set uploadform = Server.CreateObject("DEXT.FileUpload")
			menu_seq = uploadform("menu_seq")
			Set uploadform = Nothing
		End If

		Set funcRs = server.createobject("adodb.recordset")
		sql = ""
		sql = sql & " select * "
		sql = sql & "       ,isnull(daily_cnt,9999) as daily_cnt "
		sql = sql & "   from cf_menu "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		sql = sql & "    and cafe_id  = '" & cafe_id  & "' "
		funcRs.Open Sql, Conn, 3, 1

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
				sql = ""
				sql = sql & " select count(menu_seq) as write_cnt "
				sql = sql & "   from cf_board "
				sql = sql & "  where menu_seq = '" & menu_seq  & "' "
				sql = sql & "    and cafe_id = '" & cafe_id  & "' "
				sql = sql & "    and agency = '" & session("agency")  & "' "
				sql = sql & "    and convert(varchar(10), credt, 120) = '" & date & "' "
				funcRs.Open Sql, conn, 3, 1
				write_cnt = funcRs("write_cnt")
				funcRs.close
			Else
				sql = ""
				sql = sql & " select count(wl.menu_seq) as write_cnt "
				sql = sql & "   from cf_write_log wl "
				sql = sql & "   left join cf_member cm on cm.user_id = wl.user_id "
				sql = sql & "  where wl.menu_seq = '" & menu_seq  & "' "
				sql = sql & "    and wl.cafe_id = '" & cafe_id  & "' "
				sql = sql & "    and cm.agency = '" & session("agency")  & "' "
				sql = sql & "    and convert(varchar(10), wl.credt, 120) = '" & date & "' "
				funcRs.Open Sql, conn, 3, 1
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

	Sub setViewCnt(menu_type, com_seq)
		If Session("view_seq") <> com_seq Then
			sql = ""
			sql = sql & " update cf_" & menu_type & " "
			sql = sql & "    Set view_cnt = isnull(view_cnt,0) + 1 "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where " & menu_type & "_seq = '" & com_seq & "' "

			Conn.Execute(sql)
			Session("view_seq") = com_seq
		End If
	End Sub
	
'/*----------------------------------------------------------------*/
'/*----- 실행시간표시
'/*----------------------------------------------------------------*/
	sub extime(msg)
		response.write msg  & " : " & FormatNumber(Timer()-StartTime,5) & " (초)<br>"
	end sub

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
	function makeCombo(field1,field2,opt,table,refstr,sovalue)
		DIM funcSQL
		DIM funcRs
		DIM strCombo
		DIM a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSQL = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSQL, Conn, 1

		strCombo = vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = funcRs(1)
			if isnull(sovalue) Then sovalue = ""
			if cstr(a) = cstr(sovalue) Then
				if opt <> "" Then a = funcRs(2)
			strCombo = strCombo & "						<option value='" &a& "' selected>" &b& "</option>" &vbCrLf
			Else
				if opt <> "" Then a = funcRs(2)
			strCombo = strCombo & "						<option value='" &a& "'>" &b& "</option>" &vbCrLf
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeCombo = strCombo
	end function

	function makeFont(inFont)
		strFont ="굴림,궁서,돋움,바탕,새굴림,휴먼둥근헤드라인,휴먼매직체,휴먼모음T,휴먼아미,휴먼엑스포,휴먼옛체,휴먼편지,HY견고딕,HY견명조,HY궁서B,HY그래픽M,HY목각파임B,HY신명조,HY얕은샘물M,HY엽서M,HY중고딕,HY헤드라인"

		arrFont = Split(strFont, ",")

		strCombo = strCombo & "<option></option>" &vbCrLf
		For i = 1 To ubound(arrFont)
			if cstr(inFont) = cstr(arrFont(i)) Then
			strCombo = strCombo & "<option value='" &arrFont(i)& "' selected>" &arrFont(i)& "</option>" &vbCrLf
			Else
			strCombo = strCombo & "<option value='" &arrFont(i)& "'>" &arrFont(i)& "</option>" &vbCrLf
			End If
		Next

		makeFont = strCombo
	end function

'/*----------------------------------------------------------------*/
'/*----- 코드관리가 되는것들의 라디오버튼 생성
'/*----------------------------------------------------------------*/
	function makeRadio(func,tagname,cndt,tagtitle,field1,field2,opt,table,refstr,sovalue,read)
		DIM funcSQL
		DIM funcRs
		DIM strRadio
		DIM a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSQL = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSQL, Conn, 1
		strRadio = vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = trim(funcRs(1))
			if isnull(sovalue) Then sovalue = ""
			if cstr(a) = cstr(sovalue) Then
				if func = "" Then
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked " & read & ">" &b& " & nbsp;" &vbCrLf
				Else
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked onclick=""" & func & """ " & read & ">" &b& " & nbsp;" &vbCrLf
				End If
			Else
				if func = "" Then
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' " & read & ">" &b& " & nbsp;" &vbCrLf
				Else
			strRadio = strRadio & "<input type='radio' hidefocus='true' name='" & tagname & "' value='" &a& "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' onclick=""" & func & """ " & read & ">" &b& " & nbsp;" &vbCrLf
				End If
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeRadio = strRadio
	end function

'/*----------------------------------------------------------------*/
'/*----- 코드관리가 되는것들의 체크박스 생성
'/*----------------------------------------------------------------*/
	function makeCheckBox(width,func,tagname,cndt,tagtitle,field1,field2,opt,table,refstr,sovalue)
		DIM funcSQL
		DIM funcRs
		DIM strCheckBox
		DIM a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSQL = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSQL, Conn, 1
		strCheckBox = vbCrLf

'		strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='CheckBox' value='checkbox' name='allchk' title='" & tagtitle & "' style='border-color:#F2F2F2;'  onclick=""allChk('" & tagname & "',this.checked)"">전체&nbsp;</span>" &vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = funcRs(1)
			if isnull(sovalue) Then sovalue = ""
			if instr(sovalue, a) > 0 Then
				if func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			Else
				if func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;'>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeCheckBox = strCheckBox
	end function
	function makeCheckBox2(width,func,tagname,cndt,tagtitle,field1,field2,opt,table,refstr,sovalue)
		DIM funcSQL
		DIM funcRs
		DIM strCheckBox
		DIM a,b

		Set funcRs = server.createobject("adodb.recordset")
		funcSQL = "select " & field1 & " ," & field2 & " " & opt & " from " & table & " " & refstr
		funcRs.Open funcSQL, Conn, 1
		strCheckBox = vbCrLf

'		strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='CheckBox' value='checkbox' name='allchk' title='" & tagtitle & "' style='border-color:#F2F2F2;'  onclick=""allChk('" & tagname & "',this.checked)"">전체&nbsp;</span>" &vbCrLf

		Do until funcRs.EOF
			a = trim(funcRs(0))
			b = funcRs(1)
			if isnull(sovalue) Then sovalue = "0"
			if IsAuth(sovalue, 2 ^ a) Then
				if func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' checked onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			Else
				if func = "" Then
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;'>" &b& " & nbsp;</span>" &vbCrLf
				Else
					strCheckBox = strCheckBox & "<span style='width:" & width & "'><input type='checkbox' hidefocus='true' value='" &a& "' name='" & tagname & "' cndt='" &cndt& "' title='" & tagtitle & "' style='border-color:#F2F2F2;' onclick=""" & func & """>" &b& " & nbsp;</span>" &vbCrLf
				End If
			End If
			funcRs.Movenext
		Loop

		funcRs.close

		makeCheckBox2 = strCheckBox
	end function
'/*-------------------------------------------------------------*/
'/*----- Request 값들
'/*-------------------------------------------------------------*/
	sub Reval()
		response.write "<hr>"
		response.write "넘어온 쿼리 콜렉션 값"
		response.write "<hr>"

		for each item in request.querystring
			for i = 1 to request.querystring(item).count
				response.write "<br>"
				response.write item & " = " & request.querystring(item)(i)
			next
		next
		response.write "<hr>"
		response.write "넘어온 폼 콜렉션 값"
		response.write "<hr>"

		for each item in request.form
			for i = 1 to request.form(item).count
				response.write "<br>"
				response.write item & "=" & request.form(item)(i)
			next
		next
	end sub

	sub fReval()
		response.write "<hr>"
		response.write "넘어온 쿼리 콜렉션 값"
		response.write "<hr>"

		for each item in request.querystring
			for i = 1 to request.querystring(item).count
				response.write "<br>"
				response.write item & " = " & request.querystring(item)(i)
			next
		next
		response.write "<hr>"
		response.write "넘어온 폼 콜렉션 값"
		response.write "<hr>"

		for each item in uploadform
			for i = 1 to uploadform(item).count
				response.write "<br>"
				response.write item & "=" & uploadform(item)(i)
			next
		next
	end sub


'/*-------------------------------------------------------------*/
'/*-----	한 데이타 가져오기
'/*-------------------------------------------------------------*/
	function getOneValue(field,table,refstr)
		DIM funcSQL
		DIM funcRs

		Set funcRs = server.createobject("adodb.recordset")
		funcSQL = "select " & field & " from " & table & " " & refstr

		funcRs.open funcSQL, conn, 1, 1

		if funcRs.eof Then
			getOneValue = ""
		Else
			getOneValue = Trim(funcRs(0))
			If isnull(getOneValue) Then getOneValue = ""
		End If
		funcRs.close
	end function
'/*-------------------------------------------------------------*/
'/*-----	메시지 보이기
'/*-------------------------------------------------------------*/
	sub MsgOnly(str)
		Response.write "<script LANGUAGE=JAVAscript>" & vbcrlf
		Response.write "alert(""\n" & str  & """)" & vbcrlf
		Response.write "</script>" & vbcrlf
	end sub
	sub MsgEnd(str)
		Response.write "<script LANGUAGE=JAVAscript>" & vbcrlf
		Response.write "alert(""\n" & str  & """)" & vbcrlf
		Response.write "</script>" & vbcrlf
		Response.end
	end sub
	sub MsgGo(str,url)
		Response.write "<script LANGUAGE=JAVAscript>" & vbcrlf
		if str <> "" Then
		Response.write "alert(""\n" & str  & """)" & vbcrlf
		End If
		if url = "" Then
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
		Response.end
	end sub

'/*-------------------------------------------------------------*/
'/*-----	숫자를 임의의 자릿수로 0 추가해서 출력
'/*-------------------------------------------------------------*/
	function numc(val, c_len)
		DIM i, temp, t_len

		if val <> "" Then temp = cstr(val)
		t_len = len(temp)
		if c_len > t_len Then
			for i = 1 to (c_len - t_len)
				temp = "0" & temp
			next
		End If
		numc = CStr(temp)
	end function

	function if3(var, tvalue, fvalue)
		if (var = true) Then
			if3 = tvalue
		Else
			if3 = fvalue
		End If
	end function

	function rmid(val, c_len, a_str)
		if val <> "" Then temp = cstr(val)

		if len(temp) > c_len Then
			rmid = mid(temp, 1, c_len) & a_str
		Else
			rmid = temp
		End If
	end function

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
	sub del_comment(menu_type, com_seq)

		Set funcRs = server.createobject("adodb.recordset")

		' 모든 댓글 조회
		sql = ""
		sql = sql & " with tree_query  as (                                                                                                            "
		sql = sql & "   select                                                                                                                         "
		sql = sql & "          comment_seq                                                                                                                     "
		sql = sql & "        , parent_seq                                                                                                              "
		sql = sql & "        , comment                                                                                                                 "
		sql = sql & "        , convert(varchar(255), comment_seq) sort                                                                                         "
		sql = sql & "        , convert(varchar(2000), comment) depth_fullname                                                                          "
		sql = sql & "     from cf_" & menu_type & "_comment                                                                                                        "
		sql = sql & "     where comment_seq = " & com_seq & "                                                                                                          "
		sql = sql & "     union all                                                                                                                    "
		sql = sql & "     select                                                                                                                       "
		sql = sql & "           b.comment_seq                                                                                                                  "
		sql = sql & "         , b.parent_seq                                                                                                           "
		sql = sql & "         , b.comment                                                                                                              "
		sql = sql & "         , convert(varchar(255), convert(nvarchar,c.sort) + ' > ' +  convert(varchar(255), b.comment_seq)) sort                           "
		sql = sql & "         , convert(varchar(2000), convert(nvarchar,c.depth_fullname) + ' > ' +  convert(varchar(2000), b.comment)) depth_fullname "
		sql = sql & "     from  cf_" & menu_type & "_comment b, tree_query c                                                                               "
		sql = sql & "     where b.parent_seq = c.comment_seq                                                                                                   "
		sql = sql & " )                                                                                                                                "
		sql = sql & " select *                                                                                                                         "
		sql = sql & "   from cf_" & menu_type & "_comment                                                                                                  "
		sql = sql & "  where comment_seq in (                                                                                                    "
		sql = sql & " select comment_seq from tree_query)                                                                                                      "

		sql = ""
		sql = sql & "   select " & menu_type & "_seq         "
		sql = sql & "         ,comment_seq               "
		sql = sql & "         ,comment                   "
		sql = sql & "     from cf_" & menu_type & "_comment  "
		sql = sql & "    where comment_seq = " & com_seq & " "
		Response.write sql
		funcRs.Open Sql, conn, 1

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
			sql = ""
			sql = sql & " delete cf_" & menu_type & "_comment "
			sql = sql & "  where comment_seq = '" & arr_comment_seq(j) & "' "
			Conn.Execute(sql)

			sql = ""
			sql = sql & " update cf_" & menu_type & " "
			sql = sql & "    Set comment_cnt = (select count(*) from cf_" & menu_type & "_comment where " & menu_type & "_seq = '" & arr_seq(i) & "') "
			sql = sql & "       ,modid = '" & Session("user_id") & "' "
			sql = sql & "       ,moddt = getdate() "
			sql = sql & "  where " & menu_type & "_seq = " & arr_seq(i) & " "
			Conn.Execute(sql)
		Next

	End sub

	sub waste_content(menu_type, com_seq)

		' 모든 첨부 삭제
		sql = ""
		sql = sql & " update cf_" & menu_type & "_attach "
		sql = sql & "    Set restoreid = '" & session("user_id") & "' "
		sql = sql & "       ,restoredt = getdate() "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " insert into cf_waste_" & menu_type & "_attach "
		sql = sql & " select * "
		sql = sql & "   from cf_" & menu_type & "_attach "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " delete cf_" & menu_type & "_attach "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 모든 댓글 삭제
		sql = ""
		sql = sql & " update cf_" & menu_type & "_comment "
		sql = sql & "    Set restoreid = '" & session("user_id") & "' "
		sql = sql & "       ,restoredt = getdate() "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " insert into cf_waste_" & menu_type & "_comment "
		sql = sql & " select * "
		sql = sql & "   from cf_" & menu_type & "_comment "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " delete cf_" & menu_type & "_comment "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 부모글 삭제 업데이트
		sql = ""
		sql = sql & " update cf_" & menu_type & " "
		sql = sql & "    Set parent_del_yn = 'Y' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where parent_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 본글 삭제
		sql = ""
		sql = sql & " update cf_" & menu_type & " "
		sql = sql & "    Set restoreid = '" & session("user_id") & "' "
		sql = sql & "       ,restoredt = getdate() "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " insert into cf_waste_" & menu_type & "  "
		sql = sql & " select *  "
		sql = sql & "   from cf_" & menu_type & "  "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		sql = ""
		sql = sql & " delete cf_" & menu_type & "  "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 공지글 수 업데이트
		sql = ""
		sql = sql & " update cf_menu "
		sql = sql & "    Set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
		sql = sql & "       ,last_date = (select max(credt) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "') "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		Conn.Execute(sql)

	End sub

	sub restore_content(menu_type, com_seq)

		' 모든 첨부 복원
		sql = ""
		sql = sql & " update cf_waste_" & menu_type & "_attach "
		sql = sql & "    Set delid = '" & session("user_id") & "' "
		sql = sql & "       ,deldt = getdate() "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)
		sql = ""
		sql = sql & " insert into cf_" & menu_type & "_attach "
		sql = sql & " select * "
		sql = sql & "   from cf_waste_" & menu_type & "_attach "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)
		sql = ""
		sql = sql & " delete cf_waste_" & menu_type & "_attach "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 부모글 삭제 업데이트
		sql = ""
		sql = sql & " update cf_" & menu_type & " "
		sql = sql & "    Set parent_del_yn = 'N' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where parent_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 본글 복원
		sql = ""
		sql = sql & " update cf_waste_" & menu_type & " "
		sql = sql & "    Set delid = '" & session("user_id") & "' "
		sql = sql & "       ,deldt = getdate() "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)
		sql = ""
		sql = sql & " insert into cf_" & menu_type & " "
		sql = sql & " select * "
		sql = sql & "   from cf_waste_" & menu_type & " "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)
		sql = ""
		sql = sql & " delete cf_waste_" & menu_type & " "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 모든 댓글 복원
		sql = ""
		sql = sql & " update cf_waste_" & menu_type & "_comment "
		sql = sql & "    Set delid = '" & session("user_id") & "' "
		sql = sql & "       ,deldt = getdate() "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)
		sql = ""
		sql = sql & " insert into cf_" & menu_type & "_comment "
		sql = sql & " select * "
		sql = sql & "   from cf_waste_" & menu_type & "_comment "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)
		sql = ""
		sql = sql & " delete cf_waste_" & menu_type & "_comment "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 공지글 수 업데이트
		sql = ""
		sql = sql & " update cf_menu "
		sql = sql & "    Set top_cnt = (select count(*) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "' and top_yn = 'Y') "
		sql = sql & "       ,last_date = (select max(credt) from cf_" & menu_type & " where menu_seq = '" & menu_seq & "') "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where menu_seq = '" & menu_seq & "' "
		Conn.Execute(sql)

	End sub

	Dim attach_file()
	ReDim attach_file(1)
	sub delete_content(menu_type, com_seq)

		Set funcRs = server.createobject("adodb.recordset")

		sql = ""
		sql = sql & " select file_name "
		sql = sql & "   from cf_waste_" & menu_type & "_attach "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		funcRs.Open Sql, conn, 1

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
		sql = ""
		sql = sql & " delete cf_waste_" & menu_type & "_attach "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 모든 댓글 삭제
		sql = ""
		sql = sql & " delete cf_waste_" & menu_type & "_comment "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

		' 본글 삭제
		sql = ""
		sql = sql & " delete cf_waste_" & menu_type & " "
		sql = sql & "  where " & menu_type & "_seq = '" & com_seq  & "' "
		Conn.Execute(sql)

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

		if true = objImage.SetSourceFile(path) Then
			getImgYN = "Y"
		Else
			getImgYN = "N"
		End If
		Set objImage = nothing
	End Function
%>



<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<%
'	Option Explicit
	Dim root,level, folder,folderspec
	Dim MyFile
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Application("db")
	Set rs = Server.CreateObject ("ADODB.Recordset")

	auth_url = Server.MapPath("\")
	Set fso = server.CreateObject("Scripting.FileSystemObject")
Response.write "D:\경인네트웍스\sarang\프로그램기능리스트 "&date&".xls"
	Set MyFile1 = fso.CreateTextFile("D:\경인네트웍스\sarang\프로그램기능리스트 "&date&".xls", True)
	
	root = "D:\경인네트웍스\sarang"

	Dim rCnt, fCnt
	rCnt = UBound(Split(root, "\")) + 1

	call CheckFolderList(root)
	Dim arrFolder()

	list = ""
	list = list & "경로"
	list = list & Chr(9) & "파일명"
	list = list & Chr(9) & "열기"

	i = 1
	For j = rCnt To fCnt
		list = list & Chr(9) & "폴더" & i
		i = i + 1
	Next

	list = list & Chr(9) & "구분"
	list = list & Chr(9) & "업무"
	list = list & Chr(9) & "작업"
	list = list & Chr(9) & "프로그램설명"
	list = list & Chr(9) & "화면열기"
	list = list & Chr(9) & "기능"
	list = list & Chr(9) & "점검결과"
	list = list & Chr(9) & "오류내용"
Response.write "<br>" & list
	MyFile1.WriteLine(list)

	call ShowFileList(root)
	call ShowFolderList(root)

	Sub ShowFolderList(folderspec)
		Dim fso, f, f1, s, sf,dwidth ,i
		Set fso = server.CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set sf = f.SubFolders

		For Each f1 in sf
			'MyFile1.WriteLine(dwidth & f1.name)
			'response.write dwidth &"<b>"& f1.name & "</b><br>"
			ShowFileList(folderspec &"\"& f1.name)
			ShowFolderList(folderspec &"\"& f1.name)
		Next
	End Sub

	Sub ShowFileList(folderspec)
		Dim fso, f, f1, fc, s,fwidth, i
		Set fso = server.CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set fc = f.Files
		i = 1
		For Each f1 in fc
			'response.write f1.name & "<br>"
'			If instr(folderspec, "backup") = 0 and instr(folderspec, "crjee") = 0 and instr(folderspec, "mobile") = 0 and LCase(Right(f1.name, 3)) = "asp" then
'			If LCase(Right(f1.name, 4)) = "html" Or LCase(Right(f1.name, 3)) = ".js" Or LCase(Right(f1.name, 3)) = "css" Or LCase(Right(f1.name, 3)) = "asp" then
			If LCase(Right(f1.name, 4)) = ".asp" then
			'MyFile1.WriteLine("copy " & folderspec &"\"& f1.name & " " & Replace(folderspec,"wwwroot","wwwroot2") &"\"& f1.name)
			spFolder = Split(folderspec, "\")

			For j = rCnt To fCnt
				ReDim Preserve arrFolder(j)
				arrFolder(j) = ""

				If j <= UBound(spFolder) Then
					arrFolder(j) = spFolder(j)
				End If
			Next




			spPgm = Split(f1.name, ".")
			spBiz = Split(spPgm(0), "_")
			Biz = spBiz(0)
			spTask = Split(spPgm(0), "_")
			Task = spTask(UBound(spTask))


			If Task = "list" Or Task = "view" Or Task = "edit" Or Task = "modify" Or Task = "write" Or Task = "reply" Or Task = "result" Or Task = "form" Then
				list = ""
				list = list & folderspec &"\"& f1.name
				list = list & Chr(9) & f1.name
				list = list & Chr(9) & "=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")"

				For j = rCnt To fCnt
					list = list & Chr(9) & arrFolder(j)
				Next

				If arrFolder(rCnt) = "home" Then
					list = list & Chr(9) & "경인홈"
				ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "admin" Then
					list = list & Chr(9) & "경인관리자"
				ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "manager" Then
					list = list & Chr(9) & "사랑방지기"
				ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "skin" Then
					list = list & Chr(9) & "사랑방"
				End If

				list = list & Chr(9) & biz
				list = list & Chr(9) & task

				sql = ""
				sql = sql & " select *        "
				sql = sql & "   from cf_z_pgm       "
				sql = sql & "  where file_path = '" & folderspec &"\"& f1.name & "' "
				rs.open Sql, conn, 3, 1

				If Not rs.EOF Then
					pgm_expl = rs("pgm_expl")
					pgm_url = rs("web_open")

					list = list & Chr(9) & pgm_expl
					list = list & Chr(9) & pgm_url
				Else
					pgm_url = Replace(folderspec &"\"& f1.name, root, "")
					pgm_url = Replace(pgm_url, "\", "/")

					list = list & Chr(9) & ""
					list = list & Chr(9) & "http://210.97.243.65" & pgm_url
				End If
				rs.close

				strText = LoadStream(folderspec &"\"& f1.name)
				arrSql = Split(strText, Chr(10))
				Dim dbName : dbName = ""

				If InStr(strText, "<button") Then
					i = 1
					For Each lineSql In arrSql
						fnct_nm = ""
						If InStr(lineSql, "<button") > 0 And InStr(lineSql, "menuSeq") = 0  And InStr(lineSql, "MovePage") = 0  And InStr(lineSql, "btnNext") = 0  Then
							lineSql = Right(lineSql, Len(lineSql) - InStr(lineSql, "<button"))
							fnct_nm = getGroup(lineSql, ">", "</button>")
							fnct_nm = Replace(fnct_nm, "</em>", "")
							fnct_nm1 = fnct_nm

							If InStr(fnct_nm, "if3") Then
								fnct_nm = getGroup(lineSql, """,""", """)")
								fnct_nm = Replace(fnct_nm, """", "")
							End If

							If InStr(fnct_nm, ">") Then
								Do While InStr(fnct_nm, ">")
								fnct_nm = Right(fnct_nm, Len(fnct_nm) - InStr(fnct_nm, ">"))
								Loop
							End If

							If fnct_nm = "" And fnct_nm1 <> "" Then
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & fnct_nm1
								Response.write "<br>" & fnct_nm
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
								Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
							End If

							If i = 1 Then
								list = list & Chr(9) & fnct_nm
								MyFile1.WriteLine(list)
							Else

								list = ""
								list = list & folderspec &"\"& f1.name
								list = list & Chr(9) & f1.name
								list = list & Chr(9) & "=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")"

								For j = rCnt To fCnt
									list = list & Chr(9) & arrFolder(j)
								Next

								If arrFolder(rCnt) = "home" Then
									list = list & Chr(9) & "경인홈"
								ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "admin" Then
									list = list & Chr(9) & "경인관리자"
								ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "manager" Then
									list = list & Chr(9) & "사랑방지기"
								ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "skin" Then
									list = list & Chr(9) & "사랑방"
								End If

								list = list & Chr(9) & biz
								list = list & Chr(9) & task
								list = list & Chr(9) & pgm_expl
								list = list & Chr(9) & ""'pgm_url
								list = list & Chr(9) & fnct_nm
								MyFile1.WriteLine(list)
							End If
							i = i + 1
						End If
					Next
				Else
					MyFile1.WriteLine(list)
					USE_YN = "Y"
				End If
	'			Fso.CopyFile folderspec &"\"& f1.name, folderspec &"\"& replace(f1.name, "_n.asp", ".asp") , false
	'			fso.deleteFile folderspec &"\"& f1.name
	'			MyFile2.WriteLine(PGM_CD & chr(9) & PGM_NM & chr(9) & PGM_URL & chr(9) & PGM_AUTH & chr(9) & MENU_CD & chr(9) & USE_YN & chr(9) & REGI_DATE & chr(9) & REGI_PSN & chr(9) & UPDT_DATE & chr(9) & UPDT_PSN)
				i = i + 1
				End If
			End If
		Next
	End Sub

	Function LoadStream(strPathName)
	'UTF-8 형식의 텍스트파일을 불러오는 사용자정의 함수입니다.
		
		Set objStream = CreateObject("ADODB.Stream")
		
		With objStream
			.Open
			.Type = 2 'adTypeText
			.Charset = "UTF-8"
			.LoadFromFile strPathName
			LoadStream = .ReadText
		End With
		
		Set objStream = Nothing
		
	End Function

	Sub CheckFolderList(folderspec)
		Dim fso, f, f1, s, sf,dwidth ,i
		Set fso = server.CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set sf = f.SubFolders

		For Each f1 in sf
			'MyFile1.WriteLine(dwidth & f1.name)
			'response.write dwidth &"<b>"& f1.name & "</b><br>"
			CheckFileList(folderspec &"\"& f1.name)
			CheckFolderList(folderspec &"\"& f1.name)
		Next
	End Sub

	Sub CheckFileList(folderspec)
		Dim fso, f, f1, fc, s,fwidth, i
		Set fso = server.CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set fc = f.Files
		i = 1
		For Each f1 in fc
			If LCase(Right(f1.name, 4)) = ".asp" then
				spFolder = Split(folderspec, "\")

				If fCnt < UBound(spFolder) Then
					fCnt = UBound(spFolder)
				End If
			End If
		Next
	End Sub

	Function getGroup(ByVal tg_str, ByVal st_str, ByVal ed_str) ' 문자열 사이의 값
		Response.write "<br>" & "re_str : " & tg_str & "  " & st_str & "  " & ed_str
		If InStr(tg_str, st_str) Then
			re_str = right(tg_str, Len(tg_str) - InStr(tg_str, st_str) - Len(st_str) + 1)
			re_str = Left(re_str, InStr(re_str, ed_str) - 1)
		Else
			re_str = tg_str
		End If

'		Response.write "re_str : " & re_str & "<br>"
		getGroup = re_str
	End Function

	Function getGroupA(ByVal tgStr, ByVal stStr, ByVal edStr)
		If InStr(tgStr, stStr) Then
			reStr = Right(tgStr, Len(tgStr) - InStr(tgStr, stStr) - Len(stStr) + 1)
			reStr = stStr & Left(reStr, InStr(reStr, edStr) - 1) & edStr
		Else
			reStr = ""
		End If
		getGroupA = reStr
	End Function
%>
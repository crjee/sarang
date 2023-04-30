'	Option Explicit
	Dim root,level, folder,folderspec
	Dim MyFile

	Set fso = CreateObject("Scripting.FileSystemObject")
'Response.write "D:\경인네트웍스\pgm\프로그램기능리스트 "&date&".xls"
	Set MyFile1 = fso.CreateTextFile("D:\경인네트웍스\pgm\프로그램기능리스트 "&date&".xls", True)
	
	root = "D:\경인네트웍스\pgm"

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

	list = list & Chr(9) & "업무"
	list = list & Chr(9) & "작업"
	list = list & Chr(9) & "화면열기"
'Response.write "<br>" & list
	MyFile1.WriteLine(list)

	call ShowFileList(root)
	call ShowFolderList(root)
	MsgBox "완료!"

	Sub ShowFolderList(folderspec)
		Dim fso, f, f1, s, sf,dwidth ,i
		Set fso = CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set sf = f.SubFolders

		For Each f1 in sf
			'MyFile1.WriteLine(dwidth & f1.name)
			''Response.write dwidth &"<b>"& f1.name & "</b><br>"
			ShowFileList(folderspec &"\"& f1.name)
			ShowFolderList(folderspec &"\"& f1.name)
		Next
	End Sub

	Sub ShowFileList(folderspec)
		Dim fso, f, f1, fc, s,fwidth, i
		Set fso = CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set fc = f.Files
		i = 1
		For Each f1 in fc
			''Response.write f1.name & "<br>"
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

			list = ""
			list = list & folderspec &"\"& f1.name
			list = list & Chr(9) & f1.name
			list = list & Chr(9) & "=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")"

			For j = rCnt To fCnt
				list = list & Chr(9) & arrFolder(j)
			Next

			list = list & Chr(9) & biz
			list = list & Chr(9) & task
			pgm_url = Replace(folderspec &"\"& f1.name, root, "")
			pgm_url = Replace(pgm_url, "\", "/")
			list = list & Chr(9) & "http://210.97.243.65" & pgm_url

			strText = LoadStream(folderspec &"\"& f1.name)
			arrSql = Split(strText, Chr(10))
			Dim dbName : dbName = ""

			If InStr(strText, "<button") Then
				i = 1
				For Each lineSql In arrSql
					fnct_nm = ""
					If InStr(lineSql, "<button") Then
						lineSql = Right(lineSql, Len(lineSql) - InStr(lineSql, "<button"))
						fnct_nm = getGroup(lineSql, ">", "</button>")

						If i = 1 Then
							list = list & Chr(9) & fnct_nm
							MyFile1.WriteLine(list)
						Else
							list = ""
							list = list & ""
							list = list & Chr(9) & ""
							list = list & Chr(9) & ""
							For j = rCnt To fCnt
								list = list & Chr(9) & ""
							Next
							list = list & Chr(9) & ""
							list = list & Chr(9) & ""
							list = list & Chr(9) & ""
							list = list & Chr(9) & fnct_nm
						End If
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
		Next
	End Sub

	Function LoadStream(FilePath)
'Response.write "<br>" & FilePath
		Dim objStream
		Set objStream = CreateObject("ADODB.Stream")
		objStream.Mode=3
		objStream.Type=2
		objStream.Charset = "utf-8"
		objStream.Open
		objStream.LoadFromFile FilePath
		LoadStream = objStream.Read
		objStream.Close
		Set objStream = Nothing
	End Function

	Sub CheckFolderList(folderspec)
		Dim fso, f, f1, s, sf,dwidth ,i
		Set fso = CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set sf = f.SubFolders

		For Each f1 in sf
			'MyFile1.WriteLine(dwidth & f1.name)
			''Response.write dwidth &"<b>"& f1.name & "</b><br>"
			CheckFileList(folderspec &"\"& f1.name)
			CheckFolderList(folderspec &"\"& f1.name)
		Next
	End Sub

	Sub CheckFileList(folderspec)
		Dim fso, f, f1, fc, s,fwidth, i
		Set fso = CreateObject("Scripting.FileSystemObject")

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
		'Response.write "<br>" & "re_str : " & tg_str & "  " & st_str & "  " & ed_str
		If InStr(tg_str, st_str) Then
			re_str = right(tg_str, Len(tg_str) - InStr(tg_str, st_str) - Len(st_str) + 1)
			re_str = Left(re_str, InStr(re_str, ed_str) - 1)
		Else
			re_str = tg_str
		End If

'		'Response.write "re_str : " & re_str & "<br>"
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

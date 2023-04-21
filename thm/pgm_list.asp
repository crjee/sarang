<%@Language="VBScript" CODEPAGE="65001" %>
<%
	freePage = True
%>
<!--#include  virtual="/include/config_inc.asp"-->
<!DOCTYPE html>
<html lang="kr">
<head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>GI</title>
	<link rel="stylesheet" type="text/css" href="/common/css/base.css" />
	<script src="/common/js/jquery-3.6.0.min.js"></script>
	<script src="/common/js/jquery-ui.min.js"></script>
	<script src="/common/js/slick.min.js"></script>
	<script src="/common/js/common.js"></script>
	<script src="/common/js/cafe.js"></script>
</head>
<body>
		<main id="main" class="main">
				<div class="cont_tit">
					<h2 class="h2"><%=menu_name%></h2>
				</div>
<%
'	Option Explicit
	Dim root,level, folder,folderspec
	Dim MyFile
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Application("db")
	Set rs = Server.CreateObject ("ADODB.Recordset")

	auth_url = Server.MapPath("\")
	Set fso = server.CreateObject("Scripting.FileSystemObject")
	Set MyFile1 = fso.CreateTextFile("D:\경인네트웍스\sarang\thm\프로그램기능리스트 "&date&".xls", True)
	
	root = "D:\경인네트웍스\sarang"

	Dim rCnt, fCnt
	rCnt = UBound(Split(root, "\")) + 1

	call CheckFolderList(root)
	Dim arrFolder()

	list = "" : list2 = list
	list = list & "<div class='tb'>" & vbcrlf : list2 = list
	MyFile1.WriteLine(list)

	list = "" : list2 = list
	list = list & "<table border=1>" & vbcrlf   : list2 = list
	list = list & "<colgroup>" & vbcrlf         : list2 = list
	list = list & "<col width=0 />" & vbcrlf    ': list2 = list ' 경로</td>
	list = list & "<col  />" & vbcrlf           : list2 = list ' <td>파일명</td>
	list = list & "<col width=0 />" & vbcrlf    ': list2 = list' <td>열기</td>

	i = 1
	For j = rCnt To fCnt
		list = list & "<col  />" & vbcrlf : list2 = list '<td>폴더" & i & "</td>
		i = i + 1
	Next

	list = list & "<col width=0 />" & vbcrlf  : list2 = list ' <td>구분</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         ': list2 = list ' <td>업무</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         : list2 = list ' <td>작업</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         : list2 = list ' <td>프로그램설명</td>" & vbcrlf
	list = list & "<col  />" & vbcrlf         : list2 = list ' <td>화면열기</td>" & vbcrlf   
	list = list & "<col  />" & vbcrlf         : list2 = list ' <td>기능</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         : list2 = list ' <td>점검결과</td>" & vbcrlf   
	list = list & "<col  />" & vbcrlf         : list2 = list ' <td>오류내용</td>" & vbcrlf   
	list = list & "</colgroup>" & vbcrlf      : list2 = list
	MyFile1.WriteLine(list)
	response.write list2

	list = ""
	list = list & "<thead>" & vbcrlf                   : list2 = list
	list = list & "<tr bgcolor='skyblue'>" & vbcrlf    : list2 = list' <tr bgcolor='skyblue'>"
	list = list & "<th scope='col'>경로</th>" & vbcrlf   ': list2 = list ' <td>경로</td>" & vbcrlf
	list = list & "<th scope='col'>파일명</th>" & vbcrlf : list2 = list ' <td>파일명</td>" & vbcrlf
	list = list & "<th scope='col'>열기</th>" & vbcrlf  ': list2 = list ' <td>열기</td>" & vbcrlf

	i = 1
	For j = rCnt To fCnt
		list = list & "<th scope='col'>폴더" & i & "</th>" & vbcrlf : list2 = list ' <td>폴더" & i & "</td>
		i = i + 1
	Next

	list = list & "<th scope='col'>구분</th>" & vbcrlf         : list2 = list ' <td>구분</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>업무</th>" & vbcrlf         ': list2 = list ' <td>업무</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>작업</th>" & vbcrlf         : list2 = list ' <td>작업</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>프로그램설명</th>" & vbcrlf    : list2 = list ' <td>프로그램설명</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>화면열기</th>" & vbcrlf      : list2 = list ' <td>화면열기</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>기능</th>" & vbcrlf         : list2 = list ' <td>기능</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>점검결과</th>" & vbcrlf       : list2 = list ' <td>점검결과</td>" & vbcrlf : list2 = list
	list = list & "<th scope='col'>오류내용</th>" & vbcrlf       : list2 = list ' <td>오류내용</td>" & vbcrlf : list2 = list
	list = list & "</tr>" & vbcrlf                            : list2 = list
	list = list & "</thead>" & vbcrlf                         : list2 = list
	list = list & "<tbody>" & vbcrlf                          : list2 = list
	MyFile1.WriteLine(list)
	response.write list2

	call ShowFileList(root)
	call ShowFolderList(root)

	list = ""
	list = list & "<tbody>" & vbcrlf : list2 = list
	list = list & "</table>" & vbcrlf : list2 = list
	list = list & "</div>" & vbcrlf : list2 = list
	MyFile1.WriteLine(list)
	response.write list2

	Sub ShowFolderList(folderspec)
		Dim fso, f, f1, s, sf,dwidth ,i
		Set fso = server.CreateObject("Scripting.FileSystemObject")

		Set f = fso.GetFolder(folderspec)
		Set sf = f.SubFolders

		For Each f1 in sf
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
			If LCase(Right(f1.name, 4)) = ".asp" then
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
				spwork_nm = Split(spPgm(0), "_")
				work_nm = spwork_nm(UBound(spwork_nm))

				If arrFolder(rCnt) = "cafe" Or arrFolder(rCnt) = "home" Then
'					If work_nm = "list" Or work_nm = "view" Or work_nm = "edit" Or work_nm = "modify" Or work_nm = "write" Or work_nm = "reply" Or work_nm = "result" Or work_nm = "form" Then
					If 1=1 Then
						list = ""
						list = list & "<tr>" & vbcrlf                                                                        : list2 = list
						list = list & "<td>" & folderspec &"\"& f1.name & "</td>" & vbcrlf                                  ': list2 = list
						list = list & "<td>" & f1.name & "</td>" & vbcrlf                                                    : list2 = list
						list = list & "<td>=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")" & "</td>" & vbcrlf ': list2 = list

						For j = rCnt To fCnt
							list = list & "<td>" & arrFolder(j) & "</td>" & vbcrlf : list2 = list
							Select case j = 1
								Case 1
								folder1 = arrFolder(j)
								Case 2
								folder2 = arrFolder(j)
								Case 3
								folder3 = arrFolder(j)
								Case 4
								folder4 = arrFolder(j)
							End Select
						Next

						folder1 = ""
						folder2 = ""
						folder3 = ""
						folder4 = ""
						If arrFolder(rCnt) = "home" Then
							list = list & "<td>경인홈</td>" & vbcrlf : list2 = list
						ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "admin" Then
							list = list & "<td>경인관리자</td>" & vbcrlf : list2 = list
						ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "manager" Then
							list = list & "<td>사랑방지기</td>" & vbcrlf : list2 = list
						ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "skin" Then
							list = list & "<td>사랑방</td>" & vbcrlf : list2 = list
						End If

						list = list & "<td>" & biz & "</td>" & vbcrlf     ': list2 = list
						list = list & "<td>" & work_nm & "</td>" & vbcrlf : list2 = list

						sql = ""
						sql = sql & " select *        "
						sql = sql & "   from cf_z_pgm       "
						sql = sql & "  where file_path = '" & folderspec &"\"& f1.name & "' "
						rs.open Sql, conn, 3, 1

						If Not rs.EOF Then
							pgm_expl = rs("pgm_expl")
							pgm_url = rs("web_open")

							sql = ""
							sql = sql & " update cf_z_pgm                                      "
							sql = sql & "    set use_yn = 'S'                                  "
							sql = sql & " where file_path = '" & folderspec &"\"& f1.name & "' "
							Conn.execute sql

							list = list & "<td>" & pgm_expl & "</td>" & vbcrlf : list2 = list
							list = list & "<td><a href='" & pgm_url & "' target='_blank'>" & pgm_url & "</a></td>" & vbcrlf : list2 = list
						Else
							pgm_expl = ""
							pgm_url = Replace(folderspec &"\"& f1.name, root, "")
							pgm_url = Replace(pgm_url, "\", "/")

							file_path   = folderspec &"\"& f1.name
							file_name   = f1.name
							file_open   = "=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")"
							folder1     = folder1
							folder2     = folder2
							folder3     = folder3
							folder4     = folder4
							biz         = biz
							wrk_nm      = wrk_nm
							pgm_expl    = pgm_expl
							pgm_fnct_nm = pgm_fnct_nm
							web_open    = ConfigURL & "/" & Replace(Replace(file_path, root, ""), "\", "/")
							use_yn      = "Y"

							pgm_id = getSeq("cf_z_pgm")

							sql = ""
							sql = sql & " insert into cf_z_pgm( "
							sql = sql & "        pgm_id      "
							sql = sql & "       ,file_path   "
							sql = sql & "       ,file_name   "
							sql = sql & "       ,file_open   "
							sql = sql & "       ,folder1     "
							sql = sql & "       ,folder2     "
							sql = sql & "       ,folder3     "
							sql = sql & "       ,folder4     "
							sql = sql & "       ,biz         "
							sql = sql & "       ,wrk_nm      "
							sql = sql & "       ,pgm_expl    "
							sql = sql & "       ,pgm_fnct_nm "
							sql = sql & "       ,web_open    "
							sql = sql & "       ,use_yn      "
							sql = sql & "       ,credt       "
							sql = sql & "      ) values("
							sql = sql & "        '" & pgm_id   & "' "
							sql = sql & "       ,'" & file_path   & "' "
							sql = sql & "       ,'" & file_name   & "' "
							sql = sql & "       ,'" & file_open   & "' "
							sql = sql & "       ,'" & folder1     & "' "
							sql = sql & "       ,'" & folder2     & "' "
							sql = sql & "       ,'" & folder3     & "' "
							sql = sql & "       ,'" & folder4     & "' "
							sql = sql & "       ,'" & biz         & "' "
							sql = sql & "       ,'" & wrk_nm      & "' "
							sql = sql & "       ,'" & pgm_expl    & "' "
							sql = sql & "       ,'" & pgm_fnct_nm & "' "
							sql = sql & "       ,'" & web_open    & "' "
							sql = sql & "       ,'" & use_yn      & "' "
							sql = sql & "       ,getdate()             "
							sql = sql & " ) "
Response.write sql
							Conn.execute sql

							list = list & "<td></td>" & vbcrlf : list2 = list
							list = list & "<td><a href='http://210.97.243.65" & pgm_url & "' target='_blank'>http://210.97.243.65" & pgm_url & "</a></td>" & vbcrlf : list2 = list
						End If
						rs.close

						strText = LoadStream(folderspec &"\"& f1.name)
						arrSql = Split(strText, Chr(10))
						Dim dbName : dbName = ""

						If InStr(strText, "<button") Then
							i = 1
							For Each lineSql In arrSql
								pgm_fnct_nm = ""
								If InStr(lineSql, "<button") > 0 And InStr(lineSql, "menuSeq") = 0  And InStr(lineSql, "MovePage") = 0  And InStr(lineSql, "btnNext") = 0  Then
									lineSql = Right(lineSql, Len(lineSql) - InStr(lineSql, "<button"))
									pgm_fnct_nm = getGroup(lineSql, ">", "</button>")
									pgm_fnct_nm = Replace(pgm_fnct_nm, "</em>", "")
									fnct_nm1 = pgm_fnct_nm

									If InStr(pgm_fnct_nm, "if3") Then
										pgm_fnct_nm = getGroup(lineSql, """,""", """)")
										pgm_fnct_nm = Replace(pgm_fnct_nm, """", "")
									End If

									If InStr(pgm_fnct_nm, ">") Then
										Do While InStr(pgm_fnct_nm, ">")
										pgm_fnct_nm = Right(pgm_fnct_nm, Len(pgm_fnct_nm) - InStr(pgm_fnct_nm, ">"))
										Loop
									End If

									If pgm_fnct_nm = "" And fnct_nm1 <> "" Then
										'Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
										'Response.write "<br>" & fnct_nm1
										'Response.write "<br>" & pgm_fnct_nm
										'Response.write "<br>" & "Ssssssssssssssssssssssssssssssssss"
									End If

									If i = 1 Then
										list = list & "<td>" & pgm_fnct_nm & "</td>" & vbcrlf : list2 = list
										list = list & "</tr>" & vbcrlf : list2 = list
										MyFile1.WriteLine(list)
			response.write list2
									Else
										list = ""
										list = list & "<tr>" & vbcrlf : list2 = list
										list = list & "<td>" & folderspec &"\"& f1.name & "</td>" & vbcrlf ': list2 = list
										list = list & "<td>" & f1.name & "</td>" & vbcrlf : list2 = list
										list = list & "<td>=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")" & "</td>" & vbcrlf ': list2 = list

										For j = rCnt To fCnt
											list = list & "<td>" & arrFolder(j) & "</td>" & vbcrlf : list2 = list
										Next

										If arrFolder(rCnt) = "home" Then
											list = list & "<td>경인홈</td>" & vbcrlf : list2 = list
										ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "admin" Then
											list = list & "<td>경인관리자</td>" & vbcrlf : list2 = list
										ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "manager" Then
											list = list & "<td>사랑방지기</td>" & vbcrlf : list2 = list
										ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "skin" Then
											list = list & "<td>사랑방</td>" & vbcrlf : list2 = list
										End If

										list = list & "<td>" & biz & "</td>" & vbcrlf ': list2 = list
										list = list & "<td>" & work_nm & "</td>" & vbcrlf : list2 = list
										list = list & "<td>" & pgm_expl & "</td>" & vbcrlf : list2 = list
										list = list & "<td></td>" & vbcrlf : list2 = list'pgm_url
										list = list & "<td>" & pgm_fnct_nm & "</td>" & vbcrlf : list2 = list
										list = list & "</tr>" & vbcrlf : list2 = list
										MyFile1.WriteLine(list)
			response.write list2
									End If
									i = i + 1
								End If
							Next
						Else
							MyFile1.WriteLine(list)
			response.write list2
							USE_YN = "Y"
						End If
						i = i + 1
					End If
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
%>
		</main>
	</div>
</body>
</html>

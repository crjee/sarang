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
					<h2 class="h2"><a href="/sys/프로그램기능리스트 <%=date%>.xls">리스트</a></h2>
				</div>
<%
'	Option Explicit
	Dim root,level, folder,folderspec
	Dim MyFile
	Set Conn = Server.CreateObject("ADODB.Connection")
	Conn.Open Application("db")
	Set rs = Server.CreateObject("ADODB.Recordset")

	auth_url = Server.MapPath("\")
	Set fso = server.CreateObject("Scripting.FileSystemObject")
	Set pgm_excel  = fso.CreateTextFile("D:\경인네트웍스\sarang\sys\프로그램기능리스트 "&date&".xls", True)
	Set pgm_list   = fso.CreateTextFile("D:\경인네트웍스\sarang\sys\pgm_list   기능리스트 "&date&".txt", True)
	Set pgm_write  = fso.CreateTextFile("D:\경인네트웍스\sarang\sys\pgm_write  기능리스트 "&date&".txt", True)
	Set pgm_view   = fso.CreateTextFile("D:\경인네트웍스\sarang\sys\pgm_view   기능리스트 "&date&".txt", True)
	Set pgm_modify = fso.CreateTextFile("D:\경인네트웍스\sarang\sys\pgm_modify 기능리스트 "&date&".txt", True)


	root = "D:\경인네트웍스\sarang"
	home_up_list_btn_inc = LoadStream(root & "\home\home_up_list_btn_inc.asp")
	home_up_view_btn_inc = LoadStream(root & "\home\home_up_view_btn_inc.asp")

	Dim rCnt, fCnt
	rCnt = UBound(Split(root, "\")) + 1

	Call CheckFolderList(root)
	Dim arrFolder()

	list = "" ': ddd
	list = list & "<div class='tb'>" & vbcrlf ': ddd
	pgm_excel.WriteLine(list)

	list = "" ': ddd
	list = list & "<table border=1>" & vbcrlf   ': ddd
	list = list & "<colgroup>" & vbcrlf         ': ddd
	list = list & "<col width=0 />" & vbcrlf    ': ddd ' 경로</td>
	list = list & "<col  />" & vbcrlf           ': ddd ' <td>파일명</td>
	list = list & "<col width=0 />" & vbcrlf    ': ddd' <td>열기</td>

	i = 1
	For j = rCnt To fCnt
		list = list & "<col  />" & vbcrlf ': ddd '<td>폴더" & i & "</td>
		i = i + 1
	Next

	list = list & "<col width=0 />" & vbcrlf  ': ddd ' <td>구분</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>업무</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>작업</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>프로그램설명</td>" & vbcrlf
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>화면열기</td>" & vbcrlf   
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>기능</td>" & vbcrlf      
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>점검결과</td>" & vbcrlf   
	list = list & "<col  />" & vbcrlf         ': ddd ' <td>오류내용</td>" & vbcrlf   
	list = list & "</colgroup>" & vbcrlf      ': ddd
	pgm_excel.WriteLine(list)
	response.write list

	list = ""
	list = list & "<thead>" & vbcrlf                   ': ddd
	list = list & "<tr bgcolor='skyblue'>" & vbcrlf    ': ddd' <tr bgcolor='skyblue'>"
	list = list & "<th scope='col'>경로</th>" & vbcrlf   ': ddd ' <td>경로</td>" & vbcrlf
	list = list & "<th scope='col'>파일명</th>" & vbcrlf ': ddd ' <td>파일명</td>" & vbcrlf
	list = list & "<th scope='col'>열기</th>" & vbcrlf  ': ddd ' <td>열기</td>" & vbcrlf

	i = 1
	For j = rCnt To fCnt
		list = list & "<th scope='col'>폴더" & i & "</th>" & vbcrlf ': ddd ' <td>폴더" & i & "</td>
		i = i + 1
	Next

	list = list & "<th scope='col'>구분</th>" & vbcrlf         ': ddd ' <td>구분</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>업무</th>" & vbcrlf         ': ddd ' <td>업무</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>작업</th>" & vbcrlf         ': ddd ' <td>작업</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>프로그램설명</th>" & vbcrlf    ': ddd ' <td>프로그램설명</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>화면열기</th>" & vbcrlf      ': ddd ' <td>화면열기</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>기능</th>" & vbcrlf         ': ddd ' <td>기능</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>점검결과</th>" & vbcrlf       ': ddd ' <td>점검결과</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>오류내용</th>" & vbcrlf       ': ddd ' <td>오류내용</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>권한체크1</th>" & vbcrlf       ': ddd ' <td>오류내용</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>권한체크2</th>" & vbcrlf       ': ddd ' <td>오류내용</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>권한체크3</th>" & vbcrlf       ': ddd ' <td>오류내용</td>" & vbcrlf ': ddd
	list = list & "<th scope='col'>권한체크4</th>" & vbcrlf       ': ddd ' <td>오류내용</td>" & vbcrlf ': ddd
	list = list & "</tr>" & vbcrlf                            ': ddd
	list = list & "</thead>" & vbcrlf                         ': ddd
	list = list & "<tbody>" & vbcrlf                          ': ddd
	pgm_excel.WriteLine(list)
	response.write list

	Call ShowFileList(root)
	Call ShowFolderList(root)

	list = ""
	list = list & "<tbody>" & vbcrlf ': ddd
	list = list & "</table>" & vbcrlf ': ddd
	list = list & "</div>" & vbcrlf ': ddd
	pgm_excel.WriteLine(list)
	response.write list

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
			If LCase(Right(f1.name, 4)) = ".asp" And Not (f1.name = "home_up_list_btn_inc.asp" Or f1.name = "home_up_view_btn_inc.asp") Then
				spFolder = Split(folderspec, "\")

				If InStr(f1.name, "list.asp") Then
					pgm_list.WriteLine("")
					pgm_list.WriteLine(folderspec &"\"& f1.name)
				End If
				If InStr(f1.name, "write.asp") Then
					pgm_write.WriteLine("")
					pgm_write.WriteLine(folderspec &"\"& f1.name)
				End If
				If InStr(f1.name, "view.asp") Then
					pgm_view.WriteLine("")
					pgm_view.WriteLine(folderspec &"\"& f1.name)
				End If
				If InStr(f1.name, "modify.asp") Then
					pgm_modify.WriteLine("")
					pgm_modify.WriteLine(folderspec &"\"& f1.name)
				End If

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
						list = list & "<tr>" & vbcrlf                                                                        ': --
						list = list & "<td>" & folderspec &"\"& f1.name & "</td>" & vbcrlf                                   ': 경로
						list = list & "<td>" & f1.name & "</td>" & vbcrlf                                                    ': 파일명
						list = list & "<td>=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")" & "</td>" & vbcrlf  ': 열기
' 경로      
' 파일명    
' 열기      
' 폴더1     
' 폴더2     
' 폴더3     
' 폴더4     
' 구분      
' 업무      
' 작업      
' 프로그램설명
' 화면열기   
' 기능      
' 점검결과   
' 오류내용   
						For j = rCnt To fCnt
							list = list & "<td>" & arrFolder(j) & "</td>" & vbcrlf ': 폴더1,폴더2,폴더3,폴더4
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
						If arrFolder(rCnt) = "home" And arrFolder(rCnt+1) = "admin" Then
							list = list & "<td>경인관리자</td>" & vbcrlf                                                      ': ddd
						ElseIf arrFolder(rCnt) = "home" Then
							list = list & "<td>경인홈</td>" & vbcrlf                                                          ': ddd
						ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "manager" Then
							list = list & "<td>사랑방지기</td>" & vbcrlf                                                      ': ddd
						ElseIf arrFolder(rCnt) = "cafe" Then
							list = list & "<td>사랑방</td>" & vbcrlf                                                         ': ddd
						Else
							list = list & "<td>사랑방</td>" & vbcrlf ': 구분
						End If

						list = list & "<td>" & biz & "</td>" & vbcrlf     ': 업무
						list = list & "<td>" & work_nm & "</td>" & vbcrlf ': 작업

						sql = ""
						sql = sql & " select *                                              "
						sql = sql & "   from cf_z_pgm                                       "
						sql = sql & "  where file_path = '" & folderspec &"\"& f1.name & "' "
						rs.open Sql, conn, 3, 1

						If Not rs.EOF Then
							pgm_expl = rs("pgm_expl")
							pgm_url = rs("web_open")
							pgm_url = Replace(folderspec &"\"& f1.name, root, "")
							pgm_url = Replace(pgm_url, "\", "/")

							sql = ""
							sql = sql & " update cf_z_pgm                                      "
							sql = sql & "    set use_yn = 'S'                                  "
							sql = sql & " where file_path = '" & folderspec &"\"& f1.name & "' "
							Conn.execute sql

							list = list & "<td>" & pgm_expl & "</td>" & vbcrlf                                              ': 프로그램설명
'							list = list & "<td><a href='" & pgm_url & "' target='_blank'>" & pgm_url & "</a></td>" & vbcrlf ': 화면열기
							list = list & "<td><a href='http://210.97.243.65" & pgm_url & "' target='_blank'>http://210.97.243.65" & pgm_url & "</a></td>" & vbcrlf ': 화면열기
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

							pgm_id = GetComSeq("cf_z_pgm")

							sql = ""
							sql = sql & " insert into cf_z_pgm(        "
							sql = sql & "        pgm_id                "
							sql = sql & "       ,file_path             "
							sql = sql & "       ,file_name             "
							sql = sql & "       ,file_open             "
							sql = sql & "       ,folder1               "
							sql = sql & "       ,folder2               "
							sql = sql & "       ,folder3               "
							sql = sql & "       ,folder4               "
							sql = sql & "       ,biz                   "
							sql = sql & "       ,wrk_nm                "
							sql = sql & "       ,pgm_expl              "
							sql = sql & "       ,pgm_fnct_nm           "
							sql = sql & "       ,web_open              "
							sql = sql & "       ,use_yn                "
							sql = sql & "       ,credt                 "
							sql = sql & "      ) values(               "
							sql = sql & "        '" & pgm_id      & "' "
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

							list = list & "<td></td>" & vbcrlf                                                                                                      ': 프로그램설명
							list = list & "<td><a href='http://210.97.243.65" & pgm_url & "' target='_blank'>http://210.97.243.65" & pgm_url & "</a></td>" & vbcrlf ': 화면열기
						End If
						rs.close

						strText = LoadStream(folderspec &"\"& f1.name)
						strText = Replace(strText, "home_up_list_btn_inc", home_up_list_btn_inc)
						strText = Replace(strText, "home_up_view_btn_inc", home_up_view_btn_inc)

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
										list = list & "<td>" & pgm_fnct_nm & "</td>" & vbcrlf ': 기능

										Select Case work_nm
											Case "list"
												pgm_list.WriteLine(lineSql)
											Case "write"
												pgm_write.WriteLine(lineSql)
											Case "view"
												pgm_view.WriteLine(lineSql)
											Case "modify"
												pgm_modify.WriteLine(lineSql)
											Case Else
										End Select
' 기능      
' 점검결과   
' 오류내용   
										list = list & "<td></td>" & vbcrlf  ': 점검결과
										list = list & "<td></td>" & vbcrlf  ': 오류내용

										If InStr(strText, "Call Check") Then
											i = 1
											strCall = ""
											For Each lineSql2 In arrSql
												If InStr(lineSql2, "Call Check") Then
lineSql2 = Replace(lineSql2, trim("Call CheckAdmin()                      "), "CheckAdmin()                       : 경인관리자여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckCafeMember(cafe_id)          "), "CheckCafeMember(cafe_id)           : 사랑방회원여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckDailyCount(cafe_id)          "), "CheckDailyCount(cafe_id)           : 1일등록갯수초과여부")
lineSql2 = Replace(lineSql2, trim("Call CheckDataExist(com_seq)           "), "CheckDataExist(com_seq)            : 데이터존재여부")
lineSql2 = Replace(lineSql2, trim("Call CheckLogin()                      "), "CheckLogin()                       : 로그인여부")
lineSql2 = Replace(lineSql2, trim("Call CheckManager(cafe_id)             "), "CheckManager(cafe_id)              : 사랑방관리자여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckMemoSendAuth(cafe_id)        "), "CheckMemoSendAuth(cafe_id)         : 쪽지발송가능여부-정회원(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckMenuSeq(cafe_id, menu_seq)   "), "CheckMenuSeq(cafe_id, menu_seq)    : 정상접근여부(카페아이디/메뉴번호)")
lineSql2 = Replace(lineSql2, trim("Call CheckModifyAuth(cafe_id)          "), "CheckModifyAuth(cafe_id)           : 수정가능여부(본인 또는 사랑방관리자)")
lineSql2 = Replace(lineSql2, trim("Call CheckMultipart()                  "), "CheckMultipart()                   : 게시판등록/수정실행정상접근여부")
lineSql2 = Replace(lineSql2, trim("Call CheckReadAuth(cafe_id)            "), "CheckReadAuth(cafe_id)             : 읽기가능여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckReplyAuth(cafe_id)           "), "CheckReplyAuth(cafe_id)            : 답글가능여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckWasteExist(com_seq)          "), "CheckWasteExist(com_seq)           : 휴지통데이터존재여부")
lineSql2 = Replace(lineSql2, trim("Call CheckWriteAuth(cafe_id)           "), "CheckWriteAuth(cafe_id)            : 쓰기가능여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call SetViewCnt(""notice"", notice_seq)"), "SetViewCnt(""notice"", notice_seq) : 게시물조회수증가(1일1회)")
lineSql2 = Replace(lineSql2, trim("Call SetViewCnt(menu_type, com_seq)    "), "SetViewCnt(menu_type, com_seq)     : 게시물조회수증가(1일1회)")


													strCall = strCall & "<td>" & lineSql2 & "</td>"
												End If
											Next
										Else
											strCall = ""
										End If

										list = list & strCall & vbcrlf ': ddd
										list = list & "</tr>" & vbcrlf ': ddd
										pgm_excel.WriteLine(list)
			response.write list
									Else
										list = ""
										list = list & "<tr>" & vbcrlf                                                                       ': ddd
										list = list & "<td>" & folderspec &"\"& f1.name & "</td>" & vbcrlf                                  ': ddd
										list = list & "<td>" & f1.name & "</td>" & vbcrlf                                                   ': ddd
										list = list & "<td>=HYPERLINK(""file://"&folderspec &"\"& f1.name&""", ""열기"")" & "</td>" & vbcrlf ': ddd

										For j = rCnt To fCnt
											list = list & "<td>" & arrFolder(j) & "</td>" & vbcrlf                                          ': ddd
										Next

										If arrFolder(rCnt) = "home" And arrFolder(rCnt+1) = "admin" Then
											list = list & "<td>경인관리자</td>" & vbcrlf                                                      ': ddd
										ElseIf arrFolder(rCnt) = "home" Then
											list = list & "<td>경인홈</td>" & vbcrlf                                                          ': ddd
										ElseIf arrFolder(rCnt) = "cafe" And arrFolder(rCnt+1) = "manager" Then
											list = list & "<td>사랑방지기</td>" & vbcrlf                                                      ': ddd
										ElseIf arrFolder(rCnt) = "cafe" Then
											list = list & "<td>사랑방</td>" & vbcrlf                                                         ': ddd
										End If

										list = list & "<td>" & biz & "</td>" & vbcrlf                                                       ': ddd
										list = list & "<td>" & work_nm & "</td>" & vbcrlf                                                   ': ddd
										list = list & "<td>" & pgm_expl & "</td>" & vbcrlf                                                  ': ddd
										list = list & "<td></td>" & vbcrlf                                                                  ': ddd'pgm_url
										list = list & "<td>" & pgm_fnct_nm & "</td>" & vbcrlf                                               ': ddd

										Select Case work_nm
											Case "list"
												pgm_list.WriteLine(lineSql)
											Case "write"
												pgm_write.WriteLine(lineSql)
											Case "view"
												pgm_view.WriteLine(lineSql)
											Case "modify"
												pgm_modify.WriteLine(lineSql)
											Case Else
										End Select

										list = list & "</tr>" & vbcrlf ': ddd
										pgm_excel.WriteLine(list)
			response.write list
									End If
									i = i + 1
								End If
							Next
						Else
							list = list & "<td></td>" & vbcrlf  ': 기능
							list = list & "<td></td>" & vbcrlf  ': 점검결과
							list = list & "<td></td>" & vbcrlf  ': 오류내용

							If InStr(strText, "Call Check") Then
								i = 1
								strCall = ""
								For Each lineSql2 In arrSql
									If InStr(lineSql2, "Call Check") Then
lineSql2 = Replace(lineSql2, trim("Call CheckAdmin()                      "), "CheckAdmin()                       : 경인관리자여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckCafeMember(cafe_id)          "), "CheckCafeMember(cafe_id)           : 사랑방회원여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckDailyCount(cafe_id)          "), "CheckDailyCount(cafe_id)           : 1일등록갯수초과여부")
lineSql2 = Replace(lineSql2, trim("Call CheckDataExist(com_seq)           "), "CheckDataExist(com_seq)            : 데이터존재여부")
lineSql2 = Replace(lineSql2, trim("Call CheckLogin()                      "), "CheckLogin()                       : 로그인여부")
lineSql2 = Replace(lineSql2, trim("Call CheckManager(cafe_id)             "), "CheckManager(cafe_id)              : 사랑방관리자여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckMemoSendAuth(cafe_id)        "), "CheckMemoSendAuth(cafe_id)         : 쪽지발송가능여부-정회원(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckMenuSeq(cafe_id, menu_seq)   "), "CheckMenuSeq(cafe_id, menu_seq)    : 정상접근여부(카페아이디/메뉴번호)")
lineSql2 = Replace(lineSql2, trim("Call CheckModifyAuth(cafe_id)          "), "CheckModifyAuth(cafe_id)           : 수정가능여부(본인 또는 사랑방관리자)")
lineSql2 = Replace(lineSql2, trim("Call CheckMultipart()                  "), "CheckMultipart()                   : 게시판등록/수정실행정상접근여부")
lineSql2 = Replace(lineSql2, trim("Call CheckReadAuth(cafe_id)            "), "CheckReadAuth(cafe_id)             : 읽기가능여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckReplyAuth(cafe_id)           "), "CheckReplyAuth(cafe_id)            : 답글가능여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call CheckWasteExist(com_seq)          "), "CheckWasteExist(com_seq)           : 휴지통데이터존재여부")
lineSql2 = Replace(lineSql2, trim("Call CheckWriteAuth(cafe_id)           "), "CheckWriteAuth(cafe_id)            : 쓰기가능여부(로그인여부 포함)")
lineSql2 = Replace(lineSql2, trim("Call SetViewCnt(""notice"", notice_seq)"), "SetViewCnt(""notice"", notice_seq) : 게시물조회수증가(1일1회)")
lineSql2 = Replace(lineSql2, trim("Call SetViewCnt(menu_type, com_seq)    "), "SetViewCnt(menu_type, com_seq)     : 게시물조회수증가(1일1회)")
										strCall = strCall & "<td>" & lineSql2 & "</td>"
									End If
								Next
							Else
								strCall = ""
							End If

							list = list & strCall & vbcrlf ': ddd
							list = list & "</tr>" & vbcrlf ': ddd
							pgm_excel.WriteLine(list)
			response.write list
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
			Call CheckFileList(folderspec &"\"& f1.name)
			Call CheckFolderList(folderspec &"\"& f1.name)
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

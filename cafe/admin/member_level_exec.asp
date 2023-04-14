<%@Language="VBScript" CODEPAGE="65001" %>
<!--#include  virtual="/include/config_inc.asp"-->
<%
	Call checkAdmin()

	Set rs = Server.CreateObject ("ADODB.Recordset")
	Set rs2 = Server.CreateObject ("ADODB.Recordset")

	For i = 1 To Request("chk_user").count
		user_id = Request("chk_user")(i)
		cafe_id = Request("cafe_id_" & user_id)
		cafe_mb_level = Request("cafe_mb_level_" & user_id)
		union_id = Request("union_id_" & user_id)
		union_mb_level = Request("union_mb_level_" & user_id)

		sql = ""
		sql = sql & " select * "
		sql = sql & "   from cf_cafe_member "
		sql = sql & "  where user_id = '" & user_id & "' "
		sql = sql & "    and cafe_id = '" & cafe_id & "' "
		sql = sql & "    and stat = 'Y' "
		rs.open sql, Conn, 3, 1

		If Not rs.eof Then ' 기존 사랑방 회원이면
			If cafe_mb_level <> CStr(rs("cafe_mb_level")) Then
				' 이전 사랑방 히스토리 저장
				sql = ""
				sql = sql & " insert into cf_cafe_member_history( "
				sql = sql & "        cafe_id "
				sql = sql & "       ,user_id "
				sql = sql & "       ,cafe_mb_level "
				sql = sql & "       ,remark "
				sql = sql & "       ,stdate "
				sql = sql & "       ,eddate "
				sql = sql & "       ,creid "
				sql = sql & "       ,credt "
				sql = sql & "      ) "
				sql = sql & " select cafe_id "
				sql = sql & "       ,user_id "
				sql = sql & "       ,cafe_mb_level "
				sql = sql & "       ,'사랑방 등급변경(관리자)' "
				sql = sql & "       ,stdate "
				sql = sql & "       ,getdate() "
				sql = sql & "       ,'" & Session("user_id") & "' "
				sql = sql & "       ,getdate() "
				sql = sql & "   from cf_cafe_member "
				sql = sql & "  where user_id = '" & user_id & "' "
				sql = sql & "    and cafe_id = '" & cafe_id & "' "
				Conn.Execute(sql)

				' 사랑방 등급 변경
				sql = ""
				sql = sql & " update cf_cafe_member "
				sql = sql & "    set cafe_mb_level = '" & cafe_mb_level & "' "
				sql = sql & "       ,modid = '" & Session("user_id") & "' "
				sql = sql & "       ,moddt = getdate() "
				sql = sql & "  where user_id = '" & user_id & "' "
				sql = sql & "    and cafe_id = '" & cafe_id & "' "
				Conn.Execute(sql)

				If Not(cafe_mb_level = "2" Or cafe_mb_level = "10") Then ' 연합회지기 삭제
				End If
			End If

			If union_id <> "" Then
				If union_mb_level = "10" Then ' 연합회지기
					sql = ""
					sql = sql & " select * "
					sql = sql & "   from cf_union_manager "
					sql = sql & "  where user_id = '" & user_id & "' "
					sql = sql & "    and union_id = '" & union_id & "' "
					rs2.open sql, Conn, 3, 1

					If rs2.eof Then ' 기존 연합회지기 아니면
						' 신규 연합회지기 등록
						sql = ""
						sql = sql & " insert into cf_union_manager( "
						sql = sql & "        union_id "
						sql = sql & "       ,user_id "
						sql = sql & "       ,stdate "
						sql = sql & "       ,union_mb_level "
						sql = sql & "       ,creid "
						sql = sql & "       ,credt "
						sql = sql & "      ) values( "
						sql = sql & "        '" & union_id & "' "
						sql = sql & "       ,'" & user_id & "' "
						sql = sql & "       ,getdate() "
						sql = sql & "       ,'" & union_mb_level & "' "
						sql = sql & "       ,'" & Session("user_id") & "' "
						sql = sql & "       ,getdate()) "
						Conn.Execute(sql)
					End If
					rs2.close
				Else ' 연합회지기 아님
					' 이전 연합회지기 히스토리 저장
					sql = ""
					sql = sql & " insert into cf_union_manager_history( "
					sql = sql & "        union_id "
					sql = sql & "       ,user_id "
					sql = sql & "       ,union_mb_level "
					sql = sql & "       ,remark "
					sql = sql & "       ,stdate "
					sql = sql & "       ,eddate "
					sql = sql & "       ,creid "
					sql = sql & "       ,credt "
					sql = sql & "      ) "
					sql = sql & " select union_id "
					sql = sql & "       ,user_id "
					sql = sql & "       ,union_mb_level "
					sql = sql & "       ,'연합회지기 삭제(관리자)' "
					sql = sql & "       ,stdate "
					sql = sql & "       ,getdate() "
					sql = sql & "       ,'" & Session("user_id") & "' "
					sql = sql & "       ,getdate() "
					sql = sql & "   from cf_union_manager "
					sql = sql & "  where user_id = '" & user_id & "' "
					sql = sql & "    and union_id = '" & union_id & "' "
					Conn.Execute(sql)

					' 기존 연합회지기 삭제
					sql = ""
					sql = sql & " delete cf_union_manager "
					sql = sql & "  where user_id = '" & user_id & "' "
					sql = sql & "    and union_id = '" & union_id & "' "
					Conn.Execute(sql)
				End If
			End If
		Else ' 기존 사랑방 회원 아니면
			' 이전 사랑방 히스토리 저장
			sql = ""
			sql = sql & " insert into cf_cafe_member_history( "
			sql = sql & "        cafe_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,cafe_mb_level "
			sql = sql & "       ,remark "
			sql = sql & "       ,stdate "
			sql = sql & "       ,eddate "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) "
			sql = sql & " select cafe_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,cafe_mb_level "
			sql = sql & "       ,'사랑방변경(관리자)' "
			sql = sql & "       ,stdate "
			sql = sql & "       ,getdate() "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate() "
			sql = sql & "   from cf_cafe_member "
			sql = sql & "  where user_id = '" & user_id & "' "
			sql = sql & "    and cafe_id = (select cafe_id from cf_member where user_id = '" & user_id & "') "
			Conn.Execute(sql)

			' 이전 사랑방 회원정보 삭제
			sql = ""
			sql = sql & " delete cf_cafe_member "
			sql = sql & "  where user_id = '" & user_id & "' "
			sql = sql & "    and cafe_id = (select cafe_id from cf_member where user_id = '" & user_id & "') "
			Conn.Execute(sql)

			If cafe_id <> "" Then
				' 신규 사랑방 회원정보 가입
				sql = ""
				sql = sql & " insert into cf_cafe_member( "
				sql = sql & "        cafe_id "
				sql = sql & "       ,user_id "
				sql = sql & "       ,stat "
				sql = sql & "       ,stdate "
				sql = sql & "       ,cafe_mb_level "
				sql = sql & "       ,creid "
				sql = sql & "       ,credt "
				sql = sql & "      ) values( "
				sql = sql & "        '" & cafe_id & "' "
				sql = sql & "       ,'" & user_id & "' "
				sql = sql & "       ,'Y' "
				sql = sql & "       ,getdate() "
				sql = sql & "       ,'" & cafe_mb_level & "' "
				sql = sql & "       ,'" & Session("user_id") & "' "
				sql = sql & "       ,getdate()) "
				Conn.Execute(sql)
			End If
			
			' 연합회지기 히스토리 저장
			sql = ""
			sql = sql & " insert into cf_union_manager_history( "
			sql = sql & "        union_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,union_mb_level "
			sql = sql & "       ,remark "
			sql = sql & "       ,stdate "
			sql = sql & "       ,eddate "
			sql = sql & "       ,creid "
			sql = sql & "       ,credt "
			sql = sql & "      ) "
			sql = sql & " select union_id "
			sql = sql & "       ,user_id "
			sql = sql & "       ,union_mb_level "
			sql = sql & "       ,'연합회지기 삭제(관리자)' "
			sql = sql & "       ,stdate "
			sql = sql & "       ,getdate() "
			sql = sql & "       ,'" & Session("user_id") & "' "
			sql = sql & "       ,getdate() "
			sql = sql & "   from cf_union_manager "
			sql = sql & "  where user_id = '" & user_id & "' "
			sql = sql & "    and union_id = '" & union_id & "' "
			Conn.Execute(sql)

			' 연합회지기 회원정보 삭제
			sql = ""
			sql = sql & " delete cf_union_manager "
			sql = sql & "  where user_id = '" & user_id & "' "
			sql = sql & "    and union_id = '" & union_id & "' "
			Conn.Execute(sql)
		End If
		rs.close

		sql = ""
		sql = sql & " update cf_member "
		sql = sql & "    set cafe_id = '" & cafe_id & "' "
		sql = sql & "       ,modid = '" & Session("user_id") & "' "
		sql = sql & "       ,moddt = getdate() "
		sql = sql & "  where user_id = '" & user_id & "' "
		Conn.Execute(sql)
	Next
	Set rs = nothing
	Set rs2 = nothing

	Response.Write "<script>alert('변경되었습니다.');parent.document.search_form.submit();</script>"
%>

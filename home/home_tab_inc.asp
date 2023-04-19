<%
		If tab_use_yn = "Y" Then ' 탭정보 확인
			Set tabRs = Server.CreateObject ("ADODB.Recordset")

			sql = ""
			sql = sql & " select section_seq                   "
			sql = sql & "       ,section_nm                    "
			sql = sql & "       ,section_sn                    "
			sql = sql & "   from cf_menu_section               "
			sql = sql & "  where menu_seq = '" & menu_seq & "' "
			sql = sql & "    and use_yn = 'Y'                  "
			If all_tab_use_yn = "Y" Then
			sql = sql & "  union all                           "
			sql = sql & " select null as section_seq           "
			sql = sql & "       ,'전체' as section_nm           "
			sql = sql & "       ,0 as section_sn               "
			End If
			If etc_tab_use_yn = "Y" Then
			sql = sql & "  union all                           "
			sql = sql & " select null as section_seq           "
			sql = sql & "       ,'기타' as section_nm           "
			sql = sql & "       ,999999999 as section_sn       "
			End If
			sql = sql & "  order by section_sn                 "
			tabRs.open Sql, conn, 3, 1

			If Not tabRs.eof Then
%>
					<div class="slide_cate">
<%
				Do Until tabRs.eof
%>
						<a href="javascript: goTab('<%=tabRs("section_seq")%>')" class="<%=if3(section_seq=tabRs("section_seq"),"on","")%>"><%=tabRs("section_nm")%></a>
<%
					tabRs.MoveNext
				Loop
%>
					</div>
<%
			End If
			tabRs.close
			Set tabRs = Nothing
		End If
%>

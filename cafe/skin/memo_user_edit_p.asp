<!--#include virtual="/ipin_exec_inc.asp"-->
<!--#include virtual="/include/config_inc.asp"-->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html lang="ko">
<head>
<meta charset="euc-kr" />
<title>ȸ������</title>
<meta http-equiv="X-UA-Compatible" content="IE=edge">

<link href="/cafe/skin/css/basic_layout.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/inc.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/btn.css" rel="stylesheet" type="text/css" />
<link href="/cafe/skin/css/contents_page.css" rel="stylesheet" type="text/css" />
<Script Language="JavaScript">
	ie4 = (document.all) ? true : false

	// üũ�� ��
	function chk_confirm()
	{
		var hist_value;
		var hist_text;

		if (input_form["opt_value"].value != "")
		{
			hist_value = input_form["opt_value"].value;
			hist_text = input_form["opt_text"].value;
		}//if
		else
		{
			if (opener.parent.form["opt_text"].value)
			{
				hist_value = opener.parent.form["opt_value"].value;
				hist_text = opener.parent.form["opt_text"].value;
				input_form["opt_value"].value = hist_value;
				input_form["opt_text"].value = hist_text;
			}//if
		}//if

		if (input_form["opt_value"].value != "")
		{
			select_add();
			var arr_value = hist_value.split(", ");

			for (var i = 0; i < arr_value.length; i++)
			{
				if (document.all["chk[group]["+ arr_value[i] +"]"])
					document.all["chk[group]["+ arr_value[i] +"]"].checked = true;
			}//for
		}//if
	}//function chk_confirm

	//��üȸ�� üũ
	function mem_chk(ele,user_id,kname) //ok
	{
		(ele.checked == true) ? history_write(user_id,kname) : history_remove(user_id);
	}//function mem_chk

	// �������� ����
	function history_write(listno,listname) //ok
	{
		var hist_value = input_form["opt_value"].value;
		var hist_text = input_form["opt_text"].value;

		input_form["opt_value"].value = (hist_value == "") ? listno : hist_value + ", " + listno;
		input_form["opt_text"].value = (hist_text == "") ? listname : hist_text + ", " + listname;
	}//function history_write

	// ����� �������� ����
	function history_remove(listno) //ok
	{
		var hist_value = input_form["opt_value"].value;
		var hist_text = input_form["opt_text"].value;

		var arr_value = hist_value.split(", ");
		var arr_text = hist_text.split(", ");
		var no_arr = listno.split(", ");
		for (var i = 0; i < no_arr.length; i++)
		{
			for (var j = 0; j < arr_value.length; j++)
			{
				if (no_arr[i] == arr_value[j])
				{
					arr_value.splice(j,1);
					arr_text.splice(j,1);
					break;
				}//if
			}//for
		}//for

		input_form["opt_value"].value = arr_value.join(", ");
		input_form["opt_text"].value = arr_text.join(", ");
	}//function history_remove

	function select_add() //ok
	{
		var opt_value = input_form["opt_value"].value;
		var opt_text = input_form["opt_text"].value;

		if (opt_value == "")
		{
			alert("�޴»���� �����Ͻʽÿ�.");
			return false;
		}//if

		select_obj = document.all["get_mem"];
		//opener.parent.form["opt_value"].value = opt_value;

		opt_value = opt_value.split(", ").join("','");
		opt_text = opt_text.split(", ").join("','");

		select_value = eval("['" + opt_value + "']");
		select_text = eval("['" + opt_text + "']");

		deleteCategory();

		for (var k = 0; k < select_value.length; k++)
		{
			new_option = document.createElement("OPTION");
			new_option.text = select_text[k];
			new_option.value = select_value[k];
			select_obj.add(new_option);
		}//for

	}//function select_add

	function select_remove() //ok
	{
		if (select_obj.length > 0)
		{
			gubun = "";
			var j = 0;
			var opt_value = "";
			var opt_text = "";
			for (var i = 0; i < select_obj.length; i++)
			{
				if (select_obj.options[i].selected && select_obj.options[i].value)
				{
					document.all["chk[group]["+ select_obj.options[i].value +"]"].checked = false;
					select_obj.remove(i);
					i--;
				}
				else
				{
					if (j > 0) gubun = ", ";
					opt_value = opt_value + gubun + select_obj.options[i].value;
					opt_text = opt_text + gubun + select_obj.options[i].text;
					j++;
				}//if
			}//for
			input_form["opt_value"].value = opt_value;
			input_form["opt_text"].value = opt_text;
			//opener.parent.form["opt_value"].value = opt_value;
			//opener.parent.form["opt_text"].value = opt_text;
		}
		else
			alert("������ ����� �����Ͻʽÿ�.");
	}//function select_remove

	function deleteCategory() //ok
	{
		overMaxNum = select_obj.length;
		for (var k = 0; k < overMaxNum; k++)
		{
			select_obj.remove(0);
		}//for
	}//function deleteCategory

	function mem_submit() //ok
	{
		var opt_value = "";
		var opt_text = "";
		var gubun = "";

		select_obj = document.all["get_mem"];

		for (var i = 0; i < select_obj.length; i++)
		{
			if (i > 0) gubun = ", ";
			opt_value = opt_value + gubun + select_obj.options[i].value;
			opt_text = opt_text + gubun + select_obj.options[i].text;
		}//for
		opener.parent.form["opt_value"].value = opt_value;
		opener.parent.form["opt_text"].value = opt_text;
		opener.parent.form["subject"].focus();
		window.close();
	}//function mem_submit

	function go_search()
	{
		var opt_value = "";
		var opt_text = "";
		var gubun = "";

		select_obj = document.all["get_mem"];

		for (var i = 0; i < select_obj.length; i++)
		{
			if (i > 0) gubun = ", ";
			opt_value = opt_value + gubun + select_obj.options[i].value;
			opt_text = opt_text + gubun + select_obj.options[i].text;
		}//for
		opener.parent.form["opt_value"].value = opt_value;
		opener.parent.form["opt_text"].value = opt_text;
		document.input_form.submit();
	}
</script>

</head>
<body onload="chk_confirm()">
<%
	sch_user = request("sch_user")
	cafe_id  = request("cafe_id")

	sql = ""
	sql = sql & " select 'crjee' user_id "
	sql = sql & "       ,'mi.kname' kname "
	sql = sql & "       ,'mi.phone'  phone "
	sql = sql & "       ,'mi.agency' agency "

	Set rs = Server.CreateObject ("ADODB.Recordset")
	sql = ""
	sql = sql & " select cm.user_id "
	sql = sql & "       ,mi.kname "
	sql = sql & "       ,mi.phone "
	sql = sql & "       ,mi.agency "
	sql = sql & "   from cf_cafe_member cm "
	sql = sql & "  inner join cf_member mi on mi.user_id = cm.user_id and mi.stat = 'Y' and mi.memo_receive_yn != 'N' "
	sql = sql & "  where cm.cafe_id = '" & cafe_id & "' "
	If sch_user <> "" Then
	sql = sql & "    and (mi.kname like '%" & sch_user & "%' or mi.agency like '%" & sch_user & "%') "
	End if
	sql = sql & "    and cm.stat = 'Y' "
	sql = sql & "  order by agency "

	rs.Open Sql, conn, 1, 1

	cnt = rs.recordcount
%>
	<div id="CenterPopup">
		<div id="Contents_Popuptitle">ȸ������</div>
		<div id="Contents_PopupCont">
			<div id="Contents_PopupContLeft">
				<form name="input_form" method="post" action="memo_user_edit_p.asp">
				<input type="hidden" name="opt_value" value="<%=request("opt_value")%>">
				<input type="hidden" name="opt_text" value="<%=request("opt_text")%>">
				<div id="Contents_PopupContLefttitle">
					<p class="margin10">
						ȸ�� (<%=cnt%>)<br />
						<input type="hidden" name="cafe_id" value="<%=request("cafe_id")%>">
						<input type="hidden" name="user_id" value="<%=request("user_id")%>">
						<input type="hidden" name="ipin" value="<%=request("ipin")%>">
						<input type="text" name="sch_user" value="<%=sch_user%>" class="input3" />
						<button class="btn_search" type="button" onclick="go_search()">&nbsp;</button>
					</p>
				</div>
				</form>
				<div id="Contents_PopupContLeftIn" style="width:100%;height:350px;overflow:auto">
					<p class="margin11">
<%

	Do until rs.eof
		user_id = rs("user_id")
		kname = rs("kname")
		phone = rs("phone")
		agency = rs("agency")
%>
						<input type="checkbox" name="chk[group][<%=user_id%>]" value="<%=user_id%>" onClick="mem_chk(this,'<%=user_id%>','[<%=agency%>] <%=kname%>')">
						<a title="<%=agency%>::<%=kname%>::<%=phone%>">[<%=agency%>] <font color=gray><%=kname%></font></a><br />
<%
	rs.MoveNext
	loop
%>
					</p>
				</div>
			</div>
			<div class="btncen">
				<button class="btn_plus" type="button" onClick="select_add()">&nbsp;</button><br /><br />
				<button class="btn_minus" type="button" onClick="select_remove()">&nbsp;</button>
			</div>
			<div id="Contents_PopupContRight">
				<div id="Contents_PopupContRighttitle">
					<p class="margin12">����ȸ��</p>
				</div>
				<div id="Contents_PopupContRightIn" style="width:100%;height:380px;overflow:hidden">
					<select name="get_mem" multiple style="width:100%; height:380px">
					</select>
				</div>
			</div>
		</div>

		<p class="btn_center">
			<button class="btn_2txt_sel" type="button" onclick="mem_submit()">Ȯ��</button>
			<button class="btn_2txt" type="button" onclick="window.close()">�ݱ�</button>
		</p>

	</div>
</body>
</html>

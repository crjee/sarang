<?
include_once("./_common.php");
include_once("./_head.php");
?>
<script language='javascript' src='/~AsaProgram/library/js/common.js'></script>
<script language='javascript' src='/~AsaProgram/library/js/check.js'></script>
<script language='javascript' id='getType'></script>

<table border="0" cellspacing="0" cellpadding="0">
<!-- Ÿ��Ʋ -->
<tr>
	<td>
		<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td><img src="image/title1.gif" border="0" alt=""></td>
			<td background="image/titlebg.gif" width="598" height="40" align="right">
				<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td><img src="image/home.gif" border="0" alt=""></td>
					<td style="padding:0px 0px 0px 0px;font-size:12px;color:#4d4a46">&nbsp;&nbsp;Home > �����ϱ� > <font color="#02427e"><b>ī�����</b></font></td>
				</tr>
				</table>
			</td>
		</tr>				
		</table>
	</td>
</tr>
<!-- /Ÿ��Ʋ -->
<tr>
	<td height="50"></td>
</tr>
<!-- ���� -->
<!--################################################################################-->
<!--�Ʒ��� ������ �ҽ��۾�2012-05-23 Lee-->
<?php

    /*
     * [����������û ������(STEP2-2)]
     *
     * LG�ڷ������� ���� �������� LGD_PAYKEY(����Key)�� ������ ���� ������û.(�Ķ���� ���޽� POST�� ����ϼ���)
     */

	$configPath = "/home/gibds.co.kr/www/payment/lgdacom"; //LG�ڷ��޿��� ������ ȯ������("/conf/lgdacom.conf,/conf/mall.conf") ��ġ ����. 

    /*
     *************************************************
     * 1.�������� ��û - BEGIN
     *  (��, ���� �ݾ�üũ�� ���Ͻô� ��� �ݾ�üũ �κ� �ּ��� ���� �Ͻø� �˴ϴ�.)
     *************************************************
     */
    $CST_PLATFORM               = $HTTP_POST_VARS["CST_PLATFORM"];
    $CST_MID                    = $HTTP_POST_VARS["CST_MID"];
    $LGD_MID                    = (("test" == $CST_PLATFORM)?"t":"").$CST_MID;
    $LGD_PAYKEY                 = $HTTP_POST_VARS["LGD_PAYKEY"];

    require_once("./lgdacom/XPayClient.php");
    $xpay = &new XPayClient($configPath, $CST_PLATFORM);

    $xpay->Init_TX($LGD_MID);    
    
    $xpay->Set("LGD_TXNAME", "PaymentByKey");
    $xpay->Set("LGD_PAYKEY", $LGD_PAYKEY);
    
    //�ݾ��� üũ�Ͻñ� ���ϴ� ��� �Ʒ� �ּ��� Ǯ� �̿��Ͻʽÿ�.
	//$DB_AMOUNT = "DB�� ���ǿ��� ������ �ݾ�"; //�ݵ�� �������� �Ұ����� ��(DB�� ����)���� �ݾ��� �������ʽÿ�.
	//$xpay->Set("LGD_AMOUNTCHECKYN", "Y");
	//$xpay->Set("LGD_AMOUNT", $DB_AMOUNT);
	    
    /*
     *************************************************
     * 1.�������� ��û(�������� ������) - END
     *************************************************
     */

    /*
     * 2. �������� ��û ���ó��
     *
     * ���� ������û ��� ���� �Ķ���ʹ� �����޴����� �����Ͻñ� �ٶ��ϴ�.
     */
 ?>

<tr><td align="center"><font>
<a name="map_02"></a>
<TABLE border=0 cellSpacing=0 cellPadding=0 width="100%">
<TBODY>
<TR>
<TD>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<IMG src="http://support.asadal.com/image//money/charge_title03.gif"></TD></TR>
<TR>
<TD style="LINE-HEIGHT: 120%"><!--font-->
</TD></TR></TBODY></TABLE>

<table border="0" cellpadding="0" cellspacing="0" width="700" style="margin-top:5px">
<tr>
	<td width="20"></td>
	<td width="700" align="center">

		<table border="0" cellpadding="0" cellspacing="0" width="700" align='center'>
		<tr>
			<td align='center'>
				<table align="center" border="0" width="700" cellpadding="0" cellspacing="3" bgcolor="#ECF4F8">
				<tr>
					<td align='center'>
<?
//setlocale(LC_CTYPE, 'ko_KR.utf8');
	if ($xpay->TX()) {
        //1)������� ȭ��ó��(����,���� ��� ó���� �Ͻñ� �ٶ��ϴ�.)
        /*
		echo "������û�� �Ϸ�Ǿ����ϴ�.  <br>";
        echo "TX Response_code = " . $xpay->Response_Code() . "<br>";
        echo "TX Response_msg = " . $xpay->Response_Msg() . "<p>";
		
        echo "�ŷ���ȣ : " . $xpay->Response("LGD_TID",0) . "<br>";
        echo "�������̵� : " . $xpay->Response("LGD_MID",0) . "<br>";
        */

		//echo "�����ֹ���ȣ : " . $xpay->Response("LGD_OID",0) . "<br>";
        /*
		echo "�����ݾ� : " . $xpay->Response("LGD_AMOUNT",0) . "<br>";
        echo "����ڵ� : " . $xpay->Response("LGD_RESPCODE",0) . "<br>";
        echo "����޼��� : " . $xpay->Response("LGD_RESPMSG",0) . "<p>";
        
        $keys = $xpay->Response_Names();
        foreach($keys as $name) {
            echo $name . " = " . $xpay->Response($name, 0) . "<br>";
        }*/
          
        echo "<p>";
        
        if( "0000" == $xpay->Response_Code() ) {
         	//����������û ��� ���� DBó��
           	//echo "����������û ��� ���� DBó���Ͻñ� �ٶ��ϴ�.<br>";

			$isDBOK = true; //DBó�� ���н� false�� ������ �ּ���.
			if($isDBOK ) {
				echo "���������� ������ �Ϸ�Ǿ����ϴ�..<br><br>";
				echo "<meta http-equiv='Refresh' content=\"10;url='./index.htm'\">";
				echo "10���Ŀ� �����ʱ�ȭ������ �̵��մϴ�.<br>";
			}
            //����������û ��� ���� DBó�� ���н� Rollback ó��
          	
          	if( !$isDBOK ) {
           		echo "<p>";
           		$xpay->Rollback("���� DBó�� ���з� ���Ͽ� Rollback ó�� [TID:" . $xpay->Response("LGD_TID",0) . ",MID:" . $xpay->Response("LGD_MID",0) . ",OID:" . $xpay->Response("LGD_OID",0) . "]");            		            		
            		
                echo "TX Rollback Response_code = " . $xpay->Response_Code() . "<br>";
                echo "TX Rollback Response_msg = " . $xpay->Response_Msg() . "<p>";
            		
                if( "0000" == $xpay->Response_Code() ) {
                  	echo "�ڵ���Ұ� ���������� �Ϸ� �Ǿ����ϴ�.<br>";
                }else{
          			echo "�ڵ���Ұ� ���������� ó������ �ʾҽ��ϴ�.<br>";
                }
          	}            	
        }else{
          	//����������û ��� ���� DBó��
         	echo "����������û ��� ���� DBó���Ͻñ� �ٶ��ϴ�.<br>";            	            
        }
		  
    }else {
        //2)API ��û���� ȭ��ó��
        echo "������û�� �����Ͽ����ϴ�.  <br>";
        echo "TX Response_code = " . $xpay->Response_Code() . "<br>";
        echo "TX Response_msg = " . $xpay->Response_Msg() . "<p>";
            
        //����������û ��� ���� DBó��
        echo "����������û ��� ���� DBó���Ͻñ� �ٶ��ϴ�.<br>";            	                        
    }
?>
						
					</td>
				</tr>
				</table>
			</td>
		</tr>
		</table>

	</td>
</tr>
</table>

<!-- ���� ��� END -->
<!--################################################################################-->
<tr>
	<td height="150"></td>
</tr>
<!--���볡-->
<tr>
	<td></td>
</tr>
<!-- /���� -->
</table>
<?php include "./_tail.php";?>

癤??

include_once("./_common.php");
include_once("./_head.php");
?>
<?php
    /*
     * [寃곗젣 ?몄쬆?붿껌 ?섏씠吏(STEP2-1)]
     *
     * ?섑뵆?섏씠吏?먯꽌??湲곕낯 ?뚮씪誘명꽣留??덉떆?섏뼱 ?덉쑝硫? 蹂꾨룄濡??꾩슂?섏떊 ?뚮씪誘명꽣???곕룞硫붾돱?쇱쓣 李멸퀬?섏떆??異붽? ?섏떆湲?諛붾엻?덈떎.     
     */

    /*
     * 1. 湲곕낯寃곗젣 ?몄쬆?붿껌 ?뺣낫 蹂寃?
     * 
     * 湲곕낯?뺣낫瑜?蹂寃쏀븯??二쇱떆湲?諛붾엻?덈떎.(?뚮씪誘명꽣 ?꾨떖??POST瑜??ъ슜?섏꽭??
     */
    $CST_PLATFORM               = $HTTP_POST_VARS["CST_PLATFORM"];      //LG?붾젅肄?寃곗젣 ?쒕퉬???좏깮(test:?뚯뒪?? service:?쒕퉬??
    $CST_MID                    = $HTTP_POST_VARS["CST_MID"];           //?곸젏?꾩씠??LG?붾젅肄ㅼ쑝濡?遺??諛쒓툒諛쏆쑝???곸젏?꾩씠?붾? ?낅젰?섏꽭??
                                                                        //?뚯뒪???꾩씠?붾뒗 't'瑜?諛섎뱶???쒖쇅?섍퀬 ?낅젰?섏꽭??
    $LGD_MID                    = (("test" == $CST_PLATFORM)?"t":"").$CST_MID;  //?곸젏?꾩씠???먮룞?앹꽦)
    $LGD_OID                    = $HTTP_POST_VARS["LGD_OID"];           //二쇰Ц踰덊샇(?곸젏?뺤쓽 ?좊땲?ы븳 二쇰Ц踰덊샇瑜??낅젰?섏꽭??
    $LGD_AMOUNT                 = $HTTP_POST_VARS["LGD_AMOUNT"];        //寃곗젣湲덉븸("," 瑜??쒖쇅??寃곗젣湲덉븸???낅젰?섏꽭??
    $LGD_BUYER                  = $HTTP_POST_VARS["LGD_BUYER"];         //援щℓ?먮챸
    $LGD_PRODUCTINFO            = $HTTP_POST_VARS["LGD_PRODUCTINFO"];   //?곹뭹紐?
    $LGD_BUYEREMAIL             = $HTTP_POST_VARS["LGD_BUYEREMAIL"];    //援щℓ???대찓??
    $LGD_TIMESTAMP              = date(YmdHms);                         //??꾩뒪?ы봽
    $LGD_CUSTOM_SKIN            = "blue";                               //?곸젏?뺤쓽 寃곗젣李??ㅽ궓 (red, blue, cyan, green, yellow)
    $LGD_MERTKEY				= "c60c1fcbde71f8203dbb99db5d971d91";									//?곸젏MertKey(mertkey???곸젏愿由ъ옄 -> 怨꾩빟?뺣낫 -> ?곸젏?뺣낫愿由ъ뿉???뺤씤?섏떎???덉뒿?덈떎)
	$configPath 				= "/home/gibds.co.kr/www/payment/lgdacom"; 						//LG?붾젅肄ㅼ뿉???쒓났???섍꼍?뚯씪("/conf/lgdacom.conf") ?꾩튂 吏?? 	    
    $LGD_BUYERID                = $HTTP_POST_VARS["LGD_BUYERID"];       //援щℓ???꾩씠??
    $LGD_BUYERIP                = $HTTP_POST_VARS["LGD_BUYERIP"];       //援щℓ?륤P
	
    /*
     * 媛?곴퀎醫?臾댄넻?? 寃곗젣 ?곕룞???섏떆??寃쎌슦 ?꾨옒 LGD_CASNOTEURL ???ㅼ젙?섏뿬 二쇱떆湲?諛붾엻?덈떎. 
     */    
    $LGD_CASNOTEURL				= "http://?곸젏URL/cas_noteurl.php";    
		
    /*
     *************************************************
     * 2. MD5 ?댁돩?뷀샇??(?섏젙?섏? 留덉꽭?? - BEGIN
     * 
     * MD5 ?댁돩?뷀샇?붾뒗 嫄곕옒 ?꾨?議곕? 留됯린?꾪븳 諛⑸쾿?낅땲?? 
     *************************************************
     *
     * ?댁돩 ?뷀샇???곸슜( LGD_MID + LGD_OID + LGD_AMOUNT + LGD_TIMESTAMP + LGD_MERTKEY )
     * LGD_MID          : ?곸젏?꾩씠??
     * LGD_OID          : 二쇰Ц踰덊샇
     * LGD_AMOUNT       : 湲덉븸
     * LGD_TIMESTAMP    : ??꾩뒪?ы봽
     * LGD_MERTKEY      : ?곸젏MertKey (mertkey???곸젏愿由ъ옄 -> 怨꾩빟?뺣낫 -> ?곸젏?뺣낫愿由ъ뿉???뺤씤?섏떎???덉뒿?덈떎)
     *
     * MD5 ?댁돩?곗씠???뷀샇??寃利앹쓣 ?꾪빐
     * LG?붾젅肄ㅼ뿉??諛쒓툒???곸젏??MertKey)瑜??섍꼍?ㅼ젙 ?뚯씪(lgdacom/conf/mall.conf)??諛섎뱶???낅젰?섏뿬 二쇱떆湲?諛붾엻?덈떎.
     */
    require_once("./lgdacom/XPayClient.php");
    $xpay = &new XPayClient($configPath, $LGD_PLATFORM);
   	$xpay->Init_TX($LGD_MID);
    $LGD_HASHDATA = md5($LGD_MID.$LGD_OID.$LGD_AMOUNT.$LGD_TIMESTAMP.$xpay->config[$LGD_MID]);
    $LGD_CUSTOM_PROCESSTYPE = "TWOTR";
    /*
     *************************************************
     * 2. MD5 ?댁돩?뷀샇??(?섏젙?섏? 留덉꽭?? - END
     *************************************************
     */
?>


<script language = 'javascript'>
<!--
/*
 * ?곸젏寃곗젣 ?몄쬆?붿껌??PAYKEY瑜?諛쏆븘??理쒖쥌寃곗젣 ?붿껌.
 */
function doPay_ActiveX(){
    ret = xpay_check(document.getElementById('LGD_PAYINFO'), '<?= $CST_PLATFORM ?>');

    if (ret=="00"){     //ActiveX 濡쒕뵫 ?깃났
        var LGD_RESPCODE        = dpop.getData('LGD_RESPCODE');       //寃곌낵肄붾뱶
        var LGD_RESPMSG         = dpop.getData('LGD_RESPMSG');        //寃곌낵硫붿꽭吏

        if( "0000" == LGD_RESPCODE ) { //?몄쬆?깃났
            var LGD_PAYKEY      = dpop.getData('LGD_PAYKEY');         //LG?붾젅肄??몄쬆KEY
            var msg = "?몄쬆寃곌낵 : " + LGD_RESPMSG + "\n";
            msg += "LGD_PAYKEY : " + LGD_PAYKEY +"\n\n";
            document.getElementById('LGD_PAYKEY').value = LGD_PAYKEY;
            alert(msg);
            document.getElementById('LGD_PAYINFO').submit();
        } else { //?몄쬆?ㅽ뙣
            alert("?몄쬆???ㅽ뙣?섏??듬땲?? " + LGD_RESPMSG);
            /*
             * ?몄쬆?ㅽ뙣 ?붾㈃ 泥섎━
             */
        }
    } else {
        alert("LG U+ ?꾩옄寃곗젣瑜??꾪븳 ActiveX Control?? ?ㅼ튂?섏? ?딆븯?듬땲??");
        /*
         * ?몄쬆?ㅽ뙣 ?붾㈃ 泥섎━
         */
    }
}

function isActiveXOK(){
	if(lgdacom_atx_flag == true){
    	document.getElementById('LGD_BUTTON1').style.display='none';
        document.getElementById('LGD_BUTTON2').style.display='';
	}else{
		document.getElementById('LGD_BUTTON1').style.display='';
        document.getElementById('LGD_BUTTON2').style.display='none';	
	}
}
//-->
</script>

<div id="LGD_ACTIVEX_DIV"/> <!-- ActiveX ?ㅼ튂 ?덈궡 Layer ?낅땲?? ?섏젙?섏? 留덉꽭?? -->
<form method="post" id="LGD_PAYINFO" action="payres.php">
<!--table>
    <tr>
        <td>援щℓ???대쫫 </td>
        <td><?= $LGD_BUYER ?></td>
    </tr>
    <tr>
        <td>援щℓ??IP </td>
        <td><?= $LGD_BUYERIP ?></td>
    </tr>
    <tr>
        <td>援щℓ??ID </td>
        <td><?= $LGD_BUYERID ?></td>
    </tr>
    <tr>
        <td>?곹뭹?뺣낫 </td>
        <td><?= $LGD_PRODUCTINFO ?></td>
    </tr>
    <tr>
        <td>寃곗젣湲덉븸 </td>
        <td><?= $LGD_AMOUNT ?></td>
    </tr>
    <tr>
        <td>援щℓ???대찓??</td>
        <td><?= $LGD_BUYEREMAIL ?></td>
    </tr>
    <tr>
        <td>二쇰Ц踰덊샇 </td>
        <td><?= $LGD_OID ?></td>
    </tr>
    <tr>
        <td colspan="2">* 異붽? ?곸꽭 寃곗젣?붿껌 ?뚮씪誘명꽣??硫붾돱?쇱쓣 李몄“?섏떆湲?諛붾엻?덈떎.</td>
    </tr>
    <tr>
        <td colspan="2"></td>
    </tr>    
    <tr>
        <td colspan="2">
		<div id="LGD_BUTTON1">寃곗젣瑜??꾪븳 紐⑤뱢???ㅼ슫 以묒씠嫄곕굹, 紐⑤뱢???ㅼ튂?섏? ?딆븯?듬땲?? </div>
		<div id="LGD_BUTTON2" style="display:none"><input type="button" value="?몄쬆?붿껌" onclick="doPay_ActiveX();"/> </div>        
        </td>
    </tr>    
</table-->
<br>

<br>
<input type="hidden" name="CST_PLATFORM"                value="<?= $CST_PLATFORM ?>">                   <!-- ?뚯뒪?? ?쒕퉬??援щ텇 -->
<input type="hidden" name="CST_MID"                     value="<?= $CST_MID ?>">                        <!-- ?곸젏?꾩씠??-->
<input type="hidden" name="LGD_MID"                     value="<?= $LGD_MID ?>">                        <!-- ?곸젏?꾩씠??-->
<input type="hidden" name="LGD_OID"                     value="<?= $LGD_OID ?>">                        <!-- 二쇰Ц踰덊샇 -->
<input type="hidden" name="LGD_BUYER"                   value="<?= $LGD_BUYER ?>">           			<!-- 援щℓ??-->
<input type="hidden" name="LGD_PRODUCTINFO"             value="<?= $LGD_PRODUCTINFO ?>">     			<!-- ?곹뭹?뺣낫 -->
<input type="hidden" name="LGD_AMOUNT"                  value="<?= $LGD_AMOUNT ?>">                     <!-- 寃곗젣湲덉븸 -->
<input type="hidden" name="LGD_BUYEREMAIL"              value="<?= $LGD_BUYEREMAIL ?>">                 <!-- 援щℓ???대찓??-->
<input type="hidden" name="LGD_CUSTOM_SKIN"             value="<?= $LGD_CUSTOM_SKIN ?>">                <!-- 寃곗젣李?SKIN -->
<input type="hidden" name="LGD_CUSTOM_PROCESSTYPE"      value="<?= $LGD_CUSTOM_PROCESSTYPE ?>">         <!-- ?몃옖??뀡 泥섎━諛⑹떇 -->
<input type="hidden" name="LGD_TIMESTAMP"               value="<?= $LGD_TIMESTAMP ?>">                  <!-- ??꾩뒪?ы봽 -->
<input type="hidden" name="LGD_HASHDATA"                value="<?= $LGD_HASHDATA ?>">                   <!-- MD5 ?댁돩?뷀샇媛?-->
<input type="hidden" name="LGD_PAYKEY"                  id="LGD_PAYKEY">                                <!-- LG?붾젅肄?PAYKEY(?몄쬆???먮룞?뗮똿)-->
<input type="hidden" name="LGD_VERSION"         		value="PHP_XPay_1.0">							<!-- 踰꾩쟾?뺣낫 (??젣?섏? 留덉꽭?? -->
<input type="hidden" name="LGD_BUYERIP"                 value="<?= $LGD_BUYERIP ?>">           			<!-- 援щℓ?륤P -->
<input type="hidden" name="LGD_BUYERID"                 value="<?= $LGD_BUYERID ?>">           			<!-- 援щℓ?륤D -->
<!-- 媛?곴퀎醫?臾댄넻?? 寃곗젣?곕룞???섏떆??寃쎌슦  ?좊떦/?낃툑 寃곌낵瑜??듬낫諛쏄린 ?꾪빐 諛섎뱶??LGD_CASNOTEURL ?뺣낫瑜?LG ?붾젅肄ㅼ뿉 ?꾩넚?댁빞 ?⑸땲??. -->
<!-- input type="hidden" name="LGD_CASNOTEURL"          	value="<?= $LGD_CASNOTEURL ?>"-->					<!-- 媛?곴퀎醫?NOTEURL -->  

</form>
</body>
<!--  xpay.js??諛섎뱶??body 諛묒뿉 ?먯떆湲?諛붾엻?덈떎. -->
<!--  UTF-8 ?몄퐫???ъ슜 ?쒕뒗 xpay.js ???xpay_utf-8.js ?? ?몄텧?섏떆湲?諛붾엻?덈떎.-->
<script language="javascript" src="<?= $_SERVER['SERVER_PORT']!=443?"http":"https" ?>://xpay.lgdacom.net<?=($CST_PLATFORM == "service")?($_SERVER['SERVER_PORT']!=443?":7080":":7443"):""?>/xpay/js/xpay.js" type="text/javascript"></script>


<script language = 'javascript'>
	document.onload=doPay_ActiveX();
</script>


<?php include "./_tail.php";?>

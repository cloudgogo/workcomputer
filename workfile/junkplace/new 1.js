<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=EDGE"> 
	<meta http-equiv="Expires" content="0">
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-control" content="no-cache">
	<meta http-equiv="Cache" content="no-cache">
	
	<title>人力资源数据报表平台</title>
	<link rel="stylesheet" href="css/index2.css">
	<link rel="stylesheet" href="css/iconfont.css">
	
	<!-- 测试环境	
		<link href="http://sso.cfld-sso.cn/Styles/floatMenu3.css" rel="Stylesheet" type="text/css" />
    	<script src="http://sso.cfld-sso.cn/Scripts/floatMenu3.js?d=635464743114947847" type="text/javascript"></script>
	-->
	
	<!-- 生产环境	-->
	<script src="http://sso.cfldcn.com/getssomenuinfo.aspx" type="text/javascript"></script>
	<link href="http://sso.cfldcn.com/Styles/floatMenu3.css" rel="Stylesheet" type="text/css" /> 
    <script src="http://sso.cfldcn.com/Scripts/floatMenu3.js?d=635464743114947847" type="text/javascript"></script>
    
    <script type="text/javascript">
    
    if (typeof (wd_sso_menuInfo) == "undefined" || wd_sso_menuInfo == null || wd_sso_menuInfo == "") {
           window.location.href="https://sso.cfldcn.com/";
        }
    	
    </script>
    	
</head>
<body>
	<div class="banner">
		<span>
			人力资源数据报表平台
		</span>
		<span>
			用数据驱动人力资源管理优化
		</span>
		<img src="img/logo2.png" class="logo" alt="">
		<div class="bor"></div>
	</div>
	<div class="tab">
	
	</div>
		<!-- <iframe id="friframe" style="display: none;" class="powerIframe" src="http://hrdata.cfldcn.com:8080/WebReport/ReportServer?formlet=Form25.frm" frameborder="0"></iframe> -->
		<iframe id="friframe" style="display: none;" class="powerIframe"  frameborder="0"></iframe>
	<div class="iframeDiv">
		 <iframe id="iframe" src="" frameborder="0"></iframe> 
		<!--<iframe id="iframe" src="http://localhost:8075/WebReport/ReportServer?formlet=Form25.frm" frameborder="0"></iframe> -->
	</div>
	<div class="smallIframe" id="smallIframe" >
		<div class="top">
			<span>
				<i class="icon iconfont icon-gerenxinxi people "></i>
				个人信息
			</span>
			<i class="icon iconfont icon-guanbi close"></i>
			<i class="icon iconfont icon-webicon311 fangda"></i>
			<i class="icon iconfont icon-suoxiao suoxiao"></i>
			<i class="icon iconfont icon-zuixiaohua small"></i>
		</div>
		<iframe id="iframe2" src="" frameborder="0"></iframe>
	</div>
	<div class="model"></div>
	<div class="allMinimize"></div>
	<div class="foot">
		© 华夏幸福基业股份有限公司
	</div>
	
	<!-- js 功能 -->
	<script type="text/javascript" src="js/jquery-3.0.0.min.js"></script>
	
		<script type="text/javascript">
	
		// 获取URL参数
		function getUrlVars(){
  			var vars=[],hash;
  			var hashes = window.location.href.slice(window.location.href.indexOf('?')+1).split('&');
  			
  			for(var i=0;i<hashes.length;i++){
  				hash=hashes[i].split('=');
  				vars.push(hash[0]);
  				vars[hash[0]] = hash[1];				
  				//alter(vars["ticket"]);
  			}	
  			
  			return vars;
  		}
	
		$(function() {
		
			var results = getUrlVars();
			var username = results["username"];
			var userid = results["userid"];
			// 跳转
			$("#friframe").attr("src","http://hrdata.cfldcn.com:8080/WebReport/ReportServer?formlet=Form25.frm&username="+username+"&userid="+userid);
		});
		
	</script>
	
	<script type="text/javascript" src="js/jquery.event.ue.js"></script>
	<script type="text/javascript" src="js/jquery.udraggable.js"></script>
	<script type="text/javascript" src="js/index2.js"></script>
	
	
</body>
</html>
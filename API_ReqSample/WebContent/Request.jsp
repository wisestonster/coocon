<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src='/js/jquery-3.5.1.min.js'></script>
<title>Insert title here</title>
</head>
<script type="text/javascript">

	function fn_call_ins(){
		
		//bypass.jsp에서 디코딩함으로 인코딩 1회 추가
		var param = "JSONData="+ encodeURIComponent(  JSON.stringify(mk_json_ins()) );
		alert(param);
//		console.log("잘 들어왔어요!");
		$.ajax({
			url : './bypass_ins.jsp',
			type: 'POST',
			dataType : "json",
			data : param,
			async: true,
			success: function(data, textStatus, jqXHR)
			{
				$('#result_ins').html("<pre>"+JSON.stringify(data)+"</pre>");
			},
			error: function (jqXHR, textStatus, errorThrown)
			{
				$('#result_ins').html("code:"+jqXHR.status+"\n"+"error:"+errorThrown);
			}
		});
		
	}

	function fn_call_1320(){
		//bypass.jsp에서 디코딩함으로 인코딩 1회 추가
		var param = "REQ_DATA="+ encodeURIComponent(  JSON.stringify(mk_json_1320()) );
		$.ajax({
			url : './bypass_1320.jsp',
			type: 'POST',
			dataType : "json",
			data : param,
			async: true,
			success: function(data, textStatus, jqXHR)
			{
				$('#result_1320').html("<pre>"+JSON.stringify(data)+"</pre>");
			},
			error: function (jqXHR, textStatus, errorThrown)
			{
				$('#result_1320').html("code:"+jqXHR.status+"\n"+"error:"+errorThrown);
			}
		});
		
	}
	
	function mk_json_ins(){
		var jsonObj = new Object();
		jsonObj.Auth_key = $('#Auth_key').val();
		jsonObj.Job = $('#Job').val();
		jsonObj.Module = $('#Module').val();
		jsonObj.Class = $('#Class').val();
		jsonObj.Input = $('#Input').val();
		
		return jsonObj;	
	}
	
	function mk_json_1320(){
		var jsonObj = new Object();
		jsonObj.API_KEY = $('#API_KEY').val();
		jsonObj.API_ID = $('#API_ID').val();
		jsonObj.BANKCD = $('#BANKCD').val();
		jsonObj.NAME = $('#NAME').val();
		jsonObj.REGNO = $('#REGNO').val();
		jsonObj.DRIVE_NO = $('#DRIVE_NO').val();
		jsonObj.ISSUE_DATE = $('#ISSUE_DATE').val();
		
		return jsonObj;	
	}
	
	
</script>
<body>
	<B>보험 API</B><br>
	<input type='text' id='Auth_key' value='TEST' ><br>
	<input type='text' id='Job' value='가입특약사항조회' ><br>
	<input type='text' id='Module' value='testins' ><br>
	<input type='text' id='Class' value='개인보험' ><br>
	<input type='text' id='Input' value='{"증권번호": "96011094901346","상품명": "아이사랑보험","피보험자": "홍길동"}' ><br>
	<input type='button' value='보험API 호출' onclick='javascript:fn_call_ins()'><br>
	<br><B>결과값</B><br>
	<div id='result_ins'></div><br><br>

	<B>신분증진위여부조회</B><br>
	<input type='text' id='API_KEY' value='TEST' ><br>
	<input type='text' id='API_ID' value='1320' ><br>
	<input type='text' id='BANKCD' value='004' ><br>
	<input type='text' id='NAME' value='홍길동' ><br>
	<input type='text' id='REGNO' value='9107011234567' ><br>
	<input type='text' id='DRIVE_NO' value='' ><br>
	<input type='text' id='ISSUE_DATE' value='20100601' ><br>
	<input type='button' value='신분증진위 호출' onclick='javascript:fn_call_1320()'><br>
	<br><B>결과값</B><br>
	<div id='result_1320'></div><br><br>
	
</body>
</html>
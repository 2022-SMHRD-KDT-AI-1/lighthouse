<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
function IdCheck(){
	alert("IdCheck!");
	
	window.open("IdCheckForm.jsp","idwin","width=400","height=350");
} 
</script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<h5>회원가입</h5>
	<form  action="JoinService" method="post" name=Join
		onSubmit="return check()">
		<input type="text" name="email" placeholder="Email을 입력하세요" class="input_email">
		<font id="checkEmail" size="2"></font>
		<br>
		<input type="password" name="pw" placeholder="PW를 입력하세요"><br>
		
		<font id="checkNick" size="2"></font>
		<input type="submit" value="Join">
	</form>
	
	<script>
	
	$('.input_email').focusout(function(){
		var userEmail = $('.input_email').val();
		
		
		$.ajax({
			url:"checkService",
			type: "post",
			data : {"userEmail" : userEmail},
			dataType : "json",
			success : function(result){
				if(result==0){
					$("#checkEmail").html('사용할 수 없는 이메일입니다.');
					$("#checkEmail").attr('color','red');
					
				}else{
					$("#checkEmail").html('사용할 수 있는 이메일입니다.');
					$("#checkEmail").attr('color','green');
					
				}
			},
			error : function(){
				alert('실패');
			}
		});
	});
	
	/* function check(){
		if(!document.Join.email.value){
			alert("email을 입력하세요");
			return false;
		}
		if(!document.Join.pw.value){
			alert("비밀번호를 입력하세요");
			return false;
		}
		if(!document.Join.nickName.value){
			alert("닉네임을 입력하세요");
			return false;
		}

	} */
	
	</script>
</body>
</html>
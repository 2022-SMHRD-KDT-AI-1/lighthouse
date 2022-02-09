<%@page import="Model.MemberDTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%
		
%>
	<h5>로그인</h5>
	<form action="LoginService" method="post">
		<input type="text" name="email" placeholder="Email을 입력하세요"><br>
		<input type="password" name="pw" placeholder="PW를 입력하세요"><br>
		<input type="submit" value="LogIn"><br>
	</form>
		
		<h6>아직 회원이 아니십니까?</h6>
		<form action = "Join.jsp">
		<input type="submit" value="회원가입">
		</form>
	

			
</body>
</html>
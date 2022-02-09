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
		String email = (String)session.getAttribute("email");	
	%>
	<h1>환영합니다!</h1>
	<li>
	회원가입을 축하합니다.</li>
	<li>메세지시스템의 새로운 이메일은 <%=email %>입니다.</li>
	<form action="main.jsp" main="post" >
	<input type="submit" value="main으로"  />
	</form>
	
</body>
</html>
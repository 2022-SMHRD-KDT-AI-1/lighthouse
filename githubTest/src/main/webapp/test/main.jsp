<%@page import="java.util.ArrayList"%>
<%@page import="Model.MemberDTO"%>
<%@page import="org.eclipse.jdt.internal.compiler.lookup.InferenceContext"%>
<%@page import="javax.sound.midi.MidiDevice.Info"%>
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
		MemberDTO info = (MemberDTO)session.getAttribute("info");
	
	%>

	<h5>로그인</h5>
	<form action="login.jsp" method="post">
		<li>e-mail : <input type="text" name="email"
			placeholder="Email을 입력하세요"></li>
		<li>PW : <input type="password" name="pw" placeholder="PW를 입력하세요"></li>
		<li><input type="submit" value="login" ></li>
	</form>

	<h5>회원가입</h5>
	<form action="Join.jsp" method="post">
	<li><input type="submit" value="Join" ></li>

	</form>

	

							
	

</body>
</html>
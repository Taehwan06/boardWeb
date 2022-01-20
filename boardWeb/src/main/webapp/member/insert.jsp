<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>회원 등록</h2>
		<article>
			<form name="frm" action="insertOk.jsp" method="post">
				<table border="1">
					<tr>
						<th>ID</th>
						<td><input type="text" name="memberid"></td>
					</tr>
					<tr>
						<th>패스워드</th>
						<td><input type="password" name="memberpassword"></td>
					</tr>
					<tr>
						<th>이름</th>
						<td><input type="text" name="membername"></td>
					</tr>
					<tr>
						<th>성별</th>
						<td>
							<input type="radio" name="gender" value="M">남성 
							<input type="radio" name="gender" value="F">여성 
						</td>
					</tr>
				</table>
				<input type="button" value="취소" onclick="location.href='list.jsp'">
				<input type="submit" value="등록">
			</form>
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
</body>
</html>
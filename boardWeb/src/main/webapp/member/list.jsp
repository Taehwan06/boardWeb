<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
	request.setCharacterEncoding("UTF-8");

	// searchValue 가 null 이면 검색버튼을 누르지 않고 화면으로 들어옴.
	String searchValue = request.getParameter("searchValue");
	String searchType = request.getParameter("searchType");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null; // 데이터베이스의 접속정보를 가지고 있는 객체
	PreparedStatement psmt = null; // sql을 가지고 있는 객체
	ResultSet rs = null; // 조회 결과를 담는 객체
	
	try{
		
		Class.forName("oracle.jdbc.driver.OracleDriver"); // 드라이버 매니저로서 오라클드라이버를 사용하겠다는 선언
		conn = DriverManager.getConnection(url,user,pass); // 드라이버매니저를 통해 연결을 하겠다는 내용 ()
		String sql = "SELECT * FROM member"; // 실행하고자 하는 쿼리문
		
		if(searchValue != null && !searchValue.equals("")){
			if(searchType.equals("addr")){
				
				sql += " where addr like '%"+searchValue+"%'";
			}else if(searchType.equals("membername")){
				sql += " where membername = '"+searchValue+"'";
			}			
		}
		
		
		
		psmt = conn.prepareStatement(sql); 
		
		rs = psmt.executeQuery(); // 쿼리 실행 결과를 rs에 받는다

%>
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
		<h2>회원 목록</h2>
		<article>
			<div class="searchArea">
				<form action="list.jsp">
					<select name="searchType">
						<option value="membername" <%if(searchType != null && searchType.equals("membername")) out.print("selected"); %>>회원명</option>
						<option value="addr" <%if(searchType != null && searchType.equals("addr")) out.print("selected"); %>>주소</option>
						<%-- <%
						if(searchType != null){
							if(searchType.equals("membername")){
						%>
							<option value="membername" selected>회원명</option>
							<option value="addr">주소</option>
						<%
								
							}else if(searchType.equals("addr")){
						%>
							<option value="membername">회원명</option>
							<option value="addr" selected>주소</option>
						<%	
							}
						}else{
						%>
							<option value="membername">회원명</option>
							<option value="addr">주소</option>
						<%
						}
						%> --%>
					</select>
					<%-- <%
						if(searchValue != null){
					%>
						<input type="text" name="searchValue" value="<%=searchValue%>">
					<%
						}else{
					%>
						<input type="text" name="searchValue">
					<%
						}
					%> --%>
					<input type="text" name="searchValue" 
					<%if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")) out.print("value='"+searchValue+"'"); %>>
					<input type="submit" value="검색">
				</form>
			</div>
			<table border=1>
				<thead>
					<tr>
						<th>회원번호</th>
						<th>회원명</th>
						<th>주소</th>
					</tr>
				</thead>
				<tbody>
					<%
						while(rs.next()){
					%>
						<tr>
							<td><%=rs.getInt("midx") %></td>
							<td><a href="view.jsp?midx=<%=rs.getInt("midx")%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=rs.getString("membername") %></a></td>
							<td><%=rs.getString("addr") %></td>
						<tr>	
					<%
						}
					%>
				</tbody>
			</table>
			<input type="button" value="회원 등록" onclick="location.href='insert.jsp'">
		</article>		
	</section>
	<%@ include file="/footer.jsp" %>
</body>
</html>
<%
	}catch(Exception e){
		e.printStackTrace();
	}finally{                      // finally를 만드시 넣어주어야 한다
		if(conn != null){
			conn.close();
		}
		if(psmt != null){
			psmt.close();
		}
		if(rs != null){
			rs.close();
		}
	}	
%>
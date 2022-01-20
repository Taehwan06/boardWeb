<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.vo.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");
	int midxM = login.getMidx();

	request.setCharacterEncoding("UTF-8");

	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");

	String midx = request.getParameter("midx");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
		
	
	String id_ = "";
	String password_ = "";
	String name_ = "";
	String addr_ = "";
	String phone_ = "";
	String email_ = "";
	int midx_ = 0;
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);

		String sql = "select * from member where midx = "+midx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			id_ = rs.getString("memberid");
			password_ = rs.getString("memberpassword");
			name_ = rs.getString("membername");
			addr_ = rs.getString("addr");
			phone_ = rs.getString("phone");
			email_ = rs.getString("email");
			midx_ = rs.getInt("midx");
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
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
		<h2>회원정보 상세조회</h2>
		<article>
			<table border=1>
				<tr>
					<th>회원 아이디</th>
					<td><%=id_ %></td>
					<th>회원 비밀번호</th>
					<td><%=password_ %></td>
				</tr>
				<tr>
					<th>회원명</th>
					<td><%=name_ %></td>
					<th>주소</th>
					<td><%=addr_ %></td>
				</tr>
				<tr>
					<th>연락처</th>
					<td><%=phone_ %></td>
					<th>이메일</th>
					<td><%=email_ %></td>
				</tr>
			</table>
			<button onclick="location.href='list.jsp?midx=<%=midx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">목록</button>
			<% if(midxM == midx_){ %>
			<button onclick="location.href='modify.jsp?midx=<%=midx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
			<button onclick="deleteFn()">삭제</button>
			<% } %>
			<form name="frm" method="post">
				<input type="hidden" name="midx" value="<%=midx_%>">
			</form>			
		</article>
	</section>
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn() {
			document.frm.action = "deleteOk.jsp";
			document.frm.submit();
		}
	</script>
</body>
</html>
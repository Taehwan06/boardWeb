<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="boardWeb.util.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");
	request.setCharacterEncoding("UTF-8");

	// searchValue 가 null 이면 검색버튼을 누르지 않고 화면으로 들어옴.
	String searchValue = request.getParameter("searchValue");
	String searchType = request.getParameter("searchType");
	
	String nowPage = request.getParameter("nowPage");
	int nowPageI = 1;
	if(nowPage != null){
		nowPageI = Integer.parseInt(nowPage);
	}

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null; // 데이터베이스의 접속정보를 가지고 있는 객체
	PreparedStatement psmt = null; // sql을 가지고 있는 객체
	ResultSet rs = null; // 조회 결과를 담는 객체
	
	PagingUtil paging = null;
	
	try{
		
		Class.forName("oracle.jdbc.driver.OracleDriver"); // 드라이버 매니저로서 오라클드라이버를 사용하겠다는 선언
		conn = DriverManager.getConnection(url,user,pass); // 드라이버매니저를 통해 연결을 하겠다는 내용 ()
		String sql = "";
		
		sql += "select count(*) as total from board ";
		if(searchValue != null && !searchValue.equals("")){
			if(searchType.equals("subject")){
				sql += " where subject like '%"+searchValue+"%'";
			}else if(searchType.equals("writer")){
				sql += " where writer = '"+searchValue+"'";
			}			
		}
		
		psmt = conn.prepareStatement(sql);
		
		rs = psmt.executeQuery();
		
		int total = 0;
		
		if(rs.next()){
			total = rs.getInt("total");
		}
		
		paging = new PagingUtil(total,nowPageI,5);
		
		
		sql = " select * from ";
		sql += " (select rownum r , b.* from ";		
		sql += "(SELECT * FROM board"; // 실행하고자 하는 쿼리문
		
		if(searchValue != null && !searchValue.equals("")){
			if(searchType.equals("subject")){
				sql += " where subject like '%"+searchValue+"%'";
			}else if(searchType.equals("writer")){
				sql += " where writer = '"+searchValue+"'";
			}			
		}
		
		sql += " order by bidx desc ) b) ";
		sql += " where r>="+paging.getStart()+" and r<="+paging.getEnd();
		
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
		<h2>게시글 목록</h2>
		<article>
			<div class="searchArea">
				<form action="list.jsp">
					<select name="searchType">
						<option value="subject"
						<%if(searchType != null && searchType.equals("subject")) out.print("selected"); %>
						>글제목</option>
						<option value="writer"
						<%if(searchType != null && searchType.equals("writer")) out.print("selected"); %>
						>작성자</option>
					</select>
					<input type="text" name="searchValue"
					<%if(searchValue != null && !searchValue.equals("") && !searchValue.equals("null")) out.print("value='"+searchValue+"'"); %>>					
					<input type="submit" value="검색">
				</form>
			</div>
			<table border=1>
				<thead>
					<tr>
						<th>글번호</th>
						<th>제목</th>
						<th>작성자</th>
					</tr>
				</thead>
				<tbody>
					<%
						while(rs.next()){
					%>
						<tr>
							<td><%=rs.getInt("bidx") %></td>
							<td><a href="view.jsp?bidx=<%=rs.getInt("bidx") %>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=rs.getString("subject") %></a></td>
							<td><%=rs.getString("writer") %></td>
						<tr>	
					<%
						}
					%>
				</tbody>
			</table>
			
			<!-- 페이징 영역 -->
			<div id="pagingArea">
				<% if(paging.getStartPage() > 1){
				%>
					<a href="list.jsp?nowPage=<%=paging.getStartPage()-1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">&lt;</a>	
				<%
				}
				for(int i= paging.getStartPage(); i<=paging.getEndPage(); i++){
					if(i == paging.getNowPage()){
				%>
					<b><%= i %></b>
				<%
					}else{
				%>
					<a href="list.jsp?nowPage=<%=i%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>"><%=i%></a>
				<%
					}
				}
				%>
			
				<% 
				
				if(paging.getEndPage() != paging.getLastPage()){
				%>
					<a href="list.jsp?nowPage=<%=paging.getEndPage()+1%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>">&gt;</a>	
				<%
				}
				%>
			
			</div>
			
			
			
			
			
			
			
			
			
			
			<% if(login != null){ %>
			<button onclick="location.href='insert.jsp'">등록</button>
			<% } %>
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
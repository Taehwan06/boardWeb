<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.vo.*"%>
<%@ page import="boardWeb.util.*"%>
<%
	request.setCharacterEncoding("UTF-8");

	String memberid = request.getParameter("memberid");
	String memberpassword = request.getParameter("memberpassword");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from member where memberid = ? and memberpassword = ?";
		
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,memberid);
		psmt.setString(2,memberpassword);
		
		rs = psmt.executeQuery();
		
		Member m =null;
		if(rs.next()){
			m = new Member();
			m.setMidx(rs.getInt("midx"));
			m.setMemberid(rs.getString("memberid"));
			m.setMembername(rs.getString("membername"));
			
			session.setAttribute("loginUser",m);
		}
		
		if(m != null){
			response.sendRedirect(request.getContextPath());
		}else{
			response.sendRedirect("login.jsp");
		}
		
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt, conn, rs);
	}
	
	
	
	
%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="boardWeb.util.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="org.json.simple.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");

	request.setCharacterEncoding("UTF-8");

	String ridx = request.getParameter("ridx");
	String writer = request.getParameter("writer");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "select * from reply where ridx="+ridx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		JSONArray list = new JSONArray();
		if(rs.next()){
			JSONObject obj = new JSONObject();
			obj.put("writer",login.getMembername());
			obj.put("rcontent",rs.getString("rcontent"));
			
			list.add(obj);
		}
		out.print(list.toJSONString());
		
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		DBManager.close(psmt,conn,rs);
	}
	
%>
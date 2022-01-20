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
	String rcontent = request.getParameter("rcontent");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	PreparedStatement psmt2 = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "update reply set rcontent='"+rcontent
					+"' where ridx="+ridx;
		
		psmt = conn.prepareStatement(sql);
		psmt.executeUpdate();
		
		sql = "select * from reply where ridx="+ridx;
		
		psmt2 = conn.prepareStatement(sql);
		rs = psmt2.executeQuery();
		
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
		if(psmt2 != null){			
			psmt2.close();
		}
	}

%>
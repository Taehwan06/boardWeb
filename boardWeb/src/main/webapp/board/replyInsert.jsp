<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.util.*"%>
<%@ page import="java.sql.*"%>
<%@ page import="org.json.simple.*"%>
<%
	request.setCharacterEncoding("UTF-8");
	String rcontent = request.getParameter("rcontent");
	String bidx = request.getParameter("bidx");
	String midx = request.getParameter("midx");
	String writer = request.getParameter("writer");
	
	Connection conn = null;
	PreparedStatement psmt = null;
	PreparedStatement psmt2 = null;
	ResultSet rs = null;
	
	try{
		conn = DBManager.getConnection();
		
		String sql = "insert into reply(ridx,rcontent,bidx,midx,rdate) "
					+"values(ridx_seq.nextval,?,?,?,sysdate)";
		psmt = conn.prepareStatement(sql);
		psmt.setString(1,rcontent);
		psmt.setInt(2,Integer.parseInt(bidx));
		psmt.setInt(3,Integer.parseInt(midx));
		
		
		int result = psmt.executeUpdate();
		
		sql = "select * from reply where ridx = "
				+"(select max(ridx) from reply)";
		
		psmt2 = conn.prepareStatement(sql);
		rs = psmt2.executeQuery();
		
		JSONArray list = new JSONArray();
		if(rs.next()){
			JSONObject obj = new JSONObject();
			obj.put("writer",writer);
			obj.put("rcontent",rs.getString("rcontent"));
			obj.put("ridx",rs.getInt("ridx"));
			
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

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="boardWeb.vo.*" %>
<%
	Member loginH = (Member)session.getAttribute("loginUser");
	String midxH = null;	
%>
<header>
	<h1><a href="<%=request.getContextPath() %>">게시판 만들기</a></h1>	
	<% if(loginH == null){ %>
	<div class="loginArea">
		<a href="<%=request.getContextPath() %>/login/login.jsp">로그인</a>
		|
	<a href="<%=request.getContextPath() %>/login/join.jsp">회원가입</a>
		</div>
	<% }else if(loginH != null){
			midxH = ""+loginH.getMidx();
	%>	
	<div class="loginArea">
		<a href="<%=request.getContextPath() %>/login/logout.jsp">로그아웃</a>
		|
		<a href="<%=request.getContextPath() %>/member/view.jsp?midx=<%=midxH%>">마이페이지</a>
	</div>
	<% } %>	
</header>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="boardWeb.vo.*" %>
<%@ page import="java.util.*" %>
<%
	Member login = (Member)session.getAttribute("loginUser");
	
	request.setCharacterEncoding("UTF-8");
	
	String searchType = request.getParameter("searchType");
	String searchValue = request.getParameter("searchValue");

	String bidx = request.getParameter("bidx");

	String url = "jdbc:oracle:thin:@localhost:1521:xe";
	String user = "system";
	String pass = "1234";
	
	Connection conn = null;
	PreparedStatement psmt =null;
	ResultSet rs = null;
	
	PreparedStatement psmtReply =null;
	ResultSet rsReply = null;
	
	String subject_ = "";
	String writer_ = "";
	String content_ = "";
	int bidx_ = 0;
	int midx_ = 0;
	
	ArrayList<Reply> rList = new ArrayList<>();
	
	try{
		Class.forName("oracle.jdbc.driver.OracleDriver");
		conn = DriverManager.getConnection(url,user,pass);
		
		String sql = "select * from board where bidx = "+bidx;
		
		psmt = conn.prepareStatement(sql);
		rs = psmt.executeQuery();
		
		if(rs.next()){
			subject_ = rs.getString("subject");
			writer_ = rs.getString("writer");
			content_ = rs.getString("content");
			bidx_ = rs.getInt("bidx");
			midx_ = rs.getInt("midx");
		}
		
		sql = "select * from reply r, member m where r.midx=m.midx and bidx="+bidx+" and r.delyn='N' order by ridx";
		
		psmtReply = conn.prepareStatement(sql);
		rsReply = psmtReply.executeQuery();
				
		
		while(rsReply.next()){
			Reply reply = new Reply();
			reply.setBidx(rsReply.getInt("bidx"));
			reply.setMidx(rsReply.getInt("midx"));
			reply.setRidx(rsReply.getInt("ridx"));
			reply.setRcontent(rsReply.getString("rcontent"));
			reply.setRdate(rsReply.getString("rdate"));
			reply.setMembername(rsReply.getString("membername"));
			
			rList.add(reply);
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
		if(psmtReply != null){
			psmtReply.close();
		}
		if(rsReply != null){
			rsReply.close();
		}
	}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="<%=request.getContextPath() %>/css/base.css" rel="stylesheet">
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>	
	function replyInsert(){
		$.ajax({
			url: "replyInsert.jsp",
			type: "post",
			data: $("form[name='reply']").serialize(),
			success: function(data){
				if(data != 0){
					var json = JSON.parse(data.trim());
					alert("댓글 등록 성공!");
					var html = "";
					html += "<tr>";
					html += "<td>"+json[0].writer+" :</td>";
					html += "<td>"+json[0].rcontent+"</td>";					
					html += "<td><button onclick='replyModify("+json[0].ridx+",this)'>수정</button>"							
							+"<button>삭제</button></td>";
					html += "</tr>";
					
					$("#replyTbody").append(html);
				}else{
					alert("댓글 등록 실패!");
				}
			}
		});
	}
	
	function replyModify(ridx,obj){		
		$.ajax({
			url: "replyModify.jsp",
			type: "post",
			data: "ridx="+ridx,
			success: function(data){
				var json = JSON.parse(data.trim());
				var html = "";				
				html += "<input type='text' value='"+json[0].writer+"' readonly>";								
				$(obj).parent().prev().prev().html(html);
				
				html = "";				
				html += "<input type='text' value='"+json[0].rcontent+"'>";				
				$(obj).parent().prev().html(html);
				
				$(obj).val("저장");
				$(obj).next().val("취소");
				$(obj).on("click",function(){
					var rcontent = $(obj).parent().prev().children().first().val();
					$.ajax({
						url: "replyModifyOk.jsp",
						type: "post",
						data: "ridx="+ridx+"&rcontent="+rcontent,
						success: function(data2){
							var json2 = JSON.parse(data2.trim());
							html = json2[0].rcontent;										
							$(obj).parent().prev().html(html);
							
							html = json[0].writer;								
							$(obj).parent().prev().prev().html(html);
							
							$(obj).val("수정");
							$(obj).next().val("삭제");
						}
					});
				});
			}
		});		
	}
	
	function deletFn(ridx, obj){
		var YN = confirm("삭제하시겠습니까?");
		if(YN){
			$.ajax({
				url: "deletOk.jsp",
				type: "post",
				data: "ridx="+ridx,
				success: function(data){
					if(data>0){
						alert("삭제 성공!");
						$(obj).parent().parent().remove();
					}else{
						alert("삭제 실패!");
					}
				}
				
			});
		}
	}
	
</script>
</head>
<body>
	<%@ include file="/header.jsp" %>
	<section>
		<h2>게시글 상세조회</h2>
		<article>
			<table border=1 width="70%">
				<tr>
					<th>글제목</th>
					<td colspan="3"><%=subject_ %></td>
				</tr>
				<tr>
					<th>글번호</th>
					<td><%=bidx_ %></td>
					<th>작성자</th>
					<td><%=writer_ %></td>
				</tr>
				<tr height="300">
					<th>내용</th>
					<td colspan="3"><%=content_ %></td>
				</tr>
			</table>
			<button onclick="location.href='list.jsp?searchType=<%=searchType%>&searchValue=<%=searchValue%>'">목록</button>		
			<% if(login != null && login.getMidx() == midx_){ %>
			<button onclick="location.href='modify.jsp?bidx=<%=bidx_%>&searchType=<%=searchType%>&searchValue=<%=searchValue%>'">수정</button>
			<button onclick="deleteFn()">삭제</button>
			<% } %>
			<form name="frm" action="delectOk.jsp" method="post">
				<input type="hidden" name="bidx" value="<%=bidx_%>">
			</form>
			
			<div class="replyArea">
				<div class="replyList">
				<table>
					<tbody id="replyTbody">
				<%for(Reply r: rList){ %>
						<tr>
							<td><%=r.getMembername() %> :</td>
							<td><%=r.getRcontent() %></td>
							<%if(login != null && login.getMidx() == r.getMidx()){ %>
							<td>
								<input type="button" value="수정" onclick="replyModify(<%=r.getRidx()%>,this)">
								<input type="button" value="삭제" onclick="deletFn(<%=r.getRidx()%>,this)">
							</td>
							<%} %>
						</tr>
				<%} %>
					</tbody>
				</table>
				</div>
				<%if(login != null){ %>
				<div class="replyInout">
					<form name="reply">
					<input type="hidden" name="bidx" value="<%=bidx_%>">
					<input type="hidden" name="midx" value="<%=login.getMidx()%>">
					<input type="hidden" name="writer" value="<%=login.getMembername() %>">
						<p>
							<label>
								내용 : <input type="text" name="rcontent" size="50">						
							</label>
						</p>
						<p>
							<input type="button" value="저장" onclick="replyInsert()">							
						</p>
					</form>
				</div>
				<%} %>
			</div>
			
			
		</article>	
	</section>	
	<%@ include file="/footer.jsp" %>
	<script>
		function deleteFn(){
			document.frm.submit();
		}
		
	</script>
</body>
</html>
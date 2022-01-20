<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>
	function callList(){
		$.ajax({
			url: "ajaxList2.jsp",
			type: "get",
			success: function(data){
				var json JSON.parse(data.trim());
				
				var html = "";
				html += "<table border='1'>";
				html += "<thead>";
				html += "<tr>";
				html += "<td>글번호</td><td>제목</td><td>작성자</td><td></td>";
				html += "</tr>";
				html += "</thead>";
				html += "<tbody>";
				for(var i=0; i<json.length; i++){
					html += "<tr>";
					html += "<td>"+json[i].bidx+"</td>";
					html += "<td>"+json[i].subject+"</td>";
					html += "<td>"+json[i].writer+"</td>";
					html += "<td><button onclick='modify("+json[i].bidx+",this)'>수정</button>"
							+"<button onclick='deleteFn("+json[i].bidx+",this)'>삭제</button></td>";
					html += "</tr>";
				}
				html += "</tbody>";				
				html += "</table>";
				
				$("#list").html(html);
			}
		});
	}
</script>
</head>
<body>
	<button onclick="callList()">목록 출력</button>
	<h2>ajax를 이용한 게시판 구현</h2>
	<div id="list">
		
	</div>
	<div id="write">
		<form>
		<input type="hidden" name="bidx">
			<p>
				<label>
					제목 : <input type="text" name="subject" size="50">
				</label>
			</p>
			<p>
				<label>
					작성자 : <input type="text" name="writer" size="50">
				</label>
			</p>
			<p>
				<label>
					내용 : <textarea name="content"></textarea>
				</label>
			</p>
			<input type="button" value="저장" onclick="save()">			
		</form>	
	</div>
</body>
</html>
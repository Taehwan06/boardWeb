<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="<%=request.getContextPath()%>/js/jquery-3.6.0.min.js"></script>
<script>
	var clickBtn;
	var printTable = false;
	
	function callList(){
		printTable = true;
		$.ajax({
			url: "ajaxList.jsp",
			type: "get",
			success: function(data){				
				var json = JSON.parse(data.trim());
				
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
	/*
		$.ajax({
			url: "경로",
			type: "메소드",
			data: "파라미터형식으로 된 데이터" -> "bidx=5", <- 요청 결로에서 데이터는 request.getParameter("bidx");로 찾을 수 있다.
			success: function(data){
				
			}			
		});	
	*/
	function modify(bidx,obj){
		clickBtn = obj;
		$.ajax({
			url: "ajaxView.jsp",
			type: "get",
			data: "bidx="+bidx,  // {bidx : bidx, data1 : 1}  객체 형식으로도 넘길 수 있다
								 //   키값 : 
			success: function(data){				
				var json = JSON.parse(data.trim());
				
				$("input[name='subject']").val(json[0].subject);				
				$("input[name='writer']").val(json[0].writer);
				$("textarea").val(json[0].content);
				$("input[name='bidx']").val(json[0].bidx);
			}
		});
	}
	
	function save(){
		// 저장버튼 클릭시 ajax를 이용하여 해당 데이터 수정
		// 1. form 태그 안에 입력한 입력양식 데이터
		// 2. modify.jsp 로 ajax를 통하여 1번의 데이터를 전송
		// 3. modify.jsp에서는 board 테이블 수정 작업
		var subject = $("input[name='subject']").val();
		var writer = $("input[name='writer']").val();
		var bidx = $("input[name='bidx']").val();
		
		var YN;
		
		if(bidx == ""){
			YN=confirm("등록하시겠습니까?");
			if(YN){
				$.ajax({				
					url: "ajaxInsert.jsp",
					type: "post",
					data: $("form").serialize(),
					success: function(data){
						// 화면에 게시글 목록이 출력되고 있는 경우에만
						// 응답 데이터 한건 테이블 맨 윗 행으로 추가
						// jQuery prepend()사용
						var json = JSON.parse(data.trim());
						var html = "";
						if(printTable){							
							html += "<tr>";
							html += "<td>"+json[0].bidx+"</td>";
							html += "<td>"+json[0].subject+"</td>";
							html += "<td>"+json[0].writer+"</td>";
							html += "<td><button onclick='modify("+json[0].bidx+",this)'>수정</button>"
									+"<button onclick='deleteFn("+json[0].bidx+",this)'>삭제</button></td>";
							html += "</tr>";
							
							$("tbody").prepend(html);
						}
						document.frm.reset();
						$("input[name='bidx']").val("");
					}
				});
			}
		}else{
			YN=confirm("수정하시겠습니까?");
			if(YN){
				$.ajax({
					url: "ajaxUpdate.jsp",
					type: "post",
					data: $("form").serialize(), //bidx=?&subject=?.....
					success: function(data){
						if(data.trim()>0){
							alert("수정이 완료 되었습니다.");
						}else{
							alert("수정이 실패했습니다.");
						}				
						$(clickBtn).parent().prev().text(writer);
						$(clickBtn).parent().prev().prev().text(subject);
						
						//$("form").reset();
						document.frm.reset();
						$("input[name='bidx']").val("");
					}
				});
			}
		}		
	}
	
	function deleteFn(bidx,obj){		
		$.ajax({
			url: "ajaxDelete.jsp",
			type: "post",
			data: "bidx="+bidx,
			success: function(data){
				if(data.trim()>0){
					$(obj).parent().parent().remove();
					alert("삭제가 완료되었습니다");
				}else{
					alert("삭제가 실패했습니다.");
				}			
			}
		});
	}
	
	function resetFn(){
		document.frm.reset();
		$("input[name='bidx']").val("");		
	}
	
</script>
</head>
<body>
	<button onclick="callList()">목록 출력</button>
	<h2>ajax를 이용한 게시판 구현</h2>
	<div id="list">
		
	</div>
		
	<div id="write">
		<form name="frm">
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
			<input type="button" value="초기화" onclick="resetFn()">			
		</form>	
	</div>	
</body>
</html>
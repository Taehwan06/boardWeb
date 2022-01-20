<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callJSON(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					console.log(jObj);
					
					for(var i=0; i<jObj.length; i++){
						var obj = jObj[i];
						
						document.getElementById("result").innerHTML += 
							obj.name + ","+obj.publisher+","+obj.author+","+obj.price+"<br>";
					}
				}
			}
			
		}
		
		request.open("GET","data/json/data1.json",false);
		request.send();
	}
	//json2 버튼 클릭시 data2.json ajax를 사용하여 불러오기
	function callJSON2(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					//jObj 가 가지고 있는 field3 들을 result 태그에 출력
				}
			}
		}
		
		request.open("GET","data/json/data2.json",false);
		request.send();
		
	}
	
	
	
	
</script>
</head>
<body>
	<h2>XML,JSON ajax 통신 예제</h2>
	<button onclick="callJSON()">json</button>
	<button onclick="callJSON2()">json2</button>
	<button onclick="callXML()">xml</button>
	<div id="result">
	</div>
</body>
</html>


<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script>
	function callJSON(){
		var request = new XMLHttpRequest();  // 새로운 XMLHttpRequest 객체 생성 -> ajax 통신의 시작
		request.onreadystatechange = function(){  // 예외처리 -> open() 전에 작성
			if(request.readyState == 4){  // 내가 보낸 요청의 응답이 완료된 상태
				if(request.status == 200){  //  에러 없이 온전히 처리된 상태
					var jObj = JSON.parse(request.responseText);  // 응답 데이터를 받아옴
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
	
	
	// json2 버튼 클릭시 data2.json ajax를 사용하여 불러오기
	function callJSON2(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var jObj = JSON.parse(request.responseText);
					// jObj 가 가지고 있는 field3 들을 result 태그에 출력
					
					for(var i=0; i<jObj.length; i++){
						var field3 = jObj[i].field3;
						
						for(var j=0; j<field3.length; j++){							
							
							document.getElementById("result").innerHTML +=
								field3[j].subField1 +","+ field3[j].subField2  +"<br>";						
						}						
					}					
				}
			}
		}		
		request.open("GET","data/json/data2.json",false);
		request.send();
	}
	
	
	function callXML(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					
					var books = xml.getElementsByTagName("book");
					
					//console.log(books);
					for(var i=0; i<books.length; i++){
						var name = books[i].getElementsByTagName("name")[0].textContent;
						var publisher = books[i].getElementsByTagName("publisher")[0].textContent;
						var author = books[i].getElementsByTagName("author")[0].textContent;
						var price = books[i].getElementsByTagName("price")[0].textContent;
						
						document.getElementById("result").innerHTML +=
							name +","+ publisher +","+ author +","+ price +"<br>";
					}
				}
			}
		}
		request.open("GET","data/xml/data1.xml",false);
		request.send();		
	}
	
	// xml2 버튼 클릭시 data2.xml에 있는 모든 subItem의 
	// name태그 값을 result 태그에 출력하세요
	
	function callXML2(){
		var request = new XMLHttpRequest();
		request.onreadystatechange = function(){
			if(request.readyState == 4){
				if(request.status == 200){
					var xml = request.responseXML;
					var subItem = xml.getElementsByTagName("subItem");
					for(var i=0; i<subItem.length; i++){
						var name = subItem[i].getElementsByTagName("name");
						for(var j=0; j<name.length; j++){
							document.getElementById("result").innerHTML +=
								name[j].textContent +"<br>";
						}
					}
				}
			}
		}
		request.open("GET","data/xml/data2.xml");
		request.send();
	}
		
	
</script>
</head>
<body>
	<h2>XML,JSON ajax 통신 예제</h2>
	<button onclick="callJSON()">json</button>
	<button onclick="callJSON2()">json2</button>
	<button onclick="callXML()">xml</button>
	<button onclick="callXML2()">xml2</button>
	<button onclick="callXML3()">xml3</button>
	<div id="result">
	</div>
</body>
</html>
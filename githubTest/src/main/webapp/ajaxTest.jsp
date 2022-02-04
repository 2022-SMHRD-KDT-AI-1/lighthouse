<%@page import="Model.GuDTO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="Model.GuDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=d6fdfec4a3236f5dd4c82e0e3deaf991&libraries=services"></script>
</head>
<body>

	<%
		GuDAO dao = new GuDAO();
		ArrayList<GuDTO> gu_list = dao.selectAll();
	%>


	<!-- <form action="" method="post"> -->
	<div>
		<select name="kind" id="kind">
			<option value="" disabled selected>분야를 선택하세요</option>
			<option value="편의시설">편의시설</option>
			<option value="음식점">음식점</option>
			<option value="숙박시설">숙박시설</option>
			<option value="직업재활시설">직업재활시설</option>

		</select> 
		
		<select name="gu" id="gu">
			<option value="" disabled selected>구를 선택하세요</option>
			<%
				for (int i = 0; i < gu_list.size(); i++) {
			%>
			<option value="<%=gu_list.get(i).getAddr()%>"><%=gu_list.get(i).getAddr()%></option>
			<%
				}
			%>
		</select>
		<button onclick="test()">선택</button>
	</div>

	


	<div id="map" style="width: 100%; height: 600px;"></div>
	<span id="seq"></span><br>
	<span id="name"></span><br>
	<span id="addr"></span><br>
	<span id="tel"></span><br>
	<span id="approach"></span><br>
	<span id="hdiff"></span><br>
	<span id="parking"></span><br>
	<span id="elev"></span><br>
	<span id="toilet"></span><br>
	
	<h1>===Review===</h1>
	<div>
	</div>
	
	<form action="reviewService" method="post">
		<input  type="hidden" name="chkind" id="chkind">
		<h1>Review 작성하기</h1>
		<select id="Rselect" name="Rselect"></select><br>
		<span>Q1</span>
	    1<input type="radio" id="q1" name="q1" value="1">
	    2<input type="radio" id="q1" name="q1" value="2">
	    3<input type="radio" id="q1" name="q1" value="3">
	    4<input type="radio" id="q1" name="q1" value="4">
	    5<input type="radio" id="q1" name="q1" value="5">
	    <br>
	    <span>Q2</span>
	    1<input type="radio" id="q2" name="q2" value="1">
	    2<input type="radio" id="q2" name="q2" value="2">
	    3<input type="radio" id="q2" name="q2" value="3">
	    4<input type="radio" id="q2" name="q2" value="4">
	    5<input type="radio" id="q2" name="q2" value="5">
	    <br>
	    <span>Q3</span>
	    1<input type="radio" id="q3" name="q3" value="1">
	    2<input type="radio" id="q3" name="q3" value="2">
	    3<input type="radio" id="q3" name="q3" value="3">
	    4<input type="radio" id="q3" name="q3" value="4">
	    5<input type="radio" id="q3" name="q3" value="5">
	    <br>
	    <textarea id="text" name="text" placeholder="간단한 리뷰를 작성하세요"></textarea>
	    <input type="submit" value="보내기">
    </form>
	<script>
		$('#kind').on('change',function(){
			$('input[name=chkind]').attr('value', this.value);
		})
		$('#seq').on('change',function(){
			$
		})
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div  
		mapOption = {
			center : new kakao.maps.LatLng(33.450701, 126.570667), // 초기 지도 중심좌표 , 현 위치로 하고싶음
			level : 3
		};

		var map = new kakao.maps.Map(mapContainer, mapOption); // 지도를 생성합니다

		// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다 
		var positions = [
			{
		        content: '<div>카카오</div>',
		        latlng: new kakao.maps.LatLng(33.450705, 126.570677)
		    }
		];

		for (var i = 0; i < positions.length; i++) {
			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({
				map : map, // 마커를 표시할 지도
				position : positions[i].latlng
			// 마커의 위치
			});

			// 마커에 표시할 인포윈도우를 생성합니다 
			var infowindow = new kakao.maps.InfoWindow({
				content : positions[i].content
			// 인포윈도우에 표시할 내용
			});

			// 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
			// 이벤트 리스너로는 클로저를 만들어 등록합니다 
			// for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
			kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
					map, marker, infowindow));
			kakao.maps.event.addListener(marker, 'mouseout',
					makeOutListener(infowindow));
		}

		// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
		function makeOverListener(map, marker, infowindow) {
			return function() {
				infowindow.open(map, marker);
			};
		}

		// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
		function makeOutListener(infowindow) {
			return function() {
				infowindow.close();
			};
		}
		
		var testseq = 0;
		/* ======================= 여기서부터 '선택'버튼 클릭했을 때  ======================== */
		function test() {
			// select태그에서 선택된 값을 변수에 담음
			var kind = $("#kind").val();
			var gu = $("#gu").val();
			
			
			// 한 번에 키밸류에 담음
			var param = {
				"kind" : kind,
				"gu" : gu
			};
			
			// ajax소환..
			// anyne는 안해도됨
			// url은 보낼 곳... testAjax.java에 보낼거임
			// data : 보낼 데이터가 있으면 적으삼
			// dataType : 리턴받을 데이터 타입 json, html, text 등..
			// success: 성공했을 때~
			$.ajax({
				anyne : true,
				url : "testAjax",
				type : "post",
				data : param,
				dataType : "json",
				success : function(data) {

					console.log(data);
					var mapContainer = document.getElementById('map'),
					mapOption = {
							center : new kakao.maps.LatLng(data[0].Latitude, data[0].Longitude), 
							level : 2
						// 지도의 확대 레벨
					};
					var map = new kakao.maps.Map(mapContainer, mapOption);
					
					var positions = [];
					// 마커를 표시할 위치와 내용을 가지고 있는 객체 배열입니다 
					for(var i=0; i<data.length; i++){
						positions.push({
							// 순번
							sequence : data[i].Seq,
							// 시설명
							content : data[i].Name,
							// 주소
							addr : data[i].Addr,
							// 전화번호
							tel : data[i].Tel,
							// 접근로 여부1
							approach : data[i].Approach,
							// 높이차이 여부2
							hdiff : data[i].HeightDiff,
							// 주차장 여부3
							parking : data[i].Parking,
							// 승강기 여부4
							elev : data[i].Elev,
							// 화장실 여부5
							toilet : data[i].Toilet,
							// 좌표
							latlng : new kakao.maps.LatLng(data[i].Latitude,data[i].Longitude)
						});
						
						
						
					}
						
					
					var testseq = [];
					var testName = [];
					for (var i = 0; i < positions.length; i++) {
						// 마커를 생성합니다
						var marker = new kakao.maps.Marker({
							map : map, // 마커를 표시할 지도
							position : positions[i].latlng
						// 마커의 위치
						});

						// 마커에 표시할 인포윈도우를 생성합니다 
						var infowindow = new kakao.maps.InfoWindow({
							content : positions[i].content
						// 인포윈도우에 표시할 내용
						});
						
						testseq.push(positions[i].sequence);
						testName.push(positions[i].content);
						
						kakao.maps.event.addListener(marker, 'click', chDiv(positions[i].sequence, positions[i].content,positions[i].addr, 
								positions[i].tel, positions[i].approach, positions[i].hdiff,positions[i].parking, 
								positions[i].elev, positions[i].toilet));

						// 마커에 mouseover 이벤트와 mouseout 이벤트를 등록합니다
						// 이벤트 리스너로는 클로저를 만들어 등록합니다 
						// for문에서 클로저를 만들어 주지 않으면 마지막 마커에만 이벤트가 등록됩니다
						kakao.maps.event.addListener(marker, 'mouseover', makeOverListener(
								map, marker, infowindow));
						kakao.maps.event.addListener(marker, 'mouseout',
								makeOutListener(infowindow));
						
						$('#Rselect').append('<option name="Rselect" value="'+ testseq[i] +'">'+ testName[i] +'</option>');
					}
					
					console.log(testName);

					// 인포윈도우를 표시하는 클로저를 만드는 함수입니다 
					function makeOverListener(map, marker, infowindow) {
						return function() {
							infowindow.open(map, marker);
						};
					}

					// 인포윈도우를 닫는 클로저를 만드는 함수입니다 
					function makeOutListener(infowindow) {
						return function() {
							infowindow.close();
						};
					}
					
					
					
					function chDiv(sequence, content, addr, tel, approach, hdiff, parking, elev, toilet){
						return function(){
							var ch_seq = document.getElementById('seq');  
							ch_seq.innerHTML = sequence;

							var ch_name = document.getElementById('name');
							ch_name.innerHTML = content;
							
							var ch_addr = document.getElementById('addr');
							ch_addr.innerHTML = addr;
							
							var ch_tel = document.getElementById('tel');
							ch_tel.innerHTML = tel;
							
							var ch_approach = document.getElementById('approach');
							ch_approach.innerHTML = approach;
							
							var ch_hdiff = document.getElementById('hdiff');
							ch_hdiff.innerHTML = hdiff;
							
							var ch_parking = document.getElementById('parking');
							ch_parking.innerHTML = parking;
							
							var ch_elev = document.getElementById('elev');
							ch_elev.innerHTML = elev;
							
							var ch_toilet = document.getElementById('toilet');
							ch_toilet.innerHTML = toilet;
							
							
						}
					}

					
				
				},
				error : function(e, c, d) {
					alert('error');
					console.log("ERROR : " + c + " : " + d);
				}
				

			});
		}
		
		
		
		
		
		</script>


</body>
</html>
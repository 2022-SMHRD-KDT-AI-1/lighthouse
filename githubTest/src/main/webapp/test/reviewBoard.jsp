<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html id='ht' class>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="reviewBoard.css?after" rel="stylesheet" type="text/css">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>


	<div id="board">
		<div id="n_135">
			<svg class="n_49">
			<rect id="n_49" rx="0" ry="0" x="0" y="0" width="1920" height="1080">
			</rect>
		</svg>
		</div>
		<svg class="n_50">
		<rect id="n_50" rx="0" ry="0" x="0" y="0" width="1640" height="1080">
		</rect>
	</svg>

		<input type="hidden" name="chkind" id="chkind">

		<div id="n_49_o">
			<div id="Title_TAGH1">
				<span>전체 후기</span>
			</div>
		</div>


		<select name="kind" id="kind" onchange="typeFn()">
			<option value="전체" selected>전체보기</option>
			<option value="음식점">음식점</option>
			<option value="편의시설">편의시설</option>
			<option value="숙박시설">숙박시설</option>
		</select>




		<div class="Background_STYLESTYLE2">
			<table width='1000px' id="reviewTable">
				<thread>
				<tr>
					<th class="testTH">번호</th>
					<th class="testTH">아이디</th>
					<th class="testTH">방문한 곳</th>
					<th class="testTH">작성날짜</th>
				</tr>
				</thread>
				<tbody id="chTable">
				</tbody>
			</table>
		</div>
	</div>
	<div id="n_83">
		<svg class="Background_STYLESTYLE2_b">
				<rect id="Background_STYLESTYLE2_b" rx="0" ry="0" x="0" y="0"
				width="1640" height="96">
				</rect>
			</svg>
		<div id="Terms_of_Service_STYLESTYLE2TA">
			<span>Terms of Service</span>
		</div>
		<div id="Privacy_Policy_STYLESTYLE2TAGU">
			<span>Privacy Policy</span>
		</div>
		<div id="Copyright_STYLESTYLE2TAGUI_S">
			<span>© 2022 Light House. All Rights Reserved.</span>
		</div>
	</div>

	<div onclick="location='ajaxTest.jsp'" id="n_118">
		<svg class="Area_DISPLAY_ELEMENTSLabelSIZE" viewBox="0 0 174.653 57">
				<path id="Area_DISPLAY_ELEMENTSLabelSIZE"
				d="M 0 0 L 174.65283203125 0 L 174.65283203125 57 L 0 57 L 0 0 Z">
				</path>
			</svg>
		<div id="Label">
			<span>메인화면</span>
		</div>
	</div>
	
	<script>
		var kind = $("#kind").val();

		console.log(kind);

		$.ajax({
			anyne : true,
			url : "reviewBoardService",
			type : "post",
			data : {
				"kind" : kind
			},
			dataType : "json",
			success : function(data) {
				console.log(data);

				var html = '';

				/*  */
				for (var i = 0; i < data.length; i++) {
					html += '<tr>';
					html += '<td align="center" class="Title_TAGH1_be">'
							+ (i + 1) + '</td>';
					html += '<td align="center" class="Title_TAGH1_be">'
							+ data[i].id + '</td>';
					html += '<td align="center" class="Title_TAGH1_be">'
							+ '<a href="viewBoard.jsp?seq='
							+ data[i].seq
							+ '&id='
							+ data[i].id
							+ '&num='
							+ (i + 1)
							+ '&name='
							+ data[i].name
							+ '&date='
							+ data[i].date
							+ '&s1='
							+ data[i].s1
							+ '&s2='
							+ data[i].s2
							+ '&s3='
							+ data[i].s3
							+ '&s4='
							+ data[i].s4
							+ '&s5='
							+ data[i].s5
							+ '&text='
							+ data[i].text
							+ '">'
							+ data[i].name
							+ '</a>'
							+ '</td>';
					html += '<td align="center" class="Title_TAGH1_be">'
							+ data[i].date + '</td>';
					html += '</tr>';

				}

				$("#chTable").append(html);

			},

			error : function() {
				alert("실패");
			}

		});

		function typeFn() {

			var kind = $("#kind").val();

			console.log(kind);

			$.ajax({
				anyne : true,
				url : "reviewBoardService",
				type : "post",
				data : {
					"kind" : kind
				},
				dataType : "json",
				success : function(data) {
					console.log(data);

					var html = '';

					for (var i = 0; i < data.length; i++) {
						html += '<tr>';
						html += '<td align="center" class="Title_TAGH1_be">'
								+ (i + 1) + '</td>';
						html += '<td align="center" class="Title_TAGH1_be">'
								+ data[i].id + '</td>';
						html += '<td align="center" class="Title_TAGH1_be">'
								+ '<a href="viewBoard.jsp?seq='
								+ data[i].seq
								+ '&id='
								+ data[i].id
								+ '&num='
								+ (i + 1)
								+ '&name='
								+ data[i].name
								+ '&date='
								+ data[i].date
								+ '&s1='
								+ data[i].s1
								+ '&s2='
								+ data[i].s2
								+ '&s3='
								+ data[i].s3
								+ '&s4='
								+ data[i].s4
								+ '&s5='
								+ data[i].s5
								+ '&text='
								+ data[i].text
								+ '">'
								+ data[i].name
								+ '</a></td>';
						html += '<td align="center" class="Title_TAGH1_be">'
								+ data[i].date + '</td>';
						html += '</tr>';
					}

					$("#chTable").empty();
					$("#chTable").append(html);

				},
				error : function() {
					alert("실패");
				}

			});
		}
	</script>
	<svg class="n_61">
         <rect id="n_61" rx="0" ry="0" x="0" y="0" width="140" height="192">
         </rect>
      </svg>
   
   <div id="Label_j">
            <button onClick="zoomIn();" style="font-size: 18pt;background-color : #DCDCDC;">확대
               (+)</button>
         </div>
      </div>
      <div id="List_Item_j">
         <div id="METADATA_ka">
            <span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
               Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.546Z"}</span>
         </div>
         <svg class="Base_ka">
         <rect id="Base_ka" rx="0" ry="0" x="0" y="0" width="140" height="47">
         </rect>
      </svg>
         <svg class="Divider_ka" viewBox="0 0 140 2">
         <path id="Divider_ka" d="M 0 0 L 140 0">
         </path>
      </svg>
         <div id="Label_ka">
            <button onClick="zoomOut();" style="font-size: 18pt; background-color : #DCDCDC;">축소
               (-)</button>
         </div>
      </div>
      <script type="text/javascript">
            var nowZoom = 100;

               function zoomOut() {
                 // 화면크기축소
                 nowZoom = nowZoom - 10;
                 if (nowZoom <= 70) nowZoom = 70; // 화면크기 최대 축소율 70%
                 zooms();
               }

               function zoomIn() {
                 // 화면크기확대
                 nowZoom = nowZoom + 10;
                 if (nowZoom >= 200) nowZoom = 200; // 화면크기 최대 확대율 200%
                 zooms();
               }
               
               function zooms() {
                   document.body.style.zoom = nowZoom + "%";
                   if (nowZoom == 70) {
                     alert("더 이상 축소할 수 없습니다."); // 화면 축소율이 70% 이하일 경우 경고창
                   }
                   if (nowZoom == 200) {
                     alert("더 이상 확대할 수 없습니다."); // 화면 확대율이 200% 이상일 경우 경고창
                   }
                 }
            </script>
      <div id="List_Item_ka">
         <div id="METADATA_kb">
            <span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
               Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.551Z"}</span>
         </div>
         <svg class="Base_kc">
         <rect id="Base_kc" rx="0" ry="0" x="0" y="0" width="140" height="48">
         </rect>
      </svg>
         <svg class="Divider_kd" viewBox="0 0 140 2">
         <path id="Divider_kd" d="M 0 0 L 140 0">
         </path>
      </svg>
         <div id="Label_ke">
            <button type='button' id='off' style="font-size: 18pt; background-color : #DCDCDC;">고대비끄기</button>
         </div>
      </div>
      <script type="text/javascript">
                  document.getElementById("off").addEventListener("click", function () {
                    document.getElementById("ht").setAttribute("class", "null");
               });
      
   </script>
      <div id="List_Item_kf">
         <div id="METADATA_kg">
            <span>{"config":{},"type":"ListItem","theme":"Base","nodeName":"List
               Item","__plugin":"Mockup","__version":"1.4.13","__lastUpdate":"2022-02-04T02:44:24.556Z"}</span>
         </div>
         <svg class="Base_kh">
         <rect id="Base_kh" rx="0" ry="0" x="0" y="0" width="140" height="46">
         </rect>
      </svg>
         <svg class="Divider_ki" viewBox="0 0 140 2">
         <path id="Divider_ki" d="M 0 0 L 140 0">
         </path>
      </svg>
         <div id="Label_kj">
            <button type='button' id='on' style="font-size: 18pt; background-color : #DCDCDC;">고대비켜기</button>
         </div>
      </div>
		<script type="text/javascript">
			document.getElementById("on").addEventListener("click", function () {
   	     document.getElementById("ht").setAttribute("class", "invert");
      });
	</script>


</body>
</html>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="db.DBConnetion"%>
<%@ page import="java.sql.*"%>

<%
Connection conn = DBConnetion.getConnection();

String sql = "select custno, custname, phone, address, to_char(joindate, 'yyyy-mm-dd'), case grade when 'A' then 'VIP' when 'B' then '일반'  when 'C' then '직원'  end,city from member_tbl_02";

PreparedStatement pstmt = conn.prepareStatement(sql);

ResultSet rs = pstmt.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" type="text/css" href="css/style.css?as">
</head>

<body>
	<header>
		<jsp:include page="layout/header.jsp"></jsp:include>
	</header>

	<nav>
		<jsp:include page="layout/nav.jsp"></jsp:include>
	</nav>

	<section class="section">
		<h2>회원목록조회/수정</h2>

		<table class="table_line">
			<thead>
				<tr>
					<th>회원번호</th>
					<th>회원성명</th>
					<th>전화번호</th>
					<th>주소</th>
					<th>가입일자</th>
					<th>고객등급</th>
					<th>거주지역</th>
				</tr>
			</thead>
			<tbody>
				<%
				while (rs.next()) {
				%>
				<tr>
					<td><a><%=rs.getString(1)%></a></td>
					<td><%=rs.getString(2)%></td>
					<td><%=rs.getString(3)%></td>
					<td><%=rs.getString(4)%></td>
					<td><%=rs.getString(5)%></td>
					<td><%=rs.getString(6)%></td>
					<td><%=rs.getString(7)%></td>
				</tr>
				<%
				}
				%>
			</tbody>
		</table>
	</section>

	<footer>
		<jsp:include page="layout/footer.jsp"></jsp:include>
	</footer>
</body>
</html>
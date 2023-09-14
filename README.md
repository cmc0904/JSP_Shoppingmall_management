# JSP_Shoppingmall_management
쇼핑몰 회원관리 웹사이트

## 자바 자료구조 디자인 패턴 - 싱글톤 (Singleton)

Singleton 패턴은 인스턴스를 불필요하게 생성하지 않고 오직 JVM내에서 한 개의 인스턴스만 생성하여 재사용을 위해 사용되는 디자인패턴입니다. 불필요한 객체 생성을 방지하여 메모리를 효율적으로 관리 할 수 있습니다.

## 싱글톤 방식이 적용된 데이터베이스 접근
데이터베이스에 접근하기 위한 객체는 접근할때 마다 만들필요가 없으므로 싱글톤 방식을 적용하여 효율적으로 메모리를 관리 합니다.
```java
package db;

import java.sql.*;

public class DBConnection {
	private static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	private static String id = "system";
	private static String pw = "1234";
	private static Connection conn;
	
	static {
		try {
			Class.forName("oracle.jdbc.OracleDriver");
			conn = DriverManager.getConnection(url, id, pw);
			System.out.println("접속 성공");
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	public static Connection getConnection() {
		return conn;
	}

}
```

Oracle 데이터베이스에 접근 하기 위한 객체를 얻기 위한 함수를 얻기 위한 함수를 가진 클래스 입니다.

## 회원등록
![image](https://github.com/cmc0904/JSP_Shoppingmall_management/assets/63144310/d53bbf18-9ea5-4b37-8540-474d97aad8f3)

```jsp
<%
String sql = "select max(custno) from member_tbl_02"; // 쿼리문 형식의 문자열이 변수명 sql에 저장

Connection conn = DBConnection.getConnection(); // DB 연결 기능을 객체변수 conn 에 저장 -> 1.DB연결
PreparedStatement pstmt = conn.prepareStatement(sql); // sql변수에 저장되어 있는 문장이 쿼리문이 됨 ->2.DB연결 후 쿼리문이 생성\
ResultSet rs = pstmt.executeQuery(); // 변수pstmt에 저장되어있는 SQL문을 실행하여 객체변수 rs에 저장
rs.next(); //변수 rs에 결과값이 저장되는 경우 next()를 호출하여 마지막 값을 확인

int num = rs.getInt(1) + 1; //num에는 오라클 member 테이블의 마지막 회원번호 + 1 값이 정수로 저장
%>
```

회원 등록 자동 발생을 위하여 데이터베이스로 부터 가장 최근의 회원정보를 불러온 뒤 해당 숫자에 1 을 더하여 회원번호 자동 발생

```js
function checkValue() {
	if (!document.data.custname.value) {
		alert("회원성명이 입력되지 않았습니다.");
		data.custname.focus();
		return false;
	} else if (!document.data.phone.value) {
		alert("전화번호가 입력되지 않았습니다.");
		data.phone.focus();
		return false;
	} else if (!document.data.address.value) {
		alert("주소를 입력하세요.");
		data.address.focus();
		return false;
	} else if (!document.data.joindate.value) {
		alert("가입일자를 입력하세요.");
		data.joindate.focus();
		return false;
	} else if (!document.data.grade.value) {
		alert("고객등급을 입력하세요.");
		data.grade.focus();
		return false;
	} else if (!document.data.city.value) {
		alert("도시코드를 입력하세요.");
		data.city.focus();
		return false;
	}
	return true;
}
```

사용자가 입력한 데이터가 유효한지 확인 하기 위한 코드 입니다.
<br>
input 태그에 value 을 통하여 유효성을 확인함.

## 회원정보 삽입
```jsp
<%
request.setCharacterEncoding("UTF-8");
Connection conn = DBConnetion.getConnection();

String sql = "insert into member_tbl_02 values (?, ?, ?, ?, ?, ?, ?)";

PreparedStatement pstmt = conn.prepareStatement(sql);

pstmt.setInt(1, Integer.valueOf(request.getParameter("custno")));
pstmt.setString(2, request.getParameter("custname"));
pstmt.setString(3, request.getParameter("phone"));
pstmt.setString(4, request.getParameter("address"));
pstmt.setString(5, request.getParameter("joindate"));
pstmt.setString(6, request.getParameter("grade"));
pstmt.setString(7, request.getParameter("city"));

pstmt.executeUpdate();
%>
```
form 태그를 이용하여 사용자가 입력한 데이터를 request 라는 객체에 실어 보내 데이터베이스에 유저정보 삽입
<br>
데이터베이스에 데이터를 저장한 후 
```jsp
<jsp:forward page="index.jsp"></jsp:forward>
```
index.jsp 로 redirect 하여 메인페이지로 이동

## 유저 정보 조회
![image](https://github.com/cmc0904/JSP_Shoppingmall_management/assets/63144310/83b194fe-07aa-41ff-b120-211c95d29f2d)

```jsp
<%
Connection conn = DBConnetion.getConnection();

String sql = "select custno, custname, phone, address, to_char(joindate, 'yyyy-mm-dd'), case grade when 'A' then 'VIP' when 'B' then '일반'  when 'C' then '직원'  end,city from member_tbl_02";

PreparedStatement pstmt = conn.prepareStatement(sql);

ResultSet rs = pstmt.executeQuery();
%>
```

```jsp
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
```

불러온 데이터로 부터 루프를 돌면서 사용자에게 데이터베이스에 저장된 데이터 정보를 브라우징함.

## 회원정보 조회
![image](https://github.com/cmc0904/JSP_Shoppingmall_management/assets/63144310/bc9bb5c2-c030-496d-8699-aa3d02231af1)

사용자가 입력한 회원정보가 존재하지 않는다면 해당 페이지를 브라우징 하게 됩니다.
![image](https://github.com/cmc0904/JSP_Shoppingmall_management/assets/63144310/9c325b2e-3b87-44bf-9831-c0c095b2a97e)

사용자가 입력한 외원정보가 존재한다면 해당 페이지를 브라우징 하게 됩니다.
![image](https://github.com/cmc0904/JSP_Shoppingmall_management/assets/63144310/bc21882a-2f1b-471e-855c-a49f689ee6b4)

```jsp
<%
request.setCharacterEncoding("UTF-8");


Connection conn = DBConnection.getConnection();

String sql = "select custno, custname, phone, address, to_char(joindate, 'yyyy-mm-dd'), case grade when 'A' then 'VIP' when 'B' then '일반'  when 'C' then '직원'  end,city from member_tbl_02 where custno = ?";


PreparedStatement pstmt = conn.prepareStatement(sql);
pstmt.setInt(1, Integer.valueOf(request.getParameter("custno")));

ResultSet rs = pstmt.executeQuery();


%>
``` 

form 태그를 통하여 입력 받은 회원정보를 통하여 데이터베이스로 부터 회원정보를 조회함.

```jsp
<% if(rs.next()) { %>
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
		<tr>
			<td><a><%=rs.getString(1)%></a></td>
			<td><%=rs.getString(2)%></td>
			<td><%=rs.getString(3)%></td>
			<td><%=rs.getString(4)%></td>
			<td><%=rs.getString(5)%></td>
			<td><%=rs.getString(6)%></td>
			<td><%=rs.getString(7)%></td>
		</tr>
		<tr>
			<td colspan="7"><input type="button" value="홈으로"
				onclick="location.href='index.jsp'"></td>
		</tr>
	</table>
	<% } else {%>
	<div style="text-align: center;">
		<p>찾을 수 없는 없는 결과 입니다</p> <input type="button" value="다시조회"
			onclick="location.href='member_search.jsp'">
	</div>
<% } %>
```
rs.next() 함수를 통하여 데이터 존재 유무를 확인하여 조건문을 통하여 데이터가 존재한다면 테이블을 브라우징, 존재하지 않는다면 조회할수 없다는 메세지와 함꼐 홈으로 버튼을 브라우징

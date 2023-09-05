# JSP_Shoppingmall_management
쇼핑몰 회원관리 웹사이트

## 데이터베이스 접근

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

Java 디자인 패턴 중 Singleton 방식을 사용하여 데이터베이스 Connection으로 부터 만들어진 객체를 클래스 로딩 시에 초기화되며 필요할 때만 연결이 생성됩니다. 이로 인해 자원 낭비를 방지할 수 있습니다.


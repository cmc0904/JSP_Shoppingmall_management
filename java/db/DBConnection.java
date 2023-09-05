package db;

import java.sql.*;

public class DBConnection {
	static String url = "jdbc:oracle:thin:@localhost:1521:xe";
	static String id = "system";
	static String pw = "1234";

	public static Connection getConnection() {
		Connection conn = null;

		try {
			Class.forName("oracle.jdbc.OracleDriver");
			conn = DriverManager.getConnection(url, id, pw);
			System.out.println("접속 성공");
		} catch(Exception e) {
			e.printStackTrace();
		}

		return conn;
	}

}
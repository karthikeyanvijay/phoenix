/**
* Sample program to demonstrate Phoenix JDBC connectivity
*
* @author  Vijay Anand Karthikeyan
*/

package com.example.phoenixjdbc;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.io.InputStream;
import java.util.Properties;


public class PhoenixApp
{
	public static void main(String[] args) throws SQLException 
	{
		@SuppressWarnings("unused")
		Statement stmt = null;
		ResultSet rs = null;
		String url = null;

		try 
		{
			InputStream is = PhoenixApp.class.getResourceAsStream("/connection.properties");
			Properties p=new Properties ();
			p.load (is);
			url= (String) p.get ("jdbcURL"); 
		} 
		catch (Exception e) 
		{
			System.out.println("Exception loading/processing connection.properties file");
			e.printStackTrace();
		}
		
		try 
		{
			Class.forName("org.apache.phoenix.jdbc.PhoenixDriver");
		} 
		catch (ClassNotFoundException e) 
		{
			System.out.println("Exception Loading Driver - org.apache.phoenix.jdbc.PhoenixDriver");
			e.printStackTrace();
		}
		try
		{
			Connection conn = DriverManager.getConnection(url);
			stmt = conn.createStatement();
				
			PreparedStatement statement = conn.prepareStatement("select TABLE_NAME from SYSTEM.CATALOG GROUP BY TABLE_NAME limit 5");
			rs = statement.executeQuery();
			while (rs.next())
			{
				System.out.println(rs.getString(1));
			}
			rs.close();
			statement.close();
			conn.close();
		}
		catch(Exception e)
		{
			System.out.println(e.getMessage());
		}
	}
}

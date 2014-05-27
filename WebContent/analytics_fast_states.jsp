<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<%

Connection conn=null;
Statement stmt;
String sql;
ResultSet rs, rs2, rs3; 
Integer c_offset = (request.getParameter("c_offset") == null) ? 0:Integer.parseInt(request.getParameter("c_offset"));
Integer r_offset = (request.getParameter("r_offset") == null) ? 0:Integer.parseInt(request.getParameter("r_offset"));

//System.out.print("Row Offset:" + r_offset);
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
/* 	conn = DriverManager.getConnection(
            "jdbc:postgresql://localhost/CSE135?" +
            "user=Bonnie");  */
            
		conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
    	"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
			" FROM products p" +
			" LEFT JOIN sales s" + 
			" ON s.pid = p.id" +
			" GROUP BY p.name,p.id" + 
			" ORDER BY p.name ASC" +
			" LIMIT 10 OFFSET "+c_offset;
		System.out.println(sql);
		rs = stmt.executeQuery(sql);

		stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
		" FROM users u LEFT JOIN sales s"+
		" ON s.uid = u.id"+
		" GROUP BY u.state"+
		" ORDER BY u.state ASC"+
		" LIMIT 20 OFFSET "+r_offset;

		System.out.println(sql);
		rs2 = stmt.executeQuery(sql);
		
		stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
		" FROM sales AS s, users AS u"+
		" WHERE u.state IN (SELECT DISTINCT state FROM users ORDER BY state ASC LIMIT 20 OFFSET "+r_offset+")"+
		" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
		" AND s.uid = u.id"+
		" GROUP BY u.state, s.pid";

		System.out.println(sql);
		rs3 = stmt.executeQuery(sql);
}finally{};
%>

<html>
<head>
</head>
<body>
<table border="1">
<tr>
<td>states</td>

<%
while(rs.next()){ %>
<td><strong><%= rs.getString("name") %></strong>
<br>[ $<%=rs.getInt("amount") %> ]</td>
<%} %>
</tr>

<%

rs2.beforeFirst();
while(rs2.next()){%>
	<tr>
	<td><strong><%=rs2.getString("state")%></strong> 
	<br>[ $<%=rs2.getInt("amount")%> ]
	</td>
	<% 
	rs.beforeFirst();
	while(rs.next())
	{
		boolean matched = false;
		rs3.beforeFirst();
		while(rs3.next() && !matched)
		{
			//System.out.print(rs2.getString("state") + "==" + rs3.getString("state") + "\t");
			//System.out.print(rs.getInt("id") +"=="+ rs3.getInt("pid") + "\n");
			if(rs.getInt("id") == rs3.getInt("pid") && rs2.getString("state").equals(rs3.getString("state")))
			{	
				//System.out.println(rs3.getInt("amount"));
				matched = true;
			%>
				<td><%=rs3.getInt("amount")%></td>
			<%
			}
		}
		if(matched == false){
			%>
			<td>0</td>
		<%
		}
		//System.out.print(rs.getInt("id") +"=="+rs3.getInt("pid") +"\t" +  rs2.getInt("id") +"=="+ rs3.getInt("uid") + "\n");
	}%>
	</tr>
<% }%>
</table>
</body>
</html>
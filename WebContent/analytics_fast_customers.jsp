<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>
<t:header title="Sales Analytics" />
<%

Connection conn=null;
Statement stmt;
String sql;
ResultSet rs, rs2, rs3; 
//Integer c_offset = (request.getParameter("c_offset") == null) ? 0:Integer.parseInt(request.getParameter("c_offset"));
//Integer r_offset = (request.getParameter("r_offset") == null) ? 0:Integer.parseInt(request.getParameter("r_offset"));

System.out.println("=================");

String scope = ""+request.getParameter("scope");
System.out.println("scope: " + scope);

String r_offset, next_r_offset;
if(request.getParameter("r_offset") != null && !request.getParameter("r_offset").equals("0"))
{
	r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset")));
	next_r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset"))+20);
}
else
{
	r_offset = "0";
	next_r_offset = "20";
}
System.out.println("r_offset: " + r_offset);
System.out.println("next_r_offset: " + next_r_offset);

String c_offset, next_c_offset;
if(request.getParameter("c_offset") != null && !request.getParameter("c_offset").equals("0"))
{
	c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset")));
	next_c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset"))+10);
}
else
{
	c_offset = "0";
	next_c_offset = "10";
}

System.out.println("c_offset: " + c_offset);
System.out.println("next_c_offset: " + next_c_offset);

String state = request.getParameter("state");
System.out.println("state: " + state);

String category = request.getParameter("category");
System.out.println("category: " + category);

String age = request.getParameter("ages");
System.out.println("age: " + age);

//Determine if buttons need to be disabled because of offset
String disabled = "disabled";
if(r_offset.equals("0") && c_offset.equals("0"))
{
	disabled = "";
}
System.out.println(disabled);

String SQL_1 = null;
String SQL_2 = null;

String SQL_11 = null;
String SQL_21 = null;

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
		System.out.print(sql);
		rs = stmt.executeQuery(sql);

		stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount FROM users u LEFT JOIN sales s ON s.uid = u.id GROUP BY u.name,u.id ORDER BY u.name ASC LIMIT 20 OFFSET "+r_offset;
		rs2 = stmt.executeQuery(sql);
		
		stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
		sql="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount FROM sales AS s WHERE s.uid IN (SELECT id FROM users ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+") AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+") GROUP BY s.uid, s.pid";
		rs3 = stmt.executeQuery(sql);
}finally{};
%>

<html>
<head>
</head>
<body>
<table border="1">
<tr>
<td>users</td>

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
	<td><strong><%=rs2.getString("name")%></strong> 
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
			//System.out.print(rs3.getInt("uid") + "==" + rs.getInt("id") + "\n");
			if(rs.getInt("id") == rs3.getInt("pid")&& rs2.getInt("id") == rs3.getInt("uid"))
			{	
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

	<div class="row">
	
		<%
			PreparedStatement c_pstmt = null;
			ResultSet c_rs = null;
			
			c_pstmt = conn.prepareStatement("SELECT * FROM categories");
			c_rs = c_pstmt.executeQuery();
		%>
	
		<!-- For Choosing States vs. Customers Table -->
		<form class="navbar-form navbar-left" role="search" action="analytics.jsp" method="GET">
		<div class="col-sm-12">
				<select class="form-control" name="scope" <%= disabled %>>
					<option value="states">States</option>
		        	<option value="customers">Customers</option>
		        </select>

		        <select class="form-control" name="ages" <%= disabled %>>
		        	<option value="all">All Ages</option>
		        	<option value="12 and 18">12-18</option>
		        	<option value="18 and 45">18-45</option>
		        	<option value="45 and 65">45-65</option>
		        	<option value="65 and 150">65-</option>
		        </select>
		        <select class="form-control" name="category" <%= disabled %>>
		        	<option value="all">All Categories</option>
		        	<% while(c_rs.next())
		        		{%>
		        		<option value="<%= c_rs.getString("id") %>"><%= c_rs.getString("name")%></option>
		        		<% }
		        		%>
		        </select>
		        <select class="form-control" name="state" <%= disabled %>>
		        	<option value="all">All States</option>
					<option value="Alabama">Alabama</option>
					<option value="Alaska">Alaska</option>
					<option value="Arizona">Arizona</option>
					<option value="Arkansas">Arkansas</option>
					<option value="California">California</option>
					<option value="Colorado">Colorado</option>
					<option value="Connecticut">Connecticut</option>
					<option value="Delaware">Delaware</option>
					<option value="District Of Columbia">District Of Columbia</option>
					<option value="Florida">Florida</option>
					<option value="Georgia">Georgia</option>
					<option value="Hawaii">Hawaii</option>
					<option value="Idaho">Idaho</option>
					<option value="Illinois">Illinois</option>
					<option value="Indiana">Indiana</option>
					<option value="Iowa">Iowa</option>
					<option value="Kansas">Kansas</option>
					<option value="Kentucky">Kentucky</option>
					<option value="Louisiana">Louisiana</option>
					<option value="Maine">Maine</option>
					<option value="Maryland">Maryland</option>
					<option value="Massachusetts">Massachusetts</option>
					<option value="Michigan">Michigan</option>
					<option value="Minnesota">Minnesota</option>
					<option value="Mississippi">Mississippi</option>
					<option value="Missouri">Missouri</option>
					<option value="Montana">Montana</option>
					<option value="Nebraska">Nebraska</option>
					<option value="Nevada">Nevada</option>
					<option value="New Hampshire">New Hampshire</option>
					<option value="New Jersey">New Jersey</option>
					<option value="New Mexico">New Mexico</option>
					<option value="New York">New York</option>
					<option value="North Carolina">North Carolina</option>
					<option value="North Dakota">North Dakota</option>
					<option value="Ohio">Ohio</option>
					<option value="Oklahoma">Oklahoma</option>
					<option value="Oregon">Oregon</option>
					<option value="Pennsylvania">Pennsylvania</option>
					<option value="Rhode Island">Rhode Island</option>
					<option value="Sout Carolina">South Carolina</option>
					<option value="South Dakora">South Dakota</option>
					<option value="Tennessee">Tennessee</option>
					<option value="Texas">Texas</option>
					<option value="Utah">Utah</option>
					<option value="Vermont">Vermont</option>
					<option value="Virginia">Virginia</option>
					<option value="West Virginia">Washington</option>
					<option value="West Virginia">West Virginia</option>
					<option value="Wisconsin">Wisconsin</option>
					<option value="Wyoming">Wyoming</option>
				</select>
				<input type="hidden" name="query" value="true"/>
				<% if(!disabled.equals("disabled")){
		        	%><input type="submit"  class="btn btn-default" /><%
		        }
		        %>
		        
		   	</div>
		   	</form>   
		</div>	
</body>
</html>
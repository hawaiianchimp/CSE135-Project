<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
	String role = ""+session.getAttribute("role");
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		Class.forName("org.postgresql.Driver");
		
		conn = DriverManager.getConnection(
				"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		Statement statement = conn.createStatement();
		pstmt = conn.prepareStatement("SELECT * FROM categories");
		rs = pstmt.executeQuery();

%>

<!-- category menu -->
<%
	Connection c_conn = null;
	PreparedStatement c_pstmt = null;
	ResultSet c_rs = null;

		Class.forName("org.postgresql.Driver");

		c_conn = DriverManager
				.getConnection(
						"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		Statement c_statement = c_conn.createStatement();
		c_pstmt = c_conn.prepareStatement("SELECT * FROM categories");
		c_rs = c_pstmt.executeQuery();
%>

<t:header title="Product Categories" />
<div class="container">
	<!-- category menu -->
	<div class="col-md-1">
		<ul class="nav nav-stacked navbar-left nav-pills">
		<li class="active"><a href="categories.jsp">Categories</a>
		</li>
		<%
			if (c_rs.isBeforeFirst()) {
					String rsname, rsid;
					while (c_rs.next()) {
						rsname = c_rs.getString("name");
						rsid = String.valueOf(c_rs.getInt("category_id"));
						//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
					%>
						<li><a href="products.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%></a></li>
					<%
					}
			}
			else {
			%>
				<li>No Categories</li>
			<%
			}
		
			/* Close everything  */
			// Close the ResultSet
			c_rs.close();
			//Close the Statement
			c_statement.close();
			// Close the Connection
			c_conn.close();
		%>
		</ul>
	</div>

	<div class="col-md-11">
		<%
		if(rs.isBeforeFirst())
		{
			String rsname,rsdescription,rsimg,rsid;
				while(rs.next())
				{ 
					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsimg = rs.getString("img_src");
					rsid = String.valueOf(rs.getInt("category_id"));
					if(rsimg == null)
						rsimg = "category_default";
					//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
				%>
					<t:category name="<%=rsname %>" description="<%=rsdescription %>" imgurl="<%=rsimg %>" cid="<%=rsid %>" label="Browse"/>
				<%
				}
		}
		else
		{	%>
			No Categories, please add a category
		<% }
			/* Close everything  */
			// Close the ResultSet
			rs.close();
			//Close the Statement
			statement.close();
			// Close the Connection
			conn.close();
		}
	
		catch(SQLException e){
			e.printStackTrace();
   	     	out.println("<h1>" + e.getMessage() + "</h1>");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			out.println("<h1>" + e.getMessage() + "</h1>");
		}
	
		
	if(role.equals("Owner")) {%>
		<div class="col-md-4">
			<div class="thumbnail">
				<img style="height:200px" src="img/categories/plus.png">
				<div class="caption">
					<h3>
						Add new category
					</h3>
					<p>
						Add a new category to the list
					</p>
					<p>
						<a class="btn btn-success" href="categories.jsp?action=add">Add Item</a>
					</p>
				</div>
			</div>
		</div>
	<%} %>
	</div>
</div>
<t:footer />
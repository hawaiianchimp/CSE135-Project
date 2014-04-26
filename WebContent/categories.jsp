<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		Class.forName("org.postgresql.Driver");
		
		conn = DriverManager.getConnection(
				"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		Statement statement = conn.createStatement();
		String sql = "SELECT * FROM categories AS c LEFT JOIN (SELECT p.category_id, COUNT(p.category_id) FROM products_categories AS p GROUP BY p.category_id) AS p ON (c.category_id = p.category_id);";
		pstmt = conn.prepareStatement(sql);
		
		rs = pstmt.executeQuery();
%>

<t:header title="Product Categories" />
<div class="container">
	<div class="row">
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
						rsimg = "default";
				%>
				<div class="col-md-4">
					<div class="thumbnail">
						<img style="height:200px" src="img/categories/<%=rsimg %>.png">
						<div class="caption">
							<h3>
								<%=rsname %>
							</h3>
							<p>
								<%=rsdescription %>
							</p>
							
							<p>
								<a class="btn btn-primary" href="products.jsp?cid=<%=rsid %>&category=${name}">Browse Items</a>
								
								<% if(session.getAttribute("role").equals("Owner")){ %>
									<a class="btn btn-success" href="category.jsp?action=update&cid=${cid}">Update</a>
									<% if(rs.getInt("count") == 0) { %>
									<a class="btn btn-danger" href="category.jsp?action=delete&cid=${cid}">Delete</a>
								<% } 
								}%>
							</p>
						</div>
					</div>
				</div>
				
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
	
		
	if(session.getAttribute("role").equals("Owner")) {%>
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
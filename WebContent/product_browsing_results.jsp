<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<% 
	//redirect if not logged in
	String uid = "" + session.getAttribute("uid");
	if(uid.equals("null")) 
	{
		response.sendRedirect("redirect.jsp");
	}
	
	String role = "" + session.getAttribute("role"); 
	if (role.equals("owner"))
	{
		%><t:header title="Product Search Results" /><%
	}
	else{ %>
		<t:header title="Product Browsing Results" /><%
	} 
	
	//checks if parameter inserted
	if(request.getParameter("keyword")==null) 
	{
		%>
		<h1>Error: Request Not Valid</h1>
		<%
	}
	else{
	%>
<div class="row">
<%
	String[] keywords = request.getParameter("keyword").split(" ");
	String prepared_keywords="%";
	for(String s : keywords)
		prepared_keywords += s+"%";
			
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	if(role.equals("null"))
	{
		%>
		<t:message type="warning" message="Please log in first for product browsing function." />
		<a class="btn btn-default" href="login.jsp" >Log In</a>
		<%
	}
	else
	{
		try {
			
			Class.forName("org.postgresql.Driver");
			conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly
			
			if(!prepared_keywords.equals("%%"))
			{
				String category_id = request.getParameter("cid");
				if(category_id.equals("null"))
				{
					pstmt = conn.prepareStatement("SELECT * FROM products_categories INNER JOIN products ON (products_categories.product_id=products.product_id) WHERE products_categories.product_id=products.product_id AND (products.name ILIKE ?)");
					pstmt.setString(1, prepared_keywords);
					rs = pstmt.executeQuery();
				}
				else
				{
					pstmt = conn.prepareStatement("SELECT * FROM products_categories INNER JOIN products ON (products_categories.category_id=?) WHERE products_categories.product_id=products.product_id AND (products.name ILIKE ?)");
					int cid = Integer.parseInt(category_id);
					pstmt.setInt(1, cid);
					pstmt.setString(2, prepared_keywords);
					rs = pstmt.executeQuery();
				}
				
				if(rs.isBeforeFirst())
				{
					while(rs.next())
					{
						String rsname, rsdescription, rsimg, rsprice;
						int rspid, rscid;
						rsname = rs.getString("name");
						rsdescription = rs.getString("description");
						rsimg = rs.getString("img_url");
						rspid = rs.getInt("product_id");
						//System.out.println(rspid);
						rscid = rs.getInt("category_id");
						rsprice = rs.getString("price");
						if (rsimg == null)
							rsimg = "default";
						%>
						<div class="row">
							<div class="col-sm-1">
							<img style="height:45px" src="img/products/<%=rsimg %>.png">
							</div>
							<div class="col-sm-1">
								<span class="badge badge-success">
									$<%=rsprice %>
								</span>
							</div>
							<div class="col-sm-2">
									<%=rsname %>
							</div>
							<div class="col-sm-4">
								<p>
									<%=rsdescription %>
								</p>
							</div>
							<div class="col-sm-4">
						
									<form class="" action="productorder.jsp" method="POST">
										<input type="hidden" name="action" value="order">
										<input type="hidden" name="product" value="<%=rspid %>">
										<input type="hidden" name="cid" value="<%=rscid %>">
										<input type="submit" class="btn btn-primary" value="Add To Cart">
									</form>
									
									
									<% 
									if(role.equals("owner"))
									{ %>
										<a class="btn btn-success" href="products.jsp?action=update&cid=<%=rscid%>&pid=<%=rspid %>">Update</a>
										<a class="btn btn-danger" href="products.jsp?action=delete&cid=<%=rscid%>&pid=<%=rspid %>">Delete</a>
									<% }%>
							</div>
						</div>
						<%
					}
					/* Close everything  */
					// Close the ResultSet
					rs.close();					
					//Close the Statement
					pstmt.close();
					// Close the Connection
					conn.close();
				}
				else
				{
					%>
					<t:message type="warning" message="No matches found." />
					<%
				}
			}
			else
			{
				%><t:message type="danger" message="Please enter a product browsing keyword." /><%
			}

			
		}catch (SQLException e) {
	        e.printStackTrace();
	        out.println("<h1>" + e.getMessage() + "</h1>");
	        
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			out.println("<h1>org.postgresql.Driver Not Found</h1>");
		}
	}
%>

</div>
<div class="col-md-12">
	<%
	if (role.equals("owner"))
	{
		%>
		<a class="btn btn-default" href="products.jsp" >Back to Product Searching</a>
		<a class="btn btn-default" href="categories.jsp" >Back to Categories</a>
		<%
	}
	else{ %>
		<a class="btn btn-default" href="products.jsp" >Back to Product Browsing</a><%
	} %>
	
	
</div>
<t:footer />
<%} //ends else of paramter inserted check %>
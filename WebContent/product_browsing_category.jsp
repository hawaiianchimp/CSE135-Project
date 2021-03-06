<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<% String role = "" + session.getAttribute("role"); 
	if (role.equals("owner"))
	{
		%><t:header title="Category Specific Product Searching" /><%
	}
	else
	{ 
		%><t:header title="Category Specific Product Browsing" /><%
	}%>
<div class="row clearfix">
<%
	//redirect if not logged in
	String uid = "" + session.getAttribute("uid");
	if(uid.equals("null")) 
	{
		response.sendRedirect("redirect.jsp");
	}
	
	/* Connection conn = DriverManager.getConnection(
			"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
			"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); */
			Connection conn = DriverManager.getConnection(
		            "jdbc:postgresql://localhost/CSE135?" +
		            "user=Bonnie");
	PreparedStatement pstmt = null, d_pstmt = null;
	Statement statement = null, d_statement = null;
	ResultSet rs = null;
	String sql = null;

	try{
		Class.forName("org.postgresql.Driver");
		
		statement = conn.createStatement();
		pstmt = conn.prepareStatement("SELECT * FROM categories");
		rs = pstmt.executeQuery();

		%>
		<!-- Category Menu -->
		<div class="col-md-4 column">
			<ul class="nav nav-stacked navbar-left nav-pills">
				<li class="active"><a href="products.jsp">All Categories</a></li>
				
				<%
					if (rs.isBeforeFirst()) {
							String rsname, rsid, rscount;
							while (rs.next()) {
								rsname = rs.getString("name");
								rsid = String.valueOf(rs.getInt("category_id"));
								session.setAttribute("cid", rsid);
								//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
							%>
								<li><a href="categories.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%> </a></li>
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
					rs.close();
					//Close the Statement
					statement.close();
					// Close the Connection
					conn.close();
				%>
				
			</ul>
		</div>
		
		<div class="col-md-4 column">
			<%
			if (role.equals("owner"))
			{
				%><h3>Search within <%=""+request.getParameter("category") %></h3><%
			}
			else{ %>
				<h3>Browse within <%=""+request.getParameter("category") %></h3><%
			} %>
			
			<form class="navbar-form navbar-left" action="product_browsing_results.jsp" method="GET">
				<div class="form-group">
					<input type="text" class="form-control" placeholder="Keyword"
						name="keyword">
					<input type ="hidden" name=cid value="<%=""+request.getParameter("cid")%>">
				</div>
				<button type="submit" class="btn btn-default">Search</button>
			</form>
		</div>
		
		<!-- Used for spacing -->
		<div class="col-md-4 column"></div>
		
		<%
		
	}catch(SQLException e){
		e.printStackTrace();
		%>
		<t:message type="danger" message="<%=e.getMessage() %>"></t:message>
		<%
	}
%>
</div>
<t:footer />
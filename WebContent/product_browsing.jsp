<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Product Browsing" />
<div class="row clearfix">
<%
	//redirect if not logged in
	String uid = "" + session.getAttribute("uid");
	if(uid.equals("null")) 
	{
		response.sendRedirect("login.jsp");
	}
	
	Connection conn = DriverManager.getConnection(
			"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
			"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
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
				<li class="active"><a href="categories.jsp">Categories</a></li>
				
				<%
					if (rs.isBeforeFirst()) {
							String rsname, rsid, rscount;
							while (rs.next()) {
								rsname = rs.getString("name");
								rsid = String.valueOf(rs.getInt("category_id"));
								session.setAttribute("cid", rsid);
								//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
							%>
								<li><a href="product_browsing_category.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%> </a></li>
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
			<h3>Browse All Categories</h3>
			<form class="navbar-form navbar-left" action="product_browsing_results.jsp" method="GET">
				<div class="form-group">
					<input type="text" class="form-control" placeholder="Keyword"
						name="keyword">
					<input type ="hidden" name=cid value="null">
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
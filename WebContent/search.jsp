<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Search Results" />
<div class="row clearfix">
<%
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
		<!-- Used for spacing -->
		<div class="col-md-4 column"></div>
		
		<div class="col-md-4 column">
			<form class="navbar-form navbar-left" action="search_results.jsp" method="GET">
			
				<div class="form-group">
					<input type="text" class="form-control" placeholder="Keyword"
						name="keyword">
				</div>
				
				<div class="form-group">
					<label for="category">Categories</label> 
					<select class="form-control" name="cid">
						<option value="null">All</option>
						<%
						while(rs.next())
						{
							String name = rs.getString("name");
							String cid = rs.getString("category_id");
							%>
							<option value="<%=cid%>"><%=name%></option>
							<%	
						}
						%>
					</select>
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
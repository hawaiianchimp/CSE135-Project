<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Product Categories" />

<!-- Selecting all categories -->
<%
	Class.forName("org.postgresql.Driver");
	String role = "" + session.getAttribute("role");
	String uid = "" + session.getAttribute("uid");
	String keyword = "" + request.getAttribute("keyword");
	keyword = (keyword.equals("null"))? "":keyword;
	
	if(uid.equals("null")) //redirect if not logged in
	{
		response.sendRedirect("login.jsp");
	}
	
	String action = ""+request.getParameter("action");
	String submit = ""+request.getParameter("submit");
	String cid = ""+request.getParameter("cid");
	/*Connection conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); */
					Connection conn = DriverManager.getConnection(
				            "jdbc:postgresql://localhost/CSE135?" +
				            "user=Bonnie");
	PreparedStatement pstmt = null, d_pstmt = null;
	ResultSet rs = null;
	String sql = null;
	
	ArrayList<String> images = new ArrayList<String>();
		images.add("default");
		images.add("sports");
		images.add("clothes");
		
		
%>
<!--  Deleting a category -->
<% 
	if(action.equals("delete"))
	{
		if(!cid.isEmpty())
		{
			if(role.equals("owner"))
			{
				try{
				sql = "DELETE FROM categories WHERE id = ?;";
				d_pstmt = conn.prepareStatement(sql);
				d_pstmt.setInt(1, Integer.parseInt(cid));
				int count = d_pstmt.executeUpdate();

				if(count != 0){
					%>
					<t:message type="danger" message="Category successfully deleted"></t:message>
					<%
					}
					else{
					%>
					<t:message type="danger" message="Item was already deleted"></t:message>
					<%
					}
				}
				catch(SQLException e){
					e.printStackTrace();
		   	     	String message = "Failure to Delete Category: " + e.getMessage();
		   	     	%>
					<t:message type="danger" message="<%=message %>"></t:message>
					<%
				}
				
			}	
			else
			{
				%>
				<t:message type="warning" message="You must be an owner to delete categories"></t:message>
				<%
			}
		}
		else
		{
			%>
			<t:message type="warning" message="No category selected for deletion"></t:message>
			<%
		}
		
		
	}
%>

<!-- Show insert modal -->
<% 
	System.out.print(action);
	if(action.equals("insert"))
	{
		%>
		<t:modal_header modal_title="Inserting Category" />
			<fieldset>
			<!-- Text input-->
			
			<label class="control-label" for="name">Name</label>
			<input id="name" name="name" type="text" placeholder="Name" class="form-control">
			
			<!-- Textarea -->
			<div class="control-group">
			  <label class="control-label" for="description">Description</label>
			  <div class="controls">                     
			    <textarea class="form-control" id="description" name="description"></textarea>
			  </div>
			</div>
			
			</fieldset>
		<t:modal_footer name="insert"/>
<% }	%>

<!-- Do insert submission -->
	<%
	if(submit.equals("insert"))
	{
			if(role.equals("owner"))
			{
				try{					
					
					if((""+request.getParameter("name")).isEmpty()){
						throw new SQLException("Name cannot be empty");
					}
					if((""+request.getParameter("description")).isEmpty()){
						throw new SQLException("description cannot be empty");
					}
						sql =	"INSERT INTO categories (name, description) " +
								"SELECT ?,?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("description"));

						int count = d_pstmt.executeUpdate();

						if(count != 0){
							%>
							<t:message type="success" message="Category successfully inserted"></t:message>
							<%
							}
						else{
							%>
							<t:message type="danger" message="Error occurred in SQL"></t:message>
							<%
							
						}

						d_pstmt.close();
				}
				catch(SQLException e){
					e.printStackTrace();
					String message = "Failure to Insert Category: " + e.getMessage();
			   	     	%>
						<t:message type="danger" message="<%=message %>"></t:message>
						<%
				}
				
				
		%>
		<%}	
			else{%>
				<t:message type="warning" message="You must be an owner to insert categories"></t:message>
		<%
			}
	}
%>

<!--  Updating a category -->
<% 
	if(action.equals("update"))
	{
		if(!cid.isEmpty())
		{
			if(role.equals("owner"))
			{
				try{
				sql = "SELECT * FROM categories WHERE id = ?;";
				d_pstmt = conn.prepareStatement(sql);
				d_pstmt.setInt(1, Integer.parseInt(cid));
				rs = d_pstmt.executeQuery();
				
				if(rs.next())
				{
					String rsname,rsdescription; 
					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					%>
				<t:modal_header modal_title="Updating Item" />
					<fieldset>
						<!-- Text input-->
						<input type="hidden" name="cid" value="<%=cid %>"/>
						<label class="control-label" for="name">Name</label>
						<input value="<%=rsname %>" id="name" name="name" type="text" placeholder="Name" class="form-control">
						
						<!-- Textarea -->
						<div class="control-group">
						  <label class="control-label" for="description">Description</label>
						  <div class="controls">                     
						    <textarea class="form-control" id="description" name="description"><%=rsdescription %></textarea>
						  </div>
						</div>
						
					</fieldset>
				<t:modal_footer name="update"/>
				<%
				}
					else{
					%>
					<t:message type="danger" message="Category does not exist"></t:message>
					<%
					}
				}
				catch(SQLException e){
					e.printStackTrace();
		   	     	String message = "Failure to retrieve Category: " + e.getMessage();
			   	     	%>
						<t:message type="danger" message="<%=message %>"></t:message>
						<%
				}
				
			}	
			else
			{
				%>
				<t:message type="warning" message="You must be an owner to delete categories"></t:message>
				<%
			}
		}
		else
		{
			%>
			<t:message type="warning" message="No category selected for deletion"></t:message>
			<%
		}
		
		
	}
%>

<%
	//If submit is equal to "insert"
	if(submit.equals("update"))
	{
			if(role.equals("owner"))
			{
				try{	

					if((""+request.getParameter("name")).isEmpty()){
						throw new SQLException("Name cannot be empty");
					}
					if((""+request.getParameter("description")).isEmpty()){
						throw new SQLException("description cannot be empty");
					}
						sql =	"UPDATE categories SET (name, description) = " +
								"(?,?) WHERE id = ?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("description"));
						d_pstmt.setInt(3, Integer.parseInt(request.getParameter("cid")));

						int count = d_pstmt.executeUpdate();

						if(count != 0){
							%>
							<t:message type="success" message="Category successfully updated"></t:message>
							<%
							}
						else{
							%>
							<t:message type="danger" message="Failure to Insert: Error occurred in SQL"></t:message>
							<%
							
						}
				}
				
				catch(SQLException e){
					e.printStackTrace();
					String message = "Failure to Insert Category: " + e.getMessage();
			   	     	%>
						<t:message type="danger" message="<%=message %>"></t:message>
						<%
				}
				
		%>
		<%}	
			else{%>
				<t:message type="warning" message="You must be an owner to update categories"></t:message>
		<%
			}
	}
%>

<div class="container">
	<!-- product search -->
	<div class="row clearfix">
		<div class="col-sm-12">
			<form class="navbar-form navbar-left" role="search" action="products.jsp">
		        <div class="form-group">
		        	<input type="hidden" name="cid" value="<%=cid %>"/>
		          <input name="keyword" type="text" class="form-control" placeholder="Search" value="<%= keyword%>">
		        </div>
		        <input type="submit" value="Search" class="btn btn-default"/>
		      </form>
		</div>
	</div>
	
	<!-- category menu -->
	<div class="col-sm-2">
		<ul class="nav nav-stacked navbar-left nav-pills">
		<li class="active"><a href="categories.jsp">All Categories</a>
		</li>
		<%

		
		try{

			Class.forName("org.postgresql.Driver");
			Statement statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			sql = "SELECT categories.*, COUNT(products) AS count FROM categories LEFT OUTER JOIN products ON (products.cid = categories.id) GROUP BY categories.id";
			rs = statement.executeQuery(sql);

			String rsname,rsdescription,rsid,rscount;

			if (rs.isBeforeFirst()) {

					//category menu
					while (rs.next()) {
						rsname = rs.getString("name");
						rsdescription = rs.getString("description");
						rsid = String.valueOf(rs.getInt("id"));
						rscount = rs.getString("count");
					%>
						<li><a href="products.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%><span class="badge"><%=rscount %></span></a></li>
					<%
					}
			}
			else {
			%>
				<li>No Categories</li>
			<%
			}
		%>
		</ul>
	</div>

	<div class="col-sm-10">
		<table class="table">
		<thead>
			<tr>
					
					<td>
							<h2>Name</h2>
					</td>
					<td>
						<h2>
							Description
						</h2>
					</td>
					<td>
						
					</td>
			</tr>
		</thead>
		<%
		rs.beforeFirst();
		if(rs.isBeforeFirst())
		{
				while(rs.next())
				{ 

					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsid = String.valueOf(rs.getInt("id"));
					rscount = rs.getString("count");
				%>
						<tr>
							<td>
									<%=rsname %>
							</td>
							<td>
								<p>
									<%=rsdescription %>
								</p>
							</td>
							<td>	
								<p>
									<a class="btn btn-primary" href="products.jsp?cid=<%=rsid %>&category=<%= rsname%>">Browse <span class="badge"><%=rscount %></span></a>
									
									<% if(role.equals("owner"))
										{ %>
											<a class="btn btn-success" href="categories.jsp?action=update&cid=<%=rsid %>">Update</a>
											<% if(rs.getInt("count") == 0) { %>
												<a class="btn btn-danger" href="categories.jsp?action=delete&cid=<%=rsid%>">Delete</a>
											<% } 
										}%>
								</p>
							</td>
						</tr>
				
			<%
				}
		}
		else
		{	%>
			<t:message type="warning" message="No Categories to display"/>
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
	
		
	if(role.equals("owner")) {%>
		<tr>
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
					</td>
					<td>
						<p>
							<a class="btn btn-success" href="categories.jsp?action=insert">Insert Category</a>
						</p>
					</td>
		</tr>
	<%} %>
	</table>
	</div>
</div>
<t:footer />
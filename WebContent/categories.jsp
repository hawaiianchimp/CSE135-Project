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
	
	if(uid.equals("null")) //redirect if not logged in
	{
		response.sendRedirect("login.jsp");
	}
	
	String action = ""+request.getParameter("action");
	String submit = ""+request.getParameter("submit");
	String cid = ""+request.getParameter("cid");
	Connection conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
	PreparedStatement pstmt = null, d_pstmt = null;
	Statement statement = null, d_statement = null;
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
			if(role.equals("Owner"))
			{
				try{
				statement = conn.createStatement();
				sql = "DELETE FROM categories WHERE category_id = ?;";
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
		   	     	%>
					<t:message type="danger" message="<%=e.getMessage() %>"></t:message>
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
		<t:modal_header modal_title="Inserting Item" />
			<fieldset>
			<!-- Text input-->
			
			<label class="control-label" for="name">Name</label>
			<input id="name" name="name" type="text" placeholder="Name" class="form-control">
			
			
			<label class="control-label" for="img_url">Image</label>
			<select class="form-control" name="img_url">
				<% for(String s: images){ %>
					<option value="<%=s %>"><%=s %></option>
				<% }%>
			</select>
			
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
			if(role.equals("Owner"))
			{
				try{					
					Statement check_statement = conn.createStatement();
					PreparedStatement check_pstmt = conn.prepareStatement("SELECT name FROM categories");
					String input_c_name = ""+request.getParameter("name");
					ResultSet check_rs = check_pstmt.executeQuery();
					
					Boolean duplicate_name = false;
					while(check_rs.next())
					{
						String rs_c_name = check_rs.getString("name").toLowerCase();
						if(input_c_name.toLowerCase().equals(rs_c_name))
							duplicate_name = true;	
					}
					
					if(duplicate_name==false)
					{
						statement = conn.createStatement();
						sql =	"INSERT INTO categories (name, img_url, description) " +
								"SELECT ?,?,?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("img_url"));
						d_pstmt.setString(3, ""+request.getParameter("description"));

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
					}
					else
					{
						%>
						<t:message type="danger" message="Duplicate name found. Please enter a unique category name."></t:message>
						<%	
					}
				}
				catch(SQLException e){
					e.printStackTrace();
					%>
					<t:message type="danger" message="<%=e.getMessage() %>"></t:message>
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
			if(role.equals("Owner"))
			{
				try{
				statement = conn.createStatement();
				sql = "SELECT * FROM categories WHERE category_id = ?;";
				d_pstmt = conn.prepareStatement(sql);
				d_pstmt.setInt(1, Integer.parseInt(cid));
				rs = d_pstmt.executeQuery();
				
				if(rs.next())
				{
					String rsname,rsdescription, rsimg; 
					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsimg = rs.getString("img_url");
					%>
				<t:modal_header modal_title="Updating Item" />
					<fieldset>
						<!-- Text input-->
						<input type="hidden" name="cid" value="<%=cid %>"/>
						<label class="control-label" for="name">Name</label>
						<input value="<%=rsname %>" id="name" name="name" type="text" placeholder="Name" class="form-control">
						<label class="control-label" for="img_url">Image</label>
						<select class="form-control" name="img_url">
							<% String selected = "";
								for(String s: images){ 
								selected = (s.equals(rsimg)) ? "selected":""; %>
								<option <%=selected%> value="<%=s %>"><%=s %></option>
							<% }%>
						</select>
						
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
		   	     	%>
					<t:message type="danger" message="<%=e.getMessage() %>"></t:message>
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
			if(role.equals("Owner"))
			{
				try{					
					Statement check_statement = conn.createStatement();
					PreparedStatement check_pstmt = conn.prepareStatement("SELECT name FROM categories");
					String input_c_name = ""+request.getParameter("name");
					ResultSet check_rs = check_pstmt.executeQuery();
					
					Boolean duplicate_name = false;
					while(check_rs.next())
					{
						String rs_c_name = check_rs.getString("name").toLowerCase();
						if(input_c_name.toLowerCase().equals(rs_c_name))
							duplicate_name = true;	
					}
					
					if(duplicate_name==false)
					{
						statement = conn.createStatement();
						sql =	"UPDATE categories SET (name, img_url, description) = " +
								"(?,?,?) WHERE category_id = ?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("img_url"));
						d_pstmt.setString(3, ""+request.getParameter("description"));
						d_pstmt.setInt(4, Integer.parseInt(request.getParameter("cid")));

						int count = d_pstmt.executeUpdate();

						if(count != 0){
							%>
							<t:message type="success" message="Category successfully updated"></t:message>
							<%
							}
						else{
							%>
							<t:message type="danger" message="Error occurred in SQL"></t:message>
							<%
							
						}
					}
					else
					{
						%>
						<t:message type="danger" message="Duplicate name found. Please enter a unique category name."></t:message>
						<%	
					}
				}
				
				catch(SQLException e){
					e.printStackTrace();
					%>
					<t:message type="danger" message="<%=e.getMessage() %>"></t:message>
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
		<a class="btn btn-default" href="/CSE135Project/product_browsing.jsp" >Product Search</a>
	</div>
	
	<!-- category menu -->
	<div class="col-sm-2">
		<ul class="nav nav-stacked navbar-left nav-pills">
		<li class="active"><a href="categories.jsp">Categories</a>
		</li>
		<%

		
		try{

			Class.forName("org.postgresql.Driver");
			statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
			sql = "SELECT * FROM categories AS c LEFT JOIN (SELECT p.category_id, COUNT(p.category_id) FROM products_categories AS p GROUP BY p.category_id) AS p ON (c.category_id = p.category_id);";
			rs = statement.executeQuery(sql);

			String rsname,rsdescription,rsimg,rsid,rscount;
			
			if (rs.isBeforeFirst()) {

					//category menu
					while (rs.next()) {
						rsname = rs.getString("name");
						rsdescription = rs.getString("description");
						rsimg = rs.getString("img_url");
						rsid = String.valueOf(rs.getInt("category_id"));
						rscount = String.valueOf(rs.getInt("count"));
						//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
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
		<div class="row">
				<div class="row">
					<div class="col-sm-1">
						<h2>Image</h2>
					</div>
					<div class="col-sm-2">
							<h2>Name</h2>
					</div>
					<div class="col-sm-3">
						<h2>
							Description
						</h2>
					</div>
					<div class="col-sm-4">	
						
					</div>
				</div>
		</div>
		<hr>
		<%
		rs.beforeFirst();
		if(rs.isBeforeFirst())
		{
				while(rs.next())
				{ 

					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsimg = rs.getString("img_url");
					rsid = String.valueOf(rs.getInt("category_id"));
					rscount = String.valueOf(rs.getInt("count"));
					if(rsimg == null)
						rsimg = "category_default";
					//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
				%>
				<div class="row">
						<div class="row">
							<div class="col-sm-1">
								<img style="height:45px" src="img/categories/<%=rsimg %>.png">
							</div>
							<div class="col-sm-2">
									<%=rsname %>
							</div>
							<div class="col-sm-3">
								<p>
									<%=rsdescription %>
								</p>
							</div>
							<div class="col-sm-4">	
								<p>
									<a class="btn btn-primary" href="products.jsp?cid=<%=rsid %>&category=<%= rsname%>">Browse <span class="badge"><%= rscount %></span></a>
									
									<% if(role.equals("Owner"))
										{ %>
											<a class="btn btn-success" href="categories.jsp?action=update&cid=<%=rsid %>">Update</a>
											<% if(rs.getInt("count") == 0) { %>
												<a class="btn btn-danger" href="categories.jsp?action=delete&cid=<%=rsid%>">Delete</a>
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
	
		
	if(role.equals("Owner")) {%>
		<div class="row">
				<div class="row">
					<div class="col-sm-1">
						<img style="height:45px" src="img/plus.png">
					</div>
					<div class="col-sm-2">
							Insert new category
					</div>
					<div class="col-sm-3">
						<p>
							Insert a new category to the list
						</p>
					</div>
					<div class="col-sm-4">	
						<p>
							<a class="btn btn-success" href="categories.jsp?action=insert">Insert Item</a>
						</p>
					</div>
				</div>
		</div>
	<%} %>
	</div>
</div>
<t:footer />
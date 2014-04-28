<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Product Categories" />

<!-- Selecting all categories -->
<%
	String role = ""+session.getAttribute("role");
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

<div class="row">
<form class="navbar-form navbar-left" action="search.jsp" method="GET">
  <div class="form-group">
  	<input type="text" class="form-control" placeholder="Search All" name="keyword">
  	<input type ="hidden" name=cid value="<%=cid%>">
 	</div>
  <button type="submit" class="btn btn-default">Search</button>
</form>
</div>



<!--  Deleting a category -->
<% 
	if(action.equals("delete"))
	{
		if(!cid.isEmpty())
		{
			if(role.equals("Owner"))
			{
				try{
				Class.forName("org.postgresql.Driver");
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

<!-- Show add modal -->
<% 
	System.out.print(action);
	if(action.equals("add"))
	{
		%>
		<t:modal_header modal_title="Adding Item" />
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
		<t:modal_footer name="add"/>
<% }	%>

<!-- Do add submission -->
	<%
	if(submit.equals("add"))
	{
			if(role.equals("Owner"))
			{
				try{
					Class.forName("org.postgresql.Driver");
					
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
						sql =	"INSERT INTO categories (name, img_src, description) " +
								"SELECT ?,?,?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("img_url"));
						d_pstmt.setString(3, ""+request.getParameter("description"));

						int count = d_pstmt.executeUpdate();

						if(count != 0){
							%>
							<t:message type="danger" message="Category successfully added"></t:message>
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
				<t:message type="warning" message="You must be an owner to add categories"></t:message>
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
				Class.forName("org.postgresql.Driver");
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
					rsimg = rs.getString("img_src");
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
	//If submit is equal to "add"
	if(submit.equals("update"))
	{
			if(role.equals("Owner"))
			{
				try{
					Class.forName("org.postgresql.Driver");
					
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
						sql =	"UPDATE categories SET (name, img_src, description) = " +
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
						rsimg = rs.getString("img_src");
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
		<%
		rs.beforeFirst();
		if(rs.isBeforeFirst())
		{
				while(rs.next())
				{ 

					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsimg = rs.getString("img_src");
					rsid = String.valueOf(rs.getInt("category_id"));
					rscount = String.valueOf(rs.getInt("count"));
					if(rsimg == null)
						rsimg = "category_default";
					//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
				%>
				<div class="col-sm-4">
					<div class="thumbnail">
						<img style="height:200px" src="img/categories/<%=rsimg %>.png">
						<div class="caption">
							<h3>
								<%=rsname %>
							</h3>
							<p>
								<span class="label label-info">Description:</span> <%=rsdescription %>
							</p>
							
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
		<div class="col-sm-4">
			<div class="thumbnail">
				<img style="height:200px" src="img/plus.png">
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
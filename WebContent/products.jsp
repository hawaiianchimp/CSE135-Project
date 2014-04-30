<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Product Categories" />

<%
	Class.forName("org.postgresql.Driver");

	String role = ""+session.getAttribute("role");
	String action = ""+request.getParameter("action");
	String submit = ""+request.getParameter("submit");
	String cid = ""+request.getParameter("cid");
	String pid = ""+request.getParameter("pid");
	
	Connection conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
	PreparedStatement pstmt = null, d_pstmt = null;
	Statement statement = null, d_statement = null;
	ResultSet rs = null;
	String sql = null;
	ArrayList<String> images = new ArrayList<String>();
		images.add("default");
		images.add("baseball_bat");
		//Add more images here
%>	
	
	<!--  Deleting a product -->
	
	
	<% 
	//TODO still need to implement delete
	if(!cid.equals("null"))
	{
		if(action.equals("delete"))
		{
			if(!cid.isEmpty())
			{
				if(role.equals("Owner"))
				{
					try{
					Class.forName("org.postgresql.Driver");
					statement = conn.createStatement();

					//Need a transaction to delete from products and products_categories tables
					sql = "DELETE FROM products WHERE product_id = ?;";
					
					d_pstmt = conn.prepareStatement(sql);
					d_pstmt.setInt(1, Integer.parseInt(cid));
					int count = d_pstmt.executeUpdate();

					if(count != 0){
						%>
						<t:message type="danger" message="Product successfully deleted"></t:message>
						<%
						}
						else{
						%>
						<t:message type="danger" message="Product was already deleted"></t:message>
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
					<t:message type="warning" message="You must be an owner to delete items"></t:message>
					<%
				}
			}
			else
			{
				%>
				<t:message type="warning" message="No product item for deletion"></t:message>
				<%
			}
			
			
		}
	%>

	<!-- Show add modal -->
	<% 
	//TODO still need to implement add modal
		System.out.print(action);
		if(action.equals("add"))
		{
			%>
			<t:modal_header modal_title="Adding Item" />
						<fieldset>
							<!-- Text input-->
							<input type="hidden" name="cid" value="<%=cid %>"/>
							<input type="hidden" name="pid" value="<%=pid %>"/>
							<label class="control-label" for="name">Name</label>
							<input id="name" name="name" type="text" placeholder="Name" class="form-control">
							
							<label class="control-label" for="name">SKU</label>
							<input id="sku" name="sku" type="text" placeholder="SKU" class="form-control">
							
							<label class="control-label" for="img_url">Category</label>
							<select class="form-control" name="category">
								<% 
								
								try{	
									sql = "SELECT category_id, name FROM categories";
									statement = conn.createStatement();
									rs = statement.executeQuery(sql);
									ArrayList<String> categories;
									while(rs.next())
									{
										String c = rs.getString("name");
										String id = rs.getString("category_id");
										String selected = (c.equals(id)) ? "selected":""; %>
										<option <%=selected%> value="<%=c %>"><%=c %></option>
								<% }
									statement.close();
								}
								catch(PSQLException e)
								{
									e.printStackTrace();
								}%>
								
								
							</select>
							<label class="control-label" for="price">Price</label>
							<input id="price" type="text" class="form-control" name="price"/>
							
							<!-- Textarea -->
							<div class="control-group">
							  <label class="control-label" for="description">Description</label>
							  <div class="controls">                     
							    <textarea class="form-control" id="description" name="description"></textarea>
							  </div>
							</div>
							
							
							<label class="control-label" for="img_url">Image</label>
							<select class="form-control" name="img_url">
								<%for(String s: images){ %>
									<option value="<%=s %>"><%=s %></option>
								<% }%>
							</select>
							
							
						</fieldset>
					<t:modal_footer name="add"/>
	<% }	%>

	<!-- Do add submission -->
		<%
		//TODO still need to implement add submission
		if(submit.equals("add"))
		{
				if(role.equals("Owner"))
				{
					try{
						Class.forName("org.postgresql.Driver");
						statement = conn.createStatement();
						//need a transaction to add in products and product_categories
						sql =	"INSERT INTO products (name, sku, img_url, description, price) " +
								"SELECT ?,?,?,?,?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(1, ""+request.getParameter("sku"));
						d_pstmt.setString(2, ""+request.getParameter("img_url"));
						d_pstmt.setString(3, ""+request.getParameter("description"));
						d_pstmt.setString(4, ""+request.getParameter("price"));

						int count = d_pstmt.executeUpdate();
						if(count != 0){
							%>
							<t:message type="danger" message="Product successfully deleted"></t:message>
							<%
							}
						else{
							%>
							<t:message type="danger" message="Error occurred in SQL"></t:message>
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

	<!--  Updating a product -->
	<% 
		//TODO still need to implement udpate modal
		if(action.equals("update"))
		{
			if(!cid.isEmpty())
			{
				if(role.equals("Owner"))
				{
					try{
					Class.forName("org.postgresql.Driver");
					statement = conn.createStatement();
					sql = "SELECT p.*, categories.name AS category_name  FROM (SELECT * FROM products_categories INNER JOIN products ON (products_categories.category_id=?) WHERE products_categories.product_id=products.product_id AND products.product_id = ?) AS p LEFT JOIN categories ON (p.category_id = categories.category_ID);";
					d_pstmt = conn.prepareStatement(sql);
					d_pstmt.setInt(1, Integer.parseInt(cid));
					d_pstmt.setInt(2, Integer.parseInt(pid));
					rs = d_pstmt.executeQuery();
					
					if(rs.next())
					{
						String rsname,rsdescription, rsimg, rsprice, rscategory, rssku; 
						rsname = rs.getString("name");
						rsdescription = rs.getString("description");
						rsimg = rs.getString("img_url");
						rsprice = rs.getString("price");
						rssku = rs.getString("sku");
						rscategory = rs.getString("category_name");
						%>
					<t:modal_header modal_title="Updating Item" />
						<fieldset>
							<!-- Text input-->
							<input type="hidden" name="cid" value="<%=cid %>"/>
							<input type="hidden" name="pid" value="<%=pid %>"/>
							<label class="control-label" for="name">Name</label>
							<input value="<%=rssku %>" id="name" name="name" type="text" placeholder="Name" class="form-control">
							
							<label class="control-label" for="name">SKU</label>
							<input value="<%=rsname %>" id="sku" name="sku" type="text" placeholder="SKU" class="form-control">
							
							<label class="control-label" for="img_url">Category</label>
							<select class="form-control" name="category">
								<% 
								
								try{	
									sql = "SELECT name FROM categories";
									statement = conn.createStatement();
									rs = statement.executeQuery(sql);
									ArrayList<String> categories;
									while(rs.next())
									{
										String c = rs.getString("name");
										String selected = (c.equals(rscategory)) ? "selected":""; %>
										<option <%=selected%> value="<%=c %>"><%=c %></option>
								<% }
									statement.close();
								}
								catch(PSQLException e)
								{
									e.printStackTrace();
								}%>
								
								
							</select>
							<label class="control-label" for="price">Price</label>
							<input value="<%=rsprice %>" id="price" type="text" class="form-control" name="price"/>
							
							<!-- Textarea -->
							<div class="control-group">
							  <label class="control-label" for="description">Description</label>
							  <div class="controls">                     
							    <textarea class="form-control" id="description" name="description"><%=rsdescription %></textarea>
							  </div>
							</div>
							
							
							<label class="control-label" for="img_url">Image</label>
							<select class="form-control" name="img_url">
								<% String selected = "";
									for(String s: images){ 
									selected = (s.equals(rsimg)) ? "selected":""; %>
									<option <%=selected%> value="<%=s %>"><%=s %></option>
								<% }%>
							</select>
							
							
						</fieldset>
					<t:modal_footer name="update"/>
					<%
					}
						else{
						%>
						<t:message type="danger" message="Product does not exist"></t:message>
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
				<t:message type="warning" message="No product selected for deletion"></t:message>
				<%
			}
			
			
		}
	%>

	<%
		//TODO still need to implement update action
		//If submit is equal to "add"
		if(submit.equals("update"))
		{
				if(role.equals("Owner"))
				{
					try{
						Class.forName("org.postgresql.Driver");
						statement = conn.createStatement();
						sql =	"UPDATE products SET (name, img_url, description, price) = " +
								"(?,?,?,?) WHERE product_id = ?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("img_url"));
						d_pstmt.setString(3, ""+request.getParameter("description"));
						
						//ERROR HERE with the double casting from string
						d_pstmt.setDouble(4, Double.valueOf(""+request.getParameter("price")));
						d_pstmt.setInt(5, Integer.parseInt(request.getParameter("cid")));

						int count = d_pstmt.executeUpdate();
						d_pstmt.close();
						if(count != 0){
							%>
							<t:message type="success" message="Product successfully updated"></t:message>
							<%
							}
						else{
							%>
							<t:message type="danger" message="Error occurred in SQL"></t:message>
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
	}
	
	
	
	
	
	
	
	
	
	

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
		c_pstmt = c_conn.prepareStatement("SELECT * FROM categories AS c LEFT JOIN (SELECT p.category_id, COUNT(p.category_id) FROM products_categories AS p GROUP BY p.category_id) AS p ON (c.category_id = p.category_id);");
		c_rs = c_pstmt.executeQuery();
%>

	<div class="row">
	<!-- category menu -->
	<div class="col-sm-2">
		<ul class="nav nav-stacked navbar-left nav-pills">
		<li class="active"><a href="categories.jsp">Categories</a>
		</li>
		<%
			if (c_rs.isBeforeFirst()) {
					String rsname, rsid, rscount;
					while (c_rs.next()) {
						rsname = c_rs.getString("name");
						rsid = String.valueOf(c_rs.getInt("category_id"));
						session.setAttribute("cid", rsid);
						rscount = String.valueOf(c_rs.getInt("count"));
						//System.out.println(rsname + "," + rsdescription + "," + rsimg + "," + rsid);
					%>
						<li><a href="products.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%> <span class="badge"><%=rscount %></span></a></li>
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

		<!-- products -->
		<div class="col-sm-10">
			<%

			if(!cid.equals("null"))
			{
					try {
						// Registering Postgresql JDBC driver with the DriverManager
						Class.forName("org.postgresql.Driver");

						// Open a connection to the database using DriverManager
						conn = DriverManager
								.getConnection(
										"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
										"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");

						// Create the statement
						statement = conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);

						// Use the created statement to SELECT
						// the student attributes FROM the Student table.
						
						sql = "SELECT p.*, categories.name AS category_name  FROM (SELECT * FROM products_categories INNER JOIN products ON (products_categories.category_id=?) WHERE products_categories.product_id=products.product_id) AS p LEFT JOIN categories ON (p.category_id = categories.category_ID)";
						pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);


						int category_id = Integer.parseInt(cid);
						pstmt.setInt(1, category_id);
						rs = pstmt.executeQuery();
					
					
					
					if (rs.isBeforeFirst()) {
						String rsname, rsdescription, rsimg, rssku, rspid, rsprice;
						rs.next();
						%> <h1><%=rs.getString("category_name") %></h1> 
								<div class="row">
										<div class="col-sm-1">
											<h3>Image</h3>
										</div>
										<div class="col-sm-1">
												<h3>Price</h3>
										</div>
										<div class="col-sm-2">
												<h3>Name</h3>
										</div>
										<div class="col-sm-4">
											<p>
												<h3>Description</h3>
											</p>
										</div>
										<div class="col-sm-4">
										</div>
								</div>
								<hr>
						<%
						rs.beforeFirst();
						while (rs.next()) {
							rsname = rs.getString("name");
							rsdescription = rs.getString("description");
							rsimg = rs.getString("img_url");
							rssku = rs.getString("sku");
							rspid = String.valueOf(rs.getInt("product_id"));
							rsprice = String.valueOf(rs.getDouble("price"));
	
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
										<p>
											<a class="btn btn-primary" href="productorder.jsp?product=<%=rspid %>&cid=<%=cid %>">Add to Cart</a>
											<% if(role.equals("Owner"))
											{ %>
												<a class="btn btn-success" href="products.jsp?action=update&cid=<%=cid%>&pid=<%=rspid %>">Update</a>
												<a class="btn btn-danger" href="products.jsp?action=delete&cid=<%=cid%>&pid=<%=rspid %>">Delete</a>
											<% }%>
										</p>
									</div>
							</div>
						<%}
					} 
					else 
					{
						if (role.equals("Owner")) 
						{%>
							<t:message type="warning" message="No Products in this category, please add a product"></t:message>
						<%} 
						else 
						{%>
							<t:message type="warning" message="No Products in this category"></t:message>
						<%}
					}
			
				/* Close everything  */
				// Close the ResultSet
				rs.close();
				//Close the Statement
				statement.close();
				// Close the Connection
				conn.close();
				}

				catch (SQLException e) {
					e.printStackTrace();
					out.println("<h1>" + e.getMessage() + "</h1>");
				} catch (ClassNotFoundException e) {
					e.printStackTrace();
					out.println("<h1>org.postgresql.Driver Not Found</h1>");
				}

				if (role.equals("Owner")) {
			%>
			<div class="row">
									<div class="col-sm-1">
										<img style="height:45px" src="img/plus.png">
									</div>
									<div class="col-sm-1">
									</div>
									<div class="col-sm-2">
											Add new product
									</div>
									<div class="col-sm-4">
										<p>
											Add a new product to the list
										</p>
									</div>
									<div class="col-sm-4">
										<a class="btn btn-success" href="products.jsp?cid=<%=cid %>&action=add">Add Item</a>
									</div>
							</div>





			<%
				}
		
		}
		else{%>
			<t:message type="warning" message="No category selected, please select a category"></t:message>
		<%}%>
		</div>
	</div>
<t:footer />

<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Product Categories" />

<%
	Class.forName("org.postgresql.Driver");

	String uid = "" + session.getAttribute("uid");
	if(uid.equals("null")) //redirect if not logged in
	{
		response.sendRedirect("redirect.jsp");
	}

	String role = ""+session.getAttribute("role");
	String action = ""+request.getParameter("action");
	String submit = ""+request.getParameter("submit");
	String category_name = ((""+request.getParameter("category")).equals("null")) ? "all":""+request.getParameter("category");
	String cid = ""+request.getParameter("cid");
	String pid = ""+request.getParameter("pid");
	String keyword = ""+request.getParameter("keyword");
	keyword = (keyword.equals("null"))? "":keyword;
	
	Connection conn = DriverManager.getConnection(
					"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
					"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
	PreparedStatement pstmt = null, d_pstmt = null;
	Statement statement = null, d_statement = null;
	ResultSet rs = null, d_rs = null;
	String sql = null;
	ArrayList<String> images = new ArrayList<String>();
		images.add("default");
		images.add("baseball_bat");
		//Add more images here
%>	
	
	<!--  Deleting a product -->
	
	
	<% 
	//TODO still need to implement delete
		if(action.equals("delete"))
		{
			if(!cid.isEmpty())
			{
				if(role.equals("owner"))
				{
					try{
						Class.forName("org.postgresql.Driver");
					
						//Need a transaction to delete from products and products_categories tables
						conn.setAutoCommit(false);
						sql = "DELETE FROM products WHERE id = ?;";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setInt(1, Integer.parseInt(pid));
						int d2 = d_pstmt.executeUpdate();
						System.out.print("d2:" + d2);
						if(d2 == 1)
						{
						conn.commit();
							%>
							<t:message type="success" message="Product successfully deleted"></t:message>
							<%
						// Close the ResultSet
						}
						else
						{
							conn.rollback();
								%>
								<t:message type="danger" message="Product deletion unsuccessful. It might be in one of the customers carts."></t:message>
								<%
						}
						d_pstmt.close();
					}
					catch(SQLException e){
						e.printStackTrace();
						conn.rollback();
						String message = "Failure to Delete Product: " + e.getMessage();
			   	     	%>
						<t:message type="danger" message="<%=message %>"></t:message>
						<%
					}
					conn.setAutoCommit(true);
					conn.close();
					
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
		//System.out.print(action);
		if(action.equals("add"))
		{
			%>
			<t:modal_header modal_title="Adding Item" />
						<fieldset>
							<!-- Text input-->
							<input type="hidden" name="cid" value="<%=cid %>"/>
							<input type="hidden" name="pid" value="<%=pid %>"/>	
		        			<input type="hidden" name="category" value="<%=category_name %>"/>
							<label class="control-label" for="name">Name</label>
							<input id="name" name="name" type="text" placeholder="Name" class="form-control">
							
							<label class="control-label" for="name">SKU</label>
							<input id="sku" name="sku" type="text" placeholder="SKU" class="form-control">
							
							<label class="control-label" for="category">Category</label>
							<select class="form-control" name="new_cid">
								<% 
								
								try{	
									sql = "SELECT id, name FROM categories";
									statement = conn.createStatement();
									rs = statement.executeQuery(sql);
									ArrayList<String> categories;
									while(rs.next())
									{
										String c = rs.getString("name");
										String old_id = rs.getString("id");
										String selected = (old_id.equals(cid)) ? "selected":""; %>
										<option <%=selected%> value="<%=old_id %>"><%=c %></option>
								<% }
									statement.close();
									rs.close();
									conn.close();
								}
								catch(PSQLException e)
								{
									e.printStackTrace();

									String message = "Failure to Delete Product: " + e.getMessage();
						   	     	%>
									<t:message type="danger" message="<%=message %>"></t:message>
									<%
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
							
							
						</fieldset>
					<t:modal_footer name="add"/>
	<% }	%>

	<!-- Do add submission -->
		<%
		//TODO still need to implement add submission
		if(submit.equals("add"))
		{
				if(role.equals("owner"))
				{

					try{
						if((""+request.getParameter("name")).isEmpty()){
							throw new SQLException("Name cannot be empty");
						}
						if((""+request.getParameter("sku")).isEmpty()){
							throw new SQLException("sku cannot be empty");
						}
						if((""+request.getParameter("description")).isEmpty()){
							throw new SQLException("description cannot be empty");
						}
					
						Class.forName("org.postgresql.Driver");
						conn.setAutoCommit(false);
						//need a transaction to add in products and product_categories
						sql =	"INSERT INTO products (cid, name, sku, price) " +
								"SELECT ?,?,?,?";
						pstmt = conn.prepareStatement(sql);
						
						pstmt.setString(1, ""+request.getParameter("new_cid"));
						pstmt.setString(2, ""+request.getParameter("name"));
						pstmt.setString(3, ""+request.getParameter("sku"));
						Integer p = ((""+request.getParameter("price")).isEmpty()) ? 0:Integer.parseInt(""+request.getParameter("price"));
						pstmt.setInt(4, p);
						Integer product_id;
						if(pstmt.execute())
						{
							conn.commit();
							%><t:message type="success" message="Product successfully added"></t:message><%
						}
						else{
							conn.rollback();
							%><t:message type="danger" message="Rolling back"></t:message><%
						}
						conn.setAutoCommit(true);
						pstmt.close();
						conn.close();
					}
					catch(SQLException e){
						e.printStackTrace();
						String message = "Failure to Insert Product: " + e.getMessage();
			   	     	%>
						<t:message type="danger" message="<%=message %>"></t:message>
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
			if(!pid.isEmpty())
			{
				if(role.equals("owner"))
				{
					try{
						
					if((""+request.getParameter("name")).isEmpty()){
						throw new SQLException("Name cannot be empty");
					}
					if((""+request.getParameter("sku")).isEmpty()){
						throw new SQLException("sku cannot be empty");
					}
					if((""+request.getParameter("description")).isEmpty()){
						throw new SQLException("description cannot be empty");
					}
					Class.forName("org.postgresql.Driver");
					statement = conn.createStatement();
					sql = "SELECT * FROM products WHERE id = ?";
					d_pstmt = conn.prepareStatement(sql);
					d_pstmt.setInt(1, Integer.parseInt(pid));
					rs = d_pstmt.executeQuery();
					
					if(rs.next())
					{
						String rsname, rsprice, rscategory, rssku; 
						rsname = rs.getString("name");
						rsprice = rs.getString("price");
						rssku = rs.getString("sku");
						rscategory = rs.getString("cid");
						%>
					<t:modal_header modal_title="Updating Item" />
						<fieldset>
							<!-- Text input-->
							<input type="hidden" name="cid" value="<%=cid %>"/>
							<input type="hidden" name="pid" value="<%=pid %>"/>
		        			<input type="hidden" name="category" value="<%=category_name %>"/>
							<label class="control-label" for="name">Name</label>
							<input value="<%=rsname %>" id="name" name="name" type="text" placeholder="Name" class="form-control">
							
							<label class="control-label" for="name">SKU</label>
							<input value="<%=rssku %>" id="sku" name="sku" type="text" placeholder="SKU" class="form-control">
							
							<label class="control-label" for="Category">Category</label>
							<select class="form-control" name="new_cid">
								<% 
								
								try{	
									sql = "SELECT id, name FROM categories";
									d_statement = conn.createStatement();
									d_rs = statement.executeQuery(sql);
									ArrayList<String> categories;
									while(d_rs.next())
									{
										String c = d_rs.getString("name");
										String old_id = d_rs.getString("id");
										String selected = (old_id.equals(rscategory)) ? "selected":""; %>
										<option <%=selected%> value="<%=old_id %>"><%=c %></option>
								<% }
									d_statement.close();
									conn.close();
									d_rs.close();
								}
								catch(PSQLException e)
								{
									e.printStackTrace();
								}%>
								
								
							</select>
							<label class="control-label" for="price">Price</label>
							<input value="<%=rsprice %>" id="price" type="text" class="form-control" name="price"/>
							
						</fieldset>
					<t:modal_footer name="update"/>
					<%
					rs.close();
					statement.close();
					}
						else{
						%>
						<t:message type="danger" message="Product does not exist"></t:message>
						<%
						}
					}
					catch(SQLException e){
						e.printStackTrace();
			   	     	String message = "Failure to Update Product: " + e.getMessage();
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
				if(role.equals("owner"))
				{
					try{
						Class.forName("org.postgresql.Driver");
						conn.setAutoCommit(false);
						sql =	"UPDATE products SET (cid, name, sku, price) = " +
								"(?,?,?,?) WHERE id = ?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setInt(1, Integer.parseInt(request.getParameter("new_cid")));
						d_pstmt.setString(2, ""+request.getParameter("name"));
						d_pstmt.setString(3, ""+request.getParameter("sku"));
						Integer p = ((""+request.getParameter("price")).isEmpty()) ? 0:Integer.parseInt(""+request.getParameter("price"));
						d_pstmt.setInt(4, p);
						d_pstmt.setInt(5, Integer.parseInt(request.getParameter("pid")));
						d_pstmt.executeUpdate();
					
						conn.setAutoCommit(true);
						d_pstmt.close();
						conn.close();
						
						%>
						<t:message type="success" message="Product successfully updated"></t:message>
						<%
					}
					catch(SQLException e){
						e.printStackTrace();
						conn.rollback();
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
		
		sql = "SELECT categories.*, COUNT(products) AS count FROM categories LEFT OUTER JOIN products ON (products.cid = categories.id) GROUP BY categories.id";
		c_pstmt = c_conn.prepareStatement(sql);
		c_rs = c_pstmt.executeQuery();
%>

<div class="row clearfix">
	
	<!-- product search -->
	<div class="row clearfix">
		<div class="col-sm-12">
			<form class="navbar-form navbar-left" role="search" action="products.jsp">
		        <div class="form-group">
		        	<input type="hidden" name="cid" value="<%=cid %>"/>
		        	<input type="hidden" name="pid" value="<%=pid %>"/>
		        	<input type="hidden" name="category" value="<%=category_name %>"/>
		          <input name="keyword" type="text" class="form-control" placeholder="Search in <%= category_name%>" value="<%= keyword%>">
		        </div>
		        <input type="submit" value="Search" class="btn btn-default"/>
		      </form>
		</div>
	</div>

	<!-- category menu -->
	<div class="col-sm-2">
		<ul class="nav nav-stacked navbar-left nav-pills">
		<li><a href="categories.jsp">All Categories</a>
		</li>
		<%
			if (c_rs.isBeforeFirst()) {
					String rsname, rsid, rscount,active;
					while (c_rs.next()) {
						rsname = c_rs.getString("name");
						active = (rsname.equals(category_name))? "class='active' ":"";
						rsid = String.valueOf(c_rs.getInt("id"));
						session.setAttribute("cid", rsid);
						rscount = c_rs.getString("count");
					%>
						<li <%= active%>><a href="products.jsp?cid=<%=rsid %>&category=<%=rsname %>"><%=rsname%> <span class="badge"><%=rscount %></span></a></li>
					<%
					}
			}
			else {
			%>
				<li>No Categories</li>
			<%
			}
		
			/* Close everything  */
			c_pstmt.close();
			// Close the ResultSet
			c_rs.close();
			// Close the Connection
			c_conn.close();
		%>
		</ul>
	</div>

		<!-- products -->
		<div class="col-sm-10">
			<%
					try {
						// Registering Postgresql JDBC driver with the DriverManager
						Class.forName("org.postgresql.Driver");

						// Open a connection to the database using DriverManager
						conn = DriverManager
								.getConnection(
										"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
										"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");

						// Create the statement

						// Use the created statement to SELECT
						// the student attributes FROM the Student table.
							if(!cid.equals("null"))
							{

								if(keyword.isEmpty())
								{
									sql = "SELECT p.*, c.name AS category_name  FROM products AS p, categories AS c WHERE p.cid = c.id AND c.id = " + cid + " ";
								}
								else
								{
									sql = "SELECT p.*, c.name AS category_name  FROM products AS p, categories AS c WHERE p.cid = c.id AND c.id = " + cid + " AND p.name ILIKE '%"+keyword+"%'";
								}
							}
							else
							{
								if(!keyword.isEmpty())
								{
									sql = "SELECT * FROM products WHERE products.name ILIKE '%"+ keyword+ "%'";
								}
								else
								{
									sql = "SELECT * FROM products";
								}
							}
						
						
						pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);


						rs = pstmt.executeQuery();
					
					
					
					if (rs.isBeforeFirst()) {
						String rsname, rssku, rspid, rsprice;
						rs.next();%>
							<table class="table table-condensed">
								<thead>
									<tr>
										<td>
										</td>
										<td>
												<h3>Price</h3>
										</td>
										<td>
												<h3>Name</h3>
										</td>
										<td>
												<h3>SKU</h3>
										</td>
										<td>
										</td>
									</tr>
								</thead>
								
						<%
						rs.beforeFirst();
						while (rs.next()) {
							rsname = rs.getString("name");
							rssku = rs.getString("sku");
							rspid = String.valueOf(rs.getInt("id"));
							rsprice = String.valueOf(rs.getInt("price"));

							%>
							<tr>
									<td>
										<span class="badge badge-success">
											$<%=rsprice %>
										</span>
									</td>
									<td>
										<p>
											<%=rsname %>
										</p>
									</td>
									<td>
										<p>
											<%=rssku %>
										</p>
									</td>
									<td>
										<p>
											<% if(role.equals("owner"))
											{ %>
												<form class="form-vertical" action="products.jsp" method="GET">
													<input type="hidden" name="pid" value="<%=rspid %>">
													<input type="hidden" name="cid" value="<%=cid %>">
													<input type="hidden" name="keyword" value="<%=keyword %>">
													<input type="submit" class="btn btn-success" name="action" value="update" class="form-control"/>
													<input type="submit" class="btn btn-danger" name="action" value="delete" class="form-control"/>
												</form>
											<% }
											else
											{ %>
												<form class="form-vertical" action="productorder.jsp" method="GET">
													<input type="hidden" name="action" value="order">
													<input type="hidden" name="product" value="<%=rspid %>">
													<input type="hidden" name="cid" value="<%=cid %>">
													<input type="hidden" name="keyword" value="<%=keyword %>">
													<input type="submit" class="btn btn-primary" value="Add To Cart" class="form-control"/>
												</form>
											<% }%>
										</p>
									</td>
							</tr>
						<%}
					} 
					else 
					{
						if (role.equals("owner")) 
						{%>
							<t:message type="warning" message="No Products in this category, please add a product"></t:message>
						<%} 
						else 
						{%>
							<t:message type="warning" message="No Products in this category"></t:message>
						<%}
					}
			
				/* Close everything  */
				pstmt.close();
				// Close the ResultSet
				rs.close();
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

				if (role.equals("owner")) {
					%>
						<tr>
							<td>
							</td>
							<td>
							</td>
							<td>
							</div>
							</td>
							<td>
								<a class="btn btn-success" href="products.jsp?cid=<%=cid %>&action=add">Add Item</a>
							</td>
						</tr>

			<%
				}
		%>
		
		</table>
		
	</div>
	</div>
<t:footer />

<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Dashboard" />

<%
	Class.forName("org.postgresql.Driver");

	String uid = "" + session.getAttribute("id");
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
						sql = "DELETE FROM products_categories WHERE product_id = ?;";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setInt(1, Integer.parseInt(pid));
						int d1 = d_pstmt.executeUpdate();
						System.out.print(d1);
						sql = "DELETE FROM products WHERE product_id = ?;";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setInt(1, Integer.parseInt(pid));
						int d2 = d_pstmt.executeUpdate();
						System.out.print(d2);
						if((d1 + d2) == 2)
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
							
							<label class="control-label" for="img_url">Category</label>
							<select class="form-control" name="new_category_id">
								<% 
								
								try{	
									sql = "SELECT category_id, name FROM categories";
									statement = conn.createStatement();
									rs = statement.executeQuery(sql);
									ArrayList<String> categories;
									while(rs.next())
									{
										String c = rs.getString("name");
										String old_id = rs.getString("category_id");
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
						sql =	"INSERT INTO products (name, sku, img_url, description, price) " +
								"SELECT ?,?,?,?,? RETURNING product_id";
						pstmt = conn.prepareStatement(sql);
						
						pstmt.setString(1, ""+request.getParameter("name"));
						pstmt.setString(2, ""+request.getParameter("sku"));
						pstmt.setString(3, ""+request.getParameter("img_url"));
						pstmt.setString(4, ""+request.getParameter("description"));
						Double p = ((""+request.getParameter("price")).isEmpty()) ? 0:Double.parseDouble(""+request.getParameter("price"));
						pstmt.setDouble(5, p);
						Integer product_id;
						if(pstmt.execute())
						{
							rs = pstmt.getResultSet();
							if(rs.next()){ 
							product_id = rs.getInt("product_id");
							sql =	"INSERT INTO products_categories (category_id, product_id) " +
									"SELECT ?,?";
							pstmt = conn.prepareStatement(sql);
							String new_id = (""+request.getParameter("new_category_id"));
							pstmt.setInt(1, Integer.parseInt(new_id));
							pstmt.setInt(2, product_id);
								if(pstmt.executeUpdate() != 0)
								{
									conn.commit();
									%><t:message type="success" message="Product successfully added"></t:message><%
								}
								else{
									conn.rollback();
									%><t:message type="danger" message="Rolling back"></t:message><%
								}
							}
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
					sql = "SELECT * FROM (SELECT * FROM (products NATURAL JOIN products_categories) AS product_join NATURAL JOIN (SELECT name AS category_name, category_id FROM categories) AS c) AS p_join WHERE p_join.product_id = ?";
					d_pstmt = conn.prepareStatement(sql);
					d_pstmt.setInt(1, Integer.parseInt(pid));
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
		        			<input type="hidden" name="category" value="<%=category_name %>"/>
							<label class="control-label" for="name">Name</label>
							<input value="<%=rsname %>" id="name" name="name" type="text" placeholder="Name" class="form-control">
							
							<label class="control-label" for="name">SKU</label>
							<input value="<%=rssku %>" id="sku" name="sku" type="text" placeholder="SKU" class="form-control">
							
							<label class="control-label" for="img_url">Category</label>
							<select class="form-control" name="new_category_id">
								<% 
								
								try{	
									sql = "SELECT category_id, name FROM categories";
									d_statement = conn.createStatement();
									d_rs = statement.executeQuery(sql);
									ArrayList<String> categories;
									while(d_rs.next())
									{
										String c = d_rs.getString("name");
										String old_id = d_rs.getString("category_id");
										String selected = (c.equals(rscategory)) ? "selected":""; %>
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
						sql =	"UPDATE products SET (name, sku, img_url, description, price) = " +
								"(?,?,?,?,?) WHERE product_id = ?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setString(1, ""+request.getParameter("name"));
						d_pstmt.setString(2, ""+request.getParameter("sku"));
						d_pstmt.setString(3, ""+request.getParameter("img_url"));
						d_pstmt.setString(4, ""+request.getParameter("description"));
						Double p = ((""+request.getParameter("price")).isEmpty()) ? 0:Double.parseDouble(""+request.getParameter("price"));
						d_pstmt.setDouble(5, p);
						d_pstmt.setInt(6, Integer.parseInt(request.getParameter("pid")));
						d_pstmt.executeUpdate();
						sql =	"UPDATE products_categories SET (category_id) = " +
								"(?) WHERE product_id = ?";
						d_pstmt = conn.prepareStatement(sql);
						d_pstmt.setInt(1, Integer.parseInt(request.getParameter("new_category_id")));
						d_pstmt.setInt(2, Integer.parseInt(request.getParameter("pid")));

						int count = d_pstmt.executeUpdate();
						conn.commit();
						//ERROR HERE with the double casting from string

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
		c_pstmt = c_conn.prepareStatement("SELECT * FROM categories");
		c_rs = c_pstmt.executeQuery();
%>
	
	<!-- product search -->
	<div class="row">
		<div class="col-sm-4">
			<form class="navbar-form navbar-left" role="search" action="dashboard.jsp" method="GET">
				<select class="form-control" name="scope">
		        	<option value="customers">Customers</option>
		        	<option value="states">States</option>
		        </select>
		        <input type="submit" value="Run Query" class="btn btn-default"/>
		    </form>
		    </div>
		<div class="col-sm-1">
		</div>
		<div class="col-sm-7">
		<form class="navbar-form navbar-left" role="search" action="dashboard.jsp" method="GET">
		        <select class="form-control" name="ages">
		        	<option value="all">All Ages</option>
		        	<option value="1">12-18</option>
		        	<option value="2">18-45</option>
		        	<option value="3">45-65</option>
		        	<option value="4">65-</option>
		        </select>
		        <select class="form-control" name="category">
		        	<option>All Categories</option>
		        	<% while(c_rs.next())
		        		{%>
		        		<option value="<%= c_rs.getString("id") %>"><%= c_rs.getString("name")%></option>
		        		<% }
		        		%>
		        </select>
		        <select class="form-control" name="state">
		        	<option value="all">All States</option>
					<option value="AL">Alabama</option>
					<option value="AK">Alaska</option>
					<option value="AZ">Arizona</option>
					<option value="AR">Arkansas</option>
					<option value="CA">California</option>
					<option value="CO">Colorado</option>
					<option value="CT">Connecticut</option>
					<option value="DE">Delaware</option>
					<option value="DC">District Of Columbia</option>
					<option value="FL">Florida</option>
					<option value="GA">Georgia</option>
					<option value="HI">Hawaii</option>
					<option value="ID">Idaho</option>
					<option value="IL">Illinois</option>
					<option value="IN">Indiana</option>
					<option value="IA">Iowa</option>
					<option value="KS">Kansas</option>
					<option value="KY">Kentucky</option>
					<option value="LA">Louisiana</option>
					<option value="ME">Maine</option>
					<option value="MD">Maryland</option>
					<option value="MA">Massachusetts</option>
					<option value="MI">Michigan</option>
					<option value="MN">Minnesota</option>
					<option value="MS">Mississippi</option>
					<option value="MO">Missouri</option>
					<option value="MT">Montana</option>
					<option value="NE">Nebraska</option>
					<option value="NV">Nevada</option>
					<option value="NH">New Hampshire</option>
					<option value="NJ">New Jersey</option>
					<option value="NM">New Mexico</option>
					<option value="NY">New York</option>
					<option value="NC">North Carolina</option>
					<option value="ND">North Dakota</option>
					<option value="OH">Ohio</option>
					<option value="OK">Oklahoma</option>
					<option value="OR">Oregon</option>
					<option value="PA">Pennsylvania</option>
					<option value="RI">Rhode Island</option>
					<option value="SC">South Carolina</option>
					<option value="SD">South Dakota</option>
					<option value="TN">Tennessee</option>
					<option value="TX">Texas</option>
					<option value="UT">Utah</option>
					<option value="VT">Vermont</option>
					<option value="VA">Virginia</option>
					<option value="WA">Washington</option>
					<option value="WV">West Virginia</option>
					<option value="WI">Wisconsin</option>
					<option value="WY">Wyoming</option>
				</select>
				<input type="hidden" name="query" value="true"/>
		        <input type="submit"  class="btn btn-default"/>
		      </form>
		</div>
	</div>
	<div class="row">
		<!-- category menu -->
		<div class="col-sm-12">
			<table class="table">
				<thead>
					<tr>
						<th></th>
						<th>table1</th>
						<th>table2</th>
						<th>table3</th>
						<th>table4</th>
						<th>table5</th>
						<th>table6</th>
						<th>table7</th>
						<th>table8</th>
						<th>table9</th>
						<th>table10</th>
						<th><a href="#" class="btn btn-default">Next 20 customers</a></th>
					</tr>
				</thead>
				
				<tr><th>name</th><td>table1</td><td>table2</td><td>table3</td><td>table4</td><td>table5</td><td>table6</td><td>table7</td><td>table8</td><td>table9</td><td>table10</td></tr>
				<tr><th>name</th><td>table1</td><td>table2</td><td>table3</td><td>table4</td><td>table5</td><td>table6</td><td>table7</td><td>table8</td><td>table9</td><td>table10</td></tr>
				<tr><th>name</th><td>table1</td><td>table2</td><td>table3</td><td>table4</td><td>table5</td><td>table6</td><td>table7</td><td>table8</td><td>table9</td><td>table10</td></tr>
				<tr><th>name</th><td>table1</td><td>table2</td><td>table3</td><td>table4</td><td>table5</td><td>table6</td><td>table7</td><td>table8</td><td>table9</td><td>table10</td></tr>
			</table>
			<a href="#" class="btn btn-default">Next 20 customers</a>
	
		</div>
	</div>
<t:footer />

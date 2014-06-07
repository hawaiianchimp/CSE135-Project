<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<t:header title="Sales Analytics Precomputed" />
<%

Connection conn=null;
Statement stmt1=null,stmt2=null,stmt3=null;
ResultSet rs1=null,rs2=null,rs3=null;
String sql1 =null, sql2 = null, sql3 = null;


try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
	"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
	
	conn = DriverManager.getConnection(
    	"jdbc:postgresql://localhost/CSE135?" +
    	"user=Bonnie"); 
	
	conn.setAutoCommit(false);
	
	stmt1 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt2 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt3 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	
	String scope = ""+request.getParameter("scope");
	String state = request.getParameter("state");
	String category = request.getParameter("category");
	
	//sql1: Products and Totals for column labels
	
	if(category == null || category.equals("all") || category.equals("null"))
	{
		//category - off
		sql1 = "SELECT * FROM products_total ORDER BY total DESC LIMIT 10";	
	}
	else
	{
		//category - on
		sql1 = "SELECT * FROM products_total WHERE pid IN (SELECT id FROM products WHERE cid = " + category + ") ORDER BY total DESC LIMIT 10";
	}
	
	//sql2: Users/states and totals for row labels
	//sql3: per product per user/state for table data
	
	if (scope.equals("states"))
	{
		if (category == null || category.equals("all") || category.equals("null"))
		{
			if (state == null || state.equals("all") || state.equals("null"))
			{
				//category - off, state - off
				sql2 = "SELECT * FROM states_total ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM states_products_total AS spt WHERE spt.pid IN (SELECT pt.pid FROM products_total as pt ORDER BY pt.total DESC LIMIT 10)";
			}
			else
			{
				//category - off, state - on
				sql2 = "SELECT * FROM states_total WHERE state = '" + state + "' ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM states_products_total AS spt WHERE spt.state = '" + state + "' AND spt.pid IN (SELECT pt.pid FROM products_total AS pt ORDER BY pt.total DESC LIMIT 10)";
			}
		}
		else
		{
			if (state == null || state.equals("all") || state.equals("null"))
			{
				//category - on, state - off
				sql2 = "SELECT * FROM states_categories_total WHERE cid = " + category + " ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM states_products_total AS spt WHERE spt.pid IN (SELECT pt.pid FROM products_total AS pt WHERE pt.pid IN (SELECT p.id FROM products AS p WHERE p.cid = " + category + ") ORDER BY pt.total DESC LIMIT 10)";
			}
			else
			{
				//category - on, state - on
				sql2 = "SELECT * FROM states_categories_total WHERE cid = " + category + " AND state = '" + state + "' ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM states_products_total AS spt WHERE spt.state = '" + state + "' AND spt.pid IN (SELECT pt.pid FROM products_total AS pt WHERE pt.pid IN (SELECT p.id FROM products AS p WHERE p.cid = " + category + ") ORDER BY pt.total DESC LIMIT 10)";
			}
		}
	}
	else //scope = users
	{
		if(category == null || category.equals("all") || category.equals("null"))
		{
			if (state == null || state.equals("all") || state.equals("null"))
			{
				//category - off, state - off
				sql2 = "SELECT * FROM users_total ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM users_products_total AS upt WHERE upt.pid IN (SELECT pt.pid FROM products_total AS pt ORDER BY pt.total DESC LIMIT 10)";
			}
			else
			{
				//category - off, state - on
				sql2 = "SELECT * FROM users_total AS ut WHERE ut.uid IN (SELECT u.uid FROM users AS u WHERE u.state = '" + state + "') ORDER BY ut.total LIMIT 20";
				sql3 = "SELECT * FROM users_products_total AS upt WHERE upt.uid IN (SELECT u.uid FROM users u WHERE u.state = '" + state + "') AND upt.pid IN (SELECT pt.pid FROM products_total AS pt ORDER BY pt.total LIMIT 10)";
			}
		}
		else
		{
			if (state == null || state.equals("all") || state.equals("null"))
			{
				//category - on, state - off
				sql2 = "SELECT * FROM users_categories_total ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM users_products_total AS upt WHERE upt.pid IN (SELECT p.id FROM products AS p WHERE p.cid = " + category + ") ORDER BY upt.total DESC LIMIT 10";
			}
			else
			{
				//category - on, state - on
				sql2 = "SELECT * FROM users_categories_total AS uct WHERE uct.uid IN (SELECT u.uid FROM users AS u WHERE u.state = '" + state + "') ORDER BY uct.total DESC LIMIT 20";
				sql3 = "SELECT * FROM users_products_total AS upt WHERE upt.uid IN (SELECT u.uid FROM users WHERE u.state = '" + state + "') AND upt.pid in (SELECT p.pid FROM products AS p WHERE p.cid = " + category + ") ORDER BY upt.total DESC LIMIT 20";
			}
		}
	}
	
	//rs1 = products row
	//rs2 = user/state column
	//rs3 = table cells
	rs1 = stmt1.executeQuery(sql1); //1 = pid, 2 = total
	rs2 = stmt2.executeQuery(sql2); //1 = uid OR state, 2 = total
	rs3 = stmt3.executeQuery(sql3);	//1 = uid OR state, 2 = pid, 3 = total
	
	rs1.beforeFirst();
	rs2.beforeFirst();
	rs3.beforeFirst();
	
	%>
	<table class = "table">
	<thead>
	<tr>
	
	<th>
	<a class="btn btn-default btn-primary" href='#' >Home</a>
	</th>
	<%
			PreparedStatement c_pstmt = null;
			ResultSet c_rs = null;
			
			c_pstmt = conn.prepareStatement("SELECT * FROM categories LIMIT 10");
			c_rs = c_pstmt.executeQuery();
		%>
	
		<!-- For Choosing States vs. Customers Table -->
		<form class="navbar-form navbar-left" role="search" method="GET">
				<th colspan="2">
				<% String scope_select = "<select class='form-control' name='scope'>" +
			        	"<option value='customers'>Customers</option>"+
						"<option value='states'>States</option>"+
			        "</select>";
			        scope_select = scope_select.replaceAll("value='"+scope+"'","value='"+scope+"' selected");%>
			        <%=scope_select %>
				</th><th colspan="2">
		        <select class="form-control" name="category">
		        	<option value="all">All Categories</option>
		        	<% String selected = "";   
		        	while(c_rs.next())
		        		{
		        			if(c_rs.getString("id").equals(category))
		        			{
		        				selected = "selected";
		        			}
		        		%>
		        		<option value="<%= c_rs.getString("id") %>" <%=selected %>><%= c_rs.getString("name")%></option>
		        		<% }
		        		%>
		        </select>
		        </th><th colspan="2">
		        <% String s = "<select class='form-control' name='state'>" +
			        	"<option value='all'>All States</option>" +
						"<option value='Alabama'>Alabama</option>" +
						"<option value='Alaska'>Alaska</option>" +
						"<option value='Arizona'>Arizona</option>" +
						"<option value='Arkansas'>Arkansas</option>" +
						"<option value='California'>California</option>" +
						"<option value='Colorado'>Colorado</option>" +
						"<option value='Connecticut'>Connecticut</option>" +
						"<option value='Delaware'>Delaware</option>" +
						"<option value='District Of Columbia'>District Of Columbia</option>" +
						"<option value='Florida'>Florida</option>" +
						"<option value='Georgia'>Georgia</option>" +
						"<option value='Hawaii'>Hawaii</option>" +
						"<option value='Idaho'>Idaho</option>" +
						"<option value='Illinois'>Illinois</option>" +
						"<option value='Indiana'>Indiana</option>" +
						"<option value='Iowa'>Iowa</option>" +
						"<option value='Kansas'>Kansas</option>" +
						"<option value='Kentucky'>Kentucky</option>" +
						"<option value='Louisiana'>Louisiana</option>" +
						"<option value='Maine'>Maine</option>" +
						"<option value='Maryland'>Maryland</option>" +
						"<option value='Massachusetts'>Massachusetts</option>" +
						"<option value='Michigan'>Michigan</option>" +
						"<option value='Minnesota'>Minnesota</option>" +
						"<option value='Mississippi'>Mississippi</option>" +
						"<option value='Missouri'>Missouri</option>" +
						"<option value='Montana'>Montana</option>" +
						"<option value='Nebraska'>Nebraska</option>" +
						"<option value='Nevada'>Nevada</option>" +
						"<option value='New Hampshire'>New Hampshire</option>" +
						"<option value='New Jersey'>New Jersey</option>" +
						"<option value='New Mexico'>New Mexico</option>" +
						"<option value='New York'>New York</option>" +
						"<option value='North Carolina'>North Carolina</option>" +
						"<option value='North Dakota'>North Dakota</option>" +
						"<option value='Ohio'>Ohio</option>" +
						"<option value='Oklahoma'>Oklahoma</option>" +
						"<option value='Oregon'>Oregon</option>" +
						"<option value='Pennsylvania'>Pennsylvania</option>" +
						"<option value='Rhode Island'>Rhode Island</option>" +
						"<option value='Sout Carolina'>South Carolina</option>" +
						"<option value='South Dakora'>South Dakota</option>" +
						"<option value='Tennessee'>Tennessee</option>" +
						"<option value='Texas'>Texas</option>" +
						"<option value='Utah'>Utah</option>" +
						"<option value='Vermont'>Vermont</option>" +
						"<option value='Virginia'>Virginia</option>" +
						"<option value='West Virginia'>Washington</option>" +
						"<option value='West Virginia'>West Virginia</option>" +
						"<option value='Wisconsin'>Wisconsin</option>" +
						"<option value='Wyoming'>Wyoming</option>" +
					" </select>"; 
					s = s.replaceAll("value='"+ state +"'", "value='"+ state +"' selected"); %>
					<%=s %>
				</th><th colspan="3">
				<input type="hidden" name="query" value="true"/>
				<input type="submit"  class="btn btn-default" />
		        </th>
		   	</form> 
	<tr>
	
	<%
	String row_name = "";
	String row_selector = "";
	
			if(scope.equals("states")) {
				%>
				<th>STATE</th>
				<%
				if(state == null || state.equals("all") || state.equals("null"))  
				{
					row_name = "name";
					row_selector = "uid";
				}
				else
				{
					
					System.out.print(state);
					row_name = "state";
					row_selector = "state";
				}
			}
			else{
				%>
				<th>USER</th>
				<%
				row_name = "name";
				row_selector = "uid";
			}
			%>
	<%
	//prints out the product labels
	while(rs1.next()){
		%>
			<td>
				<strong><%=rs1.getString("name") %></strong>
				<br>
				<span class="label label-success">$<%=rs1.getInt("total") %></span>
			</td>	
		<%
	}
	%>
	</tr>
	</thead>
	<%
	//prints out the user/state labels
	while(rs2.next()){
		%>
			<tr>
				<td>
				<strong><%=rs2.getString(1)%></strong>
				<br>
				<span class="label label-success">$<%=rs2.getInt("total") %></span>
				</td>
				<%
				rs1.beforeFirst();
				while(rs1.next())
				{
					boolean match = false;
					rs3.beforeFirst();
					while(rs3.next() && !match) 
					{
						if(!scope.equals("states"))
						{
							if((rs1.getInt("pid") == rs3.getInt("pid")) && (rs2.getInt("uid") == rs3.getInt("uid")))
							{	
								//System.out.println(rs_3.getInt("amount"));
								match = true;
							%>
								<td class="alert alert-success">$<%=rs3.getInt("total")%></td>
							<%
							}
						}else
						{
							if(rs1.getInt("pid") == rs3.getInt("pid") && rs2.getString("state").equals(rs3.getString("state")))
							{	
								//System.out.println(rs_3.getInt("amount"));
								match = true;
							%>
								<td class="alert alert-success">$<%=rs3.getInt("total")%></td>
							<%
							}
						}
					}
					if(match == false){
						%>
						<td>0</td>
					<%
					}
				}
				%>
			</tr>	
		<%
	}
	%>
	</table>
	<%
	
	/*
	conn.commit();
	conn.setAutoCommit(true);
	*/
}

catch (SQLException e)
{
	conn.rollback();
	e.printStackTrace();
}

finally
{
	if (conn != null)
		conn.close();
	if (stmt1 != null)
		stmt1.close();
	if (stmt2 != null)
		stmt2.close();
	if (stmt3 != null)
		stmt3.close();
	if (rs1 != null)
		rs1.close();
	if (rs2 != null)
		rs2.close();
	if (rs3 != null)
		rs3.close();
}
%>
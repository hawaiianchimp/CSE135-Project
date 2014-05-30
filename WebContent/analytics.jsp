<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Sales Analytics" />
<%

long beg = System.nanoTime();
Connection conn=null;
Statement stmt,stmt_2,stmt_3;
ResultSet rs=null,rs_2=null,rs_3=null;
String SQL=null;
try
{
	try{Class.forName("org.postgresql.Driver");}catch(Exception e){System.out.println("Driver error");}
	
	conn = DriverManager.getConnection(
    	"jdbc:postgresql://localhost/cse135?" +
    	"user=Sean");  
            
	/* conn = DriverManager.getConnection("jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
   	"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); */
	stmt =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt_2 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	stmt_3 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	
	//System.out.println("=================");
	
	//scope session variable
	String scope = ""+request.getParameter("scope");
	//System.out.println("scope: " + scope);
	
	//r_offset and next_r_offset session variable
	String r_offset, next_r_offset;
	if(request.getParameter("r_offset") != null && !request.getParameter("r_offset").equals("0"))
	{
		r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset")));
		next_r_offset = String.valueOf(Integer.valueOf(request.getParameter("r_offset"))+20);
	}
	else
	{
		r_offset = "0";
		next_r_offset = "20";
	}
	//System.out.println("r_offset: " + r_offset);
	//System.out.println("next_r_offset: " + next_r_offset);
	
	//c_offset and next_c_offset session variable
	String c_offset, next_c_offset;
	if(request.getParameter("c_offset") != null && !request.getParameter("c_offset").equals("0"))
	{
		c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset")));
		next_c_offset = String.valueOf(Integer.valueOf(request.getParameter("c_offset"))+10);
	}
	else
	{
		c_offset = "0";
		next_c_offset = "10";
	}
	
	//System.out.println("c_offset: " + c_offset);
	//System.out.println("next_c_offset: " + next_c_offset);
	
	//state session variable
	String state = request.getParameter("state");
	//System.out.println("state: " + state);
	
	//category session variable
	String category = request.getParameter("category");
	//System.out.println("category: " + category);
	
	//age session variable
	String age = request.getParameter("ages");
	//System.out.println("age: " + age);
	
	//Determine if buttons need to be disabled because of offset
	String disabled = "disabled";
	if(r_offset.equals("0") && c_offset.equals("0"))
	{
		disabled = "";
	}
	//System.out.println(disabled);
	
	String SQL_1 = null;
	String SQL_2 = null;
	
	String SQL_11 = null;
	String SQL_21 = null;
	
	String SQL_3 = null;
	
	if(category == null || category.equals("all") || category.equals("null"))
	{
		//System.out.println("columns: product - no filters");
		/** pulls product names, no filters**/
		/* SQL_1 ="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
			" FROM products p" +
			" LEFT JOIN sales s" + 
			" ON s.pid = p.id" +
			" GROUP BY p.name,p.id" + 
			" ORDER BY p.name ASC" +
			" LIMIT 11 OFFSET "+c_offset; */
		SQL_1 = "SELECT pds.id, pds.name, SUM(sales.quantity*sales.price) AS amount "+  //DONE
				"FROM (SELECT id, name FROM products "+
				"ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+") AS pds "+
				"LEFT JOIN sales ON (sales.pid = pds.id) "+
				"GROUP BY pds.id, pds.name";
		/* SQL_11="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
				" FROM products p" +
				" LEFT JOIN sales s" + 
				" ON s.pid = p.id" +
				" GROUP BY p.name,p.id" + 
				" ORDER BY p.name ASC" +
				" LIMIT 1 OFFSET "+next_c_offset; */
		
	}
	else
	{
		//System.out.println("columns: product - category filters");
		/** pulls product names, category filter**/		 
		 /* SQL_1 ="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
					" FROM products p" +
					" LEFT JOIN sales s" + 
					" ON s.pid = p.id" +
					" WHERE p.cid='"+ category +"'" +
					" GROUP BY p.name,p.id" + 
					" ORDER BY p.name ASC" +
					" LIMIT 11 OFFSET "+c_offset; */
		 SQL_1 = "SELECT pds.id, pds.name, SUM(sales.quantity*sales.price) AS amount "+
					"FROM (SELECT id, name FROM products "+
					"WHERE products.cid='"+ category +"' " +
					"ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+") AS pds "+
					"LEFT JOIN sales ON (sales.pid = pds.id) "+
					"GROUP BY pds.id, pds.name";
		 /* SQL_11 ="SELECT p.id, p.name, SUM(s.quantity*s.price) AS amount" +
					" FROM products p" +
					" LEFT JOIN sales s" + 
					" ON s.pid = p.id" +
					" WHERE p.cid='"+ category +"'" +
					" GROUP BY p.name,p.id" + 
					" ORDER BY p.name ASC" +
					" LIMIT 1 OFFSET "+next_c_offset; */
	}			
	
	int selector = 11;
	if (state != null && !state.equals("all") && !state.equals("null"))
		selector -= 1;
	if (age != null && !age.equals("all") && !age.equals("null"))
		selector -= 10;
	//System.out.println("selector: " + selector);
	//11 = no filters
	//10 - state filter
	//01 - age filter
	//00 - age and state filter
	
	//scope = states
	if(scope.equals("states"))
	{
		if(state == null || state.equals("all") || state.equals("all"))
		{
			//System.out.println("rows: states - no filters");
			/** pulls state names, no filters**/
			
		  /* SQL_2 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 21 OFFSET "+r_offset; */
			SQL_2 = "SELECT st.name, SUM(s.price*s.quantity) AS amount "+
					"FROM (SELECT name FROM states ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+") "+
					"AS st JOIN users u ON (st.name = u.state) "+
					"LEFT JOIN sales s ON (s.uid = u.id) "+
					"GROUP BY st.name";
			/* SQL_21 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 1 OFFSET "+next_r_offset; */
			
			//no category filter
			if(category == null || category.equals("all") || category.equals("null"))
			{
				//no age filter, no category filter
				if(age == null || age.equals("all") || age.equals("null"))
				{
					SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
							" FROM sales AS s, users AS u"+
							" WHERE u.state IN (SELECT name FROM states ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
							" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
							" AND s.uid = u.id"+
							" GROUP BY u.state, s.pid";
				}
				//age filter, no category filter 
				else
				{
					SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
							" FROM sales AS s, users AS u"+
							" WHERE u.state IN (SELECT name FROM states WHERE age BETWEEN "+age+" ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
							" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
							" AND s.uid = u.id"+
							" GROUP BY u.state, s.pid";
				}
			}
			//category filter
			else
			{
				//no age filter, category filter
				if(age == null || age.equals("all") || age.equals("null"))
				{
					SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
							" FROM sales AS s, users AS u"+
							" WHERE u.state IN (SELECT name FROM states ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
							" AND s.pid IN (SELECT id FROM products WHERE cid='"+category+"'ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
							" AND s.uid = u.id"+
							" GROUP BY u.state, s.pid";
				}
				//age filter, category filter
				else
				{
					SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
							" FROM sales AS s, users AS u"+
							" WHERE u.state IN (SELECT name FROM states WHERE age BETWEEN "+age+" ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
							" AND s.pid IN (SELECT id FROM products WHERE cid='"+category+"' ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
							" AND s.uid = u.id"+
							" GROUP BY u.state, s.pid";
				}
			}
			
		}
		else
		{
			//System.out.println("rows: states - state filters");
			/* pulls state names, state filter */
			SQL_2 ="SELECT u.state, SUM(s.price*s.quantity) AS amount"+
					" FROM users u"+
					" JOIN sales s ON (s.uid = u.id)"+
					" WHERE u.state = '"+state+"'"+
					" GROUP BY u.state";
			/* SQL_21 ="SELECT u.state, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s"+
					" ON s.uid = u.id"+
					" WHERE u.state='"+ state +"'" + 
					" GROUP BY u.state"+
					" ORDER BY u.state ASC"+
					" LIMIT 1 OFFSET "+next_r_offset; */
			if(category == null || category.equals("all") || category.equals("null"))
			{
				SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s, users AS u"+
						" WHERE u.state = '"+state+"'"+
						" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" AND s.uid = u.id"+
						" GROUP BY u.state, s.pid";
			}
			else
			{
				SQL_3="SELECT s.pid, u.state, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s, users AS u"+
						" WHERE u.state = '"+state+"'"+
						" AND s.pid IN (SELECT id FROM products WHERE cid='"+category+"' ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" AND s.uid = u.id"+
						" GROUP BY u.state, s.pid";
			}
		}
	}
	//scope = customers
	else
	{	
	
		if(selector == 11)
		{
			//System.out.println("rows: user - no filters");
			/** pulls user names, no filters**/
			/* SQL_2 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 21"+
					" OFFSET "+r_offset; */
			SQL_2 = "SELECT user_table.id, user_table.name, SUM(s.quantity*s.price) AS amount "+ 
					"FROM (SELECT name, id FROM users "+
					"ORDER BY name ASC LIMIT 20 OFFSET "+r_offset +") "+ 
					"AS user_table LEFT JOIN sales s "+ 
					"ON (s.uid = user_table.id) " + 
					"GROUP BY user_table.id, user_table.name ";
			
			/* SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset; */
			if(category == null || category.equals("all") || category.equals("null"))
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
			else
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products WHERE cid= '"+category+"'ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
			
		}
		else if(selector == 10) 
		{
			//System.out.println("rows: user - state filters");
			/* pulls user names, state filter */ 	
		    SQL_2 ="SELECT user_table.id, user_table.name, SUM(s.quantity*s.price) AS amount FROM (SELECT u.id, u.name "+
					" FROM users u " +
					" WHERE u.state='"+ state +"') AS user_table" + 
					" LEFT JOIN sales s ON s.uid = user_table.id"+
					" GROUP BY user_table.name,user_table.id"+
					" ORDER BY user_table.name ASC LIMIT 20"+
					" OFFSET "+r_offset;
			/* SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.state='"+ state +"'" + 
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset; */
			if(category == null || category.equals("all") || category.equals("null"))
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users WHERE state = '"+state+"' ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
			else
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users WHERE state = '"+state+"' ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products WHERE cid='"+category+"' ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
		}
		else if (selector == 01)
		{
			//System.out.println("rows: user - age filters");
			/* pulls user names, age filter */ 	
			SQL_2 ="SELECT user_table.id, user_table.name, SUM(s.quantity*s.price) AS amount"+
					" FROM (SELECT u.id, u.name"+ 
					" FROM users u WHERE u.age between "+age+" ORDER BY u.name ASC LIMIT 20 OFFSET " +r_offset+ ") AS user_table"+
					" LEFT JOIN sales s ON (s.uid = user_table.id)"+ 
					" GROUP BY user_table.name,user_table.id";
			/* SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.age between " + age +  
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset; */
			if(category == null || category.equals("all") || category.equals("null"))
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users WHERE age BETWEEN "+age+" ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
			else
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users WHERE age BETWEEN "+age+" ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products WHERE cid='"+category+"'ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
		}
		else if (selector == 00)
		{
			//System.out.println("rows: user - age and state filters");
			/* pulls user names, age and state filter */ 	
		   /* SQL_2 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.age between " + age + " AND u.state='"+ state +"'" +
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 21"+
					" OFFSET "+r_offset; */
			
		   SQL_2 = "SELECT user_table.id, user_table.name, SUM(s.quantity*s.price) AS amount"+ 
					" FROM (SELECT name, id FROM users u WHERE u.age between " + age + " AND u.state='"+ state +"'" +
					" ORDER BY name ASC LIMIT 20 OFFSET "+r_offset +")"+ 
					" AS user_table LEFT JOIN sales s"+ 
					" ON (s.uid = user_table.id)" + 
					" GROUP BY user_table.id, user_table.name";
					  
		   /* SQL_21 ="SELECT u.id, u.name, SUM(s.quantity*s.price) AS amount"+
					" FROM users u LEFT JOIN sales s ON s.uid = u.id"+
					" WHERE u.age between " + age + " AND u.state='"+ state +"'" +
					" GROUP BY u.name,u.id"+
					" ORDER BY u.name ASC LIMIT 1"+
					" OFFSET "+next_r_offset; */
		   
		   if(category == null || category.equals("all") || category.equals("null"))
			{
			   SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users WHERE age BETWEEN "+age+" AND state = '"+state+"' ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
			else
			{
				SQL_3 ="SELECT s.pid, s.uid, SUM(s.quantity*s.price) AS amount"+
						" FROM sales AS s"+
						" WHERE s.uid IN"+
						" (SELECT id FROM users WHERE age BETWEEN "+age+" AND state = '"+state+"' ORDER BY name ASC LIMIT 20 OFFSET "+r_offset+")"+
						" AND s.pid IN (SELECT id FROM products WHERE cid='"+category+"'ORDER BY name ASC LIMIT 10 OFFSET "+c_offset+")"+
						" GROUP BY s.uid, s.pid";
			}
		}
	}
	
	/* Determine if there are more rows and columns */
	//Statement stmt_11 =conn.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
	//ResultSet rs_11=stmt_11.executeQuery(SQL_11);
	boolean moreColumns = false;
	//rs.relative(11);
	if(true)
	{
		moreColumns = true;
	}
	//Statement stmt_21 =conn.createStatement();
	//ResultSet rs_21=stmt_21.executeQuery(SQL_21);
	boolean moreRows = false;
	//rs_2.relative(21);
	if(true)
	{
		moreRows = true;
	}
	
	

	
	//System.out.println("moreColumns: " + moreColumns);
	//System.out.println("moreRows: " + moreRows);
	
	long q1s, q1e, q2s, q2e, q3s, q3e;
	double elapsed1, elapsed2, elapsed3;
	
	q1s = System.nanoTime();
	rs=stmt.executeQuery(SQL_1);
	q1e = System.nanoTime();
	
	q2s = System.nanoTime();
	rs_2=stmt_2.executeQuery(SQL_2);
	q2e = System.nanoTime();
	
	q3s = System.nanoTime();
	rs_3=stmt_3.executeQuery(SQL_3);
	q3e = System.nanoTime();
	
	//state not id, many users in one state
//    out.println("product #:"+p_list.size()+"<br>state #:"+s_list.size()+"<p>");
	int i=0,j=0;	
	float amount=0;
%>


<table class="table">

<thead>
<tr>	
<th>
<a class="btn btn-default btn-primary" href='analytics.jsp' >Home</a>
</th>
		<%
			PreparedStatement c_pstmt = null;
			ResultSet c_rs = null;
			
			c_pstmt = conn.prepareStatement("SELECT * FROM categories LIMIT 10");
			c_rs = c_pstmt.executeQuery();
		%>
	
		<!-- For Choosing States vs. Customers Table -->
		<form class="navbar-form navbar-left" role="search" action="analytics.jsp" method="GET">
				<th colspan="2">
				<% String scope_select = "<select class='form-control' name='scope' "+ disabled +">" +
			        	"<option value='customers'>Customers</option>"+
						"<option value='states'>States</option>"+
			        "</select>";
			        scope_select = scope_select.replaceAll("value='"+scope+"'","value='"+scope+"' selected");%>
			        <%=scope_select %>
				</th><th colspan="2">
				<% String age_select= "<select class='form-control' name='ages' "+disabled+">"+
		        	"<option value='all'>All Ages</option>"+
		        	"<option value='12 and 18'>12-18</option>"+
		        	"<option value='18 and 45'>18-45</option>"+
		        	"<option value='45 and 65'>45-65</option>"+
		        	"<option value='65 and 150'>65-</option>"+
		        "</select>";
		        age_select = age_select.replaceAll("value='"+age+"'","value='"+age+"' selected");
		        %>
		        <%=age_select %>
		        </th><th colspan="2">
		        <select class="form-control" name="category" <%= disabled %>>
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
		        <% String s = "<select class='form-control' name='state'" + disabled + ">" +
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
				<% if(!disabled.equals("disabled")){
		        	%><input type="submit"  class="btn btn-default" /><%
		        }
		        %>
		        </th>
		   	</form> 
</tr>
<tr>
<%
String row_name = "";
			if(scope.equals("states")) {
				%>
				<th>STATE</th>
				<%
				if(!state.equals("null") && !state.equals("all"))  
				{
					System.out.print(state);
					row_name = "state";
				}
				else
				{
					row_name = "name";
				}
			}
			else{
				%>
				<th>USER</th>
				<%
				row_name = "name";
			}
			%>

<%
while(rs.next()){ %>
<th><strong><%= rs.getString("name") %></strong>
<br><span class="label label-success">$<%=rs.getInt("amount") %></span></th>
<%} %>


<%	
	if(moreColumns)
	{
		//out.print("<th><input type='submit' class='btn btn-primary' value='Next 10'></th>");
		int offset = Integer.valueOf(c_offset) + 10;
		%>
		<th>
		
	   	<form action="analytics.jsp" method="GET">
			<div class="form-group">
				<input type ="hidden" name=scope value="<%=scope%>">
				<input type ="hidden" name=r_offset value="<%=r_offset%>">
				<input type ="hidden" name=c_offset value="<%=offset%>">
				<input type ="hidden" name=state value="<%=state%>">
				<input type ="hidden" name=category value="<%=category%>">
				<input type ="hidden" name=ages value="<%=age%>">
			</div>
			<button type="submit" class="btn btn-primary">Next 10</button>
		</form>
		</th>
		<%
	}
%>
</tr>
</thead>

<%

rs_2.beforeFirst();
while(rs_2.next()){%>
	<tr>
	<th><%=rs_2.getString(row_name)%> 
	<br><span class="label label-success">$<%=rs_2.getInt("amount")%></span>
	</th>
	<% 
	rs.beforeFirst();
	while(rs.next())
	{
		boolean matched = false;
		rs_3.beforeFirst();
		while(rs_3.next() && !matched)
		{
			//System.out.print("r2.u.id: "+rs_2.getString(1) + "==" + rs_3.getString(2) + ":rs3.uid\t");
			//System.out.print("rs.p.id:"+rs.getInt(1) +"=="+ rs_3.getInt(1) + ":rs3.pid\n");
			if(rs.getInt("id") == rs_3.getInt("pid") && rs_2.getString(1).equals(rs_3.getString(2)))
			{	
				//System.out.println(rs_3.getInt("amount"));
				matched = true;
			%>
				<td class="alert alert-success">$<%=rs_3.getInt("amount")%></td>
			<%
			}
		}
		if(matched == false){
			%>
			<td>0</td>
		<%
		}
		//System.out.print(rs.getInt("id") +"=="+rs_3.getInt("pid") +"\t" +  rs_2.getInt("id") +"=="+ rs_3.getInt("uid") + "\n");
	}%>
	</tr>
<% }%>
<% 
	if(moreRows)
	{
		int offset = Integer.valueOf(r_offset) + 20;
		%>
		<tr><td colspan="1">
		
	   	<form action="analytics.jsp" method="GET">
			<div class="form-group">
				<input type ="hidden" name=scope value="<%=scope%>">
				<input type ="hidden" name=r_offset value="<%=offset%>">
				<input type ="hidden" name=c_offset value="<%=c_offset%>">
				<input type ="hidden" name=state value="<%=state%>">
				<input type ="hidden" name=category value="<%=category%>">
				<input type ="hidden" name=ages value="<%=age%>">
			</div>
			<button type="submit" class="btn btn-primary">Next 20</button>
		</form>
		</td>
		<td colspan="10">
		</td></tr>
		<%
	}
%>	
	
</table>
	
	
<%

//System.out.println("Report: ");

//System.out.println(SQL_1);
elapsed1 = (q1e - q1s) / 1000000.0;

//System.out.println("Elapsed 1: " + elapsed1);

//System.out.println();

System.out.println("Query 1 Time: " + elapsed1 + " ms");
out.println("<br>Query 1 Time: " + elapsed1 + " ms");
System.out.println();


//System.out.println(SQL_2);
elapsed2 = (q2e - q2s) / 1000000.0;
System.out.println("Query 2 Time: " + elapsed2 + " ms");
out.println("<br>Query 2 Time: " + elapsed2 + " ms");

//System.out.println("Elapsed 2: " + elapsed2);

System.out.println("Query 2 Time: " + elapsed2 + " ms");
out.println("<br>Query 2 Time: " + elapsed2 + " ms");


//System.out.println();

//System.out.println(SQL_3);
elapsed3 = (q3e - q3s) / 1000000.0;
System.out.println("Query 3 Time: " + elapsed3 + " ms");
out.println("<br>Query 3 Time: " + elapsed3 + " ms");

//System.out.println("Elapsed 3: " + elapsed3);

System.out.println("Query 3 Time: " + elapsed3 + " ms");
out.println("<br>Query 3 Time: " + elapsed3 + " ms");


//System.out.println();

long end = System.nanoTime();
double elapsed = (end - beg) / 1000000.0;

//System.out.println("Elapsed: "  + elapsed);
System.out.println(elapsed1 + "," + elapsed2 + "," + elapsed3 + "," + elapsed);

System.out.println("JSP time: "  + elapsed + " ms");
out.println("<br>JSP time: " + elapsed + " ms");
System.out.println();

}
catch(PSQLException e)
{
	//out.println("<font color='#ff0000'>Error.<br><a href=\"login.jsp\" target=\"_self\"><i>Go Back to Home Page.</i></a></font><br>");
  out.println(e.getMessage());
}
finally
{
	conn.close();
}


%>	
<<<<<<< HEAD
<t:footer/>
=======
<t:footer/>
>>>>>>> FETCH_HEAD

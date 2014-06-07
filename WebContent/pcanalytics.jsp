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
		sql1 = "SELECT * FROM products_total WHERE pid IN (SELECT pid FROM products WHERE cid = " + category + ") ORDER BY total DESC LIMIT 10";
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
				sql2 = "SELECT state, total FROM states_categories_total WHERE cid = " + category + " ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT spt.state, spt.total FROM state_products_total AS spt WHERE spt.pid IN (SELECT pt.pid FROM products_total AS pt WHERE pt.pid IN (SELECT p.pid FROM products AS p WHERE p.cid = " + category + ") ORDER BY pt.total DESC LIMIT 10)";
			}
			else
			{
				//category - on, state - on
				sql2 = "SELECT * FROM states_categories_total WHERE cid = " + category + " AND state = '" + state + "' ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT spt.state, spt.total FROM state_products_total AS spt WHERE spt.state = '" + state + "' AND spt.pid IN (SELECT pt.pid FROM products_total AS pt WHERE pt.pid IN (SELECT p.pid FROM products AS p WHERE p.cid = " + category + ") ORDER BY pt.total DESC LIMIT 10)";
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
				sql2 = "SELECT * FROM users_total AS ut WHERE ut.uid IN (SELECT u.uid FROM users AS u WHERE u.state = '" + state + "') ORDER BY ut.total DESC LIMIT 20";
				sql3 =  "SELECT * FROM users_products_total AS upt WHERE upt.uid IN (SELECT u.uid FROM users u WHERE u.state = '" + state + "') AND upt.pid IN (SELECT pt.pid FROM products_total AS pt ORDER BY pt.total DESC LIMIT 10)";
			}
		}
		else
		{
			if (state == null || state.equals("all") || state.equals("null"))
			{
				//category - on, state - off
				sql2 = "SELECT uid, total FROM users_categories_total ORDER BY total DESC LIMIT 20";
				sql3 = "SELECT * FROM users_products_total AS upt WHERE upt.pid IN (SELECT p.pid FROM products AS p WHERE p.cid = " + category + ") ORDER BY upt.total DESC LIMIT 10";
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
	<tr>
	<td></td>
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
	
	<%
	//prints out the user/state labels
	while(rs2.next()){
		%>
			<tr>
				<td>
				<strong><%=rs2.getString("name") %></strong>
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
						if(rs3.getInt("uid")==rs2.getInt("uid") && rs3.getInt("pid")==rs1.getInt("pid"))
						{
							match = true;
							%><td class="alert alert-success">$<%=rs3.getInt("total")%></td><%
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
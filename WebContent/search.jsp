<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>


<t:header title="Search Results" />
<div class="row">
<%
	String[] keywords = request.getParameter("keyword").split(" ");
	String prepared_keywords="%";
	for(String s : keywords)
		prepared_keywords += s+"%";
			
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try {
		
		Class.forName("org.postgresql.Driver");
		conn = DriverManager.getConnection(
				"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly
		
		if(!prepared_keywords.equals("%%"))
		{
			String category_id = request.getParameter("cid");
			System.out.println(category_id);
			if(category_id.equals("null"))
			{
				System.out.println("test1");
				pstmt = conn.prepareStatement("SELECT * FROM products WHERE name ILIKE ?;");
				pstmt.setString(1, prepared_keywords);
				rs = pstmt.executeQuery();
			}
			else
			{
				System.out.println("test2");
				pstmt = conn.prepareStatement("SELECT * FROM products_categories INNER JOIN products ON (products_categories.category_id=?) WHERE products_categories.product_id=products.product_id");
				int cid = Integer.parseInt(category_id);
				pstmt.setInt(1, cid);
				rs = pstmt.executeQuery();
			}
			
			if(rs.isBeforeFirst())
			{
				while(rs.next())
				{
					String rsname, rsdescription, rsimg;
					rsname = rs.getString("name");
					rsdescription = rs.getString("description");
					rsimg = rs.getString("img_src");
					if (rsimg == null)
						rsimg = "default";
					%>
					<t:product name="<%=rsname %>" description="<%=rsdescription %>" imgurl="<%=rsimg %>" />
					<%
				}
			}
			else
			{
				%>
				<t:message type="warning" message="No matches found." />
				<%
			}
		}
		else
		{
			%><t:message type="danger" message="Please enter a search keyword." /><%
		}
		
		/* Close everything  */
		// Close the ResultSet
		rs.close();
		//Close the Statement
		pstmt.close();
		// Close the Connection
		conn.close();
		
	}catch (SQLException e) {
        e.printStackTrace();
        out.println("<h1>" + e.getMessage() + "</h1>");
        
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
		out.println("<h1>org.postgresql.Driver Not Found</h1>");
	}
%>

</div>
<t:footer />
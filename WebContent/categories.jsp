<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.sql.*"%>

<%
	Connection conn = null;
	PreparedStatement pstmt = null;
	ResultSet rs = null;
	
	try{
		Class.forName("org.postgresql.Driver");
		
		conn = DriverManager.getConnection(
				"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
				"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs");
		Statement statement = conn.createStatement();
		pstmt = conn.prepareStatement("SELECT * FROM categories");
		rs = pstmt.executeQuery();

%>

<t:header title="Product Categories" />
<div class="container">
	<div class="row">
		<%
		String rsname,rsdescription,rsimg,rsid;
			while(rs.next())
			{ 
				rsname = rs.getString("name");
				rsdescription = rs.getString("description");
				rsimg = rs.getString("img_src");
				rsid = String.valueOf(rs.getInt("category_id"));
				if(rsimg == null)
					rsimg = "default";
			%>
		<t:category name="<%=rsname %>" description="<%=rsdescription %>" imgurl="<%=rsimg %>" id="<%=rsid %>"/>
			
		<%
			}
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
   	     	out.println("<h1>" + "Shit happened" + "</h1>");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			out.println("<h1>org.postgresql.Driver Not Found</h1>");
		}
		%>

	</div>
</div>
<t:footer />
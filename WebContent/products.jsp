<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@page import="java.sql.*"%>

<% String category = request.getParameter("category");%>

<t:header title="Product Categories"/>
	<div class="container">
		<div class="row">
			<t:product name="Necklace" description="Fine Jewelry. Show it off" imgurl="people"/>
			<t:product name="Mona Lisa" description="Fine Art. Good for the eyes" imgurl="abstract"/>
			<t:product name="Shirt" description="Hide that skin" imgurl="fashion"/>
			<t:product name="Ball" description="Get out, get active" imgurl="sports"/>
			<t:product name="Cellphone" description="Landline, but mobile" imgurl="technics"/>
			<%
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            
            try {
                // Registering Postgresql JDBC driver with the DriverManager
                Class.forName("org.postgresql.Driver");

                // Open a connection to the database using DriverManager
                conn = DriverManager.getConnection(
                    "jdbc:postgresql://localhost/cse135?" +
                    "user=postgres&password=postgres");
                
             // Create the statement
                Statement statement = conn.createStatement();

                // Use the created statement to SELECT
                // the student attributes FROM the Student table.
                rs = statement.executeQuery("SELECT * FROM students");
                %>
		
			<%
                // Iterate over the ResultSet
                while (rs.next()) {
            %>
			<t:product name="<%= rs.getString("name") %>" description="<%= rs.getString("description") %>" imgurl=<%= rs.getString("imgurl") %>/>
			<%
                }
			%>
			
            <%-- -------- Close Connection Code -------- --%>
            <%
                // Close the ResultSet
                rs.close();

                // Close the Statement
                statement.close();

                // Close the Connection
                conn.close();
            } catch (SQLException e) {

                // Wrap the SQL exception in a runtime exception to propagate
                // it upwards
                throw new RuntimeException(e);
            }
            finally {
                // Release resources in a finally block in reverse-order of
                // their creation

                if (rs != null) {
                    try {
                        rs.close();
                    } catch (SQLException e) { } // Ignore
                    rs = null;
                }
                if (pstmt != null) {
                    try {
                        pstmt.close();
                    } catch (SQLException e) { } // Ignore
                    pstmt = null;
                }
                if (conn != null) {
                    try {
                        conn.close();
                    } catch (SQLException e) { } // Ignore
                    conn = null;
                }
            }
            %>
		</div>
	</div>
<<t:footer />
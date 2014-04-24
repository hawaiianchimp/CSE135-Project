<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>


<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.*" %>
<%@page import="org.postgresql.*" %>
<%
	PrintWriter o = response.getWriter();

	int errors = 1;
	StringBuilder messages = new StringBuilder(); 
	String name = (request.getParameter("name") != null) ? request.getParameter("name"):"";
	System.out.print(name);
	String age = request.getParameter("age");
	String role = request.getParameter("role");
	String state = request.getParameter("state");
	String message_type = "success";
	String output = "";
	
	ArrayList<String> roles = new ArrayList<String>();
		roles.add("Owner");
		roles.add("Customer");
	
	ArrayList<String> states = new ArrayList<String>();
			states.add("AL");
			states.add("AK");
			states.add("AZ");
			states.add("AR");
			states.add("CA");
			states.add("CO");
			states.add("CT");
			states.add("DE");
			states.add("DC");
			states.add("FL");
			states.add("GA");
			states.add("HI");
			states.add("ID");
			states.add("IL");
			states.add("IN");
			states.add("IA");
			states.add("KS");
			states.add("KY");
			states.add("LA");
			states.add("ME");
			states.add("MD");
			states.add("MA");
			states.add("MI");
			states.add("MN");
			states.add("MS");
			states.add("MO");
			states.add("MT");
			states.add("NE");
			states.add("NV");
			states.add("NH");
			states.add("NJ");
			states.add("NM");
			states.add("NY");
			states.add("NC");
			states.add("ND");
			states.add("OH");
			states.add("OK");
			states.add("OR");
			states.add("PA");
			states.add("RI");
			states.add("SC");
			states.add("SD");
			states.add("TN");
			states.add("TX");
			states.add("UT");
			states.add("VT");
			states.add("VA");
			states.add("WA");
			states.add("WV");
			states.add("WI");
			states.add("WY");
			
			
	if (request.getQueryString() != null) 
	{
			
		if(name.length() < 2)
		{
			errors++;
			messages.append(", ").append("The name you entered is too short");
			message_type = "danger";
		}
		if(!states.contains(state))
		{
			errors++;
			messages.append(", ").append("Please select a state");
			message_type = "danger";
		}
		if(age.isEmpty())
		{
			errors++;
			messages.append(", ").append("Please enter an age");
			message_type = "danger";
		}
		else{
			if(Integer.parseInt(age) < 0)
			{
				errors++;
				messages.append(", ").append("Age must be a positive number");
				message_type = "danger";
			}
		}

		if(!roles.contains(role))
		{
			errors++;
			messages.append(", ").append("Please select a role");
			message_type = "danger";
		}
		
		if(errors == 1)
		{
			Connection conn = null;
			PreparedStatement pstmt = null;
			ResultSet rs = null;
			String sql = null;
			
			try {
				// Registering Postgresql JDBC driver with the DriverManager
				Class.forName("org.postgresql.Driver");

				// Open a connection to the database using DriverManager
				conn = DriverManager.getConnection(
						"jdbc:postgresql://ec2-23-21-185-168.compute-1.amazonaws.com:5432/ddbj4k4uieorq7?ssl=true&sslfactory=org.postgresql.ssl.NonValidatingFactory",
						"qwovydljafffgl", "cGdGZam7xcem_isgwfV3FQ_jxs"); //TODO: Change name of database accordingly
					
				// Create the statement
				
				Statement statement = conn.createStatement();
				// Insert the user into table users, only if it does not already exist
				sql =	"INSERT INTO users (name, role, age, state) " +
						"SELECT ?,?,?,? " +
						"WHERE NOT EXISTS (SELECT name FROM users WHERE name = ?);";
				System.out.print(sql + "\n");		   
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, name.trim());
				pstmt.setString(2, role.trim());
				pstmt.setInt(3, Integer.parseInt(age));
				pstmt.setString(4, state.trim());
				pstmt.setString(5, name.trim());
				
				//get the count for the number of rows that have been affected by the update 
				int count = pstmt.executeUpdate();
				//if no rows have been updated, that is because the name already exists.
				if(count == 0)
				{
					errors++;
					messages.append(", ").append("User " + name + " already exists, please try another name");
					message_type = "danger";
				}
				else
				{
					messages.append(", ").append("User " + name + " successfully registered");
					message_type = "success";
				}
				statement.close();
				conn.close();
		} catch (SQLException e) {
            e.printStackTrace();
            errors++;
            messages.append(", ").append("Error in SQL Statement");
            message_type = "danger";
            
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
			errors++;
			messages.append(", ").append("org.postgresql.Driver Not Found");
			message_type = "danger";
		}
	}
	output = messages.toString().substring(1);
}	
%>

<t:header title='New User Registration'/>

<% if(request.getQueryString() != null) {%>
<t:message type="<%= message_type%>" message="<%=output%>"/> 
<% } %>

<div class="row clearfix">
	<!-- Used for spacing -->
	<div class="col-md-4 column"></div>

	<!-- User registration  -->
	<div class="col-md-4 column">
		<h2>New User Registration</h2>
		<form action="register.jsp" method="GET">

			<!-- Username -->
			<div class="form-group">
				<label for="name">Name</label><input type="text" placeholder="Name"
					class="form-control" name="name" value="<%=name%>">
			</div>

			<!-- Role -->
			<div class="form-group">
				<label for="role">Role</label>
				<select class="form-control" name="role">
					<option>Role</option>
					<option>----</option>
					<option value="Owner">Owner</option>
					<option value="Customer">Customer</option>
				</select>
			</div>

			<!-- State -->
			<div class="form-group">
				<label for="age">Age</label><input type="number" placeholder="Age"
					class="form-control" name="age" value="<%=age%>">
			</div>
			<div class="form-group">
				<label for="state">State</label>
				<select class="form-control" name="state">
					<option>State</option>
					<option>-----</option>
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
			</div>

			<!-- Buttons -->
			<button type="submit" class="btn btn-primary">Submit</button>
			<a class="btn btn-default" href="/CSE135Project/index.html">Cancel</a>

		</form>
	</div>

	<!-- Used for spacing -->
	<div class="col-md-4 column"></div>
</div>
<t:footer/>
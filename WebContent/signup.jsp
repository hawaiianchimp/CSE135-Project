<%@page import="org.postgresql.util.PSQLException"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>


<%@page import="java.util.*"%>
<%@page import="java.io.*"%>
<%@page import="java.sql.*" %>
<%@page import="org.postgresql.*" %>

<t:header title='New User Registration'/>

<div class="row clearfix">
	<!-- Used for spacing -->
	<div class="col-md-4 column"></div>

	<!-- User registration  -->
	<div class="col-md-4 column">
		<h2>New User Registration</h2>
		<form action="signup_confirm.jsp" method="POST">

			<!-- Username -->
			<div class="form-group">
				<label for="username">Username</label><input type="text"
					class="form-control" name="username">
			</div>

			<!-- Role -->
			<div class="form-group">
				<label for="age">Role</label>
				<select class="form-control" name="role">
					<option value="Customer">Customer</option>
					<option value="Owner">Owner</option>
				</select>
			</div>

			<!-- Age -->
			<div class="form-group">
				<label for="age">Age</label><input type="number"
					class="form-control" name="age">
			</div>
			
			<!-- State -->
			<div class="form-group">
				<label for="age">State</label>
				<select class="form-control" name="state">
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
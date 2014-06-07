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
					<option value="customer">customer</option>
					<option value="owner">owner</option>
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
				<% String s = "<select class='form-control' name='state'>" +
			        	"<option>All States</option>" +
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
					" </select>"; %>
					<%=s %>
			</div>

			<!-- Buttons -->
			<button type="submit" class="btn btn-primary">Submit</button>
			<a class="btn btn-default" href="index.html">Cancel</a>

		</form>
	</div>

	<!-- Used for spacing -->
	<div class="col-md-4 column"></div>
</div>
<t:footer/>
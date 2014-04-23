<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<t:header title="Home Page"/>

    <!-- Main jumbotron for a primary marketing message or call to action -->
    <div class="jumbotron">
      <div class="container">
        <h1>CSE135 Project</h1>
        <p>This project is for creating a shopping cart application for an ecommerce site</p>
        <p><a href="categories.jsp" class="btn btn-primary btn-lg" role="button">Start &raquo;</a></p>
      </div>
    </div>
	
	<%
	String message = "Welcome, " + session.getAttribute("name") + "!";
	if(!message.equals("Welcome, null!"))
	{
	%>
		<h2>Welcome, <%= session.getAttribute("name") %>!</h2>
	<%
	}
	else
	{
	%>
		<h2>Welcome, Guest!</h2>
	<%
	}
	%>
		
		
    
<t:footer/>


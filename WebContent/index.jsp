<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<div id="bg">
	<img src="img/bg2.jpg" alt="">
</div>

<t:header title="" />
<% String role = ""+session.getAttribute("role"); %>

<h2 class="header_title">
	<span>CSE135 Shopping Project</span>
	<br>
	<span>This project is for creating a shopping cart</span>
	<br>
	<span>application for an ecommerce site.</span>
	<br>
	<br>
	
	<%if(role.equals("Owner")){%>
	<span><a href="categories.jsp">Go &raquo;</a></span>
	<%} %>
	
	<%if(role.equals("Customer")){%>
	<span><a href="products.jsp">Go &raquo;</a></span>
	<%} %>
	
	<%if(role.equals("null")){%>
	<span><a href="login.jsp">Go &raquo;</a></span>
	<%} %>
	
</h2>


<%-- 	
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
		 --%>


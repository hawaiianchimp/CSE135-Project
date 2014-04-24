<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<div id="bg">
	<img src="img/bg2.jpg" alt="">
</div>

<t:header title="Home Page" />
<!-- <container> 

<div class="row clearfix">
	<div class="col-md-12 column block">
		<div id="index">
			<h1 class="text-center">CSE135 Shopping Project</h1>
		</div>
		<p class="text-center text-muted centered">
			This project is for creating a shopping cart application for an ecommerce site.
		</p>
		<a href="categories.jsp" class="btn btn-primary btn-lg" role="button">Start
				&raquo;</a>
	</div>
</div>
</container> -->

<row>
<h2>
	<span> CSE135 Shopping Project<span class='spacer'></span><br>
		<span class='spacer'></span>This project is for creating a shopping cart
		<span class='spacer'></span><br><span class='spacer'></span>application for an ecommerce site.
		<span class='spacer'></span><br><br><span class='spacer'><span class='spacer'></span><a href="categories.jsp">Go &raquo;</a>
	</span>
</h2>
</row>


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


<t:footer />


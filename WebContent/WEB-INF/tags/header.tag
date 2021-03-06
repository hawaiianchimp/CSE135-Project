<%@tag description="default template" pageEncoding="UTF-8" %>
<%@attribute name="title" required="true" %>

<!--Welcome Message-->
<%
	String message = "Welcome, " + session.getAttribute("name") + "! ";
	if(session.getAttribute("name")==null)
	{
		message = "Welcome, Guest!";
	}
	String role = ""+session.getAttribute("role");
%>

<!DOCTYPE html>
<html>
<head><title>${title}</title>
<link rel="stylesheet"
      href="./css/bootstrap.min.css"
      type="text/css"/>
<link rel="stylesheet"
      href="./css/styles.css"
      type="text/css"/>

<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script src="./js/bootstrap.min.js"></script>

</head>
<body>
<nav class="navbar navbar-default" role="navigation">
  <div class="container-fluid">
    <!-- Brand and toggle get grouped for better mobile display -->
    <div class="navbar-header">
      <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#example-navbar-collapse-1">
        <span class="sr-only">Toggle navigation</span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
        <span class="icon-bar"></span>
      </button>
      <a class="navbar-brand" href="index.jsp">CSE135</a>
    </div>

    <!-- Collect the nav links, forms, and other content for toggling -->
    <div class="collapse navbar-collapse" id="example-navbar-collapse-1">
      <ul class="nav navbar-nav">
      <% if(role.equals("owner"))
      {
      %>
      <li><a href="categories.jsp">Categories</a></li>
      <% }
      else
      { %>
      <li><a href="product_browsing.jsp">Browse Products</a></li>
      <%} %>
      </ul>
      <form class="navbar-form navbar-left" role="login">
        <a class="btn btn-default" href="login.jsp" >Log In</a>
        <a class="btn btn-default" href="signup.jsp" >Signup</a>
      </form>
      <ul class="nav navbar-nav navbar-right">
      	<li><a href="#"><%=message %></a></li>
      	<% if(role.equals("customer")){ %>
        <li>
          <a href="buycart.jsp?action=view">Buy Shopping Cart</a>
        </li>
        <%} %>
      </ul>
    </div><!-- /.navbar-collapse -->
  </div><!-- /.container-fluid -->
</nav>
<div class="container">

<h1>${title}</h1>
	<hr>
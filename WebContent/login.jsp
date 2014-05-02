<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>

<t:header title='Login' />
<div class="row">
	<form class="navbar-form navbar-left" role="login" action="login_confirm.jsp" method="POST">
	  <div class="form-group">
	  	<input type="text" class="form-control" placeholder="Username" name="username">
	 	</div>
	  <button type="submit" class="btn btn-default">Log In</button>
	  <a class="btn btn-default" href="/CSE135Project/signup.jsp" >Signup</a>
	</form>
</div>
<t:footer />
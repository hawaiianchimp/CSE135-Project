<%@tag description="default template" pageEncoding="UTF-8" %>

<%@attribute name="name" required="true"%>
<%@attribute name="description" required="true"%>
<%@attribute name="imgurl" required="true"%>
<%@attribute name="cid" required="true"%>
<%@attribute name="label" required="true"%>

<div class="col-md-4">
	<div class="thumbnail">
		<img style="height:200px" src="img/categories/${imgurl}.png">
		<div class="caption">
			<h3>
				${name}
			</h3>
			<p>
				${description}
			</p>
			<% 
			String role = ""+session.getAttribute("role");
			//System.out.println("role= " + role);
			%>
			<% if(role.equals("Owner")){ %>
			<p>
				<% //System.out.println("inside if()"); %>
				<a class="btn btn-primary" href="products.jsp?cid=${cid}&category=${name}">${label}</a>
				<a class="btn btn-success" href="category.jsp?action=update&cid=${cid}">Update</a>
			</p>
			<%}else{ %>
			<p>
				<% //System.out.println("inside else()"); %>
				<a class="btn btn-primary" href="products.jsp?cid=${cid}&category=${name}">${label}</a>
			</p>
			<%} %>
			<% //System.out.println("outside if-else"); %>
		</div>
	</div>
</div>
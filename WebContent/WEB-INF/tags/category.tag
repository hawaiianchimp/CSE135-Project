<%@tag description="default template" pageEncoding="UTF-8" %>
<%@attribute name="name" required="true"%>
<%@attribute name="description" required="true"%>
<%@attribute name="imgurl" required="true"%>
<div class="col-md-4">
	<div class="thumbnail">
		<img src="img/${imgurl}.png">
		<div class="caption">
			<h3>
				${name}
			</h3>
			<p>
				${description}
			</p>
			<p>
				<a class="btn btn-primary" href="/CSE135Project/products.jsp?category=${name}">Browse Products</a>
			</p>
		</div>
	</div>
</div>
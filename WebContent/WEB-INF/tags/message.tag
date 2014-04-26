<%@tag description="Used for messages" pageEncoding="UTF-8"%>
<%@attribute name="message" required="true"%>
<%@attribute name="type" required="true"%>

<div class="col-md-12">
	<div class="alert alert-${type}">
		<p>${message}</p>
	</div>
</div>
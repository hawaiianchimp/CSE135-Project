<%@tag description="Used for messages" pageEncoding="UTF-8"%>
<%@attribute name="message" required="true"%>
<%@attribute name="type" required="true"%>

<div class="col-md-12 message">
	<div class="alert alert-${type}">
		<p>${message}</p>
	</div>
</div>
<script>
window.onload = function(){
	$(".message").hide();
	$(".message").slideDown("slow");
}
</script>
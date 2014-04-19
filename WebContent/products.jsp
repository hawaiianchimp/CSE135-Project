<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:template title="Products">
	<div class="container">
		<div class="row">
			<t:product name="Jewelry" description="Fine Jewelry. Show it off" imgurl="people"/>
			<t:product name="Art" description="Fine Art. Good for the eyes" imgurl="abstract"/>
			<t:product name="Clothes" description="Hide that skin" imgurl="fashion"/>
			<t:product name="Sports" description="Get out, get active" imgurl="sports"/>
		</div>
	</div>
</t:template>
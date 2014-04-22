<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>

<t:template title="Product Categories">
	<div class="container">
		<div class="row">
			<t:product name="Necklace" description="Fine Jewelry. Show it off" imgurl="people"/>
			<t:product name="Mona Lisa" description="Fine Art. Good for the eyes" imgurl="abstract"/>
			<t:product name="Shirt" description="Hide that skin" imgurl="fashion"/>
			<t:product name="Ball" description="Get out, get active" imgurl="sports"/>
			<t:product name="Cellphone" description="Landline, but mobile" imgurl="technics"/>
		</div>
	</div>
</t:template>
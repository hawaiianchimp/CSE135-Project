<%@tag description="default template" pageEncoding="UTF-8" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags" %>
<%@attribute name="title" required="true" %>

<t:base title="${title}">
<jsp:doBody/>		
<hr>
<div class="footer">
<p>CSE135 Project &copy; 2014</p>
</div>
</div>
</t:base>

<%@tag description="default template" pageEncoding="UTF-8" %>
<%@attribute name="title" required="true" %>
<!DOCTYPE html>
<html>
<head><title>${title}</title>
<link rel="stylesheet"
      href="./css/bootstrap.min.css"
      type="text/css"/>
</head>
<body>
<jsp:doBody/>
<script src="//code.jquery.com/jquery-1.11.0.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
<script src="./js/bootstrap.min.js"></script>


</body></html>
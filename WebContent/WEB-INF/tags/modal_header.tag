<%@tag description="Modal header" pageEncoding="UTF-8" %>
<%@attribute name="modal_title" required="true"%>
<%@attribute name="action" required="false"%>
<%@attribute name="method" required="false"%>

<div id="modal" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
        <h4 class="modal-title">${modal_title}</h4>
      </div>
      <div class="modal-body">
      <form class="form-horizontal" action="${action}" method="${method}">
      
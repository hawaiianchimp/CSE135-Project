<%@tag description="default template" pageEncoding="UTF-8" %>
<%@attribute name="label" required="true"%>
<%@attribute name="href" required="true"%>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
        <a href="${href}" type="button" class="btn btn-primary">${label}</a>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
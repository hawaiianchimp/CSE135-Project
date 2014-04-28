<%@tag description="Modal Footer" pageEncoding="UTF-8" %>
<%@attribute name="name" required="true"%>
      </div>
      <div class="modal-footer">
      	<a class="btn btn-default" href="categories.jsp">Close</a>
        <input name="submit" type="submit" value="${name}" class="btn btn-primary"/>
		</form>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<script>
$(document).ready(function() {
    $('#modal').modal('show');
});
</script>
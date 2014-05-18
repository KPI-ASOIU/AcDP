$(document).ready(function(){
  $.fn.editable.defaults.mode = 'inline';

  $(document).on("click", "#btn_remove_user", function () {
    $("#user_remove_path").attr('href', $(this).data('path'));
  });

  $(document).on("click", "#btn_remove_group", function () {
    $("#group_remove_path").attr('href', $(this).data('path'));
  });

  $(document).on("click", "#btn_remove_doctype", function () {
    $("#doctype_remove_path").attr('href', $(this).data('path'));
  });

  $.fn.editable.defaults.ajaxOptions = {type: "PATCH"};
  $('.doctype_edit').editable({
    inputclass: 'inputdoctype',
    success: function(response, newValue) {
        if(response.status == 'error') {
            return response.msg;
        } else {
          $('this').html(newValue);
        }
    }
  });

  $("tr[data-link]").on("click", function(e) {
    e.stopPropagation();
    window.location = this.getAttribute("data-link");
  });

  // documents
  $("#documents_new_file").change(function (){
      var fileName = $(this).val();
      $("#documents_new_doc_title").val(fileName.split('\\').pop());
  });

  $('.docs-title').mouseover(function(event) {
      $(this).find('.docs-navbar-tool').show();
  }).mouseout(function(event) {
      $(this).find('.docs-navbar-tool').hide();
  });

  $('.docs-navbar-tool').click(function(event){
      event.stopPropagation();
  });
});

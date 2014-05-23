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

  $(".j-admin-search-type-combo").on("click", "a", function(e){
      var $target = $(this);
      $(".j-admin-search-btn-text").text($target.text());
      $(".j-admin-search-type-input").val($target.data("search-type"));
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

  $('#documents-table').on('mouseover' ,'.docs-title', function(event) {
      $(this).find('.docs-navbar-tool').show();
  }).on('mouseout', '.docs-title', function(event) {
      $(this).find('.docs-navbar-tool').hide();
  }).on('click', '.docs-navbar-tool', function(event){
      event.stopPropagation();
  }).on('click', '#btn_remove_document', function(event) {
      $("#document_remove_path").attr('href', $(this).data('path'));
  });

  $('#collapseInfo').on('click', '#btn_remove_document', function(event) {
      $("#document_remove_path").attr('href', $(this).data('path'));
  });

  $('#documents-users-table').on('mouseover' ,'.docs-title', function(event) {
      $(this).find('.docs-navbar-tool').show();
  }).on('mouseout', '.docs-title', function(event) {
      $(this).find('.docs-navbar-tool').hide();
  });

  $(document).on('click', '.add-user-access-view', function() {
      $('#docs-add-access').val($(this).data('value'));
      $('#docs-add-access-type').val('0');
  });

  $(document).on('click', '.add-user-access-edit', function() {
      $('#docs-add-access').val($(this).data('value'));
      $('#docs-add-access-type').val('1');
  });

  $('.doc-title').editable({
    success: function(response, newValue) {
        if(response.status == 'error') {
            return response.msg;
        } else {
            $('#doc-title-' + response.doc_id).html(newValue);
        }
    }
  });

  $('.doc-tags').editable({
    inputclass: 'input-large',
    success: function(response, newValue) {
        if(response.status == 'error') return response.msg;
    },
    select2: {
      tags: [],
      width: '1000px',
      tokenSeparators: [",", " "]
      }
    });

  $('.doc-description').editable({
      rows: 3,
      inputclass: 'doc-tags-desc-input',
      success: function(response, newValue) {
          if(response.status == 'error') return response.msg;
      }
  });
});

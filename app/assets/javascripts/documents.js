$(document).ready(function(){

    // x-editable defaults
    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.ajaxOptions = {type: "PATCH"};
    $.fn.editable.defaults.emptytext = 'Не зазначено';

    $(document).on("click", "#remove_doctype", function (e) {
      e.preventDefault();
      $('.confirm_doctype_removal').modal('show');
      $("#doctype_remove_path").attr('href', $(this).data('path'));
    });

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

    $("#documents_new_file").change(function (){
        var fileName = $(this).val(),
            docsAddTitle = $("#documents_new_doc_title");

        if(docsAddTitle.val() == '') {
          $("#documents_new_doc_title").val(fileName.split('\\').pop());
        }
    });

    $('#documents-table').on('mouseover' ,'.docs-title', function(event) {
      $this = $(this);
      if($this.data('visible')) {
        $(this).find('.docs-navbar-tool').show();
      }
    }).on('mouseout', '.docs-title', function(event) {
        $(this).find('.docs-navbar-tool').hide();
    }).on('click', '.docs-navbar-tool', function(event){
        event.stopPropagation();
    }).on('click', '.btn_remove_document', function(event) {
        $("#document_remove_path").attr('href', $(this).data('path'));
    });

    $('#collapseInfo').on('click', '.btn_remove_document', function(event) {
        $("#document_remove_path").attr('href', $(this).data('path'));
    });

    $('#documents-users-table').on('mouseover' ,'.docs-title', function(event) {
      $this = $(this);
      if($this.data('visible')) {
        $this.find('.docs-navbar-tool').show();
      }
    }).on('mouseout', '.docs-title', function(event) {
        $(this).find('.docs-navbar-tool').hide();
    });

    $(document).on('click', '.add-doc-type', function() {
        $('#docs-add-types').val($(this).data('value'));
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
        inputclass: 'doc-title-input',
        success: function(response, newValue) {
            if(response.status == 'error') {
                return response.msg;
            } else {
                $('#doc-title-' + response.doc_id).html(newValue);
            }
        }
    });

    $('.doc-tags').editable({
        inputclass: 'doc-tags-input',
        success: function(response, newValue) {
            if(response.status == 'error') return response.msg;
        },
        select2: {
            tags: [],
            width: '100%',
            placeholder: 'Введіть теги',
            tokenSeparators: [",", " "]
        }
    });

    $('.doc-description').editable({
        rows: 3,
        inputclass: 'doc-desc-input',
        success: function(response, newValue) {
            if(response.status == 'error') return response.msg;
        }
    });

    if ($('.docs-move-document-btn').length > 0) {
      initDocsTree('dir', 'owned', false);

      $(document).on('click', '.docs-move-document-btn', function() {
        $('#doc-select-pk').val($(this).data('docpk'));
      });

      $('#modal-docs-list').on("select_node.jstree", function (node, selected, e) {
        $('#doc-select-target-pk').val(selected.selected[0]);
      });

      $('#modal-docs-list').on("deselect_node.jstree", function (node, selected, e) {
        if(selected.selected.length === 0)
          $('#doc-select-target-pk').val('root');
      });
    }

    $(document).on('ajax:success', '.attached-file', function(e, data, status, xhr) {
      if(data.status == 'ok') {
        var $fileSpan = $('#attached-file-' + data.doc);
        $fileSpan.closest('tr').prev().data('visible', false);
        $fileSpan.empty();
      }
    });

    $(document).on('ajax:success', '.form-change-file', function(e, data, status, xhr) {
      if(data.status == 'ok') {
        var $row = $(this).closest('tr').prev();
        $row.data('visible', true);
        $row.find('.docs-navbar-tool').attr('href', data.url);
        $('#attached-file-' + data.doc).html(data.title + ' <a class="btn btn-danger btn-xs attached-file" data-method="delete" data-remote="true" href="/documents/file/' + data.doc + '.json" rel="nofollow"><span class="glyphicon glyphicon-remove"></span></a>');
      }
    });
});

function initDocsTree(docdir, type, multiple) {
  var docs_list = $('#modal-docs-list');
  if(docs_list.length) {
      docs_list.jstree({ core: {
          multiple : multiple,
          data: {
              url : function (node) {
                  return '/documents/tree/' + docdir + '/' + type + '.json';
              },
              data : function (node) {
                  return { id: node.id };
              }
          }
      },
          plugins: multiple ? ['wholerow', 'checkbox'] : ['wholerow']
      });

      docs_list.on("loaded.jstree", function(event, data) {
          $('#doc-select-jsPanel').jScrollPane({autoReinitialise: true});
      });
  }
}

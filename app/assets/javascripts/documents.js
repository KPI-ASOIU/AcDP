$(document).ready(function(){

    // x-editable defaults
    $.fn.editable.defaults.mode = 'inline';
    $.fn.editable.defaults.ajaxOptions = {type: "PATCH"};
    $.fn.editable.defaults.emptytext = 'Не зазначено';

    $(document).on("click", "#btn_remove_doctype", function () {
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

    // document select tree
    var docs_list = $('#modal-docs-list');
    if(docs_list.length) {
        docs_list.jstree({ core: {
            data: {
                url : function (node) {
                    return '/documents/tree/owned.json';
                },
                data : function (node) {
                    return { id: node.id };
                }
            }
        },
            plugins: ['wholerow', 'checkbox']
        });

        docs_list.on("loaded.jstree", function(event, data) {
            $('#doc-select-jsPanel').jScrollPane({autoReinitialise: true});
        });
    }
});
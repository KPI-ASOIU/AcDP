$(document).ready(function(){
  $('#for_groups').prop('disabled', $('#news_post_for_roles').val() !== 'group').trigger("chosen:updated");
  $('#news_post_for_roles').change(function(){
      $('#for_groups').prop('disabled', $(this).val() !== 'group').trigger("chosen:updated");
  });

  $('#news_post_tags').select2({ tags: [] });

  $(document).on('click', '.btn_remove_news_post', function (e) {
    e.preventDefault();
    $('#modal_confirm_remove_news_post').modal('show');
    $('#news_post_remove_path').attr('href', $(this).data('path'));
  });

  $(document).on("click", "#news-add-document-btn", function(e) {
    e.preventDefault();
    $('#modal_select_document').modal('show');    
  });

  if ($('#news-add-document-btn').length > 0) {
    initDocsTree('all', 'owned', true);

    $('#docs-select-confirm').click(function() {
      ulElement = $('#news-attached-docs');
      ulElement.empty();
      var newsForm = $('form');
      $("input[name*='news_post[documents][]']").remove();

      $('#modal-docs-list').jstree(true).get_top_selected(true).forEach(function(el){
        ulElement.append('<li>' + el.text + '</li');
        $('<input>').attr({
          type: 'hidden',
          name: 'news_post[documents][]',
          value: el.id
        }).appendTo(newsForm);
      });
    });
  }
});

$(document).ready(function(){
    $.fn.wysihtml5.defaultOptions.locale = 'ua-UA';
    $.fn.wysihtml5.defaultOptions.color = true;

    $('#news_post_content').wysihtml5();

    $('#for_groups').prop('disabled', $('#news_post_for_roles').val() !== 'group').trigger("chosen:updated");
    $('#news_post_for_roles').change(function(){
        $('#for_groups').prop('disabled', $(this).val() !== 'group').trigger("chosen:updated");
    });

    $('#news_post_tags').select2({ tags: [] });

    $(document).on("click", "#btn_remove_news_post", function () {
        $("#news_post_remove_path").attr('href', $(this).data('path'));
    });
});
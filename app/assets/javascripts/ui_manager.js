$(document).ready(function(){
    $(document).on("click", "#btn_remove_user", function () {
        $("#user_remove_path").attr('href', $(this).data('path'));
    });

    $(document).on("click", "#btn_remove_group", function () {
        $("#group_remove_path").attr('href', $(this).data('path'));
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

    $("#first-conversation").on("click", function(){
        $("#conversation-open").modal();
    })

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

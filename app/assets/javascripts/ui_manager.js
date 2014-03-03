$(document).ready(function(){
    $(document).on("click", "#btn_remove_user", function () {
        $("#user_remove_path").attr('href', $(this).data('path'));
    });

    $(".j-admin-search-type-combo").on("click", "a", function(e){
        var $target = $(this);
        $(".j-admin-search-btn-text").text($target.text());
        $(".j-admin-search-type-input").val($target.data("search-type"));
    });
});


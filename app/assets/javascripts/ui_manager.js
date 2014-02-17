$(document).ready(function(){
    $(document).on("click", "#btn_remove_user", function () {
        $("#user_remove_path").attr('href', $(this).data('path'));
    });

    $(".j-admin-search-type-combo").on("click", function(e){
        var $target = $(e.target);
        $(".j-admin-search-btn-text").text($target.text());
        $(".j-admin-search-type-input").val($target.data("search-type"));
    });

    //enable chosen js
    $('.chosen-select').chosen({
		placeholder_text_multiple: 'Choose your role from list',
		no_results_text: 'No results matched',
		width: '100%'
	});
});


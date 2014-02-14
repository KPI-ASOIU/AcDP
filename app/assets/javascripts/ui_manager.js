//register ui events
$(document).ready(function(){
    $(document).on("click", "#btn_remove_user", function () {
        $("#user_remove_path").attr('href', $(this).data('path'));
    });
});

//enable chosen js
$('.chosen-select').chosen({ 
	placeholder_text_multiple: 'Choose your role from list',
	no_results_text: 'No results matched',
	width: '100%'
});
	

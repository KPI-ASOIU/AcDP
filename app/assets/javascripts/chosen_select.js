//enable chosen.js
$(document).ready(function() {
    $('#role .chosen-select').chosen({
        placeholder_text_multiple: "",
        no_results_text: "",
        width: '100%'
    });

    $('#conversationOpen #content .chosen-select').chosen({
        placeholder_text_multiple: " ",
        no_results_text: I18n.users.chosen_no_result,
        width: '100%'
    });

    $('#for_groups.chosen-select').chosen({
        placeholder_text_multiple: " ",
        no_results_text: I18n.news.group_chosen_no_result,
        width: '100%'
    });

    $('.chosen-select').chosen({
        disable_search: true,
        width: "100%"
    });
}());
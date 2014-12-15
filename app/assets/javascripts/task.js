$(document).ready(function() {
    $('#taskSearch #searchBtn').on('click', function(e) {
        $('#extendSearch').submit();
    });

    $('#taskSearch .chosen-select').chosen({
        placeholder_text_multiple: " ",
        no_results_text: I18n.util.chosen_no_result,
        width: '100%'
    });

    // this actually works for button "Add subtask"
    $('#taskActions').nestedFields();

    $('#submitSubTasks').on('click', function(e) {
        $('#subTasks').submit();
    });

    $("#extendSearch i.icon.remove").click(function() {
        !$(this).siblings('.chosen-select').val('').trigger('chosen:updated') || !$(this).siblings('input.form-control').val('');
    });
}());
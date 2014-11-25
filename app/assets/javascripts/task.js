$(document).ready(function() {
    $('#taskSearch #searchBtn').on('click', function(e) {
        $('#extendSearch').submit();
    });

    $('#taskSearch .chosen-select').chosen({
        placeholder_text_multiple: " ",
        no_results_text: "<%= I18n.t('util.chosen_no_result') %>",
        width: '100%'
    });

    // this actually works for button "Add subtask"
    $('#taskActions').nestedFields();

    $('#submitSubTasks').on('click', function(e) {
        $('#subTasks').submit();
    });

    $('#addDocumentToTask').on('click', function(e) {
        e.preventDefault();
        $('#docTaskUploadChoice').modal('show');
    });

    $('#pinDocFromWarehouse').on('click', function(e) {
        e.preventDefault();
        $('#addDocModal').modal('show');
    });

    $('#pinDocFromPC').on('click', function(e) {
        e.preventDefault();
        $('#docFromPCInput').trigger('click');
    });

    $('#docFromPCInput').on('change', function(e) {
        e.preventDefault();
        var control = e.target,
            title = document.querySelector('#taskDoc #title'),
            description = document.querySelector('#taskDoc #description'),
            today = new Date();
        title.value = control.files[0].name;
        title.setAttribute('data-value', control.files[0].name)
        description.setAttribute('data-value', 'Added ' +
            today.getDate() + '.' + today.getMonth() + '.' + today.getFullYear());
        $('#taskDoc').submit()
        $('#docTaskUploadChoice').modal('hide')
    })

    $("#extendSearch i.icon.remove").click(function() {
        !$(this).siblings('.chosen-select').val('').trigger('chosen:updated') || !$(this).siblings('input.form-control').val('');
    });
}());
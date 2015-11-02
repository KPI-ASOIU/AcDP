//= require ./checkbox
//= require ./datetimepicker
//= require ./pin_docs

$(document).ready(function() {
    $('#taskSearch #searchBtn').on('click', function(e) {
        $('#extendSearch').submit();
    });

    // this actually works for button "Add subtask"
    $('#taskActions').nestedFields();

    $('#submitSubTasks').on('click', function(e) {
        $('#subTasks').submit();
    });
}());
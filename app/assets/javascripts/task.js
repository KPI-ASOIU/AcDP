$(function() {
  $('#exec_start_date').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#exec_end_date').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#creation_start_date').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#creation_end_date').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#taskDate').datetimepicker({
    // TODO
    //  => make here default project language
    useCurrent: false,
    defultDate: '',
    language: 'uk'
  });

  $('#eventDate').datetimepicker({
    // TODO
    //  => make here default project language
    useCurrent: false,
    defultDate: '',
    language: 'uk'
  });

  $('FORM').nestedFields();
});

$(document).ready(function() {
  $('#searchBtn').on('click', function(e) { 
    $('#extendSearch').submit(); 
  });

  $('#collapseOne').on('shown.bs.collapse', function() {
    $('#searchBtn').removeClass('invisible')
  });

  $('#collapseOne').on('hide.bs.collapse', function() {
    $('#searchBtn').addClass('invisible')
  });

  $('.comments-form').jScrollPane({autoReinitialise: true});
});

$(".searchclear").click(function(){
    if((inp = $(this).siblings("input.form-control")).length != 0)
      inp.val('');
    else if((chosen = $(this).siblings(".chosen-container").find(".chosen-choices")).children().length > 1)
      chosen.children(":first").remove()
});

$('.popover').popover('show');

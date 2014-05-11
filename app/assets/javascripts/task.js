$(function() {
  $('#datetimepicker1').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    defultDate: '',
  	language: 'uk'
  });

  $('#datetimepicker2').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    defultDate: '',
  	language: 'uk'
  });

  $('#datetimepicker3').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    defultDate: '',
  	language: 'uk'
  });

  $('#datetimepicker4').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    defultDate: '',
  	language: 'uk'
  });

  $('FORM').nestedFields();
});


$(document).ready(function() {
  $('#searchBtn').on('click', function() { 
    $('#extendSearch').submit(); 
  });
  $('[href=#collapseOne]').on("click", function(){
    $("#searchBtn").toggleClass('invisible')
  });
});

$(".searchclear").click(function(){
    if((inp = $(this).siblings("input.form-control")).length != 0)
      inp.val('');
    else if((chosen = $(this).siblings(".chosen-container").find(".chosen-choices")).children().length > 1)
      chosen.children(":first").remove()
});

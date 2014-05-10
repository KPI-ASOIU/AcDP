$(function() {
  $('#datetimepicker1').datetimepicker({
  	// TODO
  	// 	=> make here default project language
  	useCurrent: false,
  	defaultDate: new Date(),
  	language: 'uk'
  });

  $('#datetimepicker2').datetimepicker({
  	// TODO
  	// 	=> make here default project language
  	useCurrent: false,
  	defaultDate: new Date(),
  	language: 'uk'
  });

  $('#datetimepicker3').datetimepicker({
  	// TODO
  	// 	=> make here default project language
  	useCurrent: false,
  	defaultDate: new Date(),
  	language: 'uk'
  });

  $('#datetimepicker4').datetimepicker({
  	// TODO
  	// 	=> make here default project language
  	useCurrent: false,
  	defaultDate: new Date(),
  	language: 'uk'
  });

  $('FORM').nestedFields();

  $('[href=#collapseOne]').on("click", function(){
  	$("#searchBtn").toggleClass('invisible')
  });
});


$(document).ready(function() {
  $('#searchBtn').on('click', function() { $('#extendSearch').submit(); });
});

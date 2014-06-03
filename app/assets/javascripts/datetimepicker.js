$(function() {
  function matchDateRegex(date) {
    return /[0-9]{2}\.[0-9]{2}\.[0-9]{4} [0-9]{2}\:[0-9]{2}/.test(date)
  }

  $('#startDate').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#endDate').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#creationStartDate').datetimepicker({
  	// TODO
  	// 	=> make here default project language
    useCurrent: false,
    defultDate: '',
  	language: 'uk'
  });

  $('#creationEndDate').datetimepicker({
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

  $('#taskDate').change(function() {
    if(!matchDateRegex($(this).val()))
      $(this).val('')
  });

  $('#eventDate').change(function() {
    if(!matchDateRegex($(this).val()))
      $(this).val('')
  });

  $('#startDate').change(function() {
    if(!matchDateRegex($(this).val()))
      $(this).val('')
  });

  $('#endDate').change(function() {
    if(!matchDateRegex($(this).val()))
      $(this).val('')
  });

  $('#creationStartDate').change(function() {
    if(!matchDateRegex($(this).val()))
      $(this).val('')
  });

  $('#creationEndDate').change(function() {
    if(!matchDateRegex($(this).val()))
      $(this).val('')
  });
});

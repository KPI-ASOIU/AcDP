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

  $('#submitSubTasks').on('click', function(e) { 
    $('#subTasks').submit(); 
  });
});

$(".searchclear").click(function(){
  !$(this).siblings('.chosen-select').val('').trigger('chosen:updated') || !$(this).siblings('input.form-control').val('');
});

$('.popover').popover('show');

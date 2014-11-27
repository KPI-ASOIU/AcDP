(function(){
	$('.regular-checkbox').click(function(){
    var checkboxes = $('.regular-checkbox'),
        total = checkboxes.length,
        checked = 0;
    $.each(checkboxes, function(index, value) {
      checked += value.checked;
    });
    $('.progress-bar').css('width', (checked*100/total).toFixed(2) + '%')
    $('.progress-bar').text((checked*100/total).toFixed(2) + '%')
  });
})();

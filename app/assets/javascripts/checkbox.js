(function() {
    $('.regular-checkbox').click(function() {
        var checkboxes = $('.regular-checkbox'),
            total = checkboxes.length,
            checked = 0;
        $.each(checkboxes, function(index, value) {
            checked += value.checked;
        });
        $('div.ui.progress .bar').css('width', (checked * 100 / total).toFixed(2) + '%')
        $('div.ui.progress .bar .ui.label').text((checked * 100 / total).toFixed(0) + '%')
    });

    $('.ui.checkbox').checkbox();
})();
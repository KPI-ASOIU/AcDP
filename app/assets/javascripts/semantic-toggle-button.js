semantic.button = {};

// ready event
semantic.button.ready = function() {
    // selector cache
    var
        $buttons = $('.ui.button'),
        $toggle = $('.ui.toggle.button'),
        $button = $('.ui.button').not($buttons).not($toggle),
        // alias
        handler = {
            activate: function() {
                $(this)
                    .toggleClass('active');
            }
        };

    $buttons.on('click', handler.activate);
    $toggle.on('click', handler.activate);

    $toggle
        .state({
            text: {
                inactive: I18n.events.cannot_visit,
                active: I18n.events.can_visit
            }
        });
};


// attach ready event
$(document)
    .ready(semantic.button.ready);
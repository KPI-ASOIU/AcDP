// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require semantic-ui
//= require_tree ../../../vendor/assets/javascripts/.
//= require rails-timeago
//= require locales/jquery.timeago.uk.js
//= require locales/jquery.timeago.ru.js
//= require moment
//= require bootstrap-datetimepicker
//= require bootstrap3-editable/bootstrap-editable
//= require moment/uk
//= require moment/ru
//= require chosen-jquery
//= require jquery.nested-fields
//= require jquery.remotipart
//= require select2
//= require select2_locale_uk
//= require jstree
//= require jquery.jscrollpane
//= require jquery.mousewheel
//= require websocket_rails/main
//= require jquery.countdown.js
//= require jquery.countdown-uk.js
//= require ckeditor/init
//= require masonry/jquery.masonry
//= require masonry/jquery.infinitescroll.min
//= require masonry/modernizr-transitions
//= require ./semantic-menu
//= require ./semantic-toggle-button

$(document).ready(function() {
    window.addComment = function(comment) {
        comment_box = $("#comments")
        $('#no_comments').fadeOut()
        $comment = $(comment.html)
        comment_box.append($comment.hide().fadeIn('slow'))
        $("time[data-time-ago]").timeago()
        // console.log(dispatcher.current_user)
        // console.log(comment.owner)
        if (dispatcher.current_user != comment.owner)
            $comment.find('div.actions').remove()
        $('#newComment').val('')-
        comment_box.scrollTop(comment_box[0].scrollHeight);
    };
    window.addMessage = function(message) {
        var dialogBox = $("#conversation"),
            messageBox = dialogBox.find('#messages');
        messageBox.append($(message.html).hide().fadeIn('slow'));
        messageBox.find('time[data-time-ago]').timeago();
        dialogBox.scrollTop(dialogBox[0].scrollHeight);
    };
    window.removeComment = function(comment) {
        $('#comment_' + comment.id).fadeOut()
    }

    $(document).on("click", "#btn_remove_user", function() {
        $("#user_remove_path").attr('href', $(this).data('path'));
    });

    $(document).on("click", "#btn_remove_group", function() {
        $("#group_remove_path").attr('href', $(this).data('path'));
    });

    $(".j-admin-search-type-combo").on("click", "a", function(e) {
        var $target = $(this);
        $(".j-admin-search-btn-text").text($target.text());
        $(".j-admin-search-type-input").val($target.data("search-type"));
    });

    $(document).on("click", "[data-link]", function(e) {
        if (e.target.tagName != 'A') {
            e.preventDefault();
            window.location = this.getAttribute("data-link");
        }
    });

    $('.ui.accordion').accordion();
    $('.ui.dropdown').dropdown();

    var comment_box = $('#comments')
    if (comment_box.length > 0)
        comment_box.scrollTop(comment_box[0].scrollHeight);

    $('textarea').on('keydown', function(event) {
        if ((event.keyCode || event.which) == 13 && !event.shiftKey) {
            event.preventDefault();
        }
    })

    $('textarea').keyup(function (event) {
        if ((event.keyCode || event.which) == 13) {
            if(event.shiftKey){
                event.stopPropagation();
            } else {
                $('form').submit();
            }
        }
    });
}());
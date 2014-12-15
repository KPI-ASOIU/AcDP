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
//= require_tree .

(function() {
    window.addComment = function(comment) {
        comment_box = $("#comments")
        $('#no_comments').fadeOut()
        $comment = $(comment.html)
        comment_box.append($comment.hide().fadeIn('slow'))
        $("time[data-time-ago]").timeago()
        console.log(dispatcher.current_user)
        console.log(comment.owner)
        if (dispatcher.current_user != comment.owner)
            $comment.find('div.actions').remove()
        $('#newComment').val('')
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
}());
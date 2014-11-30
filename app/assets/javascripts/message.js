function newMessage(message) {
    var dialogBox = $("#conversation"),
        messageBox = dialogBox.find('#messages');
    messageBox.append(message.html)
    messageBox.find('time[data-time-ago]').timeago()
    dialogBox.scrollTop(dialogBox[0].scrollHeight);
}

$(document).ready(function() {
    var dialog_box = $("#conversation");
    if (dialog_box.length) {
        dialog_box.scrollTop(dialog_box[0].scrollHeight);
    }

    $('.modalSend').click(function(e) {
        e.preventDefault();
        $("#conversationOpen").modal('show')
    });

    window.dispatcher.bind('messages.new_message', newMessage);
});
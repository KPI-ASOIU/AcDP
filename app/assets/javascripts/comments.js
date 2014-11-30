function newComment(comment) {
    $('#no_comments').fadeOut()
    $('#comments').prepend(comment.html)
    $("time[data-time-ago]").timeago()
    $('#comment_' + comment.id).hide().fadeIn('slow')
    $('#new-comment').val('')
}

$(document).ready(function() {
    window.dispatcher.bind('comments.new_comment', newComment);
});
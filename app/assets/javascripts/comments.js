function newComment(comment) {
	jQuery('#no_comments').fadeOut()
	jQuery('#comments .jspPane').prepend(comment.html)
	$("time[data-time-ago]").timeago()
	$('#comment_' + comment.id).hide().fadeIn('slow')
	$('.new-comment').val('')
}

$(document).ready(function(){
	window.dispatcher = new WebSocketRails(window.location.host + '/websocket');
	(function(){
		dispatcher.bind('comments.new_comment', newComment);
	})();
});

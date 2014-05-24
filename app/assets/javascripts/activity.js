$(document).ready(function() {
  $('.panel-activity').jScrollPane({autoReinitialise: true});
});

function newIssue(issue) {
	alert(issue)
}

$(document).ready(function(){
	window.activitySocket = new WebSocketRails(window.location.host + '/websocket_activity');
	(function(){
		activitySocket.bind('activity.new_issue', newIssue);
	})();
});

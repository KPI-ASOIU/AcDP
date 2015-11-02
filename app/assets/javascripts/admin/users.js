var setSearchWidth = function(){
	var calcWidth = $("#searchinput").parent().innerWidth() - 10 - $("#searchinput").prev().outerWidth() - $("#searchinput").next().outerWidth();
	$("#searchinput").css('width',calcWidth+'px');
};

$(document).ready(function(){
	setSearchWidth();
	$("#searchinput").prev().on("change",setSearchWidth);
	$('.ui.checkbox').checkbox();
});



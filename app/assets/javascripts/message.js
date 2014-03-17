$("#message-send").on("click", function(){ 
	$("#message").modal();    
}); 

$(document).ready(function(){
	dialog_box = $(".conversation");
	if (dialog_box.length)
		dialog_box.scrollTop(dialog_box[0].scrollHeight);
});
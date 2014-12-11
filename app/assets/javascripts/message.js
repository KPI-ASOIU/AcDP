$(document).ready(function(){
  var dialog_box = $(".conversation");
  if (dialog_box.length) {
    dialog_box.scrollTop(dialog_box[0].scrollHeight);
  }
});

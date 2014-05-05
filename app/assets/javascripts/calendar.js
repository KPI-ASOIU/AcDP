<<<<<<< HEAD
function hover (elem, color) {
  $(".calendar > tbody").children().each(function (index) {
    if (index > 0) {
      $(this).children()[$(elem).index()].style.background = color;
    };
  });
  $(elem).parent().each(function (index) {
    $(this).css("background", color);
  });
}

var sel_cell;

$(document).ready(function(){
  if (window.location.pathname.toString() == "/calendar"){
    $("td").click(function (e) {
      //put tasks from tasks[]
      var sel_month;
      if ($(this).hasClass("notmonth")){
        if (parseInt($(this).html())>15)
          sel_month = month>1 ? month-1 : 12;
        else  
          sel_month = month<12 ? month+1 : 1;   
      }
      else sel_month = month;
      date_id = parseInt($(this).html(),10)+''+sel_month;
      var list = '';
      if (tasks[date_id]){
        for (var i=0; i<tasks[date_id].length; i++)
          list+='<li><a href="'+tasks[date_id][i].link+'"><div class="name">'+tasks[date_id][i].name+'</div>'+tasks[date_id][i].time+'</a></li>';
        $('.list').html('<ul>'+list+'</ul>');
      }
      $(this).addClass("selected");
      if (sel_cell)
        $(sel_cell).removeClass("selected");
      sel_cell = this;
    })

    $("td").mouseenter(function (){
      hover(this,"rgba(128,128,128,0.1)");
    })
    $("td").mouseleave(function (){
      hover(this,"");
    })
    var now_month = (new Date()).getMonth()+1;
    if (month == now_month) $(".today").click();
    else $('td:contains("1")').not(".notmonth").first().click();
  }
});
=======
// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
>>>>>>> Create calendar template

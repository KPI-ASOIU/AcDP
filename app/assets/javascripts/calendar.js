// function hover (elem, color) {
//   $(".calendar > tbody").children().each(function (index) {
//     if (index > 0) {
//       $(this).children()[$(elem).index()].style.background = color;
//     };
//   });
//   $(elem).parent().each(function (index) {
//     $(this).css("background", color);
//   });
// }

// var sel_cell;

// $(document).ready(function(){
//   if (window.location.pathname.toString() == "/calendar"){
//     $("td").mouseenter(function (){
//       hover(this,"rgba(128,128,128,0.1)");
//     });
//     $("td").mouseleave(function (){
//       hover(this,"");
//     })
//   }
// });
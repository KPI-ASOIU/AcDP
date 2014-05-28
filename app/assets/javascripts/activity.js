$(document).ready(function() {
  $('.activity-filter a').click(function (e) {
	  e.preventDefault()
	  $('.activity-filter li').removeClass('active')
	  $(this.hash).load($(this).attr('data-url'), $(this).closest('li').addClass('active'));
	})
});

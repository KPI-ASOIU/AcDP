# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  # enable chosen js
  if($('.roles_combo').chosen)
    $('.roles_combo').chosen
      "disable_search": true
      width: '40%'

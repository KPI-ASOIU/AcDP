$ ->
  $(".message.closable .close.icon").on "click", ->
    $('.message.closable').fadeOut()
    false

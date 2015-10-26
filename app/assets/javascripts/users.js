// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

//= require ./activity
//= require ./chosen_select

$('#pickAvatar').on('click', function(e) {
    e.preventDefault();
    $('#avatarInput').trigger('click');
});
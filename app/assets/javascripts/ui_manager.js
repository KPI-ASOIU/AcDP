$(document).ready(function(){
    $(document).on("click", "#btn_remove_user", function () {
        $("#user_remove_path").attr('href', $(this).data('path'));
    });

    $('#admin_search_type_combo').click(function(event){
        var targ = event ? event.target : window.event.srcElement,
            doc = document;

        doc.getElementById('admin_search_button').firstChild.innerHTML = targ.innerHTML;
        doc.getElementById('admin_search_type').value = targ.getAttribute('data-id');
    });
});

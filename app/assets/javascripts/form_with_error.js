$(function(){
    $('.reveal-modal form').each(function(i, form) {
        $(form).on('ajax:success',function(e, data, status, xhr){
            location.reload();
        }).on('ajax:error',function(e, xhr, status, error){
            $(form).find(".error").append( xhr.responseText );
            $(form).parents(".reveal-modal").foundation('reveal', 'open');
        });
    });
});

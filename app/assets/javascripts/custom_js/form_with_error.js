$(function(){
    $('.reveal-modal form').each(function(i, form) {
        var errorSection = $(form).find(".display_error");
        $(form).on('ajax:success',function(e, data, status, xhr){
            errorSection.empty();
            location.reload();
        }).on('ajax:error',function(e, xhr, status, error){
            errorSection.empty();
            errorSection.append( xhr.responseText.split(", ").join(" <br> ") );
            $(form).parents(".reveal-modal").foundation('reveal', 'open');
        });
    });
});

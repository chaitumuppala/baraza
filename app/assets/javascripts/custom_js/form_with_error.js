$(function () {
  $('.reveal-modal form').each(function (i, form) {
    var errorSection = $(form).find(".display_error");
    var submitButton = $(form).find("input[type=submit]");
    var successFlash = $(form).parents(".reveal-modal").find(".success_flash");
    $(form).on('ajax:success', function (e, data, status, xhr) {
      submitButton.attr('disabled','disabled');
      errorSection.empty();
      successFlash.show();
      setTimeout(function () {
        location.reload();
      }, 1000);
    }).on('ajax:error', function (e, xhr, status, error) {
      errorSection.empty();
      errorSection.append(xhr.responseText.split(", ").join(" <br> "));
      $(form).parents(".reveal-modal").foundation('reveal', 'open');
    });
  });
});

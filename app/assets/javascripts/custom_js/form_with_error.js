$(function () {
  $('.reveal-modal form').each(function (i, form) {
    var errorSection = $(form).find(".display_error");
    var submitButton = $(form).find("input[type=submit]");
    var successFlash = $(form).parents(".reveal-modal").find(".success_flash");
    $(form).on('ajax:success', function (e, data, status, xhr) {
      errorSection.empty();
      successFlash.show();
      setTimeout(function () {
        location.reload();
      }, 1000);
    }).on('ajax:error', function (e, xhr, status, error) {
      errorSection.empty();
      submitButton.removeAttr('disabled');
      errorSection.append(xhr.responseText.split(", ").join(" <br> "));
      $(form).parents(".reveal-modal").foundation('reveal', 'open');
    });
  });

  $('form.no-double-click').each(function(i, form) {
    var submitButton = $(form).find("input[type=submit]");
    $(form).on('submit', function() {
      submitButton.attr('disabled','disabled');
    });
  });
});

$(function () {
  var ArticleTag = {
    init: function () {
      this.initTags();
      $("#category-select").select2();
      $("#summary").on("keyup", this.remainingCharCount);
      $(".articles form#article_form").on("submit", this.validateFile);
      $("#owner-select").select2();
    },

    initTags: function() {
      var formatValues = function(commaSeparatedValues) {
        var selections = [];
        _.forEach(commaSeparatedValues.split(","), function(tag, i){
          selections.push({id: tag, text: tag});
        });
        return selections;
      };

      $("#tags").select2({
        ajax: {
          url: "/tags",
          dataType: 'json',
          data: function (params) {
            return {
              q: params
            };
          },
          results: function (data) {
            return {results: formatValues(data.tags)};
          }
        },
        initSelection: function (element, callback) {
          callback(formatValues(element.val()));
        },
        multiple: true,
        minimumInputLength: 3,
        tokenSeparators: [","],
        tags: true,
        createSearchChoice: function (term, data) {
          if ($(data).filter(function () {
              return this.text.localeCompare(term) === 0;
            }).length === 0) {
            return {id: term, text: term};
          }
        }
      });
    },

    validateFile: function(e) {
      var form = $(e.target);
      var errorDiv = form.find("#error_explanation");
      errorDiv.find("ul").remove();
      var file = $("#file_upload")[0].files[0];
      var errorMessages = [];
      var validSize = 2000000;
      var validTypes = ["image/jpeg", "image/jpg", "image/png"];
      var formValid = true;

      var conditions = {
        titlePresence: function() {
          return $("input[name='article[title]']").val().length == 0;
        },

        titleLength: function() {
          return $("input[name='article[title]']").val().split(" ").length > 12;
        },

        categoryPresence: function() {
          return $('#category-select> option:selected').val().length == 0;
        },

        summaryPresence: function() {
          return $("#summary").val().length == 0;
        },

        summaryLength: function() {
          return $("#summary").val().length > 500;
        },

        imageSize: function() {
          return file && (file.size > validSize);
        },

        imageType: function() {
          return file && !_.contains(validTypes, file.type);
        },

        content: function() {
          return CKEDITOR.instances.article_content.getData().length == 0;
        }
       };

      var errorMessageMap = {
        titlePresence: "<li> Title can't be blank </li>",
        titleLength: "<li> Title can't be more than 12 words </li>",
        categoryPresence: "<li> Category can't be blank </li>",
        summaryPresence: "<li> Summary can't be blank </li>",
        summaryLength: "<li> Summary can't be more than 500 characters </li>",
        imageSize: "<li> Cover image can't be greater than 2MB </li>",
        imageType: "<li> Cover image content type is invalid </li>",
        content: "<li> Content can't be blank </li>"
      };

      _.forEach(errorMessageMap, function(message, field){
        if(conditions[field]()) {
          errorMessages.push(message);
        }
      });

      if(errorMessages.length > 0) {
        var list = errorDiv.append('<ul></ul>').find('ul');
        _.each(errorMessages, function(msg){
          list.append(msg);
        });
        e.preventDefault();
        formValid = false;
      }
      formValid;
    },

    remainingCharCount: function (evt) {
      var textContent = $(evt.target);
      var limit = 500;
      var len = textContent.val().length;
      if (len > limit) {
        textContent.val(textContent.val().substring(0, limit));
      } else {
        $('#char-count').text((limit - len) + " characters remaining");
      }
    }
  };
  loadPageSpecificJs("articles", ['new', 'edit', 'create', 'update', 'approve_form', 'approve'], ArticleTag.init.bind(ArticleTag));

  $("#file_upload").on("change", function(e) {
      jcropDestroy();
      var image = $("#coverImage");
      image.fadeIn("fast").attr('src',URL.createObjectURL(e.target.files[0]));
      setTimeout(function(){jcropInit(), 3000});
  });
});

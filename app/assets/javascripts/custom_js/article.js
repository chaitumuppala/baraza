$(function () {
  var ArticleTag = {
    init: function () {
      this.initTags();
      $("#category-select").select2();
      $(".articles form#article_form").on("submit", this.validateFile);
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
        title: function() {
          return $("input[name='article[title]']").val().length == 0;
        },

        category: function() {
          return $('#category-select> option:selected').length == 0;
        },

        summary: function() {
          return $("textarea[name='article[summary]']").val().length == 0;
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
        title: "<li> Title can't be blank </li>",
        category: "<li> Category can't be blank </li>",
        summary: "<li> Summary can't be blank </li>",
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
    }
  };
  loadPageSpecificJs("articles", ['new', 'edit', 'create', 'update', 'approve_form', 'approve'], ArticleTag.init.bind(ArticleTag));
});
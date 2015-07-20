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

      if(file && file.size > validSize) {
        errorMessages.push("<li> Cover image can't be greater than 2MB </li>");
      }
      if(file && !_.contains(validTypes, file.type)) {
        errorMessages.push("<li> Cover image content type is invalid </li>");
      }
      if(CKEDITOR.instances.article_content.getData().length == 0) {
        errorMessages.push("<li> Content can't be blank </li>");
      }
      if(errorMessages.length > 0) {
        debugger;
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
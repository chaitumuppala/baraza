$(function () {
  var ArticleTag = {
    init: function () {
      this.initTags();
      $("#category-select").select2();
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
    }
  };
  loadPageSpecificJs("articles", ['new', 'edit', 'create', 'update', 'approve_form', 'approve'], ArticleTag.init.bind(ArticleTag));
});
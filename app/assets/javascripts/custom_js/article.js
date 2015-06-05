$(function () {
  var ArticleTag = {
    init: function () {
      $.get("/tags", function (data) {
        $('#tags').tagit({
          availableTags: data
        });
      });
    }
  };
  loadPageSpecificJs("articles", ['new', 'edit'], ArticleTag.init);
});

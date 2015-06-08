$(function () {
  var ArticleTag = {
    init: function () {
      $.get("/tags", function (data) {
        $('#tags').tagit({
          availableTags: data
        });
      });
      $("#category-select").select2();
    }
  };
  loadPageSpecificJs("articles", ['new', 'edit'], ArticleTag.init);
});

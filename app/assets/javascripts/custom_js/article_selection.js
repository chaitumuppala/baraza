$(function () {
  var ArticleSelection = {
    init: function () {
      $("#admin-article .article").on('click', 'img', function (e) {
        ArticleSelection.selectArticle($(e.target));
      });

      $("#admin-article .article").on('click', '.article-overlay', function (e) {
        ArticleSelection.selectArticle($(e.target));
      });
    },

    selectArticle: function(element) {
      var article = element.parents(".article");
      var articleImage = article.find("img");
      var articleCheckBox = article.find("input[type=checkbox]");
      article.toggleClass("chosen");
      articleCheckBox.prop("checked", !articleCheckBox.prop("checked"));
    }
  };

  loadPageSpecificJs("newsletters", ['edit'], ArticleSelection.init.bind(ArticleSelection));
});
$(function () {
  var ArticleSelection = {
    init: function () {
      var that = this;
      $("#category-sortable").sortable({
        placeholder: "category-placeholder",
        stop: function(event, ui) {
          that.setCategoryOrder();
        }
      });

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
    },

    setCategoryOrder: function() {
      $("#category-sortable li").each(function(i, el){
        $(el).find(".cat_position").val($(el).index()+1);
      });
    }
  };

  loadPageSpecificJs("newsletters", ['edit'], ArticleSelection.init.bind(ArticleSelection));
});
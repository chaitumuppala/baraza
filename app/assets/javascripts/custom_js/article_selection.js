$(function () {
  var ArticleSelection = {
    init: function () {
      var that = this;
      $("#category-sortable").sortable({
        placeholder: "category-placeholder",
        cursor: "move",
        axis: "y",
        stop: function(event, ui) {
          that.setCategoryOrder();
        }
      });

      $("ul[id^=cat_]").sortable({
        placeholder: "article-placeholder",
        cursor: "move",
        stop: function(event, ui) {
          that.setArticleOrder();
        }
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
    },

    setArticleOrder: function() {
      $("li.article").each(function(i, el){
        $(el).find(".article_position").val($(el).index()+1);
      });
    }
  };

  loadPageSpecificJs("newsletters", ['edit'], ArticleSelection.init.bind(ArticleSelection));
});
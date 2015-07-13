$(function () {
  var ArticleHomePageOrder = {
    init: function () {
      var order, articleId, articleForm;
      $('a.choose-article').on('click', function() {
        event.preventDefault();
        order = $(event.target).data("order");
      });

      $("#chooseArticlesModal .article").on('click', function(){
        event.preventDefault();
        articleId = $(event.target).data("article-id");
        articleForm = $("#home-page .article-board #article-order-"+order);
        articleForm.find(".article-id").val(articleId);
        articleForm.attr("action", "/articles/"+articleId);
        articleForm.submit();
      });
    }
  };

  loadPageSpecificJs("articles", ['home_page_order'], ArticleHomePageOrder.init.bind(ArticleHomePageOrder));
});
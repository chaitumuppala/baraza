$(function () {
  var ArticleHomePageOrder = {
    init: function () {
      var order, articleId, articleForm;
      $('a.choose-article').on('click', function(e) {
        e.preventDefault();
        order = $(e.target).data("order");
      });

      $("#chooseArticlesModal").on('click', '.article', function(e){
        e.preventDefault();
        articleId = $(e.target).data("article-id");
        articleForm = $("#home-page .article-board #article-order-"+order);
        articleForm.find(".article-id").val(articleId);
        articleForm.attr("action", "/articles/"+articleId+"/home_page_order_update");
        articleForm.submit();
      });
    }
  };

  loadPageSpecificJs("home", ['index'], ArticleHomePageOrder.init.bind(ArticleHomePageOrder));
});
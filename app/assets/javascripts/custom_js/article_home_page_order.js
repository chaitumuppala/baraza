$(function () {
  var ArticleHomePageOrder = {
    init: function () {
      var order, articleId, articleForm;
      $('.choose-article a').on('click', function(e) {
        e.preventDefault();
        order = $(e.target).data("order");
      });
      $(document).on('open.fndtn.reveal', '[data-reveal]', function () {
        var modal = $(this);
        modal.find("h4").text("Change Block "+ order +" article");
      });
      $("#chooseArticlesModal").on('click', '.article', function(e){
        e.preventDefault();
        articleId = $(e.target).data("article-id");
        articleForm = $("#home-page #article-order-"+order);
        articleForm.find(".article-id").val(articleId);
        articleForm.attr("action", "/articles/"+articleId+"/home_page_order_update");
        articleForm.submit();
      });
    }
  };

  loadPageSpecificJs("home", ['index'], ArticleHomePageOrder.init.bind(ArticleHomePageOrder));
});
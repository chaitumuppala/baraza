$(function () {
  var ArticleComment = {
    init: function () {
      var shortname_div = $("#disqus_shortname_for_comments");
      var disqus_shortname = shortname_div.data('sname');
      /* * * DON'T EDIT BELOW THIS LINE * * */
      (function () {
        var dsq = document.createElement('script');
        dsq.type = 'text/javascript';
        dsq.async = true;
        dsq.src = '//' + disqus_shortname + '.disqus.com/embed.js';
        (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(dsq);
      })();
    }
  };
  loadPageSpecificJs("articles", ['show'], ArticleComment.init.bind(ArticleComment));
});
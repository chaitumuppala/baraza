var ArticleTag = {
  init: function () {
    $('#tags').tagsInput();
  }
};
loadPageSpecificJs("articles", ['new', 'edit'], ArticleTag.init);
class ArticleIndexJob < Struct.new(:article_id)
  def perform
    Article.find(article_id).index_current_document_values
  end
end
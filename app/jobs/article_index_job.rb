# TODO: Vijay: Is a struct more efficient than a class or a module?
class ArticleIndexJob < Struct.new(:article_id)
  def perform
    Article.find(article_id).index_current_document_values
  end
end

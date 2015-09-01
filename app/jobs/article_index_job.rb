# TODO: Vijay: Is a struct more efficient than a class or a module? - mainly to reduce effort in initialising. I have shown below how it would have been with class
# class ArticleIndexJob
# attr_accessor :id

# def initalize(id)
#   @id = id
# end
# def perform
#   Article.find(article_id).index_current_document_values
# end
# end

class ArticleIndexJob < Struct.new(:article_id)
  def perform
    Article.find(article_id).index_current_document_values
  end
end

class ArticleTag < ActiveRecord::Base
  belongs_to :article, inverse_of: false
  belongs_to :tag
  after_destroy { |at| at.article.update_index_of_doc}
  after_create { |at| at.article.update_index_of_doc}
end

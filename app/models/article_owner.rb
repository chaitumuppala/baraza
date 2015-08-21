class ArticleOwner < ActiveRecord::Base
  belongs_to :article
  belongs_to :owner, polymorphic: true
end

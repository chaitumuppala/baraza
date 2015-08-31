# TODO: Vijay: Where is the spec for this? Ideally should use shoulda for the most concise spec files - same in all other classes
class ArticleOwner < ActiveRecord::Base
  belongs_to :article
  belongs_to :owner, polymorphic: true
end

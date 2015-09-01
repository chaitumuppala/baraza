# == Schema Information
#
# Table name: article_owners
#
#  id         :integer          not null, primary key
#  article_id :integer
#  owner_id   :integer
#  owner_type :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_article_owners_on_article_id  (article_id)
#

# TODO: Vijay: Is this join table model really required as a first-class model? - yes bcoz its a polymorphic join model and has a type column that needs to be set
class ArticleOwner < ActiveRecord::Base
  belongs_to :article
  belongs_to :owner, polymorphic: true
end

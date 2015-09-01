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

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class ArticleOwner < ActiveRecord::Base
  belongs_to :article
  belongs_to :owner, polymorphic: true
end

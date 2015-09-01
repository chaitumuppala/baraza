# == Schema Information
#
# Table name: article_tags
#
#  id         :integer          not null, primary key
#  article_id :integer
#  tag_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_article_tags_on_article_id  (article_id)
#  index_article_tags_on_tag_id      (tag_id)
#

# TODO: Vijay: Is this join table model really required as a first-class model?
class ArticleTag < ActiveRecord::Base
  belongs_to :article
  belongs_to :tag
end

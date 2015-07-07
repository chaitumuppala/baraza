class Category < ActiveRecord::Base
  has_many :article_categories
  has_many :articles, -> { order('-articles.position_in_newsletter DESC', 'newsletter_id DESC') }, through: :article_categories
end

class Category < ActiveRecord::Base
  has_many :article_categories
  has_many :articles, -> { order('articles.position_in_newsletter ASC') }, through: :article_categories
end

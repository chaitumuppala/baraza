class Newsletter < ActiveRecord::Base
  has_many :articles
  has_many :category_newsletters
  has_many :categories, through: :category_newsletters
  accepts_nested_attributes_for :articles
  accepts_nested_attributes_for :category_newsletters
  after_create do
    categories << Category.all
  end

  module Status
    DRAFT = "draft"
    APPROVED = "approved"
    PUBLISHED = "published"
  end

  def eligible_articles_by_category
    article_list = Set.new
    categories.inject({}) do |article_hash, category|
      articles_for_category = category.articles.where("newsletter_id = ? or newsletter_id IS NULL", id).to_set
      article_hash[category] = articles_for_category - article_list
      article_list += articles_for_category
      article_hash
    end
  end
end

class Newsletter < ActiveRecord::Base
  has_many :articles
  accepts_nested_attributes_for :articles

  module Status
    DRAFT = "draft"
    APPROVED = "approved"
    PUBLISHED = "published"
  end

  def eligible_articles_by_category
    article_list = Set.new
    Category.all.inject({}) do |article_hash, category|
      articles_for_category = category.articles.where("newsletter_id = ? or newsletter_id IS NULL", id).to_set
      article_hash[category.name] = articles_for_category - article_list
      article_list += articles_for_category
      article_hash
    end
  end
end

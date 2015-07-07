class Newsletter < ActiveRecord::Base
  has_many :articles
  has_many :category_newsletters
  has_many :categories, through: :category_newsletters
  accepts_nested_attributes_for :articles
  accepts_nested_attributes_for :category_newsletters
  validates_presence_of :name
  after_create do
    categories << Category.all
  end

  module Status
    DRAFT = "draft"
    APPROVED = "approved"
    PUBLISHED = "published"
  end

  def eligible_articles_by_category
    group_articles_by_category { |category| category.articles.where("newsletter_id = ? or newsletter_id IS NULL", id).to_set }
  end

  def articles_by_category
    group_articles_by_category { |category| category.articles.where("newsletter_id = ?", id).to_set }
  end

  private
  def group_articles_by_category
    article_list = Set.new
    categories.inject({}) do |article_hash, category|
      articles_for_category = yield(category) if block_given?
      article_hash[category] = articles_for_category - article_list
      article_list += articles_for_category
      article_hash
    end
  end
end

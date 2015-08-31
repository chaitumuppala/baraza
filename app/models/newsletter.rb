class Newsletter < ActiveRecord::Base
  has_many :articles
  has_many :category_newsletters
  has_many :categories, through: :category_newsletters
  accepts_nested_attributes_for :articles
  accepts_nested_attributes_for :category_newsletters
  validates_presence_of :name
  before_validation :has_no_draft?, on: :create
  # TODO: Vijay: Is it better to do this as a before_save on create hook?
  after_create do
    categories << Category.all
  end
  before_update :set_date_published, if: -> {status_changed? && status == Status::PUBLISHED}

  module Status
    DRAFT = "draft"
    PUBLISHED = "published"
  end

  def eligible_articles_by_category
    # TODO: Vijay: Use arel instead of hardcoding the plain sql - other places as well
    group_articles_by_category { |category| category.articles.where(status: Article::Status::PUBLISHED).where("newsletter_id = ? or newsletter_id IS NULL", id).to_set }
  end

  def associated_articles_by_category
    group_articles_by_category { |category| category.articles.where(status: Article::Status::PUBLISHED).where("newsletter_id = ?", id).to_set }
  end

  def has_no_draft?
    Newsletter.where(status: Status::DRAFT).blank?
  end

  private
  def group_articles_by_category
    categories.inject({}) do |article_hash, category|
      articles_for_category = yield(category) if block_given?
      article_hash[category] = articles_for_category if articles_for_category.present?
      article_hash
    end
  end

  def set_date_published
    # TODO: Vijay: Use Time.current instead of DateTime.now / Time.zone.now - all other occurrences as well
    self.date_published = DateTime.now
  end
end

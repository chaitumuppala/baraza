# == Schema Information
#
# Table name: newsletters
#
#  id             :integer          not null, primary key
#  name           :string(255)
#  status         :string(255)      default("draft")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  date_published :datetime
#

class Newsletter < ActiveRecord::Base
  has_many :articles
  has_many :category_newsletters
  has_many :categories, through: :category_newsletters

  accepts_nested_attributes_for :articles
  accepts_nested_attributes_for :category_newsletters

  validates_presence_of :name
  before_validation :has_no_draft?, on: :create

  after_create do
    categories << Category.all
  end
  before_update :set_date_published, if: -> {status_changed? && status == Newsletter::Status::PUBLISHED}

  module Status
    DRAFT = "draft".freeze
    PUBLISHED = "published".freeze
  end

  def eligible_articles_by_category
    # TODO: Vijay: Remvoe duplication between this method and the next
    group_articles_by_category { |category| category.articles.where(status: Article::Status::PUBLISHED).where(newsletter_id: [id, nil]).to_set }
  end

  def associated_articles_by_category
    # TODO: Vijay: Remvoe duplication between this method and the previous
    group_articles_by_category { |category| category.articles.where(status: Article::Status::PUBLISHED).where(newsletter_id: id).to_set }
  end

  def has_no_draft?
    !Newsletter.exists?(status: Newsletter::Status::DRAFT)
  end

  private
  def group_articles_by_category
    categories.inject({}) do |article_hash, category|
      articles_for_category = yield(category)
      article_hash[category] = articles_for_category if articles_for_category.present?
      article_hash
    end
  end

  def set_date_published
    self.date_published = Time.current
  end
end

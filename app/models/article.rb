class Article < ActiveRecord::Base
  belongs_to :creator, class_name: User.name
  has_many :article_owners
  has_many :system_users, through: :article_owners, source: :owner, source_type: Author.name
  has_many :users, through: :article_owners, source: :owner, source_type: User.name
  has_one :cover_image, -> { where(preview_image: false) }
  has_and_belongs_to_many :tags
  belongs_to :category

  acts_as_taggable_on :tags

  accepts_nested_attributes_for :cover_image

  validates :title, :content, :category, :summary, presence: true
  validates :home_page_order, uniqueness: { case_sensitive: false }, allow_blank: true

  before_save :set_date_published, if: -> { status_changed? && status == Article::Status::PUBLISHED }

  module Status
    DRAFT = 'draft'.freeze
    SUBMITTED_FOR_APPROVAL = 'submitted for approval'.freeze
    PUBLISHED = 'published'.freeze
  end

  def owners
    system_users + users
  end

  def cover_image_url(style = :original)
    ci = cover_image.blank? ? build_cover_image : cover_image
    ci.cover_photo.url(style)
  end

  def principal_author
    owners.first
  end

  private

  def set_date_published
    self.date_published = Time.current
  end
end

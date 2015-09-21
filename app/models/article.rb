# == Schema Information
#
# Table name: articles
#
#  id                     :integer          not null, primary key
#  title                  :string(255)      not null
#  content                :text             not null
#  creator_id             :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  top_story              :boolean
#  newsletter_id          :integer
#  position_in_newsletter :integer
#  status                 :string(255)      default("draft")
#  author_content         :text
#  summary                :text             not null
#  home_page_order        :integer
#  date_published         :datetime
#  category_id            :integer          not null
#
# Indexes
#
#  index_articles_on_category_id  (category_id)
#  index_articles_on_creator_id   (creator_id)
#

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
    DRAFT = 'draft'
    SUBMITTED_FOR_APPROVAL = 'submitted for approval'
    PUBLISHED = 'published'
    PREVIEW = 'preview'
  end

  def owners
    system_users + users
  end

  def cover_image_url(style = :original)
    ci = cover_image.blank? ? build_cover_image : cover_image
    ci.cover_photo.url(style)
  end

  def principal_author
    if owners.count >0
      owners.first
    else
        users.where("id = ?", creator_id).first
    end
  end

  private

  def set_date_published
    self.date_published = Time.current
  end
end

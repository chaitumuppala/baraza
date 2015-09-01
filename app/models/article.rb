# == Schema Information
#
# Table name: articles
#
#  id                     :integer          not null, primary key
#  title                  :string(255)      not null
#  content                :text(65535)      not null
#  creator_id             :integer
#  top_story              :boolean
#  newsletter_id          :integer
#  position_in_newsletter :integer
#  status                 :string(255)      default("draft")
#  author_content         :text(65535)
#  summary                :text(65535)      not null
#  home_page_order        :integer
#  date_published         :datetime
#  category_id            :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_articles_on_category_id  (category_id)
#  index_articles_on_creator_id   (creator_id)
#

# TODO: Vijay: Data integrity mandates that the db has constraints like non-nullable column, foreign key constraints, etc
class Article < ActiveRecord::Base
  include Elasticsearch::Model

  belongs_to :creator, class_name: User.name
  has_many :article_owners
  has_many :system_users, through: :article_owners, source: :owner, source_type: Author.name
  has_many :users, through: :article_owners, source: :owner, source_type: User.name
  has_one :cover_image, -> { where(preview_image: false) }
  # has_many :article_tags
  has_and_belongs_to_many :tags
  belongs_to :category

  accepts_nested_attributes_for :cover_image

  attr_accessor :tag_list

  validates :title, :content, :category, :summary, presence: true
  validates :home_page_order, uniqueness: { case_sensitive: false }, allow_blank: true

  index_name    "articles_#{Rails.env}"
  settings do
    mapping do
      indexes :title, analyzer: 'snowball'.freeze
      indexes :content, analyzer: 'snowball'.freeze
      indexes :status, index: 'not_analyzed'.freeze
      indexes :tags do
        indexes :name, index: 'not_analyzed'.freeze
      end
      indexes :category do
        indexes :name, index: 'not_analyzed'.freeze
      end
    end
  end

  before_save :set_date_published, if: -> {status_changed? && status == Article::Status::PUBLISHED}
  after_save do
    Delayed::Job.enqueue(ArticleIndexJob.new(id))
  end

  module Status
    DRAFT = "draft".freeze
    SUBMITTED_FOR_APPROVAL = "submitted for approval".freeze
    PUBLISHED = "published".freeze
  end

  def owners
    system_users + users
  end

  def index_current_document_values
    __elasticsearch__.index_document
  end

  def tag_list
    tags.collect(&:name).join(','.freeze)
  end

  def tag_list=(tag_names_string)
    tag_names_array = tag_names_string.split(','.freeze)
    tags.destroy_all
    tags << tag_names_array.collect { |name| Tag.find_or_initialize_by(name: name) }
  end

  def as_indexed_json(options={})
    self.as_json(
        only: [:id, :title, :content, :status, :date_published],
        include: {tags: {only: :name},
                  category: {only: :name}}
    )
  end

  def self.search_by_all(search_text)
    query = {
        query: {
            match: {
                _all: search_text
            }
        },
        filter: {
            and: [
                {
                    term: {
                        status: Article::Status::PUBLISHED
                    }
                }
            ]
        },
        sort: {date_published: {order: :desc}}
    }.to_json
    response = Article.__elasticsearch__.search query
    response.records.to_a
  end

  [:tags, :category].each do |criteria|
    define_singleton_method "search_by_#{criteria}" do |search_text|
      query = {
          query: {
              filtered: {
                  query: {
                      match_all: {}
                  },
                  filter: {
                      bool: {
                          must: [
                              {
                                  term: {:"#{criteria}.name" => search_text}
                              },
                              {
                                  term: {status: Article::Status::PUBLISHED}
                              }
                          ]
                      }
                  }
              }
          },
          sort: {date_published: {order: :desc}}
      }.to_json
      response = Article.__elasticsearch__.search query
      response.records.to_a
    end
  end

  def cover_image_url(style=:original)
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

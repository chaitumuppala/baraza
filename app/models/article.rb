class Article < ActiveRecord::Base
  include Elasticsearch::Model
  belongs_to :creator, class_name: User
  has_many :article_owners
  has_many :system_users, through: :article_owners, source: :owner, source_type: Author.name
  has_many :users, through: :article_owners, source: :owner, source_type: User.name
  has_one :cover_image, -> { where(preview_image: false) }
  accepts_nested_attributes_for :cover_image
  has_many :article_tags
  has_many :tags, through: :article_tags
  belongs_to :category
  attr_accessor :tag_list
  validates :title, :content, :category, :summary, presence: true
  validates :home_page_order, uniqueness: true, allow_blank: true
  index_name    "articles_#{Rails.env}"
  settings do
    mapping do
      indexes :title, analyzer: 'snowball'
      indexes :content, analyzer: 'snowball'
      indexes :status, index: 'not_analyzed'
      indexes :tags do
        indexes :name, index: 'not_analyzed'
      end
      indexes :category do
        indexes :name, index: 'not_analyzed'
      end
    end
  end

  before_save :set_date_published, if: -> {status_changed? && status == Status::PUBLISHED}
  after_save do
    Delayed::Job.enqueue(ArticleIndexJob.new(id))
  end

  module Status
    DRAFT = "draft"
    SUBMITTED_FOR_APPROVAL = "submitted for approval"
    PUBLISHED = "published"
  end

  def owners
    system_users + users
  end

  def index_current_document_values
    __elasticsearch__.index_document
  end

  def tag_list
    tags.collect(&:name).join(",")
  end

  def tag_list=(tag_names_string)
    tag_names_array = tag_names_string.split(",")
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
                        status: Status::PUBLISHED
                    }
                }
            ]
        },
        sort: {date_published: {order: "desc"}}
    }.to_json
    response = Article.__elasticsearch__.search query
    response.records.to_a
  end

  ["tags", "category"].each do |criteria|
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
                                  term: {status: Status::PUBLISHED}
                              }
                          ]
                      }
                  }
              }
          },
          sort: {date_published: {order: "desc"}}
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